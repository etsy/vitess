package main

import (
	"fmt"
	"os"
	"os/exec"
	"time"
)

func main() {
	syslog := exec.Command("/usr/local/bin/syslog")
	if err := syslog.Start(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	// wait for syslog to be listening before continuing
	filePath := "/dev/log"
	timeout := 5 * time.Second

	if err := waitForFile(filePath, timeout); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	program := os.Args[1]
	args := os.Args[2:]
	cmd := exec.Command(program, args...)

	fmt.Println(cmd)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}

func waitForFile(filePath string, timeout time.Duration) error {
	deadline := time.Now().Add(timeout)
	for {
		if _, err := os.Stat(filePath); err == nil {
			return nil // File exists
		} else if !os.IsNotExist(err) {
			return err // Some other error occurred
		}

		if time.Now().After(deadline) {
			return fmt.Errorf("timeout waiting for file %s", filePath)
		}

		time.Sleep(10 * time.Millisecond)
	}
}
