FROM ros:noetic-desktop-full-3-programming

RUN apt update 

# System Utilities
RUN apt install -y python3-catkin-tools 	# More modern build tools that replace catkin_make
RUN apt install -y ros-noetic-rqt-rosmon    # ROSLaunch-like System
RUN apt install -y ros-noetic-moveit        # Motion Planning
RUN apt install -y ros-noetic-navigation        # Navigation
# by now it seems that rosdep is already initialized
#RUN rosdep init					# Initialize rosdep
