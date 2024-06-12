package builder

import "github.com/spf13/cobra"

type Cobra struct {
	*cobra.Command
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
		&cobra.Command{
			Use:   cfg.Verb,
			Short: cfg.ShortDesc,
			Long:  cfg.LongDesc,
			Run:   c.withRun(cfg.Run),
		},
	}
}

func (c *Cobra) withRun(fn func(Runner, []string)) func(*cobra.Command, []string) {
	if fn != nil {
		return func(cmd *cobra.Command, args []string) {
			fn(cmd, args)
		}
	}
	return nil
}

func (c *Cobra) Attach(verbs ...Builder) {
	for _, v := range verbs {
		c.AddCommand(v.(*Cobra).Command)
	}
}
