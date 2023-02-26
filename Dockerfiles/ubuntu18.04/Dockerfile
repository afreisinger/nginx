FROM ubuntu:18.04
LABEL maintainer="Adrian Freisinger <afreisinger@gmail.com>" \
    architecture="amd64/x86_64" \
    nginx-version="1.23.1" \
    ubuntu-version="18.04" \
    build="20-Feb-2023" \
    org.opencontainers.image.title="ubuntu-nginx" \
    org.opencontainers.image.description="Nginx Docker image running on Ubuntu Linux" \
    org.opencontainers.image.authors="Adrian Freisinger <afreisinger@gmail.com" \
    org.opencontainers.image.vendor="Adrian Freisinger Systems" \
    org.opencontainers.image.version="v1.23.1" \
    org.opencontainers.image.url="https://gitlab.com/afreisinger/nginx/container_registry/3919054" \
    org.opencontainers.image.source="https://gitlab.com/afreisinger/nginx" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE


RUN \
 apt-get update -y && \
 apt-get install -y && \
 DEBIAN_FRONTEND=noninteractive apt-get -qq -y install --no-install-recommends apt-transport-https lsb-release ca-certificates wget curl dnsutils gnupg vim-tiny \
 git build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev libgd-dev libxml2 libxml2-dev uuid-dev \
 openssl tzdata \
 python-pip jq && \
 pip install crossplane && \
 ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone && \ 
 echo ${TZ} > /etc/timezone
  

ENV NGINX_VERSION=1.23.3

ARG TIME_ZONE="America/Argentina/Buenos_Aires"
ENV TZ ${TIME_ZONE}


RUN \
 cd /tmp && \
 wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
 tar xzf nginx-${NGINX_VERSION}.tar.gz && \
 cd /tmp/nginx-${NGINX_VERSION} && \
  ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    #--lock-path=/var/run/nginx.lock \
    #--http-client-body-temp-path=/var/cache/nginx/client_temp \
    #--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    #--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    #--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    #--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_realip_module \
    #--with-http_addition_module \
    --with-http_sub_module \
    #--with-http_dav_module \
    #--with-http_flv_module \
    #--with-http_mp4_module \
    #--with-http_gunzip_module \
    #--with-http_gzip_static_module \
    #--with-http_random_index_module \
    #--with-http_secure_link_module \
    --with-http_stub_status_module \
    #--with-http_auth_request_module \
    #--with-mail \
    #--with-mail_ssl_module \
    --with-file-aio \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    #--with-stream_realip_module \
    #--with-http_slice_module \
    --with-http_v2_module && \
 make && \
 make install && \
 sed -i -e 's/#access_log  logs\/access.log  main;/access_log \/dev\/stdout;/' -e 's/#error_log  logs\/error.log  notice;/error_log stderr notice;/' /etc/nginx/nginx.conf && \
 addgroup nginx && \
 useradd -g nginx nginx && \
 mkdir -p /etc/nginx/snippets
   


RUN \
 rm -rf /tmp/* && \
 #apt-get remove -y git build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev libgd-dev libxml2 libxml2-dev uuid-dev && \ 
 apt-get autoremove -y && \
 apt-get autoclean 



COPY etc/default.conf etc/health-check.conf etc/stub-status.conf /etc/nginx/conf.d/
COPY etc/nginx.conf /etc/nginx/
COPY html/. /usr/share/nginx/html/
COPY certs/nginx-selfsigned.crt /etc/ssl/certs/
COPY certs/nginx-selfsigned.key /etc/ssl/private/
COPY certs/dhparam.pem /etc/nginx/dhparam.pem
COPY snippets/self-signed.conf snippets/ssl-params.conf /etc/nginx/snippets/

VOLUME ["/var/cache/nginx"]

EXPOSE 80 90 91 92 443

CMD ["nginx", "-g", "daemon off;"]
  
