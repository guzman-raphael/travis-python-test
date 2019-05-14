# FROM mcr.microsoft.com/windows/nanoserver:1803-amd64
FROM vitaliylebedev/nano-minio:latest
ENV MINIO_ACCESS_KEY datajoint
ENV MINIO_SECRET_KEY datajoint

EXPOSE 9000

ENTRYPOINT C:\tools\minio.exe

# CMD ["/s","/c","echo","look here"]
CMD ["server", "C:\\Data"]


# -p 9000:9000 -e "MINIO_ACCESS_KEY=accessKey" -e "MINIO_SECRET_KEY=secretKey" vitaliylebedev/windows-minio C:\tools\minio.exe server C:\Data