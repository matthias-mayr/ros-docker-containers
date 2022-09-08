FROM ros:melodic-desktop-full-3-programming

RUN apt update 

# System Utilities
RUN apt install -y python-catkin-tools\ 	# More modern build tools that replace catkin_make
RUN apt install -y ros-melodic-rqt-rosmon   # ROSLaunch system
# by now it seems that rosdep is already initialized
#RUN rosdep init					# Initialize rosdep
