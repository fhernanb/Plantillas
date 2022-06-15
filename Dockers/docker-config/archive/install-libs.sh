#!/bin/bash
#PBS -N install-libs
#PBS -l mem=4gb
#PBS -l scratch=1gb
#PBS -l nodes=1:ppn=2
#PBS -l walltime=01:59:00
#PBS -j oe
# ::  qsub -l walltime=2h -l nodes=1:ppn=2,mem=4gb -I



# set current dir manually because when using qsub, location is elsewhere
DIR=/storage/praha1/home/jan-hybs/projects/docker-config/cmakefiles
# specify location where libs will be build
LIBS_ROOT=/storage/praha1/home/jan-hybs/libs/release
# location of the flow123d
FLOW_LOC=/storage/praha1/home/jan-hybs/projects/Flow123dDocker/flow123d
_SEP_="--------------------------------------------------------------------------"

cd $DIR
mkdir -p $LIBS_ROOT

# ------------------------------------------------------------------------------
# ----------------------------------------------------------------- MODULES ----
# ------------------------------------------------------------------------------
echo "Loading modules"
echo $_SEP_
module load cmake-2.8.12
module load gcc-4.9.2
module load boost-1.56-gcc
module load perl-5.20.1-gcc
module load openmpi

module load python27-modules-gcc
module load python-2.7.6-gcc      # version 2.7.10-gcc has issue when importing hashlib 
                                  # > python
                                  # import hashlib
                                  # <ERROR>

module unload gcc-4.8.1
module unload openmpi-1.8.2-gcc

echo "Modules loaded"
module list
echo $_SEP_


# ------------------------------------------------------------------------------
# ------------------------------------------------------------ YAML-CPP LIB ----
# ------------------------------------------------------------------------------
# default build type
BUILD_TYPE=Release
# default location for building
BUILD_TREE=$LIBS_ROOT/yamlcpp
# ------------------------------------------------------------------------------
echo "Building project YAML-CPP ($BUILD_TYPE)"
echo "Build directory set to: "
echo "  $BUILD_TREE"
echo $_SEP_


# make -C $DIR/yamlcpp \
#     BUILD_TYPE=$BUILD_TYPE \
#     BUILD_TREE=$BUILD_TREE \
#     build

# fix installation, since flow123d FindYamlCPP expect .a file
# to be in lib folder, we do it manually without package call
mkdir -p $BUILD_TREE/$BUILD_TYPE/lib
cp $BUILD_TREE/$BUILD_TYPE/libyaml-cpp.a $BUILD_TREE/$BUILD_TYPE/lib/libyaml-cpp.a
echo $_SEP_


# ------------------------------------------------------------------------------
# --------------------------------------------------------------- PETSC LIB ----
# ------------------------------------------------------------------------------
# default build type
BUILD_TYPE=Release
# default location for building
PETSC_DIR=$LIBS_ROOT/petsc
PETSC_ARCH=linux-$BUILD_TYPE
# ------------------------------------------------------------------------------
echo "Building project PETSC ($BUILD_TYPE)"
echo "Build directory set to: "
echo "  PETSC_DIR=$PETSC_DIR"
echo "Architecture set to: "
echo "  PETSC_ARCH=$PETSC_ARCH"

echo $_SEP_


# create config file which will configure petsc project
CONFIG_FILE=$DIR/petsc/config/$BUILD_TYPE.config.sh
cat <<EOT > $CONFIG_FILE
#!/bin/bash
mkdir -p @PETSC_DIR@
cp -r @INSTALL_DIR@/src/* @PETSC_DIR@
cd @PETSC_DIR@

module list

./configure \
        PETSC_ARCH=@PETSC_ARCH@ \
        --download-metis=yes --download-parmetis=yes \
        --download-blacs=yes --download-scalapack=yes --download-mumps=yes --download-hypre=yes \
        --with-debugging=0 --with-shared-libraries=0 \
        --with-make-np @MAKE_NUMCPUS@ --CFLAGS="-O3" --CXXFLAGS="-O3 -Wall -Wno-unused-local-typedefs -std=c++11"
EOT
chmod +x $CONFIG_FILE

# make -C $DIR/petsc \
#     BUILD_TYPE=$BUILD_TYPE \
#     PETSC_DIR=$PETSC_DIR \
#     build

echo $_SEP_


# ------------------------------------------------------------------------------
# ----------------------------------------------------------- ARMADILLO LIB ----
# ------------------------------------------------------------------------------
# default build type
BUILD_TYPE=Release
USE_PETSC=On
# default location for building
BUILD_TREE=$LIBS_ROOT/armadillo
# ------------------------------------------------------------------------------
echo "Building project ARMADILLO ($BUILD_TYPE)"
echo "Build directory set to: "
echo "  $BUILD_TREE"
echo $_SEP_


# make -C $DIR/armadillo \
#     BUILD_TYPE=$BUILD_TYPE \
#     BUILD_TREE=$BUILD_TREE \
#     USE_PETSC=$USE_PETSC \
#     PETSC_DIR=$PETSC_DIR \
#     PETSC_ARCH=$PETSC_ARCH \
#     build

echo $_SEP_



# ------------------------------------------------------------------------------
# -------------------------------------------------------------- BDDCML LIB ----
# ------------------------------------------------------------------------------
# default build type
BUILD_TYPE=Release
USE_PETSC=On
# default location for building
BUILD_TREE=$LIBS_ROOT/bddcml
# ------------------------------------------------------------------------------
echo "Building project BDDCML ($BUILD_TYPE)"
echo "Build directory set to: "
echo "  $BUILD_TREE"
echo $_SEP_


# make -C $DIR/bddcml \
#     BUILD_TYPE=$BUILD_TYPE \
#     BUILD_TREE=$BUILD_TREE \
#     USE_PETSC=$USE_PETSC \
#     PETSC_DIR=$PETSC_DIR \
#     PETSC_ARCH=$PETSC_ARCH \
#     build

echo $_SEP_

echo "# Configuration for metacentrum"    >  config.cmake
echo "set(FLOW_BUILD_TYPE release)"       >> config.cmake
echo "set(CMAKE_VERBOSE_MAKEFILE on)"     >> config.cmake
echo "set(LIBS_ROOT $LIBS_ROOT)"          >> config.cmake
echo "set(LIB_BUILD_TYPE Release)"        >> config.cmake
cat <<EOT > config.cmake
# Configuration for metacentrum
set(FLOW_BUILD_TYPE release)
set(CMAKE_VERBOSE_MAKEFILE on)

# external libraries
set(PETSC_DIR           "$LIBS_ROOT/petsc/")
set(PETSC_ARCH          "linux-$BUILD_TYPE")

set(BDDCML_ROOT         "$LIBS_ROOT/bddcml/bddcml/$BUILD_TYPE")
set(YamlCpp_ROOT_HINT   "$LIBS_ROOT/yamlcpp/$BUILD_TYPE")
set(Armadillo_ROOT_HINT "$LIBS_ROOT/armadillo/$BUILD_TYPE")


# additional info
set(USE_PYTHON          "yes")
set(PLATFORM_NAME       "linux_x86_64")
EOT


cp $DIR/config.cmake $FLOW_LOC/config.cmake
cd $FLOW_LOC
git branch
git fetch
git pull origin master
make -j2 all


# set permission to 777 to other people can 
# execute files and access libs
chmod -R 777 $FLOW_LOC/bin
chmod -R 777 $FLOW_LOC/tests/runtest
chmod -R 777 $FLOW_LOC/build_tree/bin

# allow access to libs
chmod 777 $LIBS_ROOT/*