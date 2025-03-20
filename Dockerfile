FROM alpine:latest

COPY . /otserv/.

RUN apk update && \
    apk upgrade && \
    apk add --no-cache git make cmake gcc g++ boost-dev gmp-dev \
                       mariadb-dev lua-dev pugixml-dev luajit-dev

#RUN git clone https://luajit.org/git/luajit.git
#WORKDIR /luajit/src
#RUN make

WORKDIR /otserv/src
RUN ls -la
RUN cmake ..
RUN make
RUN chmod +x tfs

EXPOSE 7171

ENTRYPOINT ./tfs


=================


FROM alpine:3.10
COPY . /otserv/.

RUN apk update && \
    apk upgrade && \
    apk add --no-cache linux-headers git make cmake gcc g++ gmp-dev \
                       mariadb-dev lua-dev pugixml-dev luajit-dev

RUN apk add boost-dev=1.55.0-r0 --repository="https://dl-cdn.alpinelinux.org/alpine/v3.0/main/"


WORKDIR /otserv/src

RUN cmake ..
RUN make

RUN chmod +x tfs

EXPOSE 7171

ENTRYPOINT ./tfs
