#!/bin/bash
session="ros1-bridge-roboy"

tmux has-session -t $session 2>/dev/null

if [ $? == 0 ]; then
  tmux kill-session -t $session
fi

tmux new-session -s $session -d \; \
  split-window -h \; \
  select-pane -t 0 \; \
  split-window -v \; \
  select-pane -t 2 \; \
  split-window -v \; \
  select-pane -t 0 \; \
  split-window -v \; \
  select-pane -t 3 \; \
  split-window -v \; \
  select-pane -t 2 \; \
  split-window -v \; \
  send-keys -t 3 "sleep 5; source /opt/ros/noetic/setup.bash; source /roboy3/devel/setup.bash; rviz" C-m\; \
  send-keys -t 4 "sleep 5; source /roboy3/devel/setup.bash && roslaunch kindyn robot.launch simulated:=true robot_name:=upper_body" C-m\; \
  send-keys -t 0 'source /opt/ros/noetic/setup.bash; roscore' C-m\; \
  send-keys -t 1 'sleep 5; source /opt/ros/noetic/setup.bash; rosparam load /roboy3/src/bridge.yaml' C-m \; \
  send-keys -t 2 'sleep 5; source /opt/ros/noetic/setup.bash && source /opt/ros/foxy/setup.bash; ros2 run ros1_bridge parameter_bridge' C-m #\; 
  # tmux attach 
  while true; do sleep 1 ; done
