#!/bin/bash

SERVER=$(hostname)
PORT=8443
CLIENT=$1
SSH=/usr/bin/ssh
TOOLSDIR=$HOME/tools
LSWSCTRL=$HOME/tools/lsws/bin/lswsctrl
h2load=$HOME/tools/h2load-27/nghttp2/build/bin/h2load
DATUM=$(date +'%Y%m%d-%H%M%S')
WWWROOT=$HOME/tools/lsws/Example/html/shm
group=L2_RQSTS_MISS:PMC0:KERNEL,L2_LINES_OUT_DIRTY_ANY:PMC1:KERNEL
groupID=lrmllod
. /etc/profile.d/modules.sh
module load pcre
module load likwid

for protocol in http/1.1 h2 h3-27;do
    echo "launching tests for protocol $protocol"
	if [ $protocol == 'http/1.1' ]; then prot=h1; elif [ $protocol == 'h3-27' ]; then prot=h3; else prot=$protocol;fi
	RESULT_DIR=$HOME/tests/Scripts/openliteh2loadbench/$SERVER-$prot-$DATUM
	echo "creating DIR $RESULT_DIR"
	mkdir -p $RESULT_DIR
	     for (( i=0; i<=22;i++ ));do
				file=$((2**$i))	
				echo "creating file $file"
				dd if=/dev/urandom bs=1 count=$file of=$WWWROOT/$file.txt
				sleep 1
				likwid-perfctr -f -g $group -C 0-3 $LSWSCTRL start 1> $RESULT_DIR/$file-$groupID-likwid.txt 2>&1 &
				sleep 1
				echo "LiteSpeed on"
${SSH} -T $CLIENT <<EOF
module load pcre
module load likwid
likwid-perfctr -f -g $group -C 0-3 ${h2load} -c1 --header="accept-encoding:gzip" --npn-list $protocol --duration=60 https://$SERVER:$PORT/shm/$file.txt | tee $RESULT_DIR/$file-$groupID-h2out.txt
EOF
				
				echo "h2load done"
				echo "killing LiteSpeed on $SERVER"
				$LSWSCTRL stop
				sleep 5
		  done
done
echo "DONE"
	
