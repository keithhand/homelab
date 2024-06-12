package main

import (
	"fmt"
	"os"

	"homelab/pkg/cmd/builder"
	"homelab/pkg/cmd/homelab"
)

func main() {
	cmdBuilder := builder.GetDefaultBuilder()

	main := cmdBuilder.NewCmd(homelab.MainCmd)
	up := cmdBuilder.NewCmd(homelab.UpCmd)
	down := cmdBuilder.NewCmd(homelab.DownCmd)

	main.Attach(up, down)

	if err := main.Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "An error occurred: %v\n", err)
	}
}
