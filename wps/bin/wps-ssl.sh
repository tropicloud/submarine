
# SSL
# ---------------------------------------------------------------------------------

wps_ssl() {

	if [[  $WP_SSL == 'true'  ]]; then

		wps_header "Creating SSL cert."

		ln -sf $conf/nginx/https.conf $conf/nginx/conf.d
		cd $conf/ssl
		
		if [[  ! -f $conf/ssl/${WP_DOMAIN}.crt  ]]; then
		
			cat $conf/nginx/openssl.conf | sed -e "s/example.com/$WP_DOMAIN/g" > openssl.conf
			openssl req -nodes -sha256 -newkey rsa:2048 -keyout $WP_DOMAIN.key -out $WP_DOMAIN.csr -config openssl.conf -batch
			openssl rsa -in $WP_DOMAIN.key -out $WP_DOMAIN.key
			openssl x509 -req -days 365 -sha256 -in $WP_DOMAIN.csr -signkey $WP_DOMAIN.key -out $WP_DOMAIN.crt	
			rm -f openssl.conf
	
		else echo -e "Certificate already exists.\nSkipping..."
		fi
	fi
}
