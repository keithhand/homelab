package vlan

import (
	"fmt"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	"github.com/pulumiverse/pulumi-unifi/sdk/go/unifi"

	"homelab/pkg/yamlconfig"
)

type Vlan struct {
	yamlconfig.VlanYaml
	subnet    string
	dhcpStart string
	dhcpStop  string
}

// Creates a Unifi VLAN network
func New(context *pulumi.Context, networkConfig *Vlan) *unifi.Network {
	network, err := unifi.NewNetwork(context, networkConfig.Name, &unifi.NetworkArgs{
		Purpose:         pulumi.String(networkConfig.Purpose),
		Subnet:          pulumi.String(networkConfig.subnet),
		VlanId:          pulumi.IntPtr(networkConfig.Vlan),
		DhcpStart:       pulumi.String(networkConfig.dhcpStart),
		DhcpStop:        pulumi.String(networkConfig.dhcpStop),
		IgmpSnooping:    pulumi.Bool(networkConfig.Igmp),
		DhcpEnabled:     pulumi.Bool(true),
		DhcpV6Start:     pulumi.String("::2"),
		DhcpV6Stop:      pulumi.String("::7d1"),
		Ipv6PdInterface: pulumi.String("wan"),
		Ipv6PdStart:     pulumi.String("::2"),
		Ipv6PdStop:      pulumi.String("::7d1"),
		Ipv6RaEnable:    pulumi.Bool(true),
		Ipv6RaPriority:  pulumi.String("high"),
	})
	if err != nil {
		pulumi.Printf("error creating networks: %v\n", err)
		return nil
	}
	return network
}

// Sets up defaults and adds generated values to config
func SetupConfig(config *Vlan) *Vlan {
	if config.Purpose == "" {
		config.Purpose = "corporate"
	}
	config.subnet = fmt.Sprintf("10.0.%d.1/24", config.Vlan)
	config.dhcpStart = fmt.Sprintf("10.0.%d.6", config.Vlan)
	config.dhcpStop = fmt.Sprintf("10.0.%d.254", config.Vlan)
	return config
}
