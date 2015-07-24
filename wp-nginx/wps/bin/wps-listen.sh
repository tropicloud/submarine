
# LISTEN
# ---------------------------------------------------------------------------------

wps_listen() { 
if [[  ! -z $BASH  ]]; then

	HTTP_PORT="8080"
	HTTP_OUTPUT="/tmp/stdout"
	HTTP_LOCATION="Location:"
	HTTP_200="HTTP/1.1 200 OK"
	HTTP_404="HTTP/1.1 404 Not Found"
	
	rm -f $HTTP_OUTPUT
	mkfifo $HTTP_OUTPUT
	
	trap "rm -f $HTTP_OUTPUT" EXIT
	echo "Starting HTTP server"
	echo "Listening on port $HTTP_PORT"
	
	while true
	do cat $HTTP_OUTPUT | nc -l $HTTP_PORT > >(
		export REQUEST=
		while read LINE
		do LINE=$(echo "$LINE" | tr -d '[\r\n]')
	
			# GET
			if echo "$LINE" | grep -qE '^GET /'           
			then REQUEST=$(echo "$LINE" | cut -d ' ' -f2)
				
				# location ^/echo/$
				if echo $REQUEST | grep -qE '^/echo/'
				then printf "%s\n%s %s\n\n%s\n" "$HTTP_200" "$HTTP_LOCATION" $REQUEST ${REQUEST#"/echo/"} > $HTTP_OUTPUT
				
				# location ^/date
				elif echo $REQUEST | grep -qE '^/date'
				then date > $HTTP_OUTPUT
				
				# location ^/stats
				elif echo $REQUEST | grep -qE '^/stats'
				then vmstat -S M > $HTTP_OUTPUT
				
				# location ^/net
				elif echo $REQUEST | grep -qE '^/net'
				then ifconfig > $HTTP_OUTPUT
				
				# location *
				else printf "%s\n%s %s\n\n%s\n" "$HTTP_404" "$HTTP_LOCATION" $REQUEST "Resource $REQUEST NOT FOUND!" > $HTTP_OUTPUT
				fi
			fi
		done)
	done	
fi
}