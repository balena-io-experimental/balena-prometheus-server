dev: build
	sh dev.sh

dev-env: build
	sh dev-env.sh

build:
	eval $(docker-machine env) && docker build -t prometheus .

ssh-dev:
	eval $(docker-machine env) && docker exec -it resinMonitor bash

encryptenv:
	jet encrypt deploy.env deploy.env.encrypted --key-path=mirainc_resin-prometheus-server.aes

decryptenv:
	jet decrypt deploy.env.encrypted deploy.env --key-path=mirainc_resin-prometheus-server.aes

deploy:
	rm -rf ./vendor && jet steps --tag $(branch) -e CI_BRANCH=$(branch) -e CI_COMMIT_ID="local_$(image_name)" --key-path=mirainc_resin-prometheus-server.aes
