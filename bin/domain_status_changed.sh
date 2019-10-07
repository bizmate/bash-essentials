#!/usr/bin/env bash
# depends on https://github.com/nixcraft/domain-check-2
# uses domain file list ~/domains-check-list.txt
HOW_MANY_TIMES_RUNS=10

if [ -z "${DOMAIN_SEND_TO_EMAIL}" ]  ; then
	echo "Please set DOMAIN_SEND_TO_EMAIL";
	exit 1;
fi

if [ -z "${SLEEP_INTERVAL}" ]  ; then
	echo "Setting default SLEEP_INTERVAL to 60";
	SLEEP_INTERVAL=60
fi

for ((i=0; i<HOW_MANY_TIMES_RUNS; i++))
do
	DOMAIN_STATUS_CHANGED="$( ./domain-check-2.sh -f ~/domains-check-list.txt | grep -v 'Expired\|Status\|-----------------------' )" && [ -n "$DOMAIN_STATUS_CHANGED" ] && echo "$DOMAIN_STATUS_CHANGED" | mailx -v -s "Domain_check_email-Bizmate" $DOMAIN_SEND_TO_EMAIL
	sleep $SLEEP_INTERVAL
done
