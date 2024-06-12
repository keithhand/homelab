package main

import (
	"fmt"
	"os"

	"homelab/pkg/cmd/homelab"
)

func main() {
	if err := homelab.HomelabCli(); err != nil {
		fmt.Fprintf(os.Stderr, "An error occurred: %v\n", err)
	}
}
