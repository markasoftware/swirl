#!/bin/bash

# Copyright 2020 Mark Polyakov

function remotely {
    # SSH passes its arguments to a shell, so we need to handle splitting stuff carefully. SSH takes
    # each command argument, joins them with spaces, then sends that to the remote shell. We want an extra layer of quoting around each argument.
    local ssh_command=
    for arg in "$@"
    do
	arg=${arg//\\/\\\\}
	arg=${arg//\"/\\\"}
	ssh_command+=" \"$arg\""
    done
    ssh -S /tmp/%p-$$.sock "$REMOTELY_HOST" "$ssh_command"
}

# args: source, destination, extra rsync args
function ez_rsync {
    local local_path=$1
    local remote_path=$2
    shift 2
    rsync -Rrtp --info=progress2 "$@" "$local_path" "$REMOTELY_HOST:$remote_path"
}

function upload {
    if [[ -z "$1" ]]
    then
	echo 'Need to pass argument to upload!'
	exit 1
    fi
    local local_path=$1
    shift
    ez_rsync "$LDIR/$local_path" / "$@"
}

function backup {
    last_backup_dir=$(find "$backup_dir" -maxdepth 1 -name '????-??-??' -type d | sort | tail -n 1)
    new_backup_dir="$(dirname "$backup_dir")/$(date -I)"
    rsync -rtp --info=progress2 --link-dest="$last_backup_dir" "$@" "$REMOTELY_HOST:$1"
}

function env_req {
    if [[ -z $(printenv "$1") ]]
    then
	echo "Missing required environment variable $1"
	exit 1
    fi
}

set -e

if (( $# != 1 ))
then
    echo 'Usage: remotely.sh go.sh'
    exit 1
fi

if [[ -z "$REMOTELY_HOST" ]]
then
    echo 'Cannot go without REMOTELY_HOST!'
    exit 1
fi

echo 'Processing M4 templates...'
LDIR=${LDIR:-$(dirname "$0")/files}
LDIR=${LDIR%/}
LDIR="${LDIR}/."
trap "find '$LDIR' -name '*.m4' -print0 | sed -z 's/.m4$//' | xargs -0 rm -f" EXIT
find "$LDIR" -name '*~' -o -name '*#*' -delete
# use xargs instead of -exec so that errors are fatal
find "$LDIR" -name '*.m4' -print0 | xargs -0 -L1 --no-run-if-empty -- bash -c 'm4 -P "$0" "$1" > "${1%.m4}"' "$PWD/include.m4"

set -x

ssh -oControlMaster=yes -oControlPersist=200 -oControlPath=/tmp/%p-$$.sock "$REMOTELY_HOST" exit

go_path="$(readlink -f "$1")"
cd "$(dirname "$1")"
source "$go_path"
echo
echo
echo Done!
