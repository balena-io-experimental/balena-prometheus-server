# Start prometheus server
service grafana-server start &&
# Add datasource to grafana
curl 'http://admin:admin@127.0.0.1:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"Prometheus","type":"prometheus","url":"http://localhost:80","access":"proxy","isDefault":true}'
# start node discover mechanism
cd /etc/prometheus-$PROMETHEUS_VERSION.$DIST_ARCH/discovery/ && node ./index.js & \
# start prometheus
cd /etc/prometheus-$PROMETHEUS_VERSION.$DIST_ARCH \
  && ./prometheus -web.listen-address ":80" \
  -storage.local.path "/data" -storage.local.retention ${STORAGE_LOCAL_RETENTION} \
  -alertmanager.url "http://localhost:9093" &
cd /etc/alertmanager-$ALERTMANAGER_VERSION.$DIST_ARCH \
  && ./alertmanager -config.file=alertmanager.yml
