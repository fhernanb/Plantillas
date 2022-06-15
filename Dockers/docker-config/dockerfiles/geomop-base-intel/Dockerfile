ARG images_version
ARG source_image
FROM ${source_image} as installer

FROM flow123d/flow123d-intel:${images_version}
MAINTAINER Martin Spetlik

COPY --from=installer /.mpiccpath /.mpiccpath

# install mpicc
RUN apt-get update && . /opt/intel/oneapi/setvars.sh && apt-get install -y intel-oneapi-mpi-devel

# install mpi4py
RUN . /opt/intel/oneapi/setvars.sh && env MPICC=/opt/intel/oneapi/mpi/latest/bin/mpicc python3 -m pip install --no-cache-dir --ignore-installed  mpi4py
