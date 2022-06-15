# Layers ![info](https://img.shields.io/badge/flow123d/base-221.0 MB-blue.svg)
| Layer | Command                                     |  Size (MB)  | Duration (s) |
|-------|---------------------------------------------|-------------|--------------|
|   1   |`FROM ubuntu:16.04                          `|    0.00     |     5.23     |
|   2   |`MAINTAINER Jan Hybs                        `|    0.00     |     0.03     |
|   3   |`RUN rm /bin/sh && ln -s /bin/bash /bin/sh  `|    0.00     |     0.08     |
|   4   |`RUN apt-get update && apt-get install -y   `|   100.07    |    55.17     |
|   5   |`COPY autoload.sh /etc/profile.d/autoload.s `|    0.00     |     0.05     |
|   6   |`CMD ["/bin/bash", "-l"]                    `|    0.00     |     0.03     |
# Details
 - **Layer 1:**
   
    ```dockerfile
FROM ubuntu:16.04
```

 - **Layer 2:**
   
    ```dockerfile
MAINTAINER Jan Hybs
```

 - **Layer 3:**
   
    ```dockerfile
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
```

 - **Layer 4:**
   
    ```dockerfile
RUN apt-get update && apt-get install -y  \
    sudo \
    make \
    wget  \
    python3 \
    bash-completion \
    apt-utils \
    nano \
    less \
    man
```

 - **Layer 5:**
   
    ```dockerfile
COPY autoload.sh /etc/profile.d/autoload.sh
```

 - **Layer 6:**
   
    ```dockerfile
CMD ["/bin/bash", "-l"]
```

