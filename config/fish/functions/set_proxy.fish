function set_proxy --description 'Set terminal proxy'
    set port 7890

    if test (count $argv) -gt 0
        set port $argv[1]
    end

    echo set terminal proxy.
    set -gx http_proxy "http://localhost:$port"
    set -gx https_proxy "http://localhost:$port"
    set -gx ALL_PROXY "socks5://localhost:$port"
end

function unset_proxy --description 'Unset terminal proxy'
    set -e http_proxy
    set -e https_proxy
    set -e ALL_PROXY
end