#! /bin/bash
##Reports vital statistics to redis server

host=`hostname`

#test if our hostname is in the db list, add it if not.
domlist=`redis-cli -h server3 sismember hostnames $host`

if [ $domlist = 0 ]
	then
	redis-cli -h server3 sadd hostnames $host
fi

#check if we are running Music Player Daemon
ps -C mpd
mpd=$?

if [ $mpd = 0 ]
	then
	redis-cli -h server3 set "`hostname`:mpd" yes
	else
	redis-cli -h server3 set "`hostname`:mpd" no
fi

#check if cpuminer is running and grab process info
ps -C minerd
minerd=$?

if [ $minerd = 0 ]
	then
	redis-cli -h server3 set "`hostname`:minerd" yes
	redis-cli -h server3 set "`hostname`:minerinfo" "$(ps $(ps -C minerd|cut -b 1-5|grep ^....[0-9])|grep ^....[0-9]|cut -d' ' -f 1,12,17)"

	else
	redis-cli -h server3 set "`hostname`:minerd" no
	redis-cli -h server3 set "`hostname`:minerinfo" ""

fi
#fetch a bunch of other info we want

redis-cli -h server3 set "`hostname`:uptime" "`uptime|cut -d "," -f 1,2|cut -d' ' -f 4-`"
redis-cli -h server3 set "`hostname`:load" "`uptime|cut -d',' -f 4-|cut -b 17-`"

redis-cli -h server3 set "`hostname`:temp" "`acpi -t|cut -d' ' -f 4`"

redis-cli -h server3 set "`hostname`:gping" "`ping -c 2 google.com|cut -sd '/' -f 5`"


redis-cli -h server3 set "`hostname`:time" "`date +%D-%H:%M:%S`"

