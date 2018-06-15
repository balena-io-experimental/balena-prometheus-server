set -e
# clean up everything
pip install awsebcli

cd /usr/src/app

# copy eb configs into deploy folders
cp aws/.ebextensions/* aws/staging/.ebextensions
cp aws/.ebextensions/* aws/production/.ebextensions

case $CI_BRANCH in
  "staging")
    cd aws/staging && \
    zip -r deploy.zip .ebextensions Dockerrun.aws.json && \
    eb setenv \
    RESIN_EMAIL=$RESIN_EMAIL \
    RESIN_PASS=$RESIN_PASS \
    RESIN_APP_NAME=$RESIN_APP_NAME && \
    eb deploy -l "$CI_BRANCH:$CI_COMMIT_ID" ;;
  "production")
    cd aws/production && \
    zip -r deploy.zip .ebextensions Dockerrun.aws.json && \
    eb setenv \
    RESIN_EMAIL=$RESIN_EMAIL \
    RESIN_PASS=$RESIN_PASS \
    RESIN_APP_NAME=$RESIN_APP_NAME && \
    eb deploy -l "$CI_BRANCH:$CI_COMMIT_ID" ;;
  *)
    echo "not main branch" && exit 1;;
esac
