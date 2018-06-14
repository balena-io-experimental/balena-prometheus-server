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
    SENTRY_ENV=SENTRY_ENV_STAGING \
    SENTRY_DSN=SENTRY_DSN_STAGING \
    AUTH_SECRET=$AUTH_SECRET_STAGING \
    REDIS_URL=$REDIS_URL_STAGING \
    MIRA_API_URL=$MIRA_API_URL_STAGING && \
    eb deploy -l "$CI_BRANCH:$CI_COMMIT_ID" ;;
  "production")
    cd aws/production && \
    zip -r deploy.zip .ebextensions Dockerrun.aws.json && \
    eb setenv \
    SENTRY_ENV=SENTRY_ENV_PRODUCTION \
    SENTRY_DSN=SENTRY_DSN_PRODUCTION
    AUTH_SECRET=$AUTH_SECRET_PRODUCTION \
    REDIS_URL=$REDIS_URL_PRODUCTION \
    MIRA_API_URL=$MIRA_API_URL_PRODUCTION && \
    eb deploy -l "$CI_BRANCH:$CI_COMMIT_ID" ;;
  *)
    echo "not main branch" && exit 1;;
esac
