import * as pulumi from "@pulumi/pulumi";
import * as unifi from "@pulumiverse/unifi";

var config = new pulumi.Config();

interface UnifiNetworkConfig extends Array<UnifiNetwork> { }
interface UnifiNetwork {
  name: string;
  purpose: string;
  vlan: number;
  igmp: boolean;
}
const networks = config.getObject<UnifiNetworkConfig>("networks") || [];
for (var n of networks) {
  new unifi.Network(n.name, {
    igmpSnooping: n.igmp || false,
    purpose: n.purpose || "corporate",
    subnet: `10.0.${n.vlan}.1/24`,
    vlanId: n.vlan,
    dhcpStart: `10.0.${n.vlan}.6`,
    dhcpStop: `10.0.${n.vlan}.254`,
    dhcpEnabled: true,
    dhcpV6Start: "::2",
    dhcpV6Stop: "::7d1",
    ipv6PdInterface: "wan",
    ipv6PdStart: "::2",
    ipv6PdStop: "::7d1",
    ipv6RaEnable: true,
    ipv6RaPriority: "high",
  });
}
