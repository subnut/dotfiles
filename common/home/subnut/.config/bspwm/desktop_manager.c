#include <stdio.h>
#include <unistd.h>

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

	/* while (!usleep(8000)) */
	for (;;)
	{
		ppch = pch;
		pch  = cch;
		cch  = getchar();
		fputc(cch, stderr);

		if (cch == EOF)
			break;

		if (cch == 'M' && (pch == ':' || (pch == 'W' && ppch == '\n')))
		{
			should_count = 1;
			continue;
		}

		if (cch == 'm' && (pch == ':' || (pch == 'W' && ppch == '\n')))
		{
			should_count = 0;
			continue;
		}

		if (should_count)
		{
			if ((cch == 'f' || cch == 'F') && pch == ':')
				count++;
		}
		else continue;


		if (cch == '\n')
		{
			if (count > 1)
				puts("bspc desktop next.!focused.!occupied.local -r");
			if (count < 1)
				puts("bspc monitor -a Desktop");
			fflush(stdout);
			count = 0;
			sleep(1);
			continue;
		}
	}

	return 0;
}
