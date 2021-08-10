FROM ubuntu:20.04
RUN apt -yq update
RUN apt -yq install git
RUN apt -yq install wget
RUN git clone https://github.com/zhouchangxun/ngx_healthcheck_module.git && \
  wget http://nginx.org/download/nginx-1.14.2.tar.gz && \
  tar -zxf nginx-1.14.2.tar.gz && \
  cd nginx-1.14.2 && \
  git apply ../ngx_healthcheck_module/nginx_healthcheck_for_nginx_1.14+.patch
RUN chmod u+x -R nginx-1.14.2
RUN apt -yq install build-essential
RUN apt install -yq libpcre3-dev libssl-dev
RUN cd nginx-1.14.2 && \
  chmod u+x configure && \
  ./configure --with-debug \
            --with-stream \
            --add-module=../ngx_healthcheck_module \
            --without-http_gzip_module && \
  make && \
  make install
RUN ln -s /usr/local/nginx/sbin/nginx /usr/sbin/ && \
  nginx -T && \
  nginx -t

CMD ["nginx", "-t"]