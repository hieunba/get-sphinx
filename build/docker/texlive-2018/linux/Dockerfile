FROM debian:stretch

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

LABEL maintainer="Nghiem Ba Hieu <hi3unb@gmail.com>"

RUN apt-get update \
    && apt-get install -y gnupg wget curl libgetopt-long-descriptive-perl \
    libdigest-perl-md5-perl python-pygments fontconfig \
    && rm -rf /var/lib/apt/lists/*

ENV TEXLIVE_SOURCE=http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/install-tl-unx.tar.gz
ENV TEXLIVE_REPO=http://ftp.yzu.edu.tw/CTAN/systems/texlive/tlnet/

WORKDIR /
RUN curl -sL ${TEXLIVE_SOURCE} | tar zxf - \
    && mv install-tl-20* install-tl \
    && cd install-tl \
    && echo "selected_scheme scheme-full" > profile \
    && ./install-tl -repository ${TEXLIVE_REPO} -profile profile \
    && cd .. \
    && rm -rf install-tl
RUN apt-get update \
    && apt-get install -y python3 python3-pip
RUN update-alternatives \
    --install /usr/bin/python python /usr/bin/python3.5 100 \
    ; \
    update-alternatives \
     --install /usr/bin/python python /usr/bin/python2.7 1
RUN pip3 install sphinx cloud-sptheme
RUN sed -i 's#//fonts#https://fonts#' /usr/local/lib/python3.5/dist-packages/cloud_sptheme/themes/cloud/theme.conf
RUN apt-get install -y pandoc pandoc-data
RUN rm -rf /var/lib/apt/lists/*
ENV PATH /usr/local/texlive/2018/bin/x86_64-linux:$PATH

WORKDIR /docs
COPY ./start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
