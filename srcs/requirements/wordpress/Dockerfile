# pen-ultimate release (lates is 3.20)
FROM alpine:3.19

WORKDIR /usr/local/wordpress

# create a mount point directory for the volume
# RUN mkdir html

# install the necessary packages
RUN apk --update add --no-cache php \
	php-fpm \
	php-phar \
	php-mysqli \
	php-curl \
	php-dom \
	php-exif \
	php-gd \
	php-iconv \
	php-json \
	php-fileinfo \
	php-mbstring \
	php-openssl \
	php-xml \
	php-zip

RUN adduser -S www-data -G www-data && \
	sed -i "s|user = nobody|user = www-data|g" /etc/php82/php-fpm.d/www.conf && \
	sed -i "s|group = nobody|group = www-data|g" /etc/php82/php-fpm.d/www.conf && \
	sed -i "s|listen = 127.0.0.1:9000|listen = wordpress:9000|g" /etc/php82/php-fpm.d/www.conf && \
	sed -i "s|;listen.owner = nobody|listen.owner = www-data|g" /etc/php82/php-fpm.d/www.conf && \
	sed -i "s|;listen.group = www-data|listen.group = www-data|g" /etc/php82/php-fpm.d/www.conf

COPY ./tools/run.sh .

# COPY ./tools/

EXPOSE 9000

RUN chmod +x run.sh

CMD "./run.sh"
