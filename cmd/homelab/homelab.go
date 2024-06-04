package main

import (
	"fmt"
	"os"

	"github.com/keithhand/homelab/pkg/cmd/homelab"
)

func main() {
	if err := homelab.NewCommand().Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "An error occurred: %v\n", err)
	}
}
