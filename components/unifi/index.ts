import * as network from './network';

export interface UnifiConfig {
  networks?: network.Networks;
}

export function configure(config: UnifiConfig) {
  config.networks?.forEach(n => {
    network.configure(n)
  })
}
