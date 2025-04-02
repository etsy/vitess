package main

import (
	"fmt"
	"io"
	"net"
	"net/http"
	"os"
	"os/exec"
	"strings"
	"time"
)


func main() {

	// TODO: clean this up
	if len(os.Args) < 3 {
		fmt.Fprintf(os.Stderr, "No arguments were specified!\n")
		os.Exit(1)
	}

	host, port, err := net.SplitHostPort(os.Args[1])
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to parse host:port!\n")
		os.Exit(1)
	}

	cell := os.Args[2]

	portClosed := true
	timeout := 60 * time.Second
	target := fmt.Sprintf("%s:%s", host, port)
	for start := time.Now(); time.Since(start) < timeout; {
		conn, err := net.DialTimeout("tcp", target, time.Second)
		if err == nil {
			conn.Close()
			portClosed = false
			break
		}
		time.Sleep(250 * time.Millisecond)
	}

	if portClosed {
		fmt.Fprintf(os.Stderr, "vttablet port=%s not listening!\n", port)
		os.Exit(1)
	}

	retries := 60
	for retries > 0 {

		resp, err := http.Get(fmt.Sprintf("http://%s:%s/debug/health", host, port))
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			retries -= 1
			time.Sleep(250 * time.Millisecond)
			continue
		}
		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			fmt.Fprintf(os.Stderr, "http response status code=%v\n", resp.StatusCode)
			retries -= 1
			time.Sleep(250 * time.Millisecond)
			continue
		}

		body, err := io.ReadAll(resp.Body)
		if err != nil {
			fmt.Fprintln(os.Stderr, err)
			retries -= 1
			time.Sleep(250 * time.Millisecond)
			continue
		}

		bodyString := string(body)
		if bodyString != "ok" {
			fmt.Fprintf(os.Stderr, "health check responded with %v\n", bodyString)
			retries -= 1
			time.Sleep(250 * time.Millisecond)
			continue
		}

		if bodyString == "ok" {

			vtctldclient_flags := []string{}
			for _, ele := range strings.Split(strings.TrimSpace(os.Getenv("VTCTLDCLIENT_FLAGS")), "\n") {
				vtctldclient_flags = append(vtctldclient_flags, strings.TrimSpace(ele))
			}

			args := append(vtctldclient_flags, "TabletExternallyReparented", cell)
			vtctldclient := exec.Command("/usr/local/bin/vtctldclient", args...)

			fmt.Println(vtctldclient)
			vtctldclient.Stdout = os.Stdout
			vtctldclient.Stderr = os.Stderr

			if err := vtctldclient.Run(); err != nil {
				fmt.Fprintln(os.Stderr, err)
				os.Exit(1)
			}

			os.Exit(0)

		}

	}

	fmt.Fprintf(os.Stderr, "health check retries exceeded!!!\n")
	os.Exit(1)

}
