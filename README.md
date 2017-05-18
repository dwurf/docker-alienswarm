docker-alienswarm
=================

Dockerfile for running an Alien Swarm: Reactive Drop server under 
[wine](https://www.winehq.org)

Requirements
------------

1GB RAM and 5GB free disk space are essential. 

Simple start
------------

    docker run -d -t --name alienswarm \
        -p 27015:27015/tcp \
        -p 0.0.0.0:27015:27015/udp \
        -v $HOME/alienswarm:/steam \
        dwurf/docker-alienswarm:latest

Variables
---------

Not implemented yet.

Building the image
------------------

    docker build .

