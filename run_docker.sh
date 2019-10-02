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

get_distribution () {
    echo 'Please enter your choice: '
    kinetic_xenial="Kinetic Xenial 16.04"
    melodic_bionic="Melodic Bionic 18.04"
    distribution=("$kinetic_xenial" "$melodic_bionic" "Quit")
    echo "Hint: You can also specify 'melodic' or 'kinetic' as the first argument directly"
    select dist_choice in "${distribution[@]}"
    do
        case $dist_choice in
            $kinetic_xenial)
                echo "You chose $dist_choice"
                break
                ;;
            $melodic_bionic)
                echo "You chose choice $dist_choice"
                break
                ;;
            "Quit")
                exit 0
                ;;
            *) echo "Invalid option $REPLY"; exit 0;
        esac
    done
}

if [ -z "$1" ]; then
    get_distribution
else
    dist_choice=$1
fi

# The IN_DOCKER environment variable can be used to do things in the bashrc.

if [[ "$dist_choice" == "melodic" ]] || [ "$dist_choice" == "$melodic_bionic" ]  ; then
    echo -e "\nStarting melodic container\n"
    docker run -it --user=$( id -u $USER ):$( id -g $USER ) --net=host --privileged --env="DISPLAY" -e IN_DOCKER=true --workdir="/home/$USER" --volume="/home/$USER:/home/$USER" --volume="/etc/group:/etc/group:ro" --volume="/etc/passwd:/etc/passwd:ro" --volume="/etc/shadow:/etc/shadow:ro" --volume="/etc/sudoers.d:/etc/sudoers.d:ro" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --runtime=nvidia ros:kinetic-desktop-full-9-graphics-nvidia
    
elif [[ "$dist_choice" == "kinetic" ]] || [ "$dist_choice" == "$kinetic_xenial" ]; then
    echo -e "\nStarting kinetic container\n"
    nvidia-docker run -it --user=$( id -u $USER ):$( id -g $USER ) --device=/dev/dri:/dev/dri --ipc=host --net=host --privileged --env="DISPLAY"  -e IN_DOCKER=true --workdir="/home/$USER" --volume="/home/$USER:/home/$USER" --volume="/etc/group:/etc/group:ro" --volume="/etc/passwd:/etc/passwd:ro" --volume="/etc/shadow:/etc/shadow:ro" --volume="/etc/sudoers.d:/etc/sudoers.d:ro" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" ros:kinetic-desktop-full-9-graphics-nvidia

else
    echo "Unknown distribution: $dist_choice"
fi
