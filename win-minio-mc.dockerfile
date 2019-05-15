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


# FROM mcr.microsoft.com/windows/nanoserver:1803-amd64
# FROM mcr.microsoft.com/windows/servercore-insider:10.0.18362.53-amd64 as core 
FROM stefanscherer/netapi-helper:1803 as core
FROM mcr.microsoft.com/powershell:6.2.0-nanoserver-1803
COPY --from=core /windows/system32/netapi32.dll /windows/system32/netapi32.dll

MAINTAINER raphael.h.guzman@gmail.com

ENV MINIO_ACCESS_KEY datajoint
ENV MINIO_SECRET_KEY datajoint

WORKDIR C:/minio-mc
RUN pwsh -NoLogo -NoProfile -Command "Invoke-WebRequest -Uri https://dl.minio.io/client/mc/release/windows-amd64/mc.exe -OutFile mc.exe"


# RUN pwsh -NoLogo -NoProfile -Command 'icacls "minio.exe" /grant Everyone:(OI)(CI)F /T'
# RUN pwsh -NoLogo -NoProfile -Command 'Get-Acl -Path "minio.exe" | Format-Table -Wrap'

# RUN pwsh -NoLogo -NoProfile -Command 'ICACLS "minio.exe" /setowner "administrator"'
# RUN pwsh -NoLogo -NoProfile -Command 'ICACLS "minio.exe" /grant:r "administrator:(F)" /C'
# RUN pwsh -NoLogo -NoProfile -Command 'ICACLS "minio.exe" /grant:r "users:(RWX)" /C'
# RUN pwsh -NoLogo -NoProfile -Command 'ICACLS "minio.exe" /grant:r "users:(R)" /C'

# RUN pwsh -NoLogo -NoProfile -Command 'whoami'
# RUN pwsh -NoLogo -NoProfile -Command '$acl = Get-Acl "minio.exe";$perm = "administrator", "FullControl", "None", "None", "Allow";$rule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $perm;$acl.SetAccessRule($rule);$acl | Set-Acl -Path "minio.exe"'

# VOLUME [ "C:/minio/data" ]
# EXPOSE 9000
# ENTRYPOINT [ "C:/minio-mc/mc.exe" ]
# CMD [ "config" , "host" , "add" , "dj-s3", "http://minio:9000", "datajoint" , "datajoint"]
# CMD [ "Get-Acl","-Path",'"minio.exe"',"|","Format-Table","-Wrap" ]

RUN setx path "%path%;C:\minio-mc"
# RUN setx /M PATH $($Env:PATH + ';C:\minio-mc')

ENTRYPOINT ["pwsh.exe" , "-NoLogo", "-NoProfile", "-Command"]
CMD ["mc.exe config host add dj-s3 http://minio:9000 datajoint datajoint"]