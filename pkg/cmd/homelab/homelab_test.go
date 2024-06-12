package homelab_test

import (
	"testing"

	"homelab/pkg/cmd/builder"
	"homelab/pkg/cmd/homelab"
)

func TestMainCommand(t *testing.T) {
	cmd := homelab.MainCmd()
	name := "homelab"
	t.Run("Main cli command is correct", func(t *testing.T) {
		if cmd.Verb != name {
			t.Fail()
		}
	})
}

func TestUpCommand(t *testing.T) {
	cmd := homelab.UpCmd()
	name := "up"
	t.Run("up verb is correct", func(t *testing.T) {
		if cmd.Verb != name {
			t.Fail()
		}
	})
}

func TestDownCommand(t *testing.T) {
	cmd := homelab.DownCmd()
	name := "down"
	t.Run("Down verb is correct", func(t *testing.T) {
		if cmd.Verb != name {
			t.Fail()
		}
	})
}

func TestCmdService_GetCommands(t *testing.T) {
	svc := homelab.CmdService{
		Builder: builder.Cobra{},
	}
	cmds := svc.GetCommands()
	t.Run("2 total commands are returned", func(t *testing.T) {
		if len(cmds.(*builder.Cobra).Cmd.Commands()) != 2 {
			t.Fail()
		}
	})
}

func TestHomelabCli(t *testing.T) {
	t.Run("Run cli with no arguments", func(t *testing.T) {
		if err := homelab.HomelabCli(); err != nil {
			t.Fail()
		}
	})
}
