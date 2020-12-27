#!/bin/bash

source remotely.sh
remotely_backup web-server

backup /home/public-html/ -l
