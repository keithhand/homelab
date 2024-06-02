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

	subnet    string
	dhcpStart string
	dhcpStop  string
}

type PulumiNetworkConfig struct {
	Active bool
	Vlans  []VlanConfig
}

func setVlanConfigDefaults(cfg *VlanConfig) {
	if cfg.Purpose == "" {
		cfg.Purpose = "corporate"
	}
	cfg.subnet = fmt.Sprintf("10.0.%d.1/24", cfg.Id)
	cfg.dhcpStart = fmt.Sprintf("10.0.%d.6", cfg.Id)
	cfg.dhcpStop = fmt.Sprintf("10.0.%d.254", cfg.Id)
}

func main() {
	pulumi.Run(func(ctx *pulumi.Context) error {
		cfg := config.New(ctx, "homelab")
		var networkConfig PulumiNetworkConfig
		cfg.RequireObject("network", &networkConfig)
		for _, vCfg := range networkConfig.Vlans {
			setVlanConfigDefaults(&vCfg)
			unifi.NewNetwork(ctx, vCfg.Name, &unifi.NetworkArgs{
				Purpose:         pulumi.String(vCfg.Purpose),
				Subnet:          pulumi.String(vCfg.subnet),
				VlanId:          pulumi.IntPtr(vCfg.Id),
				DhcpStart:       pulumi.String(vCfg.dhcpStart),
				DhcpStop:        pulumi.String(vCfg.dhcpStop),
				IgmpSnooping:    pulumi.Bool(vCfg.Igmp),
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
