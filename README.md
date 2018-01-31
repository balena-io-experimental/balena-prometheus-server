More info can be found on the [resin-blog](https://resin.io/blog/prometheusv2/)

### Required Environment variables

| Key                | Description                                   |
|--------------------|-----------------------------------------------|
| GMAIL_ACCOUNT      | Your Gmail email                              |
| GMAIL_AUTH_TOKEN   | Your Gmail password or auth token             |
| RESIN_TOKEN        | Your resin.io token                           |
| RESIN_EMAIL        | Your resin.io email, if not using a token     |
| RESIN_PASS         | Your resin.io password, if not using a token  |
| RESIN_APP_NAME     | Resin application name you wish to monitor    |

These can be set in the Dockerfile, passed to Docker with `--env` at runtime, or placed in the `.env` in the root of this project in
as `source`-able bash commands (`export RESIN_TOKEN=...`, newline separated)

### To run

1. ```git clone git@github.com:resin-io-projects/resin-prometheus-server.git```
2. Add required environment variables in `Dockerfile`, at runtime with `--env`, or in a `.env` in `export A=B` format.
3. Optional: If you'd like persistent grafana storage run: `docker run -d -v /var/lib/grafana --name grafana-storage busybox:latest`
3. ```docker build -t prometheus .```
4. ```docker run -t -i -p 80:80 -p 3000:3000 --name resinMonitor prometheus```
