if [ "$TERM" = linux ]
then
	printf "Start X? [Y/n] "
	read ANSWER

	if test -z "$ANSWER" || echo "$ANSWER" | grep -q '^[yY]'
	then
		exec startx
	fi

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
fi
