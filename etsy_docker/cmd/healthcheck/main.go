package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
)

func main() {
	/* https://vitess.io/docs/21.0/user-guides/configuration-basic/monitoring/#debughealth-1
	/debug/health #
	This URL prints out a simple "ok" or “not ok” string that can be used to check if the server is healthy.
	*/

	// curl http://127.0.0.1:18085/debug/health
	// ok

	// curl http://127.0.0.1:15306/debug/health
	// ok

	var port, health_endpoint string
	switch len(os.Args) {
	case 1:
		fmt.Fprintf(os.Stderr, "No arguments were specified!\n")
		os.Exit(1)
	case 2:
		port = os.Args[1]
		health_endpoint = "/debug/health" // use this as the default health endpoint unless otherwise specified
	case 3:
		port = os.Args[1]
		// just to be aggravating vtadmin is different and uses /health, so accommodate that here
		health_endpoint = os.Args[2]
	}

	resp, err := http.Get(fmt.Sprintf("http://127.0.0.1:%s%s", port, health_endpoint))
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		fmt.Fprintf(os.Stderr, "http response status code=%v\n", resp.StatusCode)
		os.Exit(1)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	bodyString := strings.TrimSpace(string(body))
	if bodyString != "ok" {
		fmt.Fprintf(os.Stderr, "health check responded with %v\n", bodyString)
		os.Exit(1)
	}

	os.Exit(0)

}
