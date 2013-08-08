#! /bin/bash
##Reads vital statistics for target machine from redis server


target=$1
hostnames=`redis-cli -h server3 smembers hostnames`

function info() {
echo 'BASHREDMOND pretty raw version #1'
}

function show_target() {
echo '*************************************************************'
echo `date`
echo looking up $target ...
echo '******'
echo 'Uptime is          :       '`redis-cli -h server3 get "$target:uptime"`
echo 'Avg. Load          :       '`redis-cli -h server3 get "$target:load"`
echo 'CPU temp           :       '`redis-cli -h server3 get "$target:temp"`
echo 'ms to google       :       '`redis-cli -h server3 get "$target:gping"`
echo 'MPD running?       :       '`redis-cli -h server3 get "$target:mpd"`
echo 'minerd running?    :       '`redis-cli -h server3 get "$target:minerd"`
echo '*************************************************************'
}

function overview() {
echo Database holds these hostnames: $hostnames
echo '******'
for host in $hostnames
do
echo $host
echo 'Uptime:  '`redis-cli -h server3 get "$host:uptime"`
echo 'Load  :  '`redis-cli -h server3 get "$host:load"`
echo 'Temp  :  '`redis-cli -h server3 get "$host:temp"`
echo '******'
done

}

info
if [ "$target" = "" ]
	then 
		overview
	else
		show_target


fi


