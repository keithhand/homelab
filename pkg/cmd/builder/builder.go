package builder

var DefaultBuilder = Cobra{}

type Command struct {
	Verb      string
	ShortDesc string
	LongDesc  string
}

type Builder interface {
	NewCmd(Command) Builder
	Attach(...Builder)
	Execute() error
}

func GetDefaultBuilder() Builder {
	return &DefaultBuilder
}
