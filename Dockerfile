FROM resin/nuc-node:0.10.22-wheezy

# Enable systemd
ENV INITSYSTEM on

# versions
ENV PROMETHEUS_VERSION 0.20.0
ENV ALERTMANAGER_VERSION 0.2.0
# arch
ENV DIST_ARCH linux-amd64

# Target discovery configs
ENV RESIN_EMAIL yourResinEmail
ENV RESIN_PASS yourResinPassword
ENV RESIN_APP_NAME yourAppName
ENV DISCOVERY_INTERVAL 30000

# Alert Manager configs
ENV GMAIL_ACCOUNT yourGmail
ENV GMAIL_AUTH_TOKEN youGmailpassword
ENV THRESHOLD_CPU 50
ENV THRESHOLD_FS 50
ENV THRESHOLD_MEM 500
ENV STORAGE_LOCAL_RETENTION 360h0m0s

VOLUME ["/var/lib/grafana"]

EXPOSE 3000 80

RUN apt-get update && apt-get install apt-transport-https
RUN echo 'deb https://packagecloud.io/grafana/stable/debian/ wheezy main' >> /etc/apt/sources.list
RUN curl https://packagecloud.io/gpg.key | sudo apt-key add -

# downloading utils
RUN apt-get update && apt-get install -y wget build-essential libc6-dev grafana

WORKDIR /etc

# get prometheus server
RUN wget https://github.com/prometheus/prometheus/releases/download/$PROMETHEUS_VERSION/prometheus-$PROMETHEUS_VERSION.$DIST_ARCH.tar.gz  \
	&& tar xvfz prometheus-$PROMETHEUS_VERSION.$DIST_ARCH.tar.gz \
	&& rm prometheus-$PROMETHEUS_VERSION.$DIST_ARCH.tar.gz

# get prometheus alertmanager
RUN wget https://github.com/prometheus/alertmanager/releases/download/$ALERTMANAGER_VERSION/alertmanager-$ALERTMANAGER_VERSION.$DIST_ARCH.tar.gz  \
	&& tar xvfz alertmanager-$ALERTMANAGER_VERSION.$DIST_ARCH.tar.gz \
	&& rm alertmanager-$ALERTMANAGER_VERSION.$DIST_ARCH.tar.gz

# add discovery service
COPY discovery/ ./prometheus-$PROMETHEUS_VERSION.$DIST_ARCH/discovery/

RUN cd prometheus-$PROMETHEUS_VERSION.$DIST_ARCH/discovery && npm install

# Add config files
COPY config/ ./config/

# move all config files into place and insert config vars
RUN bash /etc/config/config.sh

WORKDIR /

COPY start.sh ./

CMD ["bash", "start.sh"]
