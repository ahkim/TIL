# How to change PostgreSQL password in Windows?

This is best described in [here](http://www.homebrewandtechnology.com/blog/graphicallychangepostgresadminpassword)

However, I find following worth a note on top of the article. 

1. C:\Program Files\PostgreSQL\9.5\data\pg_hba.conf

Detailed help [here](https://www.postgresql.org/docs/9.2/static/auth-pg-hba-conf.html)

```
# Switch to trust of each when to bypass postgres password

# IPv4 local connections:
host    all             all             127.0.0.1/32            md5
#host    all             all             127.0.0.1/32            trust
# IPv6 local connections:
host    all             all             ::1/128                 md5
#host    all             all             ::1/128                 trust
```
