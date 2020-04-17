#!/bin/bash

#USAGE: $  bash exporttodblik-h2load-bench.sh west1 20200320-235459

set -eu -o pipefail


SERVER=$1  #west1
DATUM=$2 #20200220-230611


DBNAME=h2load-results-$SERVER-$DATUM
DBNAMES=$DBNAME-server
DBNAMEC=$DBNAME-client
groupID=lrmllod

for prot in h1 h2 h3;do
    echo "importing tests for protocol $prot"
	     for (( i=0; i<=22;i++ ));do
				file=$((2**$i))	
				RESULT_DIR=$HOME/tests/Scripts/openliteh2loadbench/$SERVER-$prot-$DATUM
				cd $RESULT_DIR
				echo "pumping likwid results for the size $file into ${DBNAMES}-${prot}.db"
				python3 $HOME/tests/Scripts/lik-h2load-results-in-db.py $DBNAMES-$prot.db llod-server $file-$groupID-likwid.txt
				echo "pumping likwid results for the size $file into ${DBNAMEC}-${prot}.db"
				python3 $HOME/tests/Scripts/lik-h2load-results-in-db.py $DBNAMEC-$prot.db llod-client $file-$groupID-h2out.txt
		done
done
echo "FERTIG"