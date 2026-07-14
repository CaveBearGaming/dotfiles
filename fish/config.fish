if status is-interactive
    # Commands to run in interactive sessions can go here
end
starship init fish | source
test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish; and source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
fish_add_path ~/.nix-profile/bin
