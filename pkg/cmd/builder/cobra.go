package builder

import "github.com/spf13/cobra"

type Cobra struct {
	cmd *cobra.Command
}

func (c Cobra) withRun(fn func(Builder, []string)) func(*cobra.Command, []string) {
	if fn == nil {
		return nil
	}
	return func(cmd *cobra.Command, args []string) {
		fn(c, args)
	}
}

func (c Cobra) NewCmd(cfg Command) Builder {
	return &Cobra{
		cmd: &cobra.Command{
			Use:   cfg.Verb,
			Short: cfg.ShortDesc,
			Long:  cfg.LongDesc,
			Run:   c.withRun(cfg.Run),
		},
	}
}

func (c Cobra) Attach(verbs ...Builder) {
	for _, v := range verbs {
		c.cmd.AddCommand(v.(*Cobra).cmd)
	}
}

func (c Cobra) Execute() error {
	return c.cmd.Execute()
}
