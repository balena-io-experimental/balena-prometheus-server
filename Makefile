encryptenv:
	jet encrypt deploy.env deploy.env.encrypted --key-path=mirainc_resin-prometheus-server.aes

decryptenv:
	jet decrypt deploy.env.encrypted deploy.env --key-path=mirainc_resin-prometheus-server.aes

deploy-staging:
	rm -rf ./vendor && jet steps --tag staging -e CI_BRANCH='staging' -e CI_COMMIT_ID="local_$(image_name)" --key-path=mirainc_resin-prometheus-server.aes
