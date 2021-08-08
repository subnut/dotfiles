if [ "$TERM" = linux ]
then
	echo "1) Start X"
	echo "2) Start Sway"
	printf 'Which one? (1/2/[n]one) [n] '

	read ANSWER

	# if test -z "$ANSWER" || echo "$ANSWER" | grep -q '^[yY]'
	# then
	# 	exec startx
	# fi

	# i=0
	# while test -f "/tmp/.X$i-lock"
	# do
	# 	echo "X is running on :$i"
	# 	i=$(( i+1 ))
	# done
	#
	# printf "Start X on :$i? [Y/n] "
	# read ANSWER
	#
	# if test -z "$ANSWER" || echo "$ANSWER" | grep -q '^[yY]'
	# then
	# 	exec xinit -- ":$i"
	# fi

	# printf "Start sway? [Y/n] "
	# read ANSWER

	# if test -z "$ANSWER" || echo "$ANSWER" | grep -q '^[yY]'
	# then
	# 	exec sway
	# fi

	case "$ANSWER" in
		(1)
			exec startx
			;;
		(2)
			eval $(ssh-agent -s)
			ssh-add < /dev/null

			export _SSH_AUTH_SOCK="$SSH_AUTH_SOCK"
			export _SSH_AGENT_PID="$SSH_AGENT_PID"
			unset SSH_AUTH_SOCK
			unset SSH_AGENT_PID

			pgrep -xf 'seatd -u subnut' ||
			sh -c 'doas seatd -u subnut &' &

			mkdir -p $HOME/.xdg_runtime_dir
			export XDG_RUNTIME_DIR=$HOME/.xdg_runtime_dir

			export GDK_BACKEND=wayland
			export QT_QPA_PLATFORM=wayland-egl

			sway

			# For debugging sway -
			# Create a minimal config, save it as ~/.swayconfig,
			# uncomment the next line, comment out the above line
			# sway -c ~/.swayconfig -d 2> ~/sway.log

			export SSH_AUTH_SOCK="$_SSH_AUTH_SOCK"
			export SSH_AGENT_PID="$_SSH_AGENT_PID"
			unset _SSH_AUTH_SOCK
			unset _SSH_AGENT_PID

			eval $(ssh-agent -s -k)
			ssh-add -D < /dev/null

			exit 0
			;;
	esac
fi
