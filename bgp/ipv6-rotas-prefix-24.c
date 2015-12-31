#include <stdlib.h>
#include <stdio.h>
#include <netinet/in.h>
#include <time.h>
#include <unistd.h>

int main(int argc, char **argv){
    struct in6_addr ipv6;
     char str[INET6_ADDRSTRLEN];
    int a = 32;
    int b = 0;
    int c = 0;
    int d = 0;
    
    memset(&ipv6, 0, sizeof(struct in6_addr));

    for(;a <= 63;a++){
		ipv6.s6_addr[0] = a;
		for(b=0;b<=255;b++){
			ipv6.s6_addr[1] = b;
			for(c=0;c<=255;c++){
			    ipv6.s6_addr[2] = c;
			    inet_ntop(AF_INET6, &(ipv6), str, INET6_ADDRSTRLEN);
			    printf("%s/24\n", str);
			}
		}
    
    }
    return 0;
}
