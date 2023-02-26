FROM nginx:mainline-alpine
RUN rm /etc/nginx/conf.d/*

ARG BUILD_DATE
ARG VCS_REF
ARG TIME_ZONE="America/Argentina/Buenos_Aires"

ENV TZ ${TIME_ZONE}

LABEL maintainer="Adrian Freisinger <afreisinger@gmail.com>" \
    architecture="amd64/x86_64" \
    nginx-version="mainline-alpine" \
    build="21-Feb-2023" \
    org.opencontainers.image.title="nginx-plaintext" \
    org.opencontainers.image.description="Nginx Docker image minimal plain text" \
    org.opencontainers.image.authors="Adrian Freisinger <afreisinger@gmail.com" \
    org.opencontainers.image.vendor="Adrian Freisinger" \
    org.opencontainers.image.version="v1.23.3" \
    org.opencontainers.image.url="https://gitlab.com/afreisinger/nginx/container_registry/3919054" \
    org.opencontainers.image.source="https://gitlab.com/afreisinger/nginx" \
    org.opencontainers.image.revision=$VCS_REF \
    org.opencontainers.image.created=$BUILD_DATE



RUN chown -R nginx:nginx /etc/nginx \
 # Forward request logs to docker log collector
 && ln -sf /dev/stdout /var/log/nginx/access.log \
 && ln -sf /dev/stderr /var/log/nginx/error.log \
 && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone \ 
 && echo ${TZ} > /etc/timezone \ 
 # Raise the limits to successfully run benchmarks
 && ulimit -c -m -s -t unlimited
 ## &&  mkdir -p /etc/nginx/snippets
 # && sed -i -e 's/#access_log  logs\/access.log  main;/access_log \/dev\/stdout;/' -e 's/#error_log  logs\/error.log  notice;/error_log stderr notice;/' /etc/nginx/nginx.conf && \
 


#RUN rm /etc/nginx/conf.d/* \
#&& ln -sf /dev/stdout /var/log/nginx/access.log \
#&& ln -sf /dev/stderr /var/log/nginx/error.log 

#COPY etc/default.conf etc/health-check.conf etc/stub-status.conf etc/os-version.conf /etc/nginx/conf.d/
COPY etc/plain-text.conf /etc/nginx/conf.d/
COPY etc/nginx.conf /etc/nginx/
#COPY html/. /usr/share/nginx/html/
COPY certs/nginx-selfsigned.crt /etc/ssl/certs/
COPY certs/nginx-selfsigned.key /etc/ssl/private/
COPY certs/dhparam.pem /etc/nginx/dhparam.pem
COPY snippets/self-signed.conf snippets/ssl-params.conf /etc/nginx/snippets/