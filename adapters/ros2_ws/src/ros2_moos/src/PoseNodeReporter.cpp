#include <cstdio>

#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"
#include "MBUtils.h"
#include "PoseNodeReporter.h"

int main(int argc, char ** argv)
{
  printf("starting ros2_moos node!\n");
  rclcpp::init(argc, argv);
  rclcpp::spin(std::make_shared<PoseNodeReporter>());
  rclcpp::shutdown();
  printf("hello world ros2_moos package\n");
  return 0;
}
