package builder

type Command struct {
	Verb      string
	ShortDesc string
	LongDesc  string
}

type CommandBuilder interface {
	MainCmd() CommandBlock
	UpCmd() CommandBlock
	DownCmd() CommandBlock

	Build(CommandBlock, ...CommandBlock) CommandBlock
}

type CommandBlock interface {
	Execute() error
}

func baseMainCmd() Command {
	return Command{
		Verb:      "homelab",
		ShortDesc: "app to manage my homelab",
		LongDesc:  "An app to manage my homelab.",
	}
}

func baseUpCmd() Command {
	return Command{
		Verb:      "up",
		ShortDesc: "create or update homelab",
		LongDesc:  "Create or update homelab.",
	}
}

func baseDownCmd() Command {
	return Command{
		Verb:      "down",
		ShortDesc: "destroy homelab",
		LongDesc:  "Destroy homelab.",
	}
}
