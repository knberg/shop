FROM mysql:latest

ENV MYSQL_ROOT_PASSWORD=super
ENV MYSQL_DATABASE=shopdb

COPY init.sql /docker-entrypoint-initdb.d/

COPY custom.cnf /etc/mysql/conf.d/custom.cnf