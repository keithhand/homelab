package builder

import "github.com/spf13/cobra"

type Cobra struct {
	Cmd *cobra.Command
}

type runCmd func(Builder, []string)

func (c Cobra) withRun(fn runCmd) func(*cobra.Command, []string) {
	if fn == nil {
		return nil
	}
	return func(cmd *cobra.Command, args []string) {
		fn(c, args)
	}
}

func (c Cobra) NewCmd(cfg Command) Builder {
	return &Cobra{
		Cmd: &cobra.Command{
			Use:   cfg.Verb,
			Short: cfg.ShortDesc,
			Long:  cfg.LongDesc,
			Run:   c.withRun(cfg.Run),
		},
	}
}

func (c Cobra) Attach(verbs ...Builder) {
	for _, v := range verbs {
		c.Cmd.AddCommand(v.(*Cobra).Cmd)
	}
}

func (c Cobra) Execute() error {
	return c.Cmd.Execute()
}
