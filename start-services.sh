#!/bin/bash

# Create required directories if they don't exist
mkdir -p /run/php-fpm
mkdir -p /var/log/php-fpm
mkdir -p /var/log/nginx

# Set proper permissions
chown -R nginx:nginx /run/php-fpm
chown -R nginx:nginx /var/log/php-fpm
chown -R nginx:nginx /var/log/nginx
chown -R nginx:nginx /var/www/html

# Start PHP-FPM in foreground mode
echo "Starting PHP-FPM..."
/usr/sbin/php-fpm -F &
PHP_PID=$!

# Start nginx in foreground mode
echo "Starting Nginx..."
/usr/sbin/nginx -g "daemon off;" &
NGINX_PID=$!

# Start SSH daemon
echo "Starting SSH daemon..."
/usr/sbin/sshd

# Monitor logs
echo "Monitoring logs..."
tail -f /var/log/nginx/error.log /var/log/php-fpm/www-error.log &

# Wait for any process to exit
wait -n $PHP_PID $NGINX_PID
# Exit with status of process that exited first
exit $?
