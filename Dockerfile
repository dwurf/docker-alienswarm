FROM ubuntu:trusty

RUN dpkg --add-architecture i386 && \
    apt-get -y update && apt-get -y install wine wget xvfb

# DELETEME
RUN apt-get -y install tcpdump

RUN groupadd -g 1000 steam && useradd -u 1000 -g steam steam && mkdir /steam && chown steam.steam /steam

USER steam

ADD lib.sh /lib.sh 
ADD main /main 

VOLUME /steam

EXPOSE 27015/tcp
EXPOSE 27015/udp

CMD ["/bin/bash", "/main"]

