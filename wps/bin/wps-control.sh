
# START
# ---------------------------------------------------------------------------------

wps_start() { 

	wps_check
	wps_header "Starting"
	wps_links
	wps_chmod
	wps_mount

	exec sudo s6-svscan $run
}

# STOP
# ---------------------------------------------------------------------------------

wps_stop() { 
	
	wps_header "Stopping"

	exec WPS_RESTART="false" && sudo s6-svscanctl -t $run	
}

# RESTART
# ---------------------------------------------------------------------------------

wps_restart() { 
	
	wps_header "Restarting..."
	
	exec WPS_RESTART="true" && sudo s6-svscanctl -t $run
}

# STATUS
# ---------------------------------------------------------------------------------

wps_status() { 
	
	wps_header "$2 status"
	
	exec sudo s6-svstat -n $run/$2
	echo ""
}

# PS
# ---------------------------------------------------------------------------------

wps_ps() { 
	
	wps_header "Container processes"

	ps auxf
	echo ""
}


# LOGIN
# ---------------------------------------------------------------------------------

wps_login() { 
	
	wps_header "Logged in as \033[1;37m$user\033[0m"

	su -l $user
}


# ROOT
# ---------------------------------------------------------------------------------

wps_root() { 
	
	wps_header "Logged in as \033[1;37mroot\033[0m"

	su -l root
}
