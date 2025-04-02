package main

/*
   https://dev.to/douglasmakey/understanding-unix-domain-sockets-in-golang-32n8
   https://medium.com/@viktordev/socket-programming-in-go-write-a-simple-tcp-client-server-c9609edf3671
   https://www.kelche.co/blog/go/socket-programming/
*/

import (
	"fmt"
	"net"
	"os"
	// "os/signal"
	"syscall"
)

const socketPath = "/dev/log"

func main() {
	// Cleanup the sockfile if it exists
	if _, err := os.Stat(socketPath); err == nil {
		if err := os.Remove(socketPath); err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}
	}

	syscall.Umask(0o000)
	socket, err := net.Listen("unix", socketPath)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	// c := make(chan os.Signal, 1)
	// signal.Notify(c, os.Interrupt, syscall.SIGTERM)
	// go func() {
	// 	<-c
	// 	os.Remove(socketPath)
	// 	os.Exit(1)
	// }()

	for {
		_, err := socket.Accept()
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}
	}
}
