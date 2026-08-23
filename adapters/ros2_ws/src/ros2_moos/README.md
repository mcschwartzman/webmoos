# ROS2_MOOS
A ROS2 package originally created for testing the newly created Tether Behavior with the a [gazebo-based simulator](https://github.com/markusbuchholz/marine-robotics-sim-framework) for a tethered ROV-ASV pair.

## Prereqs
- You need to have installed both MOOS-IvP and ROS2 (this was tested with Humble)
- Build and install the tether behavior included in [moos-ivp-mcschwar](https://github.com/mcschwartzman/moos-ivp-mcschwar) (this also includes full-MOOS sim missions)
- If you want to teleop the ROV, make sure you install QGroundControl

## Quickstart
1. Start the simulator
```
# in /marine-robotics-sim-framework/blueboat_sitl/docker/
./run.sh
# in the sim container
colcon build --symlink-install --merge-install --cmake-args -DCMAKE_BUILD_TYPE=RelWithDebInfo -DBUILD_TESTING=ON -DCMAKE_CXX_STANDARD=17
source source_after_docker.sh
ros2 launch move_blueboat tethered_asv_auv_standby.launch.py
```
2. Start the SITL ROV
```
# in the same container
sim_vehicle.py -L RATBeach -v ArduSub -f vectored_6dof --model=JSON --out=udp:172.17.0.1:14550 --console
```
3. Start QGroundControl to control the ROV
```
./QGroundControl-x86_64.AppImage
```
4. Launch the ROV Node Reporter and ASV Adapter together
```
# in /ros2_moos/launch/
ros2 launch half_tether_launch.xml
```
5. Start the sim-less ASV MOOS mission
```
# in /moos-ivp-mcschwar/missions/half_tether/
ktm && ./clean.sh && ./launch.sh
```