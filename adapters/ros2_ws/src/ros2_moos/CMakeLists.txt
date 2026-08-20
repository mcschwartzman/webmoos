cmake_minimum_required(VERSION 3.8)
project(ros2_moos)

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

# find dependencies
find_package(ament_cmake REQUIRED)
find_package(rclcpp REQUIRED)
find_package(std_msgs REQUIRED)
find_package(nav_msgs REQUIRED)

find_package(MOOS 10.0)

#=================================7======================================
# Find the "moos-ivp" base directory
#=======================================================================

# Search for the moos-ivp folder
find_path( MOOSIVP_SOURCE_TREE_BASE
           NAMES build-ivp.sh build-moos.sh configure-ivp.sh
           PATHS "../moos-ivp" "../../moos-ivp" "../../moos-ivp/trunk/" "../moos-ivp/trunk/" "$ENV{HOME}/git/moos-ivp"
           DOC "Base directory of the MOOS-IvP source tree"
           NO_DEFAULT_PATH
)

if (NOT MOOSIVP_SOURCE_TREE_BASE)
    message("Please set MOOSIVP_SOURCE_TREE_BASE to  ")
    message("the location of the \"moos-ivp\" folder ")
    message( FATAL_ERROR "CMake will exit." )
endif()

INCLUDE_DIRECTORIES(
  ${MOOS_INCLUDE_DIRS}
  ${MOOSIVP_SOURCE_TREE_BASE}/include/ivp/
  )

add_executable(iPoseNodeReporter src/PoseNodeReporter.cpp)
ament_target_dependencies(iPoseNodeReporter rclcpp std_msgs nav_msgs)
target_include_directories(iPoseNodeReporter PUBLIC
  $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:include>
  /opt/ros/humble/include/tf2_geometry_msgs
  /opt/ros/humble/include/tf2
  /opt/ros/humble/include/tf2_ros
  )
  
target_compile_features(iPoseNodeReporter PUBLIC c_std_99 cxx_std_17)  # Require C99 and C++17

install(TARGETS iPoseNodeReporter
  DESTINATION lib/${PROJECT_NAME})

if(BUILD_TESTING)
  find_package(ament_lint_auto REQUIRED)
  # the following line skips the linter which checks for copyrights
  # comment the line when a copyright and license is added to all source files
  set(ament_cmake_copyright_FOUND TRUE)
  # the following line skips cpplint (only works in a git repo)
  # comment the line when this package is in a git repo and when
  # a copyright and license is added to all source files
  set(ament_cmake_cpplint_FOUND TRUE)
  ament_lint_auto_find_test_dependencies()
endif()

ament_package()
