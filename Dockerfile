FROM ubuntu:trusty
ENV DEBIAN_FRONTEND noninteractive

MAINTAINER Larry Cai <larry.caiyu@gmail.com>

ENV REFREST_AT 20150104

# nginx
RUN apt-get update -q \
    && apt-get install -yf build-essential python-software-properties software-properties-common \
    && add-apt-repository ppa:nginx/stable \
    && apt-get update -q \
    && apt-get -y install -y curl

# build nginx from source with http auth module enabled
RUN apt-get -y install libpcre3-dev zlib1g-dev libssl-dev 

RUN curl -s http://nginx.org/download/nginx-1.6.2.tar.gz | tar -xz -C /tmp \
	&& cd /tmp/nginx-1.6.2 \
	&& ./configure --with-http_ssl_module --with-http_auth_request_module && make && make install 

# put self signed ssl key (generated by htpasswd
RUN apt-get -y install apache2-utils

ADD . /app
RUN chmod +x /app/start.sh && mkdir /data

VOLUME ["/data"]

EXPOSE 80 443
CMD /app/start.sh
