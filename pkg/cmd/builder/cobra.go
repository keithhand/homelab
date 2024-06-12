package builder

import "github.com/spf13/cobra"

type Cobra struct {
	*cobra.Command
}

func (c *Cobra) NewCmd(cfg Command) Builder {
	return &Cobra{
		&cobra.Command{
			Use:   cfg.Verb,
			Short: cfg.ShortDesc,
			Long:  cfg.LongDesc,
		},
	}
}

func (c *Cobra) Attach(verbs ...Builder) {
	for _, v := range verbs {
		c.AddCommand(v.(*Cobra).Command)
	}
}
