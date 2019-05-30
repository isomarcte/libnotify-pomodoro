#!/usr/bin/env bash

set -e

# Constants #
declare -r _DEPS=('notify-send')
declare -r _DEFAULT_SHORT_BREAKS=3
declare -r _DEFAULT_SHORT_BREAK_DURATION=5
declare -r _DEFAULT_LONG_BREAK_DURATION=30
declare -r _DEFAULT_WORK_DURATION=50

# Variables #
declare _SHORT_BREAK=0
declare _WORK=0

# Functions #

function verify_deps {
    for dep in "${_DEPS[@]}"
    do
        if command -v "$dep" &>/dev/null
        then
            continue
        else
            echo "Missing Dependency: $dep" 1>&2
        fi
    done
}

# Assigns variables to default values if they are not provided in the
# current environment.
function setup_environment_variables {
    if [ -z "$_SHORT_BREAKS" ]
    then
        _SHORT_BREAKS="$_DEFAULT_SHORT_BREAKS"
    fi
    if [ -z "$_SHORT_BREAK_DURATION" ]
    then
        _SHORT_BREAK_DURATION="$_DEFAULT_SHORT_BREAK_DURATION"
    fi
    if [ -z "$_LONG_BREAKS" ]
    then
        _LONG_BREAKS="$_DEFAULT_LONG_BREAKS"
    fi
    if [ -z "$_LONG_BREAK_DURATION" ]
    then
        _LONG_BREAK_DURATION="$_DEFAULT_LONG_BREAK_DURATION"
    fi
    if [ -z "$_WORK_DURATION" ]
    then
        _WORK_DURATION="$_DEFAULT_WORK_DURATION"
    fi

}

# Convert Minutes To Seconds as required by sleep(1p).
function as_seconds {
    local -r _MINUTES="${1:?'Missing Minutes Argument'}"
    echo "$((_MINUTES * 60))"
}

function notify {
    local -r _SUMMARY="${1:?'Missing Summary'}"
    local -r _MESSAGE="${2:?'Missing Message'}"

    notify-send -u critical -a 'pomodoro.sh' "$_SUMMARY" "$_MESSAGE"
}

# FSM loop over pomodoro timer.
function loop {
    local -r _SHORT_BREAK_SECONDS="$(as_seconds "$_SHORT_BREAK_DURATION")"
    local -r _LONG_BREAK_SECONDS="$(as_seconds "$_LONG_BREAK_DURATION")"
    local -r _WORK_SECONDS="$(as_seconds "$_WORK_DURATION")"

    while true
    do
        if [ "$_WORK" -eq "0" ]
        then
            # Work Period
            _WORK=1
            echo "Entering Work: $_WORK_DURATION Minutes"
            notify 'Work' "Get focused on work for the next $_WORK_DURATION minutes!"
            sleep "$_WORK_SECONDS"
        else
            # Break Period
            _WORK=0
            if [ "$_SHORT_BREAK" -eq "$_SHORT_BREAKS" ]
            then
                echo "Entering Long Break: $_LONG_BREAK_DURATION Minutes"
                _SHORT_BREAK=0
                notify 'Long Break' "Please take a $_LONG_BREAK_DURATION minute break. You need it."
                sleep "$_LONG_BREAK_SECONDS"
            else
                echo "Entering Short Break: $_SHORT_BREAK_DURATION Minutes"
                _SHORT_BREAK="$((_SHORT_BREAK + 1))"
                notify 'Short Break' "Please take a $_SHORT_BREAK_DURATION minute break. You need it."
                sleep "$_SHORT_BREAK_SECONDS"
            fi
        fi
    done
}

# Main #

function main {
    verify_deps
    setup_environment_variables
    loop
}

main "$@"
