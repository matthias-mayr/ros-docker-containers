FROM osrf/ros:kinetic-desktop-full

RUN apt update 

# System Utilities
RUN apt install -y sudo aptitude			# sudo is needed for root priviledges
RUN apt install -y xterm tmux wget vim
RUN apt install -y ssh-askpass openssh-client
RUN apt install -y software-properties-common		# To be able to run add-apt-repository
