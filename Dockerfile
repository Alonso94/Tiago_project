FROM nvidia/cudagl:11.1.1-base-ubuntu18.04

# Minimal setup
RUN apt-get update \
 && apt-get install -y locales lsb-release
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg-reconfigure locales
 
# Install ROS Melodic
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
RUN apt-get update \
 && apt-get install -y --no-install-recommends ros-melodic-desktop-full
RUN apt-get install -y --no-install-recommends python3-rosdep
RUN rosdep init \
 && rosdep fix-permissions \
 && rosdep update
RUN echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc

RUN apt-get install -y wget python-rosinstall python-rosinstall-generator python-catkin-tools git

RUN mkdir ~/tiago_public_ws
RUN cd ~/tiago_public_ws

RUN wget https://raw.githubusercontent.com/pal-robotics/tiago_tutorials/kinetic-devel/tiago_public-melodic.rosinstall
RUN rosinstall src /opt/ros/melodic tiago_public-melodic.rosinstall

RUN rosdep install --from-paths src --ignore-src -y --rosdistro melodic --skip-keys="opencv2 opencv2-nonfree pal_laser_filters speed_limit_node\
        sensor_to_cloud hokuyo_node libdw-dev python-graphitesend-pip python-statsd pal_filters pal_vo_server pal_usb_utils pal_pcl \
        pal_pcl_points_throttle_and_filter pal_karto pal_local_joint_control camera_calibration_files pal_startup_msgs \
        pal-orbbec-openni2 dummy_actuators_manager pal_local_planner gravity_compensation_controller current_limit_controller\
        dynamic_footprint dynamixel_cpp tf_lookup opencv3 joint_impedance_trajectory_controller cartesian_impedance_controller\
        omni_base_description omni_drive_controller"
RUN catkin build -DCATKIN_ENABLE_TESTING=0 -j $(expr `nproc` / 2)
RUN echo "source /tiago_public_ws/devel/setup.bash" >> ~/.bashrc
RUN git clone 