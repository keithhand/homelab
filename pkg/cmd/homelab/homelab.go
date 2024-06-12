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

type CmdService struct {
	Builder builder.Builder
}

func (svc *CmdService) GetCommands() builder.Builder {
	main := svc.Builder.NewCmd(MainCmd())
	up := svc.Builder.NewCmd(UpCmd())
	down := svc.Builder.NewCmd(DownCmd())
	main.Attach(up, down)
	return main
}

func HomelabCli() error {
	svc := CmdService{
		Builder: builder.Cobra{},
	}
	cmds := svc.GetCommands()
	return cmds.Execute()
}
