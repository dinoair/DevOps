#! /usr/bin/env bash

daemon_script_dir=$(dirname "$(realpath "$0")")
csv_file=$daemon_script_dir/mem_monitoring.txt
parent_exec_name=$(ps -o comm= $PPID)

if [ "$parent_exec_name" == "bash" ]; then
  echo "unsupported usage"
  exit 1
fi

if [ ! -f "$csv_file" ]
then
  echo "timestamp;all_memory;free_memory;%usaged" > "$csv_file"
fi

while true
do
  line=$(free -m | grep "^Mem:.*$" | awk '{print $2;print $3;print $4;}')
  all_memory=$(echo "$line" | sed '1q;d')
  used=$(echo "$line" | sed '2q;d')
  free=$(echo "$line" | sed '3q;d')
  usage=$(((used * 100) / all_memory))
  timestamp=$(date -u +%m-%d-%Y" "%Z" "%T)
  echo "$timestamp;$all_memory;$free;$usage" >> "$csv_file"
  sleep 600
done
