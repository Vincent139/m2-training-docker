FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y curl \
    && curl -s https://packagecloud.io/install/repositories/varnishcache/varnish51/script.deb.sh | bash \
    && apt-get install -y varnish

ENV VCL_CONFIG      /etc/varnish/default.vcl
ENV CACHE_SIZE      256M
ENV VARNISHD_PARAMS "-T localhost:6082"

EXPOSE 90

COPY ./start.sh /start.sh
RUN chmod u+x /start.sh
CMD ["/start.sh"]
