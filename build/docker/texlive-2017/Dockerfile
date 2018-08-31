# escape=`
FROM microsoft/powershell
MAINTAINER 'Nghiem Ba Hieu <hi3unb@gmail.com>'
SHELL ["powershell", "-command"]

ADD ./install.ps1 C:/
RUN C:/install.ps1
ARG TEXLIVE_SOURCE=ftp://tug.org/historic/systems/texlive/2017/tlnet-final
RUN cd C:/install-tl* ;; ./install-tl-windows.bat -repository $env:TEXLIVE_SOURCE -no-gui -profile C:/profile
ADD ./install_sphinx.ps1 C:/
RUN C:/install_sphinx.ps1
RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
RUN choco install mingw -y
RUN cp C:/tools/mingw64/bin/mingw32-make.exe "$env:SYSTEMROOT/make.exe"
RUN pip install cloud-sptheme==1.9.4
ENV cloud_conf "C:\Program Files\Python36\Lib\site-packages\cloud_sptheme\themes\cloud\theme.conf"
RUN (cat $env:cloud_conf).Replace(' //fonts', ' https://fonts') | Set-Content $env:cloud_conf
ENV PANDOC_SOURCE=https://github.com/jgm/pandoc/releases/download/2.2.3.2/pandoc-2.2.3.2-windows-x86_64.msi
ENV PANDOC_DOWNLOAD_PATH=C:\\pandoc-installer.msi
RUN [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls11 -bor [System.Net.SecurityProtocolType]::Tls12; `
    (New-Object System.Net.WebClient).DownloadFile($env:PANDOC_SOURCE, $env:PANDOC_DOWNLOAD_PATH)
RUN Start-Process msiexec -ArgumentList @('/i', "$env:PANDOC_DOWNLOAD_PATH", '/qn') -Wait
ADD ./start.ps1 C:/
WORKDIR C:/docs
CMD "C:\\start.ps1"
