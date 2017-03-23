.DEFAULT_GOAL := help

up: ; docker-compose up -d
down: ; docker-compose down

c-sh: up ; docker exec -ti cli bash -i
n-sh: up ; docker exec -ti nat bash -i
s-sh: up ; docker exec -ti srv bash -i

update-mbedtls: ; git submodule update --init --recursive

help:
	@echo
	@echo "Available targets:"
	@echo
	@echo "   * up		start the test bed"
	@echo "   * down	stop the test bed"
	@echo "   * c-sh	get an interactive shell on the client"
	@echo "   * n-sh	get an interactive shell on the NAT box"
	@echo "   * s-sh	get an interactive shell on the server"
	@echo "   * rebind	TODO: force a NAT rebind"
	@echo "   * run-c	TODO: run the DTLS client"
	@echo "   * run-s	TODO: run the DTLS server"
	@echo "   * update-mbedtls	update mbedTLS submodule"
	@echo

# vim: ft=make
