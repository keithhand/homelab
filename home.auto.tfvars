unifi = {
  network = {
    base_subnet = "10.0.X.1"
    networks = {
      home = {
        vlan_id = 39
        purpose = "corporate"
      }
      guest = {
        vlan_id = 69
        purpose = "guest"
      }
      iot = {
        purpose = "corporate"
        vlan_id = 10
      }
      sonos = {
        purpose       = "corporate"
        vlan_id       = 11
        igmp_snooping = true
      }
    }
  }
}
