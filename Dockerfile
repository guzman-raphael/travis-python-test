FROM mcr.microsoft.com/windows/nanoserver:1803-amd64

ENTRYPOINT cmd.exe

CMD ["/s","/c","echo","look here"]