package network

import (
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	pulumiconfig "github.com/pulumi/pulumi/sdk/v3/go/pulumi/config"

	"homelab/pkg/network/vlan"
	"homelab/pkg/yamlconfig"
)

type Network struct {
	yamlconfig.NetworkYaml
	Vlans []vlan.Vlan
}

// Bootstraps network resources
func New(context *pulumi.Context, config *pulumiconfig.Config) *Network {
	networkConfig := getNetworkConfig(config)
	createNetworks(context, networkConfig.Vlans)
	return &networkConfig
}

// Loops through and creates all networks in config
func createNetworks(context *pulumi.Context, networks []vlan.Vlan) {
	for _, config := range networks {
		vlan.New(context, vlan.SetupConfig(&config))
	}
}

// Reads configuration from the Pulumi API
func getNetworkConfig(config *pulumiconfig.Config) Network {
	var networkConfig Network
	config.RequireObject(yamlconfig.CONFIG_NETWORK_KEY, &networkConfig)
	return networkConfig
}
