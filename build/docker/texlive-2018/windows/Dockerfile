# escape=`
FROM microsoft/powershell
MAINTAINER 'Nghiem Ba Hieu <hi3unb@gmail.com>'

ENV TEXLIVE_SOURCE=http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/install-tl.zip
ENV TEXLIVE_DOWNLOAD_PATH=C:/install-tl.zip
RUN (New-Object System.Net.WebClient).DownloadFile($env:TEXLIVE_SOURCE, $env:TEXLIVE_DOWNLOAD_PATH)
RUN Set-Content -Path C:/profile -Value 'selected_scheme scheme-full'
RUN Expand-Archive C:/install-tl.zip -DestinationPath C:/
RUN mv C:/install-tl*  C:/install-tl ; `
    C:/install-tl/install-tl-windows.bat -repository http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet -no-gui -profile C:/profile
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
RUN rm "$env:PANDOC_DOWNLOAD_PATH" ; `
    rm "C:\\install_sphinx.ps1"
ADD ./start.ps1 C:/
WORKDIR C:/docs
CMD "C:\\start.ps1"
