# Start grafana server
service grafana-server start &&
# wait for grafana to start
sleep 10 &&
# Add datasource to grafana
curl 'http://hello:world@127.0.0.1:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"Prometheus","type":"prometheus","url":"http://localhost:80","access":"proxy","isDefault":true}'
# start node discover mechanism
cd /etc/prometheus-$PROMETHEUS_VERSION.$DIST_ARCH/discovery/ && node ./index.js & \
# start prometheus
cd /etc/prometheus-$PROMETHEUS_VERSION.$DIST_ARCH \
  && ./prometheus --web.listen-address ":80" \
  --storage.tsdb.path "/data" --storage.tsdb.retention ${STORAGE_LOCAL_RETENTION} \
  --log.level=debug &
cd /etc/alertmanager-$ALERTMANAGER_VERSION.$DIST_ARCH \
  && ./alertmanager -config.file=alertmanager.yml
