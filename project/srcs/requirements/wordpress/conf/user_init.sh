#!bin/sh

wp core install --url=localhost --title="Inception Docker Project" --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PWD} --admin_email=${WP_ADMIN_MAIL}

if wp user get ${WP_USER} >/dev/null 2>&1; then
	echo "Us exists."
else
	wp user create ${WP_USER} ${WP_USER_MAIL} --role=subscriber --user_pass=${WP_USER_PWD}
fi
#wp user update "${WP_ADMIN_USER}" --user_pass="${WP_USER_PWD}" --skip-email
if wp user get "${WP_ADMIN_USER}" >/dev/null 2>&1; then
	echo "Logged in succesfully as root."
else
	echo "Login failed."
fi
/usr/sbin/php-fpm83 -F