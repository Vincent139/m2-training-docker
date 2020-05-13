FROM docker.elastic.co/elasticsearch/elasticsearch:5.6.6

MAINTAINER Clever-Age DevOps Team <system@clever-age.com>

# Install plugins
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-phonetic
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu
