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

FROM python:3.7-alpine3.9

RUN apk add musl-dev g++ pkgconfig gcc freetype-dev graphviz ghostscript-fonts python3-tkinter
RUN addgroup -S rguzman && adduser -S -G rguzman rguzman

USER rguzman

RUN pip install --user datajoint

#docker run -d --name TEST --user=$(id -u) --env="DISPLAY" --volume="/etc/group:/etc/group:ro" --volume="/etc/passwd:/etc/passwd:ro" --volume="/etc/shadow:/etc/shadow:ro" --volume="/etc/sudoers.d:/etc/sudoers.d:ro" --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" -v /github/raphael/jnb/py:/src issue:v6.0 tail -f /dev/null
#docker run --name TEST --network dj_main -du $(id -u) -e DISPLAY -v /etc/group:/etc/group:ro -v /etc/passwd:/etc/passwd:ro -v /etc/shadow:/etc/shadow:ro -v /etc/sudoers.d:/etc/sudoers.d:ro -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v /github/raphael/jnb/py:/src issue:v6.0 tail -f /dev/null