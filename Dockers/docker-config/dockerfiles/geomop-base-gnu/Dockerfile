ARG images_version
ARG source_image
FROM ${source_image} as installer

FROM flow123d/flow123d-gnu:${images_version}
MAINTAINER Martin Spetlik

COPY --from=installer /.mpiccpath /.mpiccpath
RUN env MPICC=$(cat /.mpiccpath) python3 -m pip install --no-cache-dir --ignore-installed  mpi4py
