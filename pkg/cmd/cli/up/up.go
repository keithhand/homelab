package up

import (
	"fmt"

	"github.com/spf13/cobra"
)

func NewCommand() *cobra.Command {
	c := &cobra.Command{
		Use:   "up",
		Short: "Create or update homelab",
		Long:  "Create or update homelab.",
		Run:   Run,
	}

	c.Flags().BoolP("refresh", "r", true, "refreshes the stack before updating")

	return c
}

func Run(cmd *cobra.Command, args []string) {
	if refresh, _ := cmd.Flags().GetBool("refresh"); refresh {
		fmt.Println("refreshing")
	}
	fmt.Println("hello")
}
