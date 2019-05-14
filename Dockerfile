# FROM mcr.microsoft.com/windows/nanoserver:1803-amd64

# FROM vitaliylebedev/nano-minio:latest
# FROM minherz/minio-server:nanoserver
# FROM vitaliylebedev/windows-minio:latest

# ENV MINIO_ACCESS_KEY datajoint
# ENV MINIO_SECRET_KEY datajoint

# EXPOSE 9000

# ENTRYPOINT C:\\tools\\minio.exe

# # CMD ["/s","/c","echo","look here"]
# CMD ["server", "C:\\Data"]


# -p 9000:9000 -e "MINIO_ACCESS_KEY=accessKey" -e "MINIO_SECRET_KEY=secretKey" vitaliylebedev/windows-minio C:\tools\minio.exe server C:\Data


FROM mcr.microsoft.com/windows/nanoserver:1803-amd64

ENV MINIO_ACCESS_KEY datajoint
ENV MINIO_SECRET_KEY datajoint

WORKDIR C:/minio
RUN mkdir data config
RUN powershell "Invoke-WebRequest -Uri https://dl.minio.io/server/minio/release/windows-amd64/minio.exe -OutFile minio.exe"
VOLUME [ "C:/minio/data", "C:/minio/config" ]
EXPOSE 9000
ENTRYPOINT [ "C:/minio/minio.exe" ]
CMD [ "server" , "--config-dir" , "config" , "data" ]