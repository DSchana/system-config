# system-config
Quick bring-up and sync between machines and environments

### Nix Darwin Example
```
First time — bootstrap nix-darwin:
  nix run nix-darwin -- switch --flake github:dschana system-config#anz-macbook`                                                                      
                  
After that, subsequent rebuilds:
  darwin-rebuild switch --flake github:dschana/system-config#anz-macbook
```

### Home Manager Example
`nix run home-manager -- switch --flake github:dschana/system-config#dschana-laptop`
