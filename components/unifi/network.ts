import { Network } from "@pulumiverse/unifi";

interface NetworkConfig {
  name: string;
  purpose: string;
  vlan: number;
  igmp: boolean;
}
export interface Networks extends Array<NetworkConfig> { }

export function configure(network: NetworkConfig) {
  return new Network(network.name, {
    igmpSnooping: network.igmp || false,
    purpose: network.purpose || "corporate",
    subnet: `10.0.${network.vlan}.1/24`,
    vlanId: network.vlan,
    dhcpStart: `10.0.${network.vlan}.6`,
    dhcpStop: `10.0.${network.vlan}.254`,
    dhcpEnabled: true,
    dhcpV6Start: "::2",
    dhcpV6Stop: "::7d1",
    ipv6PdInterface: "wan",
    ipv6PdStart: "::2",
    ipv6PdStop: "::7d1",
    ipv6RaEnable: true,
    ipv6RaPriority: "high",
  }, { protect: true });
}
