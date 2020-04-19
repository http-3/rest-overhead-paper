#!/bin/bash


WWWROOT=$HOME/tools/var/www/
URL=http://west1:3000
THREADS=24
WRK=$HOME/tools/wrk2/wrk
RESULT_DIR=wrk2results

bench_file() {
		curl -s -o /dev/null -I -w "%{http_code}" "$URL/$1"
        for CONNECTION_NUM in  24 50 100 400 500 1000
		do
		OUT="$RESULT_DIR/$CONNECTION_NUM-$1"
		echo "Benching file $1 to $OUT"
        	        $WRK -t$THREADS -c${CONNECTION_NUM} -d10s -R200 "$URL/$1" # warmup
	        sleep 10
	        $WRK -t$THREADS -c${CONNECTION_NUM} -d60s -R2000 -L "$URL/$1" | tee -a $OUT
            echo "------------------------${CONNECTION_NUM}--DONE------------------------" | tee -a $OUT
        done
}

mkdir -p $RESULT_DIR



if [ -n "$1" ]; then
    bench_file $1
else
    for file in 10 100 1000
    do
		dd if=/dev/urandom bs=1024 count=$file of=$WWWROOT/$file.txt
        bench_file $file.txt
    done
fi
echo "Done benching! Results logged to $OUT."
exit 0
