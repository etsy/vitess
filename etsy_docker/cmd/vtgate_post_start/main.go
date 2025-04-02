package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func main() {

	if len(os.Args) < 2 {
		fmt.Fprintf(os.Stderr, "No arguments were specified!\n")
		os.Exit(1)
	}

	vschema_path := os.Args[1]

	vtctldclient_flags := []string{}
	for _, ele := range strings.Split(strings.TrimSpace(os.Getenv("VTCTLDCLIENT_FLAGS")), "\n") {
		vtctldclient_flags = append(vtctldclient_flags, strings.TrimSpace(ele))
	}

	vschema_files, err := filepath.Glob(vschema_path + "/*_vschema.json")
	if err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}

	for _, vschema_file := range vschema_files {
		keyspace := strings.TrimSuffix(filepath.Base(vschema_file), "_vschema.json")
		args := append(vtctldclient_flags, "ApplyVSchema", "--vschema-file", vschema_file, keyspace)
		vtctldclient := exec.Command("/usr/local/bin/vtctldclient", args...)

		fmt.Println(vtctldclient)
		vtctldclient.Stdout = os.Stdout
		vtctldclient.Stderr = os.Stderr

		if err := vtctldclient.Run(); err != nil {
			fmt.Fprintln(os.Stderr, err)
			os.Exit(1)
		}
	}

	os.Exit(0)

}
