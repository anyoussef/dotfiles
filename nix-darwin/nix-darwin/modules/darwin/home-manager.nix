# Wires Home Manager into the system; the actual user config lives in ../home
{ inputs, username, ... }: {
  imports = [ inputs.home-manager.darwinModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${username} = {
      imports = [ ../home ];
      home.username = username;
      home.homeDirectory = "/Users/${username}";
    };
  };
}
