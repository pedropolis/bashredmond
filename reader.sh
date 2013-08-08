#! /bin/bash
##Reads vital statistics for target machine from redis server

rdb="-h server3"
target=$1
params=$#
hostnames=`redis-cli -h server3 smembers hostnames`

function info() {
echo 'BASHREDMOND pretty raw version #1'
}

function test() {

if [ "$params" != "1" ]
	then
		echo One parameter only please
	else
	for arg in $target
	do
		case $arg in all )
		overview ;;
		help )
		echo here is a help file...good luck
		echo "`cat help`" ;;
		* )
		echo "Checking hostname"
			if [ `redis-cli $rdb sismember hostnames $target` = 1 ]
			then
			echo $target was found in the database
			show_target
			else
			echo $target was NOT found in the database
			fi ;;	
		esac
	done
fi
echo $params parameters passed \($target\)
echo hostnames from db: $hostnames
}

#function test() {
#if [ $# !-eq 1 ]
#	then
#	echo One parameter only please
#else
#}

function show_target() {
echo '*************************************************************'
echo `date`
echo looking up $target ...
echo '******'
echo 'Uptime is          :       '`redis-cli $rdb get "$target:uptime"`
echo 'Avg. Load          :       '`redis-cli $rdb get "$target:load"`
echo 'CPU temp           :       '`redis-cli $rdb get "$target:temp"`
echo 'ms to google       :       '`redis-cli $rdb get "$target:gping"`
echo 'MPD running?       :       '`redis-cli $rdb get "$target:mpd"`
echo 'minerd running?    :       '`redis-cli $rdb get "$target:minerd"`
echo '*************************************************************'
}

function overview() {
echo Database holds these hostnames: $hostnames
echo '******'
for host in $hostnames
do
echo $host
echo 'Uptime:  '`redis-cli $rdb get "$host:uptime"`
echo 'Load  :  '`redis-cli $rdb get "$host:load"`
echo 'Temp  :  '`redis-cli $rdb get "$host:temp"`
echo '******'
done

}


info
test



#if [ "$target" = "" ]
#	then 
#		overview
#	else
#		show_target
#fi


