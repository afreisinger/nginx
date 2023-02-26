FROM centos:8
LABEL maintainer="Adrian Freisinger <afreisinger@gmail.com>" \
    architecture="amd64/x86_64" \
    nginx-version="1.23.1" \
    centos-version="8" \
    build="20-Feb-2023" \
    org.opencontainers.image.title="centos-nginx" \
    org.opencontainers.image.description="Nginx Docker image running on CentOS Linux" \
    org.opencontainers.image.authors="Adrian Freisinger <afreisinger@gmail.com" \
    org.opencontainers.image.vendor="Adrian Freisinger Systems" \
    org.opencontainers.image.version="v1.23.1" \
    org.opencontainers.image.url="https://gitlab.com/afreisinger/nginx/container_registry/3919054" \
    org.opencontainers.image.source="https://gitlab.com/afreisinger/nginx" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE


RUN \
 sed -i -e "s|mirrorlist=|#mirrorlist=|g" /etc/yum.repos.d/CentOS-* && \
 sed -i -e "s|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g" /etc/yum.repos.d/CentOS-* && \
 yum update -y && \
 yum install -y wget curl yum-utils && \
 dnf group install -y "Development Tools" && \
 ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone && \ 
 echo ${TZ} > /etc/timezone
  

ENV NGINX_VERSION=1.23.3

ARG TIME_ZONE="America/Argentina/Buenos_Aires"
ENV TZ ${TIME_ZONE}


RUN \
 cd /tmp && \
 wget https://ftp.exim.org/pub/pcre/pcre-8.44.tar.gz && tar zxvf pcre-* && \
 wget https://www.zlib.net/fossils/zlib-1.2.11.tar.gz && tar zxvf zlib-* && \
 wget https://www.openssl.org/source/openssl-1.1.1g.tar.gz && tar zxvf openssl-* && \
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
    --with-pcre=/tmp/pcre-8.44 \
    --with-zlib=/tmp/zlib-1.2.11 \
    --with-openssl=/tmp/openssl-1.1.1g \
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
 adduser nginx --system --no-create-home --shell /bin/false --user-group

RUN \
 rm -rf /tmp/* && \
 mkdir -p /etc/nginx/snippets
 #dnf autoremove -y && \
 #package-cleanup -q --leaves | xargs -l1 yum -y remove 



#COPY etc/default.conf etc/health-check.conf etc/stub-status.conf etc/os-version.conf /etc/nginx/conf.d/
COPY etc/default.conf etc/health-check.conf etc/stub-status.conf /etc/nginx/conf.d/
COPY etc/nginx.conf /etc/nginx/
COPY html/. /usr/share/nginx/html/
COPY certs/nginx-selfsigned.crt /etc/ssl/certs/
COPY certs/nginx-selfsigned.key /etc/ssl/private/
COPY certs/dhparam.pem /etc/nginx/dhparam.pem
#COPY snippets/self-signed.conf snippets/ssl-params.conf /etc/nginx/snippets/
COPY snippets/. /etc/nginx/snippets/

VOLUME ["/var/cache/nginx"]

EXPOSE 80 90 91 92 443

CMD ["nginx", "-g", "daemon off;"]
  
