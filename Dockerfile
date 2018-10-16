FROM ubuntu:18.04
LABEL "org.opencontainers.image.authors"="levkov"
EXPOSE 9001 22 9200
CMD ["/usr/bin/supervisord"]
WORKDIR /tmp

RUN apt-get update && \
    apt-get install wget \
                    supervisor \
                    software-properties-common \
                    apt-transport-https \
                    gnupg2 \
                    -y



RUN add-apt-repository ppa:openjdk-r/ppa -y && apt-get update && \
    apt-get install -y openjdk-8-jre

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-6.x.list
RUN apt-get update && apt-get install elasticsearch

RUN chmod 777 /var/lib/elasticsearch

COPY conf/supervisord.conf /etc/supervisor/supervisord.conf
COPY conf/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml