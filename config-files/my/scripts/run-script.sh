#!/usr/bin/env bash
set -euo pipefail

# --------------------------------------------------
# Configuration
# --------------------------------------------------
SCRIPT_NAME=$(basename "$0")
PARENT_DIR="/tmp/run-script"
PIDFILE=""
PGIDFILE=""
LOGFILE=""
TARGET_SCRIPT=""

# --------------------------------------------------
# Help
# --------------------------------------------------
usage() {
    cat <<EOF
Usage: $SCRIPT_NAME [OPTIONS]

Options:
  -s, --script PATH  Path to the script that should be run (required if not --list-running or --stop-all)
  -r, --run          Run the given script in the background
  -x, --stop         Stop the script that is running in the background
  -l, --log          Show the log of the running script
  -w, --list-running List running scripts
  -a, --stop-all     Stop all running scripts
  -h, --help         Show this help message and exit

Examples:
  $SCRIPT_NAME --run --script /path/to/myworker.sh
  $SCRIPT_NAME -s -i ./worker.sh
  $SCRIPT_NAME -x
  $SCRIPT_NAME --log
EOF
}

# --------------------------------------------------
# Helper: check if process is running
# --------------------------------------------------
is_running() {
    if [[ -f "$PIDFILE" ]]; then
        local pid=$(cat "$PIDFILE")
        if kill -0 "$pid" 2>/dev/null; then
            return 0
        else
            rm -f "$PIDFILE"
        fi
    fi
    return 1
}

# --------------------------------------------------
# Run
# --------------------------------------------------
do_run() {
    if is_running; then
        echo "Already running (PID $(cat "$PIDFILE"))."
        exit 1
    fi

    rm -f "$LOGFILE"

    echo "Starting '$TARGET_SCRIPT' in background ..."

    # Run the user script in background, redirecting all output to the log
    nohup "$TARGET_SCRIPT" >> "$LOGFILE" 2>&1 &

    PID=$!
    PGID=$(ps -o pgid= -p $PID | tr -d ' ')
    echo $PID > "$PIDFILE"
    echo $PGID > "$PGIDFILE"
    echo "Started with PID $PID and PGID $PGID"
    echo "Log file: $LOGFILE"
}

# --------------------------------------------------
# Stop
# --------------------------------------------------
do_stop() {
    if ! is_running; then
        echo "Not running."
        exit 1
    fi

    local pid=$(cat "$PIDFILE")
    local pgid=$(cat "$PGIDFILE")
    echo "Stopping PID $pid and PGID $pgid ..."
    kill -15 "-$pgid"
    sleep 1
    if kill -0 "$pid" 2>/dev/null; then
        kill -9 "-$pgid"
    fi
    rm -f "$PIDFILE"
    rm -f "$PGIDFILE"
}

# --------------------------------------------------
# Restart
# --------------------------------------------------
do_restart() {
    echo "Restarting $TARGET_SCRIPT ..."

    if is_running; then
        do_stop
    fi

    do_run
}

# --------------------------------------------------
# Log
# --------------------------------------------------
do_log() {
    if [[ ! -f "$LOGFILE" ]]; then
        echo "No log file found ($LOGFILE)."
        exit 1
    fi
    local state="stopped"
    if is_running; then
        state="running"
    fi
    echo "=== Log ($LOGFILE) ($state) ==="
    if [[ $state == "running" ]]; then
        tail -n 100 -f "$LOGFILE"
    else
        tail -n 100 "$LOGFILE"
    fi
}

# --------------------------------------------------
# List running scripts
# --------------------------------------------------
do_list_running() {
    for pid_file in "$PARENT_DIR"/*/*.pid; do
        local pgid_file="${pid_file%.*}.pgid"
        PIDFILE="$pid_file"
        PGIDFILE="$pgid_file"
        if is_running; then
            local pid=$(cat "$PIDFILE")
            TARGET_SCRIPT=$(ps -o cmd= -p $pid | cut -d ' ' -f 2)
            echo "$pid $TARGET_SCRIPT"
        fi
    done
}

# --------------------------------------------------
# List running scripts
# --------------------------------------------------
do_stop_all() {
    for pid_file in "$PARENT_DIR"/*/*.pid; do
        local pgid_file="${pid_file%.*}.pgid"
        PIDFILE="$pid_file"
        PGIDFILE="$pgid_file"
        do_stop
    done
}

validate_script() {
    if [[ -z "$TARGET_SCRIPT" ]]; then
        echo "Error: -s / --script is required"
        usage
        exit 1
    fi

    if [[ ! -f "$TARGET_SCRIPT" ]]; then
        echo "Error: script '$TARGET_SCRIPT' does not exist"
        exit 1
    fi

    if [[ ! -x "$TARGET_SCRIPT" ]]; then
        echo "Error: script '$TARGET_SCRIPT' is not executable"
        exit 1
    fi

}

set_files() {
    TARGET_SCRIPT=$(realpath "$TARGET_SCRIPT")
    TARGET_BASE=$(basename "$TARGET_SCRIPT")
    SCRIPT_DIR="$PARENT_DIR/$TARGET_BASE"
    TARGET_HASH=$(echo "$TARGET_SCRIPT" | md5sum | cut -d ' ' -f 1)
    mkdir -p "$SCRIPT_DIR"
    PIDFILE="$SCRIPT_DIR/$TARGET_HASH.pid"
    PGIDFILE="$SCRIPT_DIR/$TARGET_HASH.pgid"
    LOGFILE="$SCRIPT_DIR/$TARGET_HASH.log"
}

# --------------------------------------------------
# Parse options with getopt
# --------------------------------------------------
TEMP=$(getopt -o s:rxelwah \
              --long script:,run,stop,restart,log,list-running,stop-all,help \
              -n "$SCRIPT_NAME" -- "$@") || {
    usage
    exit 1
}

eval set -- "$TEMP"

ACTION=""

while true; do
    case "$1" in
        -s|--script)
            TARGET_SCRIPT="$2"
            shift 2
            ;;
        -r|--run)
            ACTION="run"
            shift
            ;;
        -x|--stop)
            ACTION="stop"
            shift
            ;;
        -e|--restart)
            ACTION="restart"
            shift
            ;;
        -l|--log)
            ACTION="log"
            shift
            ;;
        -w|--list-running)
            ACTION="list-running"
            shift
            ;;
        -a|--stop-all)
            ACTION="stop-all"
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error!" >&2
            exit 1
            ;;
    esac
done

if [[ "$ACTION" != "list-running" &&  "$ACTION" != "stop-all" ]]; then
    validate_script
    set_files
fi

# --------------------------------------------------
# Execute the chosen action
# --------------------------------------------------
case "$ACTION" in
    run)          do_run          ;;
    stop)         do_stop         ;;
    restart)      do_restart      ;;
    log)          do_log          ;;
    list-running) do_list_running ;;
    stop-all)     do_stop_all     ;;
    *)
        echo "Error: no action specified."
        usage
        exit 1
        ;;
esac
