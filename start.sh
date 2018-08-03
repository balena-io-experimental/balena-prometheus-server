# export EFS_FILE_SYSTEM_ID=XXXXXX # Set by Codeship envs
export EFS_MOUNT_DIR=/efs
export EFS_REGION=us-west-2

mkdir -p $EFS_MOUNT_DIR

echo "mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${EFS_FILE_SYSTEM_ID}.efs.${EFS_REGION}.amazonaws.com:/ ${EFS_MOUNT_DIR}"
    mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 ${EFS_FILE_SYSTEM_ID}.efs.${EFS_REGION}.amazonaws.com:/ ${EFS_MOUNT_DIR}

# Set configuration variables
bash /etc/config/config.sh

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

# Add readonly user
echo "adding readonly user \n"
curl 'http://admin:changeme@127.0.0.1:3000/api/admin/users' -X POST -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"Prometheus Read-Only User", "email":"engineering+readonlymetrics@getmira.com", "login": "'$READONLY_USERNAME'", "password": "'$READONLY_PASSWORD'", "theme": "dark"}'

# Set prometheus admin user
curl 'http://admin:changeme@127.0.0.1:3000/api/users/1' -X PUT -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"name":"Prometheus User", "email":"engineering@getmira.com", "login": "'$AUTH_USERNAME'", "theme": "dark"}'

# Change admin user password
curl 'http://'$AUTH_USERNAME':changeme@127.0.0.1:3000/api/user/password' -X PUT -H 'Content-Type: application/json;charset=UTF-8' --data-binary '{"oldPassword": "changeme", "newPassword": "'$AUTH_PASSWORD'", "confirmNew": "'$AUTH_PASSWORD'"}'
# start node exporter for server metrics
/usr/src/node_exporter/node_exporter --web.listen-address ":9100" &
# start node discover mechanism
cd /etc/prometheus-$PROMETHEUS_VERSION.$DIST_ARCH/discovery/ && node ./index.js & \
# start prometheus
cd /etc/prometheus-$PROMETHEUS_VERSION.$DIST_ARCH \
  && ./prometheus --web.listen-address ":8000" \
  --storage.tsdb.path "/efs/data" --storage.tsdb.retention ${STORAGE_LOCAL_RETENTION} \
  --web.external-url https://$PUBLIC_HOST_NAME --log.level=error &
cd /etc/alertmanager-$ALERTMANAGER_VERSION.$DIST_ARCH \
  && ./alertmanager --config.file=alertmanager.yml
