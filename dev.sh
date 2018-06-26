eval $(docker-machine env)

docker rm resinMonitor
docker run -t -i -p 80:80 --name resinMonitor prometheus
