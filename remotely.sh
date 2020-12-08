#!/bin/bash

# Copyright 2020 Mark Polyakov

function remotely {
    ssh -S /tmp/%p-$$.sock "$REMOTELY_HOST" "$@"
}

# args: source, destination, extra rsync args
function ez_rsync {
    local local_path=$1
    local remote_path=$2
    shift 2
    rsync -Rrtpl --info=progress2 "$@" "$local_path" "$REMOTELY_HOST:$remote_path"
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

function env_req {
    if [[ -z $(printenv "$1") ]]
    then
	echo "Missing required environment variable $1"
	exit 1
    fi
}

set -e

if [[ $0 != */* ]]
then
    echo "\$0, which is \"$0\" does not look like a file path. Unable to determine correct pwd"
    exit 1
fi
cd "$(dirname "$0")"

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
