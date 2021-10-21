#! /usr/bin/env bash

if [[ $1 != "START" ]] && [[ $1 != "STOP" ]] && [[ $1 != "STATUS" ]]; then
  echo "You need to put"
  echo "$0 <START|STOP|STATUS>"
  exit
fi

launcher_script_dir=$(dirname "$(realpath "$0")")
daemon_script_file=$launcher_script_dir/write_mem_daemon.sh
processInfoDir=$launcher_script_dir/.process_info

run_daemon() {
  if [ ! -d "$processInfoDir" ]; then
    mkdir "$processInfoDir"
  fi
  if [ -f "$processInfoDir"/pid ]; then
    childPid=$(cat "$processInfoDir"/pid)
      if ps -p "$childPid" >/dev/null; then
        echo "daemon is already running"
        exit 0
      fi
  fi
  $daemon_script_file &
  childPid=$!
  echo "child pid = $childPid"
  echo $childPid >"$processInfoDir"/pid
}

if [ "$1" == "START" ]; then
  run_daemon
elif [ "$1" == "STOP" ]; then
  if [ ! -f "$processInfoDir"/pid ]; then
    echo "daemon is not running"
    exit 0
  fi
  pid=$(cat "$processInfoDir"/pid)
  kill "$pid"
else
  if [ ! -f "$processInfoDir"/pid ]; then
    echo "daemon is not running"
    exit 0
  fi
  childPid=$(cat "$processInfoDir"/pid)
  if ps -p "$childPid" >/dev/null; then
    echo "daemon is running"
  else
    echo "daemon is not running"
  fi
fi
