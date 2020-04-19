#!/bin/bash

SERVER=$(hostname)
CLIENT=$1
SSH=/usr/bin/ssh
TOOLSDIR=$HOME/tools
WRK=$HOME/tools/wrk/wrk
DATUM=$(date +'%Y%m%d-%H%M%S')
WWWROOT=/dev/shm
group=L2_LINES_OUT_DIRTY_ANY:PMC0:KERNEL,L2_RQSTS_MISS:PMC1:KERNEL
groupID=l2lol2rm
. /etc/profile.d/modules.sh
module load pcre
module load likwid

for THREADS in 1 24; do
	for OPEN_CON in 1 10 240; do
	if ((THREADS > OPEN_CON));then continue;fi
	RESULT_DIR=$HOME/tests/Scripts/likbenchsswrkresults-$SERVER-$THREADS-$OPEN_CON-$DATUM
	echo "creating DIR $RESULT_DIR"
	mkdir -p $RESULT_DIR
	LCORE=$(( THREADS -1 ))
		  for file in 1 100 1000 100000 1000000 100000000;do
				echo "creating file $file"
				dd if=/dev/urandom bs=1 count=$file of=$WWWROOT/$file.txt
				sleep 1
				likwid-perfctr -f -g $group -C 0-$LCORE $TOOLSDIR/sbin/lighttpd -D -f $TOOLSDIR/lighttpdshm.conf 1> $RESULT_DIR/$file-$groupID-likwid.txt 2>&1 &
				sleep 1
				echo "light on"
${SSH} -T $CLIENT <<EOSSH
module load pcre
module load likwid
likwid-perfctr -f -g $group -C 0-$LCORE ${WRK} -t$THREADS -c$OPEN_CON -d60s --latency http://$SERVER:3000/$file.txt | tee $RESULT_DIR/$file-$groupID-wrkout.txt
EOSSH
				
				echo "wrk done"
				echo "killing lighttpd on $SERVER"
				pkill lighttpd
				sleep 5
		  done
	done
done
echo "DONE"
	
