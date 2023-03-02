FROM osrf/ros:foxy-ros1-bridge
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654

RUN apt-get update && apt-get install -y libeigen3-dev libxml2-dev coinor-libipopt-dev \
qtbase5-dev qtdeclarative5-dev qtmultimedia5-dev qml-module-qtquick2 \
qml-module-qtquick-window2 qml-module-qtmultimedia qml-module-qtquick-dialogs \
qml-module-qtquick-controls qml-module-qt-labs-folderlistmodel \
qml-module-qt-labs-settings libxml++2.6-dev swig doxygen


ENV DEBIAN_FRONTEND=noninteractive
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y ros-$ROS1_DISTRO-geometry-msgs ros-$ROS1_DISTRO-moveit-msgs ros-$ROS1_DISTRO-actionlib-msgs ros-$ROS1_DISTRO-actionlib ros-$ROS1_DISTRO-tf ros-$ROS1_DISTRO-tf-conversions ros-$ROS1_DISTRO-cv-bridge ros-$ROS1_DISTRO-image-transport ros-$ROS1_DISTRO-rviz ros-$ROS1_DISTRO-sensor-msgs ros-$ROS1_DISTRO-rqt-gui ros-$ROS1_DISTRO-rqt-gui-cpp ros-$ROS1_DISTRO-roslint ros-$ROS1_DISTRO-rosbag ros-$ROS1_DISTRO-controller-interface \
ros-$ROS1_DISTRO-robot-state-publisher ros-$ROS1_DISTRO-controller-manager ros-$ROS1_DISTRO-effort-controllers ros-$ROS1_DISTRO-eigen-conversions ros-$ROS1_DISTRO-pcl-ros 

RUN git clone https://github.com/Roboy/roboy3

ENV ROBOY3_WS=/roboy3
WORKDIR $ROBOY3_WS

RUN git submodule init && git submodule update --recursive

WORKDIR $ROBOY3_WS/src/idyntree
RUN mkdir build && cd build \
 && cmake .. -DIDYNTREE_USES_IPOPT=ON \ 
 && make -j4 \
 && make install


# build qpOASES
WORKDIR $ROBOY3_WS/src/qpOASES
RUN mkdir build && cd build \
 && cmake .. \
 && sudo make -j4 install

RUN apt-get install -y ros-$ROS1_DISTRO-cmake-modules ros-$ROS1_DISTRO-genpy vim tmux
RUN touch /roboy3/src/ball_in_socket_estimator/CATKIN_IGNORE
WORKDIR $ROBOY3_WS
RUN bash -c "source /opt/ros/${ROS1_DISTRO}/setup.bash && catkin_make"

COPY bridge.yaml /roboy3/src/
COPY autostart.sh /roboy3/src
RUN chmod +x /roboy3/src/autostart.sh
COPY default.rviz /opt/ros/noetic/share/rviz/

ENTRYPOINT ["bash", "-c", "/roboy3/src/autostart.sh"] 