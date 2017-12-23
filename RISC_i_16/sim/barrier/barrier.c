#include <stdio.h>

int strlen(char *str);

int main(void)
{
	char str[100];
	char out[100];
	int n,i,j,m,len;
	scanf("%s",str);
	scanf("%d",&n);

	len=strlen(str);

	i=0;
	j=0;
	while(j<len)
	{
		m=0;
		while(m<len)
		{
			out[j]=str[m+i];
			j++;
			m+=n;
		}
		i++;
	}

	out[j]='\0';
	printf("%s",out);

	return 0;
}

int strlen(char *str)
{
	int i=0;
	while(str[i])
		i++;
	return i;
}

