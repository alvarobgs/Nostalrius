FROM alpine:3.10

RUN apk update
RUN apk upgrade
RUN apk add libzmq=4.3.3-r0 zlib=1.2.11-r1 zlib-dev=1.2.11-r1 bzip2-dev=1.0.6-r7 linux-headers=4.19.36-r0 make=4.2.1-r2 cmake=3.14.5-r0 gcc=8.3.0-r0 g++=8.3.0-r0 gmp-dev=6.1.2-r1 --repository="https://dl-cdn.alpinelinux.org/alpine/v3.10/main/"

RUN wget https://sourceforge.net/projects/boost/files/boost/1.53.0/boost_1_53_0.tar.gz/download -O boost.tar.gz
RUN tar -zxf boost.tar.gz
#RUN rm -rf boost.tar.gz
WORKDIR boost_1_53_0
RUN chmod +x bootstrap.sh
RUN ./bootstrap.sh || cat bootstrap.log
RUN ./b2 --prefix=/usr/local

ENV BOOST_ROOT=/boost_1_53_0/
ENV BOOST_LIBRARYDIR=/boost_1_53_0/libs/
ENV BOOST_INCLUDEDIR=/boost_1_53_0/
ENV LUA_INCLUDE_DIR=/usr/include/luajit-2.1/

RUN apk add mariadb-dev lua-dev pugixml-dev git
RUN apk add luajit=2.1.0_beta3-r4 luajit-dev=2.1.0_beta3-r4 --repository="https://dl-cdn.alpinelinux.org/alpine/v3.10/main/"

COPY cmake /otserv/cmake/
COPY src /otserv/src/
COPY CMakeLists.txt /otserv/CMakeLists.txt

WORKDIR /otserv/src

RUN cmake ..
RUN make

RUN mv tfs ../
WORKDIR /otserv

COPY data ./data/
COPY config.lua .

EXPOSE 7171

ENTRYPOINT ./tfs

#docker run -it --rm nost /bin/ash

