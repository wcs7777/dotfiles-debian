{pkgs, ...}: {
    home.username = "wcs";
    home.homeDirectory = "/home/wcs";
    home.stateVersion = "24.11"; # Comment out for error with "latest" version
    programs.home-manager.enable = true;
    home.packages = [
        pkgs.bat
        pkgs.cargo
        pkgs.delta
        pkgs.eza
        pkgs.fd
        pkgs.fzf
        pkgs.go
        pkgs.lua51Packages.lua
        pkgs.luajitPackages.luarocks_bootstrap
        pkgs.nodejs
        pkgs.ripgrep
        pkgs.ruby
        pkgs.sqlite
        pkgs.trash-cli
        pkgs.tree-sitter
    ];
}
