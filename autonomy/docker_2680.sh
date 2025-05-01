#!/bin/bash

cd /git/moos-ivp-2680/missions/lab_14_rescue_baseline

export PATH="$PATH:/git/moos-ivp-mcschwar/bin"
export PATH="$PATH:/git/moos-ivp-mcschwar/lib"
export PATH="$PATH:/git/moos-ivp-2680/bin"
export IVP_BEHAVIOR_DIRS="/git/moos-ivp-mcschwar/lib"

# check some env vars
if [[ $VNAME == "" ]];
then
    # if vname is empty, must be shoreside
    echo "running shoreside"
    ./launch_shoreside.sh --mport=$MPORT --pshare=$PSHARE --ip=10.1.0.2 --swim_file=mit_05.txt $TIMEWARP
else
    # otherwise run this with the vname
    echo "running vehicle ($VNAME)"
    ./launch_vehicle.sh --vname=$VNAME --mport=$MPORT --sim --pshare=$PSHARE --ip=$VIP --vrole=$VROLE --tmate=$TMATE --shore=10.1.0.2 $TIMEWARP
fi;
