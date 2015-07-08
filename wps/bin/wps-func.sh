
# HEADER
# ---------------------------------------------------------------------------------

wps_header() {
	echo -e "\033[0;30m
-----------------------------------------------------
\033[0;34m  Submarine\033[0;37m - $1\033[0;30m
-----------------------------------------------------
\033[0m"
}

# CHECK
# ---------------------------------------------------------------------------------

wps_check() {
  	if [[  -z $WP_DOMAIN  ]];
  	then wps_check_false
  	else wps_check_true
  	fi
}

wps_check_true() {
	if [[  -d $www  ]];
	then /bin/true
	else rm -rf /wps/run && wps_setup
	fi
}

wps_check_false() {
	wps_header "[ERROR] WP_DOMAIN is not set!"
	echo -e "\033[1;31m  Pleae define WP_DOMAIN as an environment variable.
\033[0m  ex: docker run -P -e WP_DOMAIN=\"example.com\" -d tropicloud/wp-submarine
\033[0m  Aborting script...\n\n"
	exit 1;
}

# ADMINER
# ---------------------------------------------------------------------------------

wps_adminer() { 

	wps_header "Adminer (mysql admin)"

	echo -e "  Password: $DB_PASSWORD\n"
	php -S 0.0.0.0:8888 -t /usr/local/adminer
}

# CHMOD
# ---------------------------------------------------------------------------------

wps_chmod() { 

	sudo chown -R $user:nginx $home
	
	sudo find $home -type f -exec chmod 644 {} \;
	sudo find $home -type d -exec chmod 755 {} \;
}

# MOUNT
# ---------------------------------------------------------------------------------

wps_mount() { 

	ln -sf /dev/stdout /var/log/nginx/access.log
	ln -sf /dev/stderr /var/log/nginx/error.log
	
	cp -R $conf/s6 /wps/run

	if [[  ! $WP_SQL == 'local'  ]];
	then rm -rf /wps/run/mysql
	fi
	
	sudo find /wps/run -type f -exec chmod +x {} \;
}


# UN-MOUNT
# ---------------------------------------------------------------------------------

wps_unmount() { 

	sudo kill -9 -1
	sudo rm -rf /wps/run
}

# LINKS
# ---------------------------------------------------------------------------------

wps_links() {

	if [[  ! $WPS_MYSQL == '127.0.0.1:3306'  ]];
	then echo -e "\033[1;32m  •\033[0;37m MySQL\033[0m -> $WPS_MYSQL"
	else echo -e "\033[1;33m  •\033[0;37m MySQL\033[0m -> $WPS_MYSQL (localhost)"
	fi	
	
	if [[  ! -z $WPS_REDIS  ]];
	then echo -e "\033[1;32m  •\033[0;37m Redis\033[0m -> $WPS_REDIS"		
	else echo -e "\033[1;31m  •\033[0;37m Redis\033[0m [not connected]"
	fi		
	
	if [[  ! -z $WPS_MEMCACHED  ]];
	then echo -e "\033[1;32m  •\033[0;37m Memcached\033[0m -> $WPS_MEMCACHED"
	else echo -e "\033[1;31m  •\033[0;37m Memcached\033[0m [not connected]"
	fi
	echo ""
}
