FROM ubuntu:16.04
MAINTAINER Jan Hybs

# add link for bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# install sudo (for 16.04)
RUN apt-get update && apt-get install -y sudo


# preq
RUN sudo apt-get update && sudo apt-get install -y 
    nano \
    wget \
    git \
    apt-transport-https \
    ca-certificates \
    apparmor \
    man \
    python \
    git \
    python-pip


# install docker
# alt way to install wget -qO- https://get.docker.com/ | sh
RUN sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
RUN echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
RUN sudo apt-get update
RUN sudo apt-get purge lxc-docker
RUN sudo apt-cache policy docker-engine
RUN sudo apt-get install docker-engine


# install jenkins
RUN wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
RUN sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
RUN sudo apt-get update
RUN sudo apt-get install -y jenkins