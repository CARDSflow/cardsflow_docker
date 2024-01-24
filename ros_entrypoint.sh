#!/bin/bash
set -e

# setup ros environment
echo $ROS_DISTRO && source /opt/ros/$ROS_DISTRO/setup.bash --
exec "$@"