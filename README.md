bashredmond
===========

BASH scripts for running REDis based MONitoring Daemon

dependancies
Redis database (here running on server3)
#apt-get install redis-server
this will install the database server and redis-cli which bashredmond uses to communicate

reporter.sh
runs from a crontab on each machine to be monitored

first checks to see if its own hostname is listed,
if not it adds itself to the list then reports its stats and checks a couple of services

reader.sh
client to check machine status

currently currently has one optional input, a machine hostname.
this will show a detailed view of that particular machine.
if no input is given it will show a summary of all hostnames in the database


