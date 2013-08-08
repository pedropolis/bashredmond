#! /bin/bash
##Reads vital statistics for target machine from redis server

rdb="-h server3"
target=$1
params=$#
hostnames=`redis-cli -h server3 smembers hostnames`

function info() {
echo 'BASHREDMOND v0.1'
echo localtime : `date +%H:%M:%S`
}

function parse_param() {

if [ "$params" != "1" ]
	then
		echo ERR: One parameter only please
		echo $params parameters received
	else
	echo $params parameters passed \($target\)
	for arg in $target
	do
		case $arg in all )
		overview ;;
		help )
		echo here is a help file...good luck
		echo "`cat help`" ;;
		ping )
		ping_hosts ;;
		* )
		check_host ;;	
		esac
	done
fi

}

#ping all hostnames in the database
function ping_hosts() {
ms=0
ping=1
for host in $hostnames
	do
		echo pinging $host...
		ms=`ping -c 2 $host|cut -sd '/' -f 5`
		ping=$?
		if [ $ping = 0 ]
			then	
	 			echo $ms ms to $host
			else
				echo Ping to $host failed!!!!
		fi
	done
}


#check parameter input against hostnames in DB 
function check_host() {
	echo "Checking hostname..."
	if [ `redis-cli $rdb sismember hostnames $target` = 1 ]
	then
		echo $target was found in the database
		show_target
	else
		echo $target was NOT found in the database
		echo Currently listed hostnames: $hostnames
	fi
}

#show all info for specified hostname
function show_target() {
echo '*************************************************************'
echo looking up $target ...
echo '******'
echo 'Last Update        :       '`redis-cli $rdb get "$target:time"`
echo 'Uptime             :       '`redis-cli $rdb get "$target:uptime"`
echo 'Avg. Load          :       '`redis-cli $rdb get "$target:load"`
echo 'CPU temp           :       '`redis-cli $rdb get "$target:temp"`
echo 'Ping to google     :       '`redis-cli $rdb get "$target:gping"`ms
echo 'MPD running?       :       '`redis-cli $rdb get "$target:mpd"`
echo 'minerd running?    :       '`redis-cli $rdb get "$target:minerd"`
echo '*************************************************************'
}

#show a quick overview for every hostname found in the database
function overview() {
echo Database holds these hostnames: $hostnames
echo '******'
for host in $hostnames
do
echo $host
echo 'Time  :  '`redis-cli $rdb get "$host:time"`
echo 'Uptime:  '`redis-cli $rdb get "$host:uptime"`
echo 'Load  :  '`redis-cli $rdb get "$host:load"`
echo 'Temp  :  '`redis-cli $rdb get "$host:temp"`
echo '******'
done

}


info
parse_param



#END

