#!/bin/sh

## Wordpress Setup
echo "[info] Setting up Wordpress"

echo "[info] installing wp-cli"
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/bin/wp

if ! wp core is-installed 2>/dev/null; then
    echo "[info] wp is not installed, downloading wordpress files"
    wp core download --allow-root

    echo "[info] creating wordpress config file"
    wp config create --allow-root \
                    --dbname=$MARIADB_DATABASE \
                    --dbuser=$MARIADB_USER \
                    --dbpass=$MARIADB_USER_PASSWORD \
                    --dbhost=$WORDPRESS_DB_HOST
    if [ $? -eq 0 ]; then
        echo "[info] wp-config.php created successfully"
    else
        echo "[error] wp-config.php creation failed"
        return 1
    fi

    echo "[info] installing wordpress files"
    wp core install --allow-root \
                    --title=$WP_TITLE \
                    --url=$DOMAIN_NAME \
                    --admin_user=$WP_ADMIN \
                    --admin_password=$WP_ADMIN_PASSWORD \
                    --admin_email=$WP_ADMIN_EMAIL
    if [ $? -eq 0 ]; then
        echo "[info] WordPress installed successfully"
    else
        echo "[error] WordPress installation failed"
        return 1
    fi

    echo "[info] creating user $WP_USER"
    wp user create --allow-root $WP_USER $WP_USER_EMAIL --user_pass=$WP_USER_PASSWORD
else
    echo "[info] wp is already installed"
fi

echo "[info] changing ownership"
chown -R www-data:www-data /usr/local/wordpress
chmod -R 755 /usr/local/wordpress

echo "[info] Running PHP-FPM"
php-fpm82 -F
