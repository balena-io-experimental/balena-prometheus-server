#configure aws
cd /usr/src/app
rm docker-login-cred
aws ecr get-login --registry-ids 761633760558 >> ./docker-login-cred
