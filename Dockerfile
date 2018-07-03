FROM node:8.11.3-jessie

# Enable systemd
ENV INITSYSTEM on

# versions
ENV PROMETHEUS_VERSION 2.3.0
ENV ALERTMANAGER_VERSION 0.15.0
# arch
ENV DIST_ARCH linux-amd64

VOLUME ["/var/lib/grafana"]

EXPOSE 80

RUN apt-get update && apt-get install apt-transport-https
RUN echo 'deb https://packagecloud.io/grafana/stable/debian/ jessie main' >> /etc/apt/sources.list
RUN curl https://packagecloud.io/gpg.key | apt-key add -

# downloading utils
RUN apt-get update && apt-get install -y wget build-essential libc6-dev grafana

WORKDIR /etc

# get prometheus server
RUN wget https://github.com/prometheus/prometheus/releases/download/v$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.$DIST_ARCH.tar.gz  \
    && tar xvfz prometheus-$PROMETHEUS_VERSION.$DIST_ARCH.tar.gz \
    && rm prometheus-$PROMETHEUS_VERSION.$DIST_ARCH.tar.gz

## TODO: Pull into its own service
# get prometheus alertmanager
RUN wget https://github.com/prometheus/alertmanager/releases/download/v$ALERTMANAGER_VERSION/alertmanager-$ALERTMANAGER_VERSION.$DIST_ARCH.tar.gz  \
    && tar xvfz alertmanager-$ALERTMANAGER_VERSION.$DIST_ARCH.tar.gz \
    && rm alertmanager-$ALERTMANAGER_VERSION.$DIST_ARCH.tar.gz

# add discovery service
COPY discovery/ ./prometheus-$PROMETHEUS_VERSION.$DIST_ARCH/discovery/

RUN cd prometheus-$PROMETHEUS_VERSION.$DIST_ARCH/discovery && npm install


# install Nginx
RUN apt-get install nginx -yq
RUN rm /etc/nginx/sites-enabled/default
COPY config/server.conf /etc/nginx/conf.d/server.conf

RUN apt-get install apache2-utils -yq


# install prereqs for EFS mounting
RUN apt-get install nfs-common -yq


# Target discovery configs
ENV RESIN_EMAIL engineering@getmira.com
ENV RESIN_PASS CHANGE_ME
ENV RESIN_APP_NAME STK1A32SCStaging
ENV DISCOVERY_INTERVAL 30000

# Alert Manager configs
ENV GMAIL_ACCOUNT fake@getmira.com
ENV GMAIL_AUTH_TOKEN CHANGE_ME
ENV NOTIFICATION_EMAIL fake_notification@getmira.com
ENV THRESHOLD_CPU 75
ENV THRESHOLD_FS 50
ENV THRESHOLD_MEM 500
ENV STORAGE_LOCAL_RETENTION 15d

# Basic auth config
ENV AUTH_USERNAME promAdmin
ENV AUTH_PASSWORD promPass

ENV PUBLIC_HOST_NAME 192.168.99.100

# Add config files
COPY config/ ./config/

WORKDIR /

COPY start.sh ./

CMD ["bash", "start.sh"]
