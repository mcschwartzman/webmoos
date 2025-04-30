#!/bin/bash

cd /missions/henry_gilda_baseline

# check some env vars
if [[ $VNAME == "" ]];
then
    # if vname is empty, must be shoreside
    echo "running shoreside"
    ./launch_shoreside.sh --mport=$MPORT --pshare=$PSHARE $TIMEWARP
else
    # otherwise run this with the vname
    echo "running vehicle ($VNAME)"
    ./launch_vehicle.sh --mport=$MPORT --pshare=$PSHARE $TIMEWARP
fi;
