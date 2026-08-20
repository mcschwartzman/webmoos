#include <string>
#include "tf2_geometry_msgs/tf2_geometry_msgs.hpp"
#include "nav_msgs/msg/odometry.hpp"

#include "MBUtils.h"
#include "iMOOSClient/MOOSClient.h"
#include "iMOOSClient/MOOSClient_Info.h"

using std::placeholders::_1;

class PoseNodeReporter : public rclcpp::Node
{
    public:
        MOOSClient moos_client;
        PoseNodeReporter() : Node("pose_node_reporter")
        {
            subscription_ = this->create_subscription<nav_msgs::msg::Odometry>(
                "/model/bluerov2_heavy/odometry", 10, std::bind(&PoseNodeReporter::odom_callback, this, _1)
            );
        }
    private:
        void odom_callback(const nav_msgs::msg::Odometry &msg) const 
        {
            std::string node_report_string = "NAME=BLU";

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
            node_report_string += ",DEP=" + std::to_string(pose_z);
            node_report_string += ",HDG=" + std::to_string(yaw);
            node_report_string += ",SPD=" + std::to_string(speed);

            RCLCPP_INFO_STREAM(this->get_logger(), "NODE_REPORT: " << node_report_string);

        }
        rclcpp::Subscription<nav_msgs::msg::Odometry>::SharedPtr subscription_;
};