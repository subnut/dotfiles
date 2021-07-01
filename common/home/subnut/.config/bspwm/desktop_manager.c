#include <stdio.h>

int
main(void)
{
	int count;
	char should_count;

	char cch;	// current char
	char pch;	// previous char

	cch  = '\0';
	pch  = '\0';

	count = 0;
	should_count = 0;

	for (;;)
	{
		count = 0;
		should_count = 0;

		for (;;)
		{
			pch = cch;
			cch = getchar();

			if (cch == EOF)
				break;

			if (cch == '\n')
				break;

			if (cch == 'M' && pch == ':')
			{
				should_count = 1;
				continue;
			}

			if (cch == 'm' && pch == ':')
			{
				if (should_count == 1)
					break;
				else
					continue;
			}

			if ((cch == 'F' || cch == 'f') && pch == ':')
				count++;
		}

		if (count != 1)
			if (count > 1)
				puts("bspc desktop next.!focused.!occupied.local -r");
			else
				puts("bspc monitor -a Desktop");
		fflush(stdout);

		if (cch == EOF)
			break;
	}
}
