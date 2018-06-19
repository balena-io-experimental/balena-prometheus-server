set -e

cd /usr/src/app
# login to docker repository and remove credential
sh ./docker-login-cred
rm docker-login-cred

case $CI_BRANCH in
  "version"|"staging"|"production")
    docker build -t $AWS_ECR:$CI_BRANCH -f ./Dockerfile . && \
    docker push $AWS_ECR:$CI_BRANCH && \
    docker build -t $AWS_ECR:$CI_COMMIT_ID -f ./Dockerfile . && \
    docker push $AWS_ECR:$CI_COMMIT_ID ;;
  *)
    echo 'Not a deployable branch' && exit 1;;
    # Uncomment below lines to test image push
    # docker build -t $AWS_ECR:test -f docker/Dockerfile.prod . && \
    # docker push $AWS_ECR:test && \
    # docker build -t $AWS_ECR:$CI_COMMIT_ID -f docker/Dockerfile.prod . && \
    # docker push $AWS_ECR:$CI_COMMIT_ID ;;
esac
