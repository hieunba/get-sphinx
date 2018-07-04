FROM microsoft/powershell
MAINTAINER 'Nghiem Ba Hieu <hi3unb@gmail.com>'

ADD ./install.ps1 C:/
RUN C:/install.ps1
RUN cd C:/install-tl* ;; ./install-tl-windows.bat -repository ftp://tug.org/historic/systems/texlive/2017/tlnet-final -no-gui -profile C:/profile
ADD ./install_sphinx.ps1 C:/
RUN C:/install_sphinx.ps1
RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RUN choco install mingw -y
RUN cp C:/tools/mingw64/bin/mingw32-make.exe "$env:SYSTEMROOT/make.exe"
WORKDIR C:/docs
CMD ["tlgmr.bat", "--version"]