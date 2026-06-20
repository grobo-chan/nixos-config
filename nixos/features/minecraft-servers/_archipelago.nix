{pkgs, ...}: {
  enable = true;
  package = pkgs.neoforgeServers.neoforge-1_21_11;

  serverProperties = {
    difficulty=2;
    enforce-secure-profile=false; # I HATE CHAT REPORT I HATE CHAT REPORT FUCK THAT SHIT
  };

  symlinks = {
    mods = pkgs.linkFarmFromDrvs "mods" (
      builtins.attrValues {
        AP-Randomizer = pkgs.fetchurl {
          url = "https://github.com/qixils/NeoForgeAP/releases/download/v2.1.3/aprandomizer-2.1.3+1.21.11.jar";
          sha256 = "sha256-mzmTBsyVgh+6/jjR/CUCKj0nZVCENMQNJzYsL8eh824=";
        };
      }
    );
  };
}
