FROM docker.elastic.co/elasticsearch/elasticsearch:7.7.1

MAINTAINER VLE <lemairev@gmail.com>

# Install plugins
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-phonetic
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-icu
