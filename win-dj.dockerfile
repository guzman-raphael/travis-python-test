FROM microsoft/windowsservercore:1803 as base

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV PYTHON_VERSION 3.6.5
ENV PYTHON_RELEASE 3.6.5

RUN $url = ('https://www.python.org/ftp/python/{0}/python-{1}-amd64.exe' -f $env:PYTHON_RELEASE, $env:PYTHON_VERSION); \
	Write-Host ('Downloading {0} ...' -f $url); \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -Uri $url -OutFile 'python.exe'; \
	\
	Write-Host 'Installing ...'; \
# https://docs.python.org/3.5/using/windows.html#installing-without-ui
	Start-Process python.exe -Wait \
		-ArgumentList @( \
			'/quiet', \
			'InstallAllUsers=1', \
			'TargetDir=C:\Python', \
			'PrependPath=1', \
			'Shortcuts=0', \
			'Include_doc=0', \
			'Include_pip=0', \
			'Include_test=0' \
		); \
	\
# the installer updated PATH, so we should refresh our local value
	$env:PATH = [Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine); \
	\
	Write-Host 'Verifying install ...'; \
	Write-Host '  python --version'; python --version; \
	\
	Write-Host 'Removing ...'; \
	Remove-Item python.exe -Force; \
	\
	Write-Host 'Complete.';

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ENV PYTHON_PIP_VERSION 9.0.3

RUN Write-Host ('Installing pip=={0} ...' -f $env:PYTHON_PIP_VERSION); \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -Uri 'https://bootstrap.pypa.io/get-pip.py' -OutFile 'get-pip.py'; \
	python get-pip.py \
		--disable-pip-version-check \
		--no-cache-dir \
		('pip=={0}' -f $env:PYTHON_PIP_VERSION) \
	; \
	Remove-Item get-pip.py -Force; \
	\
	Write-Host 'Verifying pip install ...'; \
	pip --version; \
	\
	Write-Host 'Complete.';

FROM mcr.microsoft.com/powershell:6.2.0-nanoserver-1803

COPY --from=base ["Python", "Python"]

# USER ContainerAdministrator
# RUN setx /M PATH %PATH%;c:\Python\;c:\Python\scripts\;
RUN setx PATH "%PATH%;c:\Python;c:\Python\scripts"
# USER ContainerUser

# SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# RUN mkdir C:\src
# RUN New-Item -Path C:\src -ItemType directory
# SHELL ["cmd", "/C"]
# RUN echo %username%
# USER ContainerAdministrator
WORKDIR c:/src
VOLUME C:/src
ENTRYPOINT ["pwsh.exe" , "-NoLogo", "-NoProfile", "-Command"]
CMD ["python --version"]


# FROM microsoft/windowsservercore:1803 as base

# SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# ENV PYTHON_VERSION 3.6.5
# ENV PYTHON_RELEASE 3.6.5

# RUN $url = ('https://www.python.org/ftp/python/{0}/python-{1}-amd64.exe' -f $env:PYTHON_RELEASE, $env:PYTHON_VERSION); \
# 	Write-Host ('Downloading {0} ...' -f $url); \
# 	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
# 	Invoke-WebRequest -Uri $url -OutFile 'python.exe'; \
# 	\
# 	Write-Host 'Installing ...'; \
# # https://docs.python.org/3.5/using/windows.html#installing-without-ui
# 	Start-Process python.exe -Wait \
# 		-ArgumentList @( \
# 			'/quiet', \
# 			'InstallAllUsers=1', \
# 			'TargetDir=C:\Python', \
# 			'PrependPath=1', \
# 			'Shortcuts=0', \
# 			'Include_doc=0', \
# 			'Include_pip=0', \
# 			'Include_test=0' \
# 		); \
# 	\
# # the installer updated PATH, so we should refresh our local value
# 	$env:PATH = [Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine); \
# 	\
# 	Write-Host 'Verifying install ...'; \
# 	Write-Host '  python --version'; python --version; \
# 	\
# 	Write-Host 'Removing ...'; \
# 	Remove-Item python.exe -Force; \
# 	\
# 	Write-Host 'Complete.';

# # if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
# ENV PYTHON_PIP_VERSION 9.0.3

# RUN Write-Host ('Installing pip=={0} ...' -f $env:PYTHON_PIP_VERSION); \
# 	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
# 	Invoke-WebRequest -Uri 'https://bootstrap.pypa.io/get-pip.py' -OutFile 'get-pip.py'; \
# 	python get-pip.py \
# 		--disable-pip-version-check \
# 		--no-cache-dir \
# 		('pip=={0}' -f $env:PYTHON_PIP_VERSION) \
# 	; \
# 	Remove-Item get-pip.py -Force; \
# 	\
# 	Write-Host 'Verifying pip install ...'; \
# 	pip --version; \
# 	\
# 	Write-Host 'Complete.';

# # FROM microsoft/nanoserver:1803
# FROM mcr.microsoft.com/powershell:6.2.0-nanoserver-1803

# COPY --from=base ["Python", "Python"]

# SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]


# ENV MINGIT_VERSION 2.21.0
# ADD https://raw.githubusercontent.com/computeronix/docker-mingit/master/get_dep_ver.ps1 get_dep_ver.ps1

# # RUN .\get_dep_ver.ps1; \
# #     Invoke-WebRequest $('https://github.com/git-for-windows/git/releases/download/v{0}.windows.1/MinGit-{0}-64-bit.zip' -f $MINGIT_VERSION) -OutFile 'mingit.zip' -UseBasicParsing ; \
# #     \
# #     Expand-Archive mingit.zip -DestinationPath C:\mingit ; \
# #     $env:PATH = 'C:\mingit\cmd;{0}' -f $env:PATH ; \
# #     Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' -Name Path -Value $env:PATH ; \
# #     Remove-Item -Path mingit.zip; \
# #     Remove-Item get_dep_ver.ps1; \
# #     Write-Host git version; git version;


# # ADD https://github.com/git-for-windows/git/releases/download/v2.21.0.windows.1/MinGit-2.21.0-64-bit.zip MinGit.zip

# # RUN Expand-Archive c:\MinGit.zip -DestinationPath c:\MinGit; \
# # $env:PATH = $env:PATH + ';C:\MinGit\cmd\;C:\MinGit\cmd'; \
# # Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment' -Name Path -Value $env:PATH

# USER ContainerAdministrator
# RUN setx /M PATH %PATH%;c:\Python\;c:\Python\scripts\;
# # RUN setx /M DJ_HOST mysqlref
# # RUN setx /M DJ_USER root
# # RUN setx /M DJ_PASS simple
# USER ContainerUser

# # RUN pip install datajoint
# #RUN pip install nose

# RUN \
# 	New-Item -Path 'c:\"' -Name 'src' -ItemType 'directory'
# 	#; \
# 	#Set-Location -Path C:\src; \
# 	#git clone https://github.com/datajoint/datajoint-python.git; \
# 	#Set-Location -Path C:\src\datajoint-python; \
# 	#pip install .


# #COPY run.py run.py

# ENTRYPOINT ["pwsh.exe" , "-NoLogo", "-NoProfile", "-Command"]
# # CMD ["python --help"]
# #CMD ["Set-Location -Path C:\src\datajoint-python\tests;nosetests -v --nocapture"]


# # FROM mcr.microsoft.com/powershell:6.2.0-nanoserver-1803

# # # USER Administrator

# # SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# # ENV PYTHON_VERSION 3.7.3
# # ENV PYTHON_RELEASE 3.7.3

# # WORKDIR C:/base
# # # RUN setx path "%path%;C:\python"
# # RUN $url = ('https://www.python.org/ftp/python/{0}/python-{1}-amd64.exe' -f $env:PYTHON_RELEASE, $env:PYTHON_VERSION); \
# # 	Write-Host ('Downloading {0} ...' -f $url); \
# # 	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
# # 	Invoke-WebRequest -Uri $url -OutFile 'python.exe'; \
# # 	\
# # 	Write-Host 'Installing ...'; \
# # # https://docs.python.org/3.5/using/windows.html#installing-without-ui
# # 	Start-Process python.exe -Wait \
# # 		-ArgumentList @( \
# # 			'/quiet', \
# # 			'InstallAllUsers=1', \
# # 			'TargetDir=C:\Python', \
# # 			'PrependPath=1', \
# # 			'Shortcuts=0', \
# # 			'Include_doc=0', \
# # 			'Include_pip=0', \
# # 			'Include_test=0' \
# # 		)

# # SHELL ["cmd", "/C"]
# # RUN setx path "%path%;C:\base"
# # SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# # RUN \
# # # the installer updated PATH, so we should refresh our local value
# #     # setx PATH /M %PATH%;C:\python ; \
# # 	$env:PATH = [Environment]::GetEnvironmentVariable('PATH', [EnvironmentVariableTarget]::Machine); \
# # 	\
# # 	Write-Host 'Verifying install ...'; \
# # 	Write-Host '  python --version'; C:\base\python.exe --version; \
# # 	\
# # 	Write-Host 'Removing ...'; \
# # 	# Remove-Item python.exe -Force; \
# # 	\
# # 	Write-Host 'Complete.';

# # # if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
# # ENV PYTHON_PIP_VERSION 19.1.1

# # RUN Write-Host ('Installing pip=={0} ...' -f $env:PYTHON_PIP_VERSION); \
# # 	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
# # 	Invoke-WebRequest -Uri 'https://bootstrap.pypa.io/get-pip.py' -OutFile 'get-pip.py'; \
# # 	C:\base\python.exe get-pip.py \
# # 		--disable-pip-version-check \
# # 		--no-cache-dir \
# # 		('pip=={0}' -f $env:PYTHON_PIP_VERSION) \
# # 	; \
# # 	Remove-Item get-pip.py -Force; \
# # 	\
# # 	Write-Host 'Verifying pip install ...'; \
# # 	C:\base\pip.exe --version; \
# # 	\
# # 	Write-Host 'Complete.';

# # CMD ["python"]
