package builder

type Command struct {
	Verb      string
	ShortDesc string
	LongDesc  string
	Run       func(Builder, []string)
}

type Builder interface {
	NewCmd(Command) Builder
	Attach(...Builder)
	Execute() error
}

func GetBuilder() Builder {
	return &Cobra{}
}
