fn __set_proxy {
  echo set terminal proxy.
  set-env http_proxy  http://localhost:7890
  set-env https_proxy http://localhost:7890
  set-env ALL_PROXY   socks5://localhost:7890
}

fn unset_proxy {
  unset-env http_proxy
  unset-env https_proxy
  unset-env ALL_PROXY
}
