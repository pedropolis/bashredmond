#! /bin/bash
##Reports vital statistics to redis server

host=`hostname`

domlist=`redis-cli -h server3 sismember hostnames $host`

if [ $domlist = 0 ]
	then
	redis-cli -h server3 sadd hostnames $host
fi

ps -C mpd
mpd=$?

if [ $mpd = 0 ]
	then
	redis-cli -h server3 set "`hostname`:mpd" yes
	else
	redis-cli -h server3 set "`hostname`:mpd" no
fi

ps -C minerd
minerd=$?

if [ $mpd = 0 ]
	then
	redis-cli -h server3 set "`hostname`:minerd" yes
	
	else
	redis-cli -h server3 set "`hostname`:minerd" no
fi


redis-cli -h server3 set "`hostname`:time" "`date +%D-%H:%M:%S`"
redis-cli -h server3 set "`hostname`:uptime" "`uptime|cut -d "," -f 1,2|cut -d' ' -f 4-`"
redis-cli -h server3 set "`hostname`:load" "`uptime|cut -d',' -f 4-|cut -b 17-`"
redis-cli -h server3 set "`hostname`:temp" "`acpi -t|cut -d' ' -f 4`"
redis-cli -h server3 set "`hostname`:gping" "`ping -c 2 google.com|cut -sd '/' -f 5`"
