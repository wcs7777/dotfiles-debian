{
  home.username = "wcs";
  home.homeDirectory = "/home/wcs";
  home.stateVersion = "25.05"; # Please read the comment before changing.
  home.packages = [
    pkgs.bat
    pkgs.cargo
    pkgs.delta
    pkgs.eza
    pkgs.fd
    pkgs.fzf
    pkgs.ripgrep
    pkgs.ruby
    pkgs.sqlite
    pkgs.trash-cli
    pkgs.tree-sitter
  ];
  home.file = {
  };
  home.sessionVariables = {
  };
  programs.home-manager.enable = true;
}
