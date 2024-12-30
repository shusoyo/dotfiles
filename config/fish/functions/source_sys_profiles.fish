function source_sys_profiles --description 'source system profiles in /etc/*profile'
    if not [ -e /run/current-system/sw/bin/fish ]
        exec dash -c "
          [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ] && \
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'; \

          [ -e '/etc/profile' ] && \
          . '/etc/profile'; \

          exec fish 
        "
    end
end
