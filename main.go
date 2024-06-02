package main

import (
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	pulumiconfig "github.com/pulumi/pulumi/sdk/v3/go/pulumi/config"

	"homelab/pkg/network"
	"homelab/pkg/yamlconfig"
)

func main() {
	pulumi.Run(func(context *pulumi.Context) error {
		stackConfig := pulumiconfig.New(context, yamlconfig.CONFIG_NAMESPACE)
		network.New(context, stackConfig)
		return nil
	})
}
