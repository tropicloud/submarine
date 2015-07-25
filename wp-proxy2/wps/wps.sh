#!/bin/sh

# WPS-NGINX
# ---------------------------------------------------------------------------------
# @author: admin@tropicloud.net
# version: 0.1
# ---------------------------------------------------------------------------------

export bin="/wps/bin"
export etc="/wps/etc"
export run="/wps/run"

for f in $bin/*;
	do . $f
done

  if [[  $1 == 'build'  ]];   then wps_build
elif [[  $1 == 'start'  ]];   then wps_start
elif [[  $1 == 'listen'  ]];  then wps_listen
elif [[  $1 == 'reload'  ]];  then wps_reload
elif [[  $1 == 'root'  ]];    then wps_root
elif [[  $1 == 'true'  ]];    then /bin/true
else /bin/sh -c "$@"
  fi
