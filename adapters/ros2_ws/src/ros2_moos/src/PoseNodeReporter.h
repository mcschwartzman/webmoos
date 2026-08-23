#include <chrono>
#include <functional>
#include <memory>
#include <string>

#include "std_msgs/msg/float64.hpp"
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
            this->declare_parameter("moosvars", "NODE_REPORT");
            this->declare_parameter("odom_topic", "/model/vehicle_name/odometry");

            std::string moos_host_param = this->get_parameter("moos_host").as_string();
            int moos_port_param = this->get_parameter("moos_port").as_int();
            std::string app_name_param = this->get_parameter("app_name").as_string();
            std::string moosvars_param = this->get_parameter("moosvars").as_string();
            std::string odom_topic_param = this->get_parameter("odom_topic").as_string();
            
            subscription_ = this->create_subscription<nav_msgs::msg::Odometry>(
                odom_topic_param, 10, std::bind(&PoseNodeReporter::odom_callback, this, _1)
            );
            timer_ = this->create_wall_timer(250ms, std::bind(&PoseNodeReporter::node_report_timer_callback, this));
        
            m_moos_client.Run(moos_host_param, moos_port_param, app_name_param);
            m_node_reporter = (moosvars_param == "NODE_REPORT");

            if (!m_node_reporter){
                m_moos_client.Register("DESIRED_THRUST", 0);
                m_moos_client.Register("DESIRED_RUDDER", 0);
                
                m_moos_client.SetOnMailCallBack(PoseNodeReporter::moos_mail_callback, this);
                
                port_thrust_pub_ = this->create_publisher<std_msgs::msg::Float64>("/model/blueboat/joint/motor_port_joint/cmd_thrust", 10);
                stbd_thrust_pub_ = this->create_publisher<std_msgs::msg::Float64>("/model/blueboat/joint/motor_stbd_joint/cmd_thrust", 10);
            }

        }
        MOOSClient m_moos_client;
        std::string m_node_report_string;
        bool m_node_reporter;

        double m_desired_thrust;
        double m_desired_rudder;

        double m_port_thrust;
        double m_stbd_thrust;

    private:
        static bool moos_mail_callback(void * pParam){
            CMOOSCommClient * pC = static_cast<CMOOSCommClient*> (pParam);
            PoseNodeReporter* pNR = static_cast<PoseNodeReporter*>(pParam);
            MOOSMSG_LIST NewMail;
            pC->Fetch(NewMail);

            MOOSMSG_LIST::iterator p;

            for(p=NewMail.begin(); p!=NewMail.end(); p++) {
                CMOOSMsg &msg = *p;
                std::string key    = msg.GetKey();

                double dval  = msg.GetDouble();
            #if 0 // Keep these around just for template
                std::string comm  = msg.GetCommunity();
                std::string sval  = msg.GetString(); 
                std::string msrc  = msg.GetSource();
                double mtime = msg.GetTime();
                bool   mdbl  = msg.IsDouble();
                bool   mstr  = msg.IsString();
            #endif

                if(key == "DESIRED_THRUST"){
                    pNR->m_desired_thrust = dval;
                }
                else if(key == "DESIRED_RUDDER"){
                    pNR->m_desired_rudder = dval;
                }
                else if(key != "APPCAST_REQ"){

                } // handled by AppCastingMOOSApp
            }
                
            return(true);
        }

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
            yaw = -1 * (0 + (yaw * 360) / 6.28) + 90;

            if (m_node_reporter){
                node_report_string += ",X=" + std::to_string(pose_x);
                node_report_string += ",Y=" + std::to_string(pose_y);
                node_report_string += ",DEP=" + std::to_string(-1 * pose_z);
                node_report_string += ",HDG=" + std::to_string(yaw);
                node_report_string += ",SPD=" + std::to_string(speed);
                node_report_string += ",TIME=" + std::to_string(MOOSTime());
                node_report_string += ",LENGTH=4";
                node_report_string += ",COLOR=blue";
                node_report_string += ",ALLSTOP=clear";
                node_report_string += ",MODE=MODE@ACTIVE:TRANSITING";
                node_report_string += ",TYPE=kayak";

                m_node_report_string = node_report_string;
            }
            else {
                this->m_moos_client.Notify("NAV_HEADING", yaw);
                this->m_moos_client.Notify("NAV_HEADING_OVER_GROUND", yaw);
                this->m_moos_client.Notify("NAV_X", pose_x);
                this->m_moos_client.Notify("NAV_Y", pose_y);
                this->m_moos_client.Notify("NAV_DEPTH", -1 * pose_z);
                this->m_moos_client.Notify("NAV_SPEED", speed);
            }
        }
        void node_report_timer_callback(){
            if (m_node_reporter){
                RCLCPP_INFO_STREAM(this->get_logger(), "NODE_REPORT: " << m_node_report_string);
                this->m_moos_client.Notify("NODE_REPORT", m_node_report_string);
            }
            else {
                // calculate thruster values from desired 
                
                // rudder:
                // hard to port is -100
                // hard to stbd is 100
                // straight is 0

                // when turning hard to port, port thruster should be at 0 or less, so:
                // port thruster should always be base_thrust + desired_rudder
                // stbd thruster should always be base_thrust - desired_rudder

                double base_thrust = m_desired_thrust;
                m_port_thrust = base_thrust + m_desired_rudder;
                m_stbd_thrust = base_thrust - m_desired_rudder;

                auto port_thrust_msg = std_msgs::msg::Float64();
                port_thrust_msg.data = m_port_thrust;
                auto stbd_thrust_msg = std_msgs::msg::Float64();
                stbd_thrust_msg.data = m_stbd_thrust;

                port_thrust_pub_->publish(port_thrust_msg);
                stbd_thrust_pub_->publish(stbd_thrust_msg);
            }
        }
        rclcpp::TimerBase::SharedPtr timer_;
        rclcpp::Subscription<nav_msgs::msg::Odometry>::SharedPtr subscription_;
        rclcpp::Publisher<std_msgs::msg::Float64>::SharedPtr port_thrust_pub_;
        rclcpp::Publisher<std_msgs::msg::Float64>::SharedPtr stbd_thrust_pub_;

        std::string mission_file;
        std::string run_command;
};