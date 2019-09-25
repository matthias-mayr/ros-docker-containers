====== Docker ======

* [[https://hub.docker.com/r/osrf/ros/tags|OSRF Images we build upon]]
* [[http://wiki.ros.org/docker/Tutorials|ROS Wiki Doku]]

===== Setup/Installation =====
For Ubuntu (tested on 18.04) and Nvidia graphics card. Other manifacturers could be supported - feel free to send a merge request.

==== Docker ====
'''
sudo apt update
sudo apt install docker.io
'''


==== Nvidia graphics support ====
* [[http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration|From this ROS Wiki page]]
* we use nvidia-docker2
* [[https://github.com/nvidia/nvidia-docker/wiki/Installation-(version-2.0)|Installation procedure from here]]

=== Add nvidia-docker repo ===
'''
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
'''


=== Install nvidia-docker2 ===
'''
sudo apt install nvidia-docker2
'''


=== Restart Docker ===
'''
sudo systemctl daemon-reload
sudo systemctl restart docker
'''
Alternatively restart computer.


===== Build docker container =====
Execute ''build-ros-docker.sh''

===== Build docker container =====
Execute ''run_docker.sh melodic'' or ''run_docker.sh kinetic''
===== Troubleshooting =====

==== D-BUS Errors ====
* [[https://answers.ros.org/question/301056/ros2-rviz-in-docker-container/|See this thread]]