package homelab

import "homelab/pkg/cmd/builder"

var (
	MainCmd = builder.Command{
		Verb:      "homelab",
		ShortDesc: "app to manage my homelab",
		LongDesc:  "An app to manage my homelab.",
	}

	UpCmd = builder.Command{
		Verb:      "up",
		ShortDesc: "create or update homelab",
		LongDesc:  "Create or update homelab.",
	}

	DownCmd = builder.Command{
		Verb:      "down",
		ShortDesc: "destroy homelab",
		LongDesc:  "Destroy homelab.",
	}
)
