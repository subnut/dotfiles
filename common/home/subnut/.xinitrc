if [ $(uname) = OpenBSD ]
then
	xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation' 1
	xinput set-prop /dev/wsmouse 'WS Pointer Wheel Emulation Button' 2
	xinput set-prop /dev/wsmouse 'Device Accel Constant Deceleration' 0.45
else
	# xinput set-button-map 'TPPS/2 Elan TrackPoint' 1 0 3
	# xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Accel Speed' 0.001
	xinput set-prop 'SynPS/2 Synaptics TouchPad' 'libinput Tapping Enabled' 1
fi

if [ ! $(uname) = OpenBSD ]
then
	eval $(ssh-agent -s)
	ssh-add < /dev/null &
fi

export _SSH_AUTH_SOCK="$SSH_AUTH_SOCK"
export _SSH_AGENT_PID="$SSH_AGENT_PID"
unset SSH_AUTH_SOCK
unset SSH_AGENT_PID

bspwm

export SSH_AUTH_SOCK="$_SSH_AUTH_SOCK"
export SSH_AGENT_PID="$_SSH_AGENT_PID"
unset _SSH_AUTH_SOCK
unset _SSH_AGENT_PID

if [ ! $(uname) = OpenBSD ]
then
	eval $(ssh-agent -s -k)
	ssh-add -D < /dev/null
fi
