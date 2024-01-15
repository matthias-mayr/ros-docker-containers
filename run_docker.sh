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
    noetic_focal="Noetic Focal 20.04"
    distribution=("$kinetic_xenial" "$melodic_bionic" "$noetic_focal" "Quit")
    echo "Hint: You can also specify 'melodic', 'kinetic' or 'noetic' as the first argument and the graphics support as second one directly"
    select dist_choice in "${distribution[@]}"
    do
        case $dist_choice in
            $kinetic_xenial)
                echo "You chose $dist_choice"
                break
                ;;
            $melodic_bionic)
                echo "You chose $dist_choice"
                break
                ;;
            $noetic_focal)
                echo "You chose $dist_choice"
                break
                ;;
            "Quit")
                exit 0
                ;;
            *) echo "Invalid option $REPLY"; exit 0;
        esac
    done
}

get_graphics () {
    echo 'Please enter your choice: '
    options=("nvidia" "intel" "none" "Quit")
    select graphics_choice in "${options[@]}"
    do
        case $graphics_choice in
            "nvidia")
                echo "You chose $dist_choice with $graphics_choice"
                break
                ;;
            "intel")
                echo "You chose $dist_choice with $graphics_choice"
                break
                ;;
            "none")
                echo "You chose no 3D graphics support"
                break
                ;;
            "Quit")
                return false
                ;;
            *) echo "Invalid option $REPLY";;
        esac
    done
}

if [ -z "$1" ]; then
    get_distribution
else
    dist_choice=$1
fi

if [ -z "$2" ]; then
    get_graphics
else
    graphics_choice=$2
fi

container_name=${dist_choice// /_}	# replace space with underscore
container_name=rss_${container_name,,}	# lowercase

container_start_restart_connect() {
	name=$1
	docker_command="${@:2}"

	if [ ! "$(docker ps -q -f name=$name)" ]; then
		if [ "$(docker ps -aq -f status=exited -f name=$name)" ]; then
			echo "Restarting container"
			sleep 2
			docker start $name
			docker attach $name
		else
			echo "Starting"
			sleep 2
			eval $docker_command
		fi
	elif [ "$(docker ps -aq -f status=running -f name=$name)" ];then
			echo "Attaching to running container"
			sleep 2
			docker attach $name
	fi

}

if [[ "$dist_choice" == "melodic" ]] || [ "$dist_choice" == "$melodic_bionic" ]  ; then
    echo -e "\nUsing melodic container\n"
    # Parameter explanation:
    #
    # -e IN_DOCKER=true : Environment variable can be used to do things in the bashrc.
	if [[ "$graphics_choice" == "nvidia" ]]; then
		echo -e "Running Nvidia support\n"
		read -r -d '' docker_command <<- EOM
			docker run -it \
				--user=$( id -u $USER ):$( id -g $USER ) \
				--net=host \
				--privileged \
				--env="DISPLAY" \
				-e IN_DOCKER=true \
				--workdir="/home/$USER" \
				--volume="/home/$USER:/home/$USER" \
				--volume="/etc/group:/etc/group:ro" \
				--volume="/etc/passwd:/etc/passwd:ro" \
				--volume="/etc/shadow:/etc/shadow:ro" \
				--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
				--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
				--runtime=nvidia \
				--name "$container_name" \
				ros:melodic-desktop-full-9-graphics-nvidia
		EOM
	elif [[ "$graphics_choice" == "intel" ]]; then
		echo "Melodic bionic with intel acceleration is not supported yet."
		echo "Feel free to implement it and send a merge request."
		echo "In the meantime a container without graphics support can be chosen."
		exit -1
	else
		echo -e "Running without explicit graphics support\n"
		read -r -d '' docker_command <<- EOM
			docker run -it \
				--user=$( id -u $USER ):$( id -g  $USER ) \
				--device=/dev/dri:/dev/dri \
				--ipc=host \
				--net=host \
				--privileged \
				--env="DISPLAY=$DISPLAY" \
				-e IN_DOCKER=true \
				--workdir="/home/$USER" \
				--volume="/home/$USER:/home/$USER" \
				--volume="/etc/group:/etc/group:ro" \
				--volume="/etc/passwd:/etc/passwd:ro" \
				--volume="/etc/shadow:/etc/shadow:ro" \
				--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
				--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
				--name "$container_name" \
				ros:melodic-desktop-full-4-ros
		EOM
    fi
	container_start_restart_connect $container_name $docker_command
elif [[ "$dist_choice" == "kinetic" ]] || [ "$dist_choice" == "$kinetic_xenial" ]; then
    echo -e "\nUsing kinetic container\n"
    # Parameter explanation:
    #
    # --sysctl net.ipv6.conf.all.disable_ipv6=1 : Disables IPv6 since that caused package update issues
    # -e IN_DOCKER=true : Environment variable can be used to do things in the bashrc.
	if [[ "$graphics_choice" == "nvidia" ]]; then
		echo -e "Running Nvidia support\n"
		read -r -d '' docker_command <<- EOM
			nvidia-docker run -it \
				--user=$( id -u $USER ):$( id -g $USER ) \
				--device=/dev/dri:/dev/dri \
				--ipc=host \
				--net=host \
				--privileged \
				--sysctl net.ipv6.conf.all.disable_ipv6=1 \
				--env="DISPLAY"  \
				-e IN_DOCKER=true \
				--workdir="/home/$USER" \
				--volume="/home/$USER:/home/$USER" \
				--volume="/etc/group:/etc/group:ro" \
				--volume="/etc/passwd:/etc/passwd:ro" \
				--volume="/etc/shadow:/etc/shadow:ro" \
				--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
				--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
				--name "$container_name" \
				ros:kinetic-desktop-full-9-graphics-nvidia
		EOM
	elif [[ "$graphics_choice" == "intel" ]]; then
		echo -e "Running Intel support\n"
		export DISPLAY=:0
		xhost +
		read -r -d '' docker_command <<- EOM
			docker run -it \
				--user=$( id -u $USER ):$( id -g  $USER ) \
				--device=/dev/dri:/dev/dri \
				--ipc=host \
				--net=host \
				--privileged \
				--env="DISPLAY=$DISPLAY" \
				-e IN_DOCKER=true \
				--workdir="/home/$USER" \
				--volume="/home/$USER:/home/$USER" \
				--volume="/etc/group:/etc/group:ro" \
				--volume="/etc/passwd:/etc/passwd:ro" \
				--volume="/etc/shadow:/etc/shadow:ro" \
				--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
				--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
				--name "$container_name" \
				ros:kinetic-desktop-full-9-graphics-intel
		EOM
	else
		echo -e "Running without explicit graphics support\n"
		read -r -d '' docker_command <<- EOM
			docker run -it \
				--user=$( id -u $USER ):$( id -g  $USER ) \
				--device=/dev/dri:/dev/dri \
				--ipc=host \
				--net=host \
				--privileged \
				--env="DISPLAY=$DISPLAY" \
				-e IN_DOCKER=true \
				--workdir="/home/$USER" \
				--volume="/home/$USER:/home/$USER" \
				--volume="/etc/group:/etc/group:ro" \
				--volume="/etc/passwd:/etc/passwd:ro" \
				--volume="/etc/shadow:/etc/shadow:ro" \
				--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
				--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
				--name "$container_name" \
				ros:kinetic-desktop-full-4-ros
		EOM
    fi
	container_start_restart_connect $container_name $docker_command
elif [[ "$dist_choice" == "noetic" ]] || [ "$dist_choice" == "$noetic_focal" ]; then
    echo -e "\nUsing noetic container\n"
    # Parameter explanation:
    #
    # --sysctl net.ipv6.conf.all.disable_ipv6=1 : Disables IPv6 since that caused package update issues
    # -e IN_DOCKER=true : Environment variable can be used to do things in the bashrc.
	if [[ "$graphics_choice" == "nvidia" ]]; then
		echo -e "Running Nvidia support\n"
		read -r -d '' docker_command <<- EOM
			nvidia-docker run -it \
				--user=$( id -u $USER ):$( id -g $USER ) \
				--device=/dev/dri:/dev/dri \
				--ipc=host \
				--net=host \
				--privileged \
				--env="DISPLAY"  \
				-e IN_DOCKER=true \
				--workdir="/home/$USER" \
				--volume="/home/$USER:/home/$USER" \
				--volume="/etc/group:/etc/group:ro" \
				--volume="/etc/passwd:/etc/passwd:ro" \
				--volume="/etc/shadow:/etc/shadow:ro" \
				--volume="/etc/sudoers:/etc/sudoers:ro" \
				--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
				--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
				--name "$container_name" \
				ros:noetic-desktop-full-9-graphics-nvidia
		EOM
	elif [[ "$graphics_choice" == "intel" ]]; then
		echo "Noetic focal with intel acceleration is not supported yet."
		echo "Feel free to implement it and send a merge request."
		echo "In the meantime a container without graphics support can be chosen."
		exit -1
	else
		echo -e "Running without explicit graphics support\n"
		read -r -d '' docker_command <<- EOM
			docker run -it \
				--user=$( id -u $USER ):$( id -g $USER ) \
				--device=/dev/dri:/dev/dri \
				--ipc=host \
				--net=host \
				--privileged \
				--env="DISPLAY"  \
				-e IN_DOCKER=true \
				--workdir="/home/$USER" \
				--volume="/home/$USER:/home/$USER" \
				--volume="/etc/group:/etc/group:ro" \
				--volume="/etc/passwd:/etc/passwd:ro" \
				--volume="/etc/shadow:/etc/shadow:ro" \
				--volume="/etc/sudoers.d:/etc/sudoers.d:ro" \
				--volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
				--name "$container_name" \
				ros:noetic-desktop-full-4-ros
		EOM
	fi
	container_start_restart_connect $container_name $docker_command
else
    echo "Unknown distribution: $dist_choice"
fi
