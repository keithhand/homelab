package vlan

import (
	"github.com/pulumi/pulumi/sdk/v3/go/pulumi"
	"github.com/pulumiverse/pulumi-unifi/sdk/go/unifi"

	"fmt"
	"homelab/pkg/yamlconfig"
)

type Vlan struct {
	yamlconfig.VlanYaml

	subnet    string
	dhcpStart string
	dhcpStop  string
}

func New(context *pulumi.Context, config yamlconfig.VlanYaml) *Vlan {
	var v Vlan
	v.init(config)
	v.createUnifiVlan(context)
	return &v
}

func (v *Vlan) init(config yamlconfig.VlanYaml) {
	v.VlanYaml = config
	if v.Purpose == "" {
		v.Purpose = "corporate"
	}
	v.subnet = fmt.Sprintf("10.0.%d.1/24", config.Vlan)
	v.dhcpStart = fmt.Sprintf("10.0.%d.6", config.Vlan)
	v.dhcpStop = fmt.Sprintf("10.0.%d.254", config.Vlan)
}

func (v *Vlan) createUnifiVlan(context *pulumi.Context) error {
	_, err := unifi.NewNetwork(context, v.Name, &unifi.NetworkArgs{
		Purpose:         pulumi.String(v.Purpose),
		Subnet:          pulumi.String(v.subnet),
		VlanId:          pulumi.IntPtr(v.Vlan),
		DhcpStart:       pulumi.String(v.dhcpStart),
		DhcpStop:        pulumi.String(v.dhcpStop),
		IgmpSnooping:    pulumi.Bool(v.Igmp),
		DhcpEnabled:     pulumi.Bool(true),
		DhcpV6Start:     pulumi.String("::2"),
		DhcpV6Stop:      pulumi.String("::7d1"),
		Ipv6PdInterface: pulumi.String("wan"),
		Ipv6PdStart:     pulumi.String("::2"),
		Ipv6PdStop:      pulumi.String("::7d1"),
		Ipv6RaEnable:    pulumi.Bool(true),
		Ipv6RaPriority:  pulumi.String("high"),
	})
	return err
}
