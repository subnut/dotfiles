echo -n 'Start X? [Y/n] '
read ANSWER

if test -z "$ANSWER" || echo "$ANSWER" | grep -q '^[yY]'
then
	exec xinit
fi
