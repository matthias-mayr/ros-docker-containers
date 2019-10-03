# Docker 

* [OSRF Images we build upon](https://hub.docker.com/r/osrf/ros/tags)
* [ROS Wiki Doku](http://wiki.ros.org/docker/Tutorials)

## Setup/Installation
For Ubuntu (tested on 18.04) and Nvidia graphics card. Other manifacturers could be supported - feel free to send a merge request.
Tested on Ubuntu 18 and Intel graphics card.

### Docker 
```
sudo apt update
sudo apt install docker.io
```

* For Nvidia graphics card only
### Nvidia graphics support
* [From this ROS Wiki page](http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration)
* we use nvidia-docker2
* [Installation procedure from here](https://github.com/nvidia/nvidia-docker/wiki/Installation-(version-2.0))

#### Add nvidia-docker repo
```
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey ]( \
  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list ]( \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
````


#### Install nvidia-docker2
```
sudo apt install nvidia-docker2
```

* For both Nvidia and Intel graphics card
### Restart Docker
```
sudo systemctl daemon-reload
sudo systemctl restart docker
```
Alternatively restart computer.


## Build docker container
Execute `./build-ros-docker.sh` and select the options you want. 

## Run docker container
Execute `./run_docker.sh melodic` or `./run_docker.sh kinetic navidia` or `./run_docker.sh kinetic intel`
# Troubleshooting

## D-BUS Errors
* [See this thread](https://answers.ros.org/question/301056/ros2-rviz-in-docker-container/)