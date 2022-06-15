# Dockerfile structure
Simple scheme where dependencies are shown:
```
└── base
    ├── base-build
    │   ├── flow-dev-dbg
    │   └── flow-dev-rel
    └── install
```

# Active images
## Dockerfile  `flow123d/base` ![base](https://img.shields.io/badge/base-210.5 MB | 5 layers-blue.svg)
 - Contains minimal libs and packages. This image is ancestor for all other images and originates from `ubuntu:16.04`.
 - What is installed:
   - `make, wget, python`
   
Layer                                           | Size
----------------------------------------------- | ---
`/bin/sh -c #(nop) CMD ["/bin/bash"]          ` |  0 B                 
`/bin/sh -c #(nop)  MAINTAINER Jan Hybs       ` |  0 B                 
`/bin/sh -c rm /bin/sh && ln -s /bin/bash /bin` |  0 B                 
`/bin/sh -c apt-get update && apt-get install ` |  84.1 MB             
`/bin/sh -c #(nop) COPY file:9bd64bd216d11d547` |  240 B               


## Dockerfile `flow123d/base-build` ![base-build](https://img.shields.io/badge/base--build-5.485 MB | 7 layers-blue.svg)
 - Image for building other libraries. Originates from `flow123d/base`
 - *note*: big image size is cause be full latex environment
 - What is installed:
   - `cmake, git, python, python-dev, python-pip, pandoc, pandoc-fignos`
     `valgrind, perl, gfortran, gcc, g++, (texlive-full disabled)`
   - `libblas-dev, liblapack-dev, libmpich-dev, libopenmpi-dev`
   - `libboost`:
     - `libboost-program-options-dev`
     - `libboost-serialization-dev`
     - `libboost-regex-dev`
     - `libboost-filesystem-dev`
   - `python pip`:
     - `pyyaml`
     - `markdown`
     - `psutil`

Layer                                           | Size
----------------------------------------------- | ---
`/bin/sh -c #(nop)  MAINTAINER Jan Hybs       ` |  0 B                 
`/bin/sh -c sudo apt-get update && sudo apt-ge` |  850.7 MB            
`/bin/sh -c sudo apt-get update && sudo apt-ge` |  218 MB              
`/bin/sh -c sudo apt-get update && sudo apt-ge` |  154.4 MB            
`/bin/sh -c sudo pip install     pyyaml     ma` |  6.657 MB            
`/bin/sh -c sudo apt-get update && sudo apt-ge` |  4.01 GB             
`/bin/sh -c pip install     pandoc-fignos     ` |  342.8 kB            


## Dockerfile `flow123d/flow-dev-gnu-dbg` ![flow-dev-gnu-dbg](https://img.shields.io/badge/flow--libs--dev--dbg-5.8 GB | 7 layers-blue.svg)
Contains additional debug libraries compiled with debug flag: `YamlCpp, PETSC, Armadillo, BDDCML`

Layer                                           | Size
----------------------------------------------- | ---
`/bin/sh -c #(nop)  MAINTAINER Jan Hybs`        |  0 B 
`/bin/sh -c #(nop)  ARG BUILD_TYPE=release`     |  0 B
`/bin/sh -c #(nop) COPY file:394778cdc9cf1be4f` |  708 B
`BUILD_TYPE=debug /bin/sh -c /usr/bin/ins`      |  486.5 MB
`BUILD_TYPE=debug /bin/sh -c /usr/bin/ins`      |  12.61 MB
`BUILD_TYPE=debug /bin/sh -c /usr/bin/ins`      |  4.838 MB
`BUILD_TYPE=debug /bin/sh -c /usr/bin/ins`      |  37.73 MB

## Dockerfile `flow123d/flow-dev-gnu-rel` ![flow-dev-gnu-rel](https://img.shields.io/badge/flow--libs--dev--rel-6.2 GB | 7 layers-blue.svg)
 Contains additional debug libraries compiled with release flag: `YamlCpp, PETSC, Armadillo, BDDCML`
 
Layer                                           | Size
 ----------------------------------------------- | ---
 `/bin/sh -c #(nop)  MAINTAINER Jan Hybs`        |  0 B 
 `/bin/sh -c #(nop)  ARG BUILD_TYPE=release`     |  0 B
 `/bin/sh -c #(nop) COPY file:394778cdc9cf1be4f` |  708 B
 `BUILD_TYPE=release /bin/sh -c /usr/bin/ins`    |  384.5 MB
 `BUILD_TYPE=release /bin/sh -c /usr/bin/ins`    |  3.761 MB
 `BUILD_TYPE=release /bin/sh -c /usr/bin/ins`    |  4.838 MB
 `BUILD_TYPE=release /bin/sh -c /usr/bin/ins`    |  19.42 MB


## Dockerfile `flow123d/flow-install` ![flow-libs-install](https://img.shields.io/badge/flow--libs--install-532.5 MB | 4 layers-blue.svg)
Contains all necessary packages for Flow123d to run

Layer                                           | Size
----------------------------------------------- | ---
`/bin/sh -c #(nop)  MAINTAINER Jan Hybs`        |  0 B 
`/bin/sh -c #(nop)  ARG BUILD_TYPE=release`     |  0 B
`/bin/sh -c sudo apt-get update && sudo apt-ge` |  351.7 B
`/bin/sh -c sudo pip install     pyyaml     ma` |  6.987 B
