# FROM golang:1.12-alpine

# LABEL maintainer="MinIO Inc <dev@min.io>"

# ENV GOPATH /go
# ENV CGO_ENABLED 0
# ENV GO111MODULE on

# RUN  \
#      apk add --no-cache git && \
#      git clone https://github.com/minio/minio && cd minio && \
#      go install -v -ldflags "$(go run buildscripts/gen-ldflags.go)" && \
#      cd dockerscripts && \
#      env GOOS=windows GOARCH=amd64 go build -ldflags "-s -w" -o /usr/bin/healthcheck.exe healthcheck.go

# FROM python:3.7-alpine3.9

# RUN apk add musl-dev g++ pkgconfig gcc freetype-dev graphviz ghostscript-fonts python3-tkinter
# RUN addgroup -S rguzman && adduser -S -G rguzman rguzman

# USER rguzman

# RUN pip install --user datajoint

# USER root

# RUN chmod -R u+rwx,g+rwx,o+rwx /home/rguzman/.local

# USER rguzman


FROM python:3.7-alpine3.9

RUN apk add musl-dev g++ pkgconfig gcc freetype-dev graphviz ghostscript-fonts python3-tkinter

# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/dja && \
    echo "dja:x:${uid}:${gid}:Developer,,,:/home/dja:/bin/bash" >> /etc/passwd && \
    echo "dja:x:${uid}:" >> /etc/group && \
    # echo "dja ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    # chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/dja

USER dja
ENV HOME /home/dja

RUN pip install --user datajoint

#docker run --name GOOD --network dj_main -du $(id -u) -e DISPLAY -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro -v /etc/shadow:/etc/shadow:ro -v /etc/sudoers.d:/etc/sudoers.d:ro -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v /github/raphael/jnb/py:/src dj:v1.0 tail -f /dev/null
#docker run --name BEST --network dj_main -d -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v /github/raphael/jnb/py:/src test:v2.0 tail -f /dev/null
