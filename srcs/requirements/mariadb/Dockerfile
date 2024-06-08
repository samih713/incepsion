# pen-ultimate release (lates is 3.20)
FROM alpine:3.19

# the local directory where commands are to be run from
WORKDIR /var/lib/mysql
# WORKDIR /usr/local/mariadb

# install mariadb
RUN apk add --update --no-cache mariadb

# copy run.sh
COPY ./tools/run.sh .

RUN chmod +x run.sh

# expose port
EXPOSE 3306

ENTRYPOINT [ "./run.sh" ]
