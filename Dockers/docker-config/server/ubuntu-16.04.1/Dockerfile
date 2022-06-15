FROM ubuntu:16.04
MAINTAINER Jan Hybs

# add link for bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# install sudo (for 16.04)
RUN apt-get update && apt-get install -y sudo


# preq
RUN sudo apt-get update && sudo apt-get install -y \
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
RUN sudo apt-get install -y docker.io


# install jenkins
RUN wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
RUN sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
RUN sudo apt-get update
RUN sudo apt-get install -y jenkins