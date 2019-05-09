FROM centos:7

MAINTAINER Benjamin Akhras "b@akhras.at"

ADD nginx-mainline.repo /etc/yum.repos.d/nginx-mainline.repo
RUN yum update -y && yum install -y nginx git netcat gcc make unzip wget curl openssl zlib-devel pcre-devel openssl-devel mercurial && \
yum groupinstall -y 'Development Tools'

RUN mkdir -p /root/nginx-modules/
WORKDIR /root/nginx-modules
ADD http://hg.nginx.org/pkg-oss/archive/tip.tar.gz tip.tar.gz
ADD build_module.sh build_module.sh

RUN tar -xvf tip.tar.gz && mv pkg-oss-* pkg-oss/ && \
git clone https://github.com/openresty/headers-more-nginx-module.git && \
git clone https://github.com/nginx-shib/nginx-http-shibboleth.git && \
export NGINX_VERSION="$(nginx -v 2>&1 | sed -n -e 's|^.*/||p' | tr -d '\n')" && \
./build_module.sh -y -o /root/nginx-modules/ -n shibboleth -v ${NGINX_VERSION} nginx-http-shibboleth/


#pkg-oss/build_module.sh -y -o /root/nginx-modules/ -n headers-more -v ${NGINX_VERSION} headers-more-nginx-module && \
#cp -vf nginx-http-shibboleth/includes/* /etc/nginx && \
#yum install -y *.rpm
