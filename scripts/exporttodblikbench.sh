#!/bin/bash

#USAGE: $ bash exporttodblikbenchss.sh likbenchssresults-west8-1

RESULT_DIR=$1

cd $RESULT_DIR
DBNAMEC=$RESULT_DIR-client
DBNAMES=$RESULT_DIR-server
group=l2lol2rm



  for file in 1 100 1000 100000 1000000 100000000;do
		echo "pumping likwid results for the size $file into results-likbenchss.db"
		python3 ../lik-results-in-db-client.py $DBNAMEC.db $group $file-$group-wrkout.txt
		python3 ../lik-results-in-db.py $DBNAMES.db $group $file-$group-likwid.txt

  done
		