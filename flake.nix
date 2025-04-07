{
  description = "Invoiceplane invoice template development shell";

  inputs.nixpkgs.url = "nixpkgs/master";

  outputs = { self, nixpkgs, ... }@inputs:
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    start =
      pkgs.writeShellScriptBin "start" ''
        set -e
	export NIXPKGS_ALLOW_INSECURE=1
        export QEMU_NET_OPTS="hostfwd=tcp::8080-:80"
        ${pkgs.nixos-shell}/bin/nixos-shell --flake .
       '';
  in {
    nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs.inputs = inputs;
      pkgs = import nixpkgs {
	overlays = [
          (self: super: {
            froide-govplan = super.froide-govplan.overrideAttrs (oldAttrs: rec {
              postInstall = oldAttrs.postInstall + ''
                rm -r $out/${pkgs.python3.sitePackages}/froide_govplan/templates
                ln -sf /var/lib/froide-govplan/templates $out/${pkgs.python3.sitePackages}/froide_govplan/templates
              '';
            });
          })
        ];
      };
      modules = [
        ({ lib, config, pkgs, ... }: {

          virtualisation = {
            memorySize = 8000;
            diskSize = 4096;
            cores = 4;
          };

	  services.froide-govplan = {
	    enable = true;
	    settings = { 
	      DEBUG = lib.mkForce true;
	      CSRF_TRUSTED_ORIGINS = [ "http://localhost:8080" ];
	    };
	  };

          nixos-shell.mounts.extraMounts = {
            "/var/lib/froide-govplan/templates" = {
               target = /home/onny/projects/froide-govplan/froide_govplan/templates;
               cache = "none";
            };
          };

          system.stateVersion = "25.05";
          services.getty.autologinUser = "root";
        })
      ];
    };

    packages = { inherit start; };
    defaultPackage.x86_64-linux = start;

  };
}

