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
exec bspwm
