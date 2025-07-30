#!/bin/bash

cd /mnt/community/missions/manual_swimmer_rescue

export PATH="$PATH:/git/moos-ivp-2680/bin"
export PATH="$PATH:$EXTENDBIN"
export PATH="$PATH:$EXTENDLIB"

# check some env vars
if [[ $VNAME == "" ]];
then
    # if vname is empty, must be shoreside
    echo "running shoreside with ./launch_shoreside.sh --mport=$SHORE_MPORT --pshare=$SHORE_PSHARE --ip=$SHORE --swim_file=mit_05.txt $TIMEWARP"
    ./launch_shoreside.sh --mport=$SHORE_MPORT --pshare=$SHORE_PSHARE --ip=$SHORE --swim_file=mit_05.txt $TIMEWARP
else
    # otherwise run this with the vname
    echo "running vehicle ($VNAME) with ./launch_vehicle.sh --vname=$VNAME --mport=$MPORT --sim --pshare=$PSHARE --ip=$VIP --vrole=$VROLE --tmate=$TMATE --shore=$SHORE --start_pos=$START_POS $TIMEWARP"
    ./launch_vehicle.sh --vname=$VNAME --mport=$MPORT --sim --pshare=$PSHARE --ip=$VIP --vrole=$VROLE --tmate=$TMATE --shore=$SHORE --start_pos=$START_POS $TIMEWARP
fi;