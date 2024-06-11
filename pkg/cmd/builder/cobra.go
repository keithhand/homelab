package builder

import "github.com/spf13/cobra"

type CobraCommandBuilder struct{}

func (b *CobraCommandBuilder) newCobraCommand(c Command) CommandBlock {
	return &cobra.Command{
		Use:   c.Verb,
		Long:  c.LongDesc,
		Short: c.ShortDesc,
	}
}

func (b *CobraCommandBuilder) MainCmd() CommandBlock {
	return b.newCobraCommand(baseMainCmd())
}

func (b *CobraCommandBuilder) UpCmd() CommandBlock {
	return b.newCobraCommand(baseUpCmd())
}

func (b *CobraCommandBuilder) DownCmd() CommandBlock {
	return b.newCobraCommand(baseDownCmd())
}

func (b *CobraCommandBuilder) Build(main CommandBlock, verbs ...CommandBlock) CommandBlock {
	for _, cmd := range verbs {
		main.(*cobra.Command).AddCommand(cmd.(*cobra.Command))
	}
	return main
}
