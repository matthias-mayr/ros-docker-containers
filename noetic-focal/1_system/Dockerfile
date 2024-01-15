FROM osrf/ros:noetic-desktop-full

RUN apt update 

# System Utilities
RUN apt install -y sudo aptitude			# sudo for root priviledges
RUN apt install -y xterm tmux wget vim
RUN apt install -y ssh-askpass openssh-client keychain # SSH tooling
RUN apt install -y software-properties-common	# To be able to run add-apt-repository
RUN apt install -y psmisc                       # Get 'killall'
