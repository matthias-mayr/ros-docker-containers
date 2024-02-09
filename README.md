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
```sh
sudo apt update
sudo apt install docker.io
```

### Nvidia graphics support (optional)

* [Background: ROS Wiki page on docker hardware acceleration](http://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration)
* We use `nvidia-docker2`
* The installation comes from [here](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

#### Add nvidia-docker repo
```sh
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
````

#### Install nvidia-docker2
```sh
sudo apt-get install -y nvidia-container-toolkit
```
#### Configure it
```sh
sudo nvidia-ctk runtime configure --runtime=docker
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
