package yamlconfig

// Interfaces for interacting with Pulumi.yaml config

const CONFIG_NAMESPACE = "homelab"
const CONFIG_NETWORK_KEY = "network"

type NetworkYaml struct {
	VlanYamls []VlanYaml
}

type VlanYaml struct {
	Vlan    int
	Name    string
	Igmp    bool
	Purpose string
}
