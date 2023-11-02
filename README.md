# cardsflow_docker
Dockerized kindyn &amp; cardsflow RViz with ROS1 &amp; ROS2 support

- To **build** the Docker image, clone this repository, navigate to its root and run
```bash
docker compose build
```

- To **instantiate** a Docker container with `ros1-bridge-roboy` image run
```bash
xhost local:root 
docker compose up
```
The above command will automatically launch necessary ROS nodes with required display settings and open RViz after about 5 seconds.


- To **test** the motion of Roboy3, from your ROS2 terminal run
```bash
ros2 topic pub /roboy/pinky/control/joint_targets sensor_msgs/msg/JointState "{name: ["shoulder_left_axis0"], position: [-0.5] }"
```
- To **bridge further topics or services** between ROS1 and ROS2 edit `bridge.yaml` and rebuild the container.

![image](https://user-images.githubusercontent.com/15858520/222543129-75795c31-7a86-419a-bdc4-d89251846575.png)
