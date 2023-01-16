# ROS Docker Containers with accelerated GUI Support
**Note Robotlab Lund:** The first go-to solution is `ros-containers` which also supports podman.


* [OSRF Images we build upon](https://hub.docker.com/r/osrf/ros/tags)
* [ROS Wiki Doku](http://wiki.ros.org/docker/Tutorials)

Our Docker containers are built on the OSRF images. They add:
* tools that we typically need
* 3D-accelerated GUI support for RViz, Gazebo, etc
* Convenient build and start scripts with reasonable defaults
* They automatically share the home folder and network to allow easy usage within an existing environment

## Support Matrix
| **Graphics/Ubuntu & ROS** | **16.04 Kinetic** | **18.04 Melodic** | **20.04 Focal** |
|---------------------------|-------------------|-------------------|-----------------|
| Nvidia                    |         X         |         X         |        X        |
| Intel                     |         X         |                   |                 |
| Without 3D support        |         X         |         X         |        X        |

Support for other combinations can be added via merge requests.

## Setup/Installation
For Ubuntu (tested on 18.04) and Nvidia graphics card. Other manifacturers could be supported - feel free to send a merge request.

### Docker (required)
```
sudo apt update
sudo apt install docker.io
```

### Nvidia graphics support (optional)

* [Background: ROS Wiki page on docker hardware acceleration](http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration)
* We use `nvidia-docker2`
* The installation comes from [here](https://github.com/nvidia/nvidia-docker/wiki/Installation-(version-2.0))

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

### Restart Docker
For both Nvidia and Intel graphics cards:
```
sudo systemctl daemon-reload
sudo systemctl restart docker
```
Alternatively restart computer.


## Build docker container
Execute `./build-ros-docker.sh` and select the options you want.

## Run docker container
Execute `./run_docker.sh` to get an interactive menu to choose a container to start.

Use `./run_docker.sh melodic nvidia`, `run_docker.sh kinetic intel` or `run_docker.sh noetic nvidia` to start a specific version with their respectice graphics card support.
# Troubleshooting

## D-BUS Errors
* [See this thread](https://answers.ros.org/question/301056/ros2-rviz-in-docker-container/)
