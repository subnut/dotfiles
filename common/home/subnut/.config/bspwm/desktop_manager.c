#include <stdio.h>

int
main(void)
{
	int count;
	char should_count;

	char cch;	// current char
	char pch;	// previous char
	char ppch;	// pre-previous char

	cch  = '\0';
	pch  = '\0';
	ppch = '\0';

	count = 0;
	should_count = 0;

	for (;;)
	{
		ppch = pch;
		pch  = cch;
		cch  = getchar();

		if (cch == EOF)
			break;

		if (cch == 'M' && (pch == ':' || (pch == 'W' && ppch == '\n')))
			should_count = 1;

		if (cch == 'm' && (pch == ':' || (pch == 'W' && ppch == '\n')))
			should_count = 0;

		if (should_count)
			if ((cch == 'f' || cch == 'F') && pch == ':')
				count++;


		if (cch == '\n')
		{
			if (count > 1)
				printf("bspc desktop next.!focused.!occupied.local -r\n");
			else if (count < 1)
				printf("bspc monitor -a Desktop\n");
			fflush(stdout);
			count = 0;
		}
	}

	return 0;
}
