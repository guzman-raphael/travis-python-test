# FROM nanoserver/iis-php
FROM mcr.microsoft.com/powershell:6.2.0-nanoserver-1803

MAINTAINER raphael.h.guzman@gmail.com

ADD https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.22-winx64.zip mysql.zip
# ADD https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.9-winx64.zip mysql.zip

RUN pwsh -NoLogo -NoProfile -Command \
    Expand-Archive -Path c:\mysql.zip -DestinationPath C:\ ; \
    ren C:\mysql-5.7.22-winx64 C:\MySQL ; \
    New-Item -Path C:\MySQL\data -ItemType directory
    # Remove-Item c:\mysql.zip -Force ; \
    # C:\MySQL\bin\mysqld.exe --initialize --log_syslog=0
    # C:\MySQL\bin\mysqld.exe --initialize --console --explicit_defaults_for_timestamp ; \
    # C:\MySQL\bin\mysqld.exe --install ; \
    # Start-Service mysql ; \
    # Remove-Item c:\mysql.zip -Force

# ADD https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-installer-web-community-5.7.9.0.msi c:/mysql-5.7.9.0.msi

# SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
# RUN Start-Process 'C:\mysql-5.7.9.0.msi' '/qn' -PassThru | Wait-Process;


# SHELL ["cmd", "/C"]


# RUN echo hi
# RUN msiexec /i mysql-5.7.9.0.msi /quiets

    
ENV MYSQL C:\\MySQL
RUN setx path "%path%;C:\MySQL\bin"

# EXPOSE 3306
ENTRYPOINT ["pwsh.exe" , "-NoLogo", "-NoProfile", "-Command"]
# CMD ["mysql -u root -psimple -h mysqlref -e 'SELECT User, Host FROM mysql.user'"]
CMD ["mysql -u root -psimple -h mysqlref -e \"SELECT User, Host FROM mysql.user\""]
