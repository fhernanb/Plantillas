# Common building tools.
ARG images_version
FROM flow123d/base-intel:${images_version}
MAINTAINER Jan Hybs
ARG images_version

# Environment variables are part of the images.
# We will use the same base boost package when selectiong specific parts of the BOOST for the install image.

    
# install basic set of tools and pandoc tools
RUN sudo apt-get update && sudo apt-get install -y  \
    make \ 
    cmake \
    wget \
    git \    
    apt-utils \
    man \
    tree \
    clang \
    gdbserver \
    valgrind \
    oprofile \
    pandoc \
    ccache \
    libboost1.71-dev \
    libboost-program-options1.71-dev \
    libboost-serialization1.71-dev \
    libboost-regex1.71-dev \
    libboost-filesystem1.71-dev \    
    lib32z1-dev \
    libpugixml-dev \
    libpython3.9-dev

# install intel compiler, mkl and mpi
RUN apt-get update && apt-get install -y \
  intel-oneapi-compiler-dpcpp-cpp-and-cpp-classic \
  intel-oneapi-compiler-fortran \
  intel-oneapi-mkl-devel \
  intel-oneapi-mpi-devel && \
  rm -rf /var/lib/apt/lists/*

# install doxygen and graphviz, latex
RUN sudo apt-get update && sudo apt-get install -y --no-install-recommends  \
    doxygen \
    graphviz \
    texlive \
    texlive-base \
    texlive-binaries \
    texlive-extra-utils \
    texlive-font-utils \
    texlive-fonts-recommended \
    texlive-plain-generic \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-latex-recommended \
    texlive-pictures \
    texlive-pstricks \
    texlive-science \
    lmodern \
    imagemagick

# some pip packages
RUN pip3 install \
    markdown \
    formic \
    pymongo \
    pandoc-fignos \
    pandoc-tablenos

    
# /usr/bin/c++ |-> /etc/alternatives/c++ -> /usr/bin/g++ -> /etc/alternatives/g++ |-> /usr/bin/g++-9
#              |                                                                  |-> /usr/bin/g++-8
#              |                                                                  |-> /usr/bin/g++-7
#              |                                                                  |-> /usr/bin/g++-6
#              |-> /etc/alternatives/c++ -> /usr/bin/clang++


#  && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-6 6 \
#  && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 6 \


# set desired compilers
# RUN update-alternatives --install /usr/bin/gcc gcc ${DEFAULT_GCC} 100 \
#  && update-alternatives --install /usr/bin/g++ g++ ${DEFAULT_GXX} 100 \
#  && update-alternatives --install /usr/bin/c++ c++ ${DEFAULT_CXX} 100 \
#  && update-alternatives --auto gcc \
#  && update-alternatives --auto g++ \
#  && update-alternatives --auto c++ \
#  && echo "gcc   " && gcc --version \
#  && echo "g++   " && g++ --version \
#  && echo "c++   " && c++ --version \
#  && echo "update-alternatives requested version set"



    


