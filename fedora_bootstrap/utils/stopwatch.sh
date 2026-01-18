#!/bin/bash

start_stopwatch() {
    local start_time=$SECONDS
    export SCRIPT_START_TIME=$start_time
}

stop_stopwatch() {
    local end_time=$SECONDS
    local start_time=$SCRIPT_START_TIME
    local duration=$((end_time - start_time))
    local minutes=$((duration / 60))
    local seconds=$((duration % 60))
    local milliseconds=$((duration * 1000 % 1000))
    echo "Script execution time: ${minutes} m : ${seconds} s : ${milliseconds} ms"
}
