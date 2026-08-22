#include <chrono>
#include <functional>
#include <memory>
#include <string>

#include "tf2_geometry_msgs/tf2_geometry_msgs.hpp"
#include "nav_msgs/msg/odometry.hpp"

#include "MBUtils.h"
#include "iMOOSClient/MOOSClient.h"

#include "NodeRecordUtils.h"
#include "NodeMessage.h"

using std::placeholders::_1;
using namespace std::chrono_literals;

class PoseNodeReporter : public rclcpp::Node
{
    public:
        PoseNodeReporter() : Node("pose_node_reporter")
        {
            this->declare_parameter("moos_host", "localhost");
            this->declare_parameter("moos_port", 9000);
            this->declare_parameter("app_name", "iPoseNodeReporter");
            
            subscription_ = this->create_subscription<nav_msgs::msg::Odometry>(
                "/model/bluerov2_heavy/odometry", 10, std::bind(&PoseNodeReporter::odom_callback, this, _1)
            );
            timer_ = this->create_wall_timer(250ms, std::bind(&PoseNodeReporter::node_report_timer_callback, this));
        
            std::string moos_host_param = this->get_parameter("moos_host").as_string();
            int moos_port_param = this->get_parameter("moos_port").as_int();
            std::string app_name_param = this->get_parameter("app_name").as_string();

            m_moos_client.Run(moos_host_param, moos_port_param, app_name_param);

        }
        MOOSClient m_moos_client;
        std::string m_node_report_string;

        
    private:
        void odom_callback(const nav_msgs::msg::Odometry &msg) 
        {
            
            std::string node_report_string = "NAME=blu";

            double velocity_x = msg.twist.twist.linear.x;
            double velocity_y = msg.twist.twist.linear.y;
            double speed = sqrt((velocity_x * velocity_x) + (velocity_y * velocity_y));

            double pose_x = msg.pose.pose.position.x;
            double pose_y = msg.pose.pose.position.y;
            double pose_z = msg.pose.pose.position.z;

            // orientation comes in as quaternion
            double orient_x = msg.pose.pose.orientation.x;
            double orient_y = msg.pose.pose.orientation.y;
            double orient_z = msg.pose.pose.orientation.z;
            double orient_w = msg.pose.pose.orientation.w;
            
            tf2::Quaternion q(orient_x, orient_y, orient_z, orient_w);
            tf2::Matrix3x3 m(q);
            double roll, pitch, yaw;
            m.getRPY(roll, pitch, yaw);

            node_report_string += ",X=" + std::to_string(pose_x);
            node_report_string += ",Y=" + std::to_string(pose_y);
            node_report_string += ",DEP=" + std::to_string(-1 * pose_z);
            node_report_string += ",HDG=" + std::to_string(-1 * (0 + (yaw * 360) / 6.28) + 90);
            node_report_string += ",SPD=" + std::to_string(speed);
            node_report_string += ",TIME=" + std::to_string(MOOSTime());
            node_report_string += ",LENGTH=4";
            node_report_string += ",COLOR=blue";
            node_report_string += ",ALLSTOP=clear";
            node_report_string += ",MODE=MODE@ACTIVE:TRANSITING";
            node_report_string += ",TYPE=kayak";

            m_node_report_string = node_report_string;

        }
        void node_report_timer_callback(){
            
            RCLCPP_INFO_STREAM(this->get_logger(), "NODE_REPORT: " << m_node_report_string);
            this->m_moos_client.Notify("NODE_REPORT", m_node_report_string);
        }
        rclcpp::TimerBase::SharedPtr timer_;
        rclcpp::Subscription<nav_msgs::msg::Odometry>::SharedPtr subscription_;

        std::string mission_file;
        std::string run_command;
};