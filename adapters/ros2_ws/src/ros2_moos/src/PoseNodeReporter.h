#include "MOOS/libMOOS/Thirdparty/AppCasting/AppCastingMOOSApp.h"
#include "nav_msgs/msg/odometry.hpp"
using std::placeholders::_1;

class PoseNodeReporter : public rclcpp::Node 
{
    public:
        PoseNodeReporter() : Node("pose_node_reporter")
        {
            subscription_ = this->create_subscription<nav_msgs::msg::Odometry>(
                "/model/blueboat/odometry", 10, std::bind(&PoseNodeReporter::odom_callback, this, _1)
            );
        }
    private:
        void odom_callback(const nav_msgs::msg::Odometry &msg) const 
        {
            RCLCPP_INFO(this->get_logger(), "I received some odometry!");
        }
        rclcpp::Subscription<nav_msgs::msg::Odometry>::SharedPtr subscription_;
};