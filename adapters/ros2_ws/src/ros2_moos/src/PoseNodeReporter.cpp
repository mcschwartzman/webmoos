#include <cstdio>

#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"
#include "MBUtils.h"
#include "PoseNodeReporter.h"

int main(int argc, char ** argv)
{
  std::string mission_file = "./client.moos";
  std::string run_command = "iMOOSClient";

  printf("starting ros2_moos node!\n");
  rclcpp::init(argc, argv);
  auto pose_node_reporter = std::make_shared<PoseNodeReporter>();
  pose_node_reporter->moos_client.Run(mission_file.c_str(), run_command.c_str());
  rclcpp::spin(pose_node_reporter);
  rclcpp::shutdown();
  printf("hello world ros2_moos package\n");
  return 0;
}
