FROM ros:kinetic-desktop-full-4-ros

RUN apt update 

# Inter Graphic cards driver
RUN \
  apt-get update && \
  apt-get -y install libgl1-mesa-glx libgl1-mesa-dri mesa-utils&& \
  rm -rf /var/lib/apt/lists/*

# Install mesa-utils for debug only
