FROM ubuntu:latest

MAINTAINER Zoltán Farkas

ADD vina.sh /usr/bin/
RUN apt-get update
RUN apt-get install -y unzip curl wget
RUN wget -O - https://github.com/occopus/flowbster/raw/master/examples/vina/bin/vina_exe.tgz | tar -C /usr/bin/ -zxf -
