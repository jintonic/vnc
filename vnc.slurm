#!/bin/sh
# use `sbatch vnc.slurm` to launch a VNC server in a worker node

# launch VNC server (-bs is used to avoid crash of ROOT GUI)
n=`vncserver -bs 2>&1 | grep desktop | awk -F: '{print $3}'`
if [ -z $n ]; then echo "Failed to launch VNC. Quit!"; exit 1; fi
# print the server information to slurm-<job id>.out
if [ -f ~/.vnc/*:$n.pid ]; then cat ~/.vnc/*:$n.log; fi

# ssh back to the login node from the worker node
# -N do not execute a command, just forward ports
# -f send ssh to background
# -R forward remote (login) requests to 54396 to local (worker) 59xx
# -M and -S options are specified in ~/.ssh/config
ssh -N -f -R 54396:localhost:$((n+5900)) $SLURM_SUBMIT_HOST
# check the background ssh connection
ssh -O check $SLURM_SUBMIT_HOST

# launch a window manager to hold the execution
# use ~/.vnc/xstartup to just launch a terminal instead
export DISPLAY=:$n
# use C-A-Enter to launch dmenu instead of a terminal
# `pkill evilwm` can be issued in dmenu to kill evilwm
evilwm --snap 30 --bw 3 --fg blue --bg gray --term dmenu_run

# kill the VNC server once the user kills the window manager
vncserver -kill :$n 2>/dev/null

# wait for the server to terminate
while [ -f ~/.vnc/*:$n.pid ]; do sleep 1; done
tail -19 ~/.vnc/*:$n.log

# send exit command to the background ssh process
ssh -O exit $SLURM_SUBMIT_HOST
ssh -O check $SLURM_SUBMIT_HOST

