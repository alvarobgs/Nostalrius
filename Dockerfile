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