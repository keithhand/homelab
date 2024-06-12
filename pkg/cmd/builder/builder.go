package builder

var DefaultBuilder = Cobra{}

type Command struct {
	Verb      string
	ShortDesc string
	LongDesc  string
	Run       func(Runner, []string)
}

type Runner interface {
	Execute() error
}

type Builder interface {
	NewCmd(Command) Builder
	Attach(...Builder)
	Runner
}

func GetDefaultBuilder() Builder {
	return &DefaultBuilder
}
