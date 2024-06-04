package homelab

import (
	"github.com/spf13/cobra"

	"github.com/keithhand/homelab/pkg/cmd/cli/up"
)

func NewCommand() *cobra.Command {
	c := &cobra.Command{
		Use:   "homelab",
		Short: "app to manage my homelab",
		Long:  "An app to manage my homelab.",
	}

	c.AddCommand(up.NewCommand())

	return c
}
