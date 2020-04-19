#!/bin/bash

RESULT_DIR=$HOME/latency-results-2nodes/
WRK2PLOT=$HOME/wrk2plot.py
#module load py-pandas

for CONNECTION_NUM in  24 50 100 400 500 1000
		do
		echo "plotting latencies for $CONNECTION_NUM "
		python3  $WRK2PLOT --output $RESULT_DIR/plotcon$CONNECTION_NUM.png --title "Latency variation in relation with file size for a fixed nb of open Connections CONN ${CONNECTION_NUM}" $RESULT_DIR/$CONNECTION_NUM-*
        done
for file in 10 100 1000
    do
		echo "plotting latencies for file size $file "
		python3  $WRK2PLOT --output $RESULT_DIR/plotfile$file.png --title "Latency variation in relation to open connections for a file of size ${file} KB" $RESULT_DIR/*-$file.txt
    done
		
