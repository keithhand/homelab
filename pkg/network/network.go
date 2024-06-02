package network

import (
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	pulumiconfig "github.com/pulumi/pulumi/sdk/v3/go/pulumi/config"

	"homelab/pkg/network/vlan"
	"homelab/pkg/yamlconfig"
)

type Network struct {
	yamlconfig.NetworkYaml
}

func New(context *pulumi.Context, config *pulumiconfig.Config) *Network {
	var n Network
	n.init(config)
	n.createVlans(context)
	return &n
}

func (n *Network) init(config *pulumiconfig.Config) {
	config.RequireObject(yamlconfig.CONFIG_NETWORK_KEY, &n.NetworkYaml)
}

func (n *Network) createVlans(context *pulumi.Context) {
	for _, config := range n.NetworkYaml.Vlans {
		vlan.New(context, config)
	}
}
