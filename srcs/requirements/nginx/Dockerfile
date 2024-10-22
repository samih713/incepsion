# pen-ultimate release (lates is 3.20)
FROM alpine:3.19

# the local directory where commands are to be run from
WORKDIR /usr/local/wordpress

# make dir
# RUN mkdir -p html

# copy the script to setup nginx into the working dir's root
COPY tools/setup.sh .

# give it excute privelage && run it
RUN chmod +x ./setup.sh && /bin/sh -c ./setup.sh

# copy .conf
COPY wordpress.conf /etc/nginx/http.d/

EXPOSE 443

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]

