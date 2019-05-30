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
RUN addgroup -S djuser && adduser -S -G djuser djuser

USER djuser

RUN pip install --user datajoint