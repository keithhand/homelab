package homelab

import (
	"homelab/pkg/cmd/builder"
)

func StartCli() error {
	var cmd builder.CommandBuilder = &builder.CobraCommandBuilder{}

	main := cmd.MainCmd()
	up := cmd.UpCmd()
	down := cmd.DownCmd()

	return cmd.Build(main, up, down).Execute()
}
