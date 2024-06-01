import * as pulumi from "@pulumi/pulumi";
import * as unifi from './components/unifi';

var config = new pulumi.Config();

const unifiConfig = config.getObject<unifi.UnifiConfig>("unifi");
if (unifiConfig) {
  unifi.configure(unifiConfig)
}
