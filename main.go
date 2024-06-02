package main

import (
	"fmt"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi/config"
	"github.com/pulumiverse/pulumi-unifi/sdk/go/unifi"
)

type VlanConfig struct {
	Id      int `json:"vlan"`
	Name    string
	Igmp    bool
	Purpose string
}

type PulumiNetworkConfig struct {
	Active bool
	Vlans  []VlanConfig
}

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		cfg := config.New(ctx, "homelab")
		var networkConfig PulumiNetworkConfig
		cfg.RequireObject("network", &networkConfig)
		for _, vlanConfig := range networkConfig.Vlans {
			if vlanConfig.Purpose == "" {
				vlanConfig.Purpose = "corporate"
			}
			unifi.NewNetwork(ctx, vlanConfig.Name, &unifi.NetworkArgs{
				Purpose:         pulumi.String(vlanConfig.Purpose),
				Subnet:          pulumi.String(fmt.Sprintf("10.0.%d.1/24", vlanConfig.Id)),
				VlanId:          pulumi.IntPtr(vlanConfig.Id),
				DhcpStart:       pulumi.String(fmt.Sprintf("10.0.%d.6", vlanConfig.Id)),
				DhcpStop:        pulumi.String(fmt.Sprintf("10.0.%d.254", vlanConfig.Id)),
				IgmpSnooping:    pulumi.Bool(vlanConfig.Igmp),
				DhcpEnabled:     pulumi.Bool(true),
				DhcpV6Start:     pulumi.String("::2"),
				DhcpV6Stop:      pulumi.String("::7d1"),
				Ipv6PdInterface: pulumi.String("wan"),
				Ipv6PdStart:     pulumi.String("::2"),
				Ipv6PdStop:      pulumi.String("::7d1"),
				Ipv6RaEnable:    pulumi.Bool(true),
				Ipv6RaPriority:  pulumi.String("high"),
			})
		}
		return nil
	})
}
