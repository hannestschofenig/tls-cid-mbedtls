# tls-cid-mbedtls
A prototype for the [DTLS connection id](https://thomas-fossati.github.io/draft-tls-cid/) proposal.

## Test bed

The test bed consists of three docker containers running [Alpine Linux edge](http://gliderlabs.viewdocs.io/docker-alpine/): a DTLS client, a NAT box and a DTLS server.

DTLS client and server live in separate networks (private and public, respectively) which are connected via a NAT gateway.

```
            |0         1|
+--------+  |  +-----+  |  +--------+
| client |--|--| NAT |--|--| server |
+--------+  |  +-----+  |  +--------+
            |           |
         private      public
```

### Controls

- To instantiate the test bed:
```
make up
```
- To shut it down (both containers and networks):
```
make down
```

- To get an interactive shell on the DTLS client:
```
make c-sh
```

- To get an interactive shell on the DTLS server:
```
make s-sh
```

- To get an interactive shell on the NAT box:
```
make n-sh
```
