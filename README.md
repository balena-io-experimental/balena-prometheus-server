More info can be found on the [resin-blog](https://resin.io/blog/prometheusv2/)

### Required Environment variables

| Key                | Description                           |
|--------------------|---------------------------------------|
| GMAIL_ACCOUNT     | Your Gmail email                      |
| GMAIL_AUTH_TOKEN | Your Gmail password or auth token      |
| RESIN_EMAIL       | Your resin.io email                   |
| RESIN_PASS        | Your resin.io password                |
| RESIN_APP_NAME   | Resin application you wish to monitor |

### To run

1. ```git clone git@github.com:resin-io-projects/resin-prometheus-server.git```
2. Add required environment variables in `Dockerfile` or at runtime. 
3. Optional: If you'd like persistent grafana storage run: `docker run -d -v /var/lib/grafana --name grafana-storage busybox:latest`
3. ```docker build -t prometheus .```
4. ```docker run -t -i -p 80:80 -p 3000:3000 --name promoContainer promo```
