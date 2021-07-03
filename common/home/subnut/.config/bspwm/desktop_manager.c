#include <stdio.h>

#ifdef EBUG
#define DPUTC(c) fputc(c, stderr)
#define DPUTS(s) fputs(s, stderr)
#define DPRINTF(...) fprintf(stderr, __VA_ARGS__)
#else
#define DPUTC(c)
#define DPUTS(s)
#define DPRINTF(...)
#endif

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
			DPUTC(cch);

			if (cch == EOF)
				break;

			if (cch == '\n')
				break;

			if (cch == 'M' && pch == ':')
			{
				DPUTS("# AFFIRMATIVE #");
				should_count = 1;
				continue;
			}

			if (cch == 'm' && pch == ':')
			{
				DPUTS("# NEGATIVE #");
				should_count = 0;
				continue;
			}

			if (should_count)
				if ((cch == 'F' || cch == 'f') && pch == ':')
					count++;
		}

		DPRINTF("COUNT(%i)\n", count);
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
