#!/bin/bash

# maybe xhost +local:docker
# maybe xhost +local:root

# maybe this: But it worked without as well
# XAUTH=/tmp/.docker.xauth
# if [ ! -f $XAUTH ]
# then
#     xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
#     if [ ! -z "$xauth_list" ]
#     then
#         echo $xauth_list | xauth -f $XAUTH nmerge -
#     else
#         touch $XAUTH
#     fi
#     chmod a+r $XAUTH
# fi

if [[ "$1" == "melodic" ]]; then

    docker run -it --user=$( id -u $USER ):$( id -g $USER ) --net=host --privileged --env="DISPLAY" --workdir="/home/$USER" --volume="/home/$USER:/home/$USER" --volume="/etc/group:/etc/group:ro" --volume="/etc/passwd:/etc/passwd:ro" --volume="/etc/shadow:/etc/shadow:ro" --volume="/etc/sudoers.d:/etc/sudoers.d:ro" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --runtime=nvidia ros:kinetic-desktop-full-9-graphics-nvidia
    
elif [[ "$1" == "kinetic" ]]; then
    nvidia-docker run -it --user=$( id -u $USER ):$( id -g $USER ) --device=/dev/dri:/dev/dri --ipc=host --net=host --privileged --env="DISPLAY" --workdir="/home/$USER" --volume="/home/$USER:/home/$USER" --volume="/etc/group:/etc/group:ro" --volume="/etc/passwd:/etc/passwd:ro" --volume="/etc/shadow:/etc/shadow:ro" --volume="/etc/sudoers.d:/etc/sudoers.d:ro" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" ros:kinetic-desktop-full-9-graphics-nvidia
fi
