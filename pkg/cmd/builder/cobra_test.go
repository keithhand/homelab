package builder_test

import (
	"testing"

	"homelab/pkg/cmd/builder"
)

var (
	testBuilder  = &builder.Cobra{}
	validTestCmd = builder.Command{
		Verb:      "test",
		ShortDesc: "this is a valid description",
		LongDesc:  "This is a valid description.",
	}
)

func TestCobra_NewCmd(t *testing.T) {
	t.Run("New Command defaults to empty run", func(t *testing.T) {
		got := testBuilder.NewCmd(validTestCmd)
		if got.(*builder.Cobra).Cmd.Run != nil {
			t.Fail()
		}
	})

	t.Run("New Command sets and executes run if attached", func(t *testing.T) {
		cmd := validTestCmd
		cmd.Run = func(b builder.Builder, s []string) {}
		testBuilder.NewCmd(cmd).Execute()
	})
}

func TestCobra_Attach(t *testing.T) {
	t.Run("1 command is aggregated to builder", func(t *testing.T) {
		main := testBuilder.NewCmd(validTestCmd)
		one := testBuilder.NewCmd(validTestCmd)

		main.Attach(one)
		allCmds := main.(*builder.Cobra).Cmd.Commands()
		got := len(allCmds)

		if got != 1 {
			t.Fail()
		}
	})

	t.Run("3 commands are aggregated to builder", func(t *testing.T) {
		main := testBuilder.NewCmd(validTestCmd)
		one := testBuilder.NewCmd(validTestCmd)
		two := testBuilder.NewCmd(validTestCmd)
		three := testBuilder.NewCmd(validTestCmd)

		main.Attach(one, two, three)
		allCmds := main.(*builder.Cobra).Cmd.Commands()
		got := len(allCmds)

		if got != 3 {
			t.Fail()
		}
	})
}

func TestCobra_Exec(t *testing.T) {
	t.Run("Valid command is executed", func(t *testing.T) {
		cmd := testBuilder.NewCmd(validTestCmd)
		if err := cmd.Execute(); err != nil {
			t.Fail()
		}
	})
}
