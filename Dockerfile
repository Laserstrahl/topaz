FROM ubuntu:18.04

# Avoid any UI since we don't have one
ENV DEBIAN_FRONTEND=noninteractive

# Working directory will be /code meaning that the contents of topaz will exist in /code
WORKDIR /code

# Update and install all requirements as well as some useful tools such as net-tools and nano
RUN apt update && apt install -y net-tools nano build-essential software-properties-common g++-8 luajit-5.1-dev libzmq3-dev luarocks python3.7 cmake pkg-config g++ dnsutils git mariadb-server libluajit-5.1-dev libzmq3-dev autoconf pkg-config zlib1g-dev libssl-dev python3.6-dev libmysqlclient-dev

# Copy everything from the host machine topaz folder to /code
ADD . /code

RUN cmake . && make -j $(nproc)

# Copy the docker config files to the conf folder instead of the default config
COPY /conf/docker/* conf/

# Startup the server when the container starts
ENTRYPOINT nohup ./topaz_connect > topaz_connect.log & \
nohup ./topaz_game > topaz_game.log & \
./topaz_search > topaz_search.log