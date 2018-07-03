#replace vars in all config file types
echo 'LOADING CONFIGS'
find /etc/config -type f -exec sed -i -e s/GMAIL_ACCOUNT/${GMAIL_ACCOUNT}/g \
-e s/GMAIL_AUTH_TOKEN/${GMAIL_AUTH_TOKEN}/g \
-e s/NOTIFICATION_EMAIL/${NOTIFICATION_EMAIL}/g \
-e s/THRESHOLD_CPU/${THRESHOLD_CPU}/g \
-e s/THRESHOLD_MEM/${THRESHOLD_MEM}/g \
-e s/THRESHOLD_FS/${THRESHOLD_FS}/g \
-e s/PUBLIC_HOST_NAME/${PUBLIC_HOST_NAME}/g \
-e s/ALERTMANAGER_PATH/alertmanager-${ALERTMANAGER_VERSION}.${DIST_ARCH}/g \
{} \;

# mv config files to correct dir
echo 'MOVING CONFIGS'
mv -t /etc/prometheus-$PROMETHEUS_VERSION.$DIST_ARCH/ /etc/config/prometheus.yml /etc/config/alert.rules.yml
mv -t /etc/alertmanager-$ALERTMANAGER_VERSION.$DIST_ARCH/ /etc/config/alertmanager.yml /etc/config/default.tmpl
mv /etc/config/grafana.ini /etc/grafana/grafana.ini
mkdir /etc/grafana/dashboards
mv /etc/config/dashboards/* /etc/grafana/dashboards

# setup grafana provisioning dir
mkdir -p /etc/grafana/provisioning/dashboards
mv /etc/config/dashboards.yml /etc/grafana/provisioning/dashboards
