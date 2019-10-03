FROM ros:kinetic-desktop-full-4-ros

RUN apt update 

# Inter Graphic cards driver
RUN \
  apt-get update && \
  apt-get -y install libgl1-mesa-glx libgl1-mesa-dri && \
  rm -rf /var/lib/apt/lists/*

# Install mesa-utils for debug only
RUN curl http://se.archive.ubuntu.com/ubuntu/pool/universe/m/mesa-demos/mesa-utils_8.4.0-1_amd64.deb > mesa-utils_8.4.0-1_amd64.deb
