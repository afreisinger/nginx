FROM nginx:1.21.1-alpine


LABEL maintainer="Adrian Freisinger <afreisinger@gmail.com>" \
      architecture="amd64/x86_64" \
      nginx-version="nginx:1.21.1-alpine"



#ENV NGINX_VERSION=1.23.3

RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz && \
pwd && \
ls

# For see https://github.com/nginxinc/docker-nginx/blob/master/mainline/alpine/Dockerfile
# https://www.zsiegel.com/2022/01/17/load-balancing-in-docker-with-nginx

RUN apk update && \
  apk add --no-cache --virtual .build-deps \
  gcc \
  libc-dev \
  make \
  openssl-dev \
  pcre-dev \
  zlib-dev \
  linux-headers \
  curl \
  gnupg \
  libxslt-dev \
  gd-dev \
  geoip-dev \
  git \
  patch \
  tar


ENV CONFARGS --prefix=/etc/nginx \
--sbin-path=/usr/sbin/nginx \
--modules-path=/usr/lib/nginx/modules \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--http-client-body-temp-path=/var/cache/nginx/client_temp \
--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
--user=nginx --group=nginx \
#--with-perl_modules_path=/usr/lib/perl5/vendor_perl \
#--with-compat \
#--with-file-aio \
#--with-threads \
#--with-http_addition_module \
#--with-http_auth_request_module \
#--with-http_dav_module \
#--with-http_flv_module \
#--with-http_gunzip_module \
#--with-http_gzip_static_module \
#--with-http_mp4_module \
#--with-http_random_index_module \
#--with-http_realip_module \
#--with-http_secure_link_module \
#--with-http_slice_module \
--with-http_ssl_module \
--with-http_stub_status_module \
--with-http_sub_module \
#--with-http_v2_module \
#--with-mail \
#--with-mail_ssl_module \
#--with-stream \
#--with-stream_realip_module \
#--with-stream_ssl_module \
#--with-stream_ssl_preread_module \
--with-cc-opt='-Os' --with-ld-opt=-Wl,--as-needed,-O1,--sort-common
RUN mkdir -p /usr/src && \
    mkdir -p /etc/nginx/includes/


RUN chown -R nginx:nginx /etc/nginx \
 # Forward request logs to docker log collector
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log \
 # Raise the limits to successfully run benchmarks
 && ulimit -c -m -s -t unlimited


RUN tar -zxC /usr/src -f nginx.tar.gz && \
    cd /usr/src/nginx-$NGINX_VERSION && \
    git clone --depth 1 --single-branch --branch master https://github.com/nginx-modules/nginx_upstream_check_module && \
    patch -p1 < nginx_upstream_check_module/check_1.16.1+.patch && \
    ./configure $CONFARGS --add-module=nginx_upstream_check_module && \
    make && make install && \
    cd / && \
    apk del .build-deps && \
    #rm -rf /usr/src && \
    rm -rf /var/lib/apt/lists/* && \
    # Remove default nginx config
    rm /etc/nginx/conf.d/default.conf && \
    # Required for this demo: Create cache folder and set permissions for proxy caching
    mkdir -p /var/cache/nginx && \
    chown -R nginx /var/cache/nginx && \
    # Required for this demo: Create State file folder and set permissions
    mkdir -p /var/lib/nginx/state && \
    chown -R nginx /var/lib/nginx/state && \
    mkdir -p  /etc/nginx/snippets && \
    chown -R nginx /etc/nginx/snippets && \
    # COPY var/lib/nginx/state/servers.conf /var/lib/nginx/state/servers.conf
    touch /var/lib/nginx/state/servers.conf



COPY etc/default.conf etc/health-check.conf etc/stub-status.conf /etc/nginx/conf.d/
COPY etc/nginx.conf /etc/nginx/
COPY html/. /usr/share/nginx/html/
COPY certs/nginx-selfsigned.crt /etc/ssl/certs/
COPY certs/nginx-selfsigned.key /etc/ssl/private/
COPY certs/dhparam.pem /etc/nginx/dhparam.pem
COPY snippets/self-signed.conf snippets/ssl-params.conf /etc/nginx/snippets/





EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]