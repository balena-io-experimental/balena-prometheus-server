# Start grafana server
service grafana-server start &&
# wait for grafana to start
sleep 10 &&
# setup nginx basic auth
htpasswd -bc /etc/nginx/conf.d/prometheus.htpasswd $AUTH_USERNAME $AUTH_PASSWORD
# start nginx
nginx &&
# Add datasource to grafana
curl 'http://admin:changeme@127.0.0.1:3000/api/datasources' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"Prometheus","type":"prometheus","url":"http://localhost:8000","access":"proxy","isDefault":true}'
# Set prometheus admin user
curl 'http://admin:changeme@127.0.0.1:3000/api/users/1' -X PUT -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"Prometheus User", "email":"engineering@getmira.com", "login": "'$AUTH_USERNAME'", "theme": "dark"}'
curl 'http://'$AUTH_USERNAME':changeme@127.0.0.1:3000/api/user/password' -X PUT -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"oldPassword": "changeme", "newPassword": "'$AUTH_PASSWORD'", "confirmNew": "'$AUTH_PASSWORD'"}'
# start node discover mechanism
cd /etc/prometheus-$PROMETHEUS_VERSION.$DIST_ARCH/discovery/ && node ./index.js & \
# start prometheus
cd /etc/prometheus-$PROMETHEUS_VERSION.$DIST_ARCH \
  && ./prometheus --web.listen-address ":8000" \
  --storage.tsdb.path "/data" --storage.tsdb.retention ${STORAGE_LOCAL_RETENTION} \
  --log.level=debug &
cd /etc/alertmanager-$ALERTMANAGER_VERSION.$DIST_ARCH \
  && ./alertmanager -config.file=alertmanager.yml


"password": "'$AUTH_PASSWORD'"