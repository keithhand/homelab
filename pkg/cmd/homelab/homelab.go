package homelab

import "homelab/pkg/cmd/builder"

func MainCmd() builder.Command {
	return builder.Command{
		Verb:      "homelab",
		ShortDesc: "app to manage my homelab",
		LongDesc:  "An app to manage my homelab.",
	}
}

func UpCmd() builder.Command {
	return builder.Command{
		Verb:      "up",
		ShortDesc: "create or update homelab",
		LongDesc:  "Create or update homelab.",
	}
}

func DownCmd() builder.Command {
	return builder.Command{
		Verb:      "down",
		ShortDesc: "destroy homelab",
		LongDesc:  "Destroy homelab.",
	}
}

func HomelabCli() error {
	bldr := builder.GetBuilder()

	main := bldr.NewCmd(MainCmd())
	up := bldr.NewCmd(UpCmd())
	down := bldr.NewCmd(DownCmd())

	main.Attach(up, down)

	return main.Execute()
}
