#!/bin/bash


get_distribution () {
    echo 'Please enter your choice: '
    kinetic_xenial="Kinetic Xenial 16.04"
    melodic_bionic="Melodic Bionic 18.04"
    noetic_focal="Noetic Focal 20.04"
    distribution=("$kinetic_xenial" "$melodic_bionic" "$noetic_focal" "Quit")
    select dist_choice in "${distribution[@]}"
    do
        case $dist_choice in
            $kinetic_xenial)
                echo "you chose $dist_choice"
                break
                ;;
            $melodic_bionic)
                echo "you chose choice $dist_choice"
                break
                ;;
            $noetic_focal)
                echo "you chose the choice $dist_choice"
                break
                ;;
            "Quit")
                exit 0
                ;;
            *) echo "invalid option $REPLY";;
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

if [[ "$dist_choice" == "melodic" ]] || [ "$dist_choice" == "$melodic_bionic" ]  ; then
    docker build melodic-bionic/1_system -t ros:melodic-desktop-full-1-system
    docker build melodic-bionic/2_user -t ros:melodic-desktop-full-2-user
    docker build melodic-bionic/3_programming -t ros:melodic-desktop-full-3-programming
    docker build melodic-bionic/4_ros -t ros:melodic-desktop-full-4-ros
        
    if [ "$graphics_choice" == "nvidia" ]; then
        docker build melodic-bionic/9_graphics_nvidia -t ros:melodic-desktop-full-9-graphics-nvidia
    elif [ "$graphics_choice" == "intel" ]; then
        echo "No option for intel with melodic yet"
        return false        
    fi
elif [[ "$dist_choice" == "kinetic" ]] || [ "$dist_choice" == "$kinetic_xenial" ]; then
    docker build kinetic-xenial/1_system -t ros:kinetic-desktop-full-1-system
    docker build kinetic-xenial/2_user -t ros:kinetic-desktop-full-2-user
    docker build kinetic-xenial/3_programming -t ros:kinetic-desktop-full-3-programming
    docker build kinetic-xenial/4_ros -t ros:kinetic-desktop-full-4-ros
        
    if [ "$graphics_choice" == "nvidia" ]; then
        docker build kinetic-xenial/9_graphics_nvidia -t ros:kinetic-desktop-full-9-graphics-nvidia
    elif [ "$graphics_choice" == "intel" ]; then
         docker build kinetic-xenial/9_graphics_intel -t ros:kinetic-desktop-full-9-graphics-intel
    fi
elif [[ "$dist_choice" == "noetic" ]] || [ "$dist_choice" == "$noetic_focal" ]; then
    docker build noetic-focal/1_system -t ros:noetic-desktop-full-1-system
    docker build noetic-focal/2_user -t ros:noetic-desktop-full-2-user
    docker build noetic-focal/3_programming -t ros:noetic-desktop-full-3-programming
    docker build noetic-focal/4_ros -t ros:noetic-desktop-full-4-ros
    if [ "$graphics_choice" == "nvidia" ]; then
        docker build noetic-focal/9_graphics_nvidia -t ros:noetic-desktop-full-9-graphics-nvidia
    elif [ "$graphics_choice" == "intel" ]; then
        echo "No option for intel with noetic yet"
        return false        
    fi
fi

