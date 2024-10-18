use platform

if (==s (platform:hostname) "study") { 
  set paths =  (conj $paths $E:HOME/os/qemu/build $E:HOME/os/qemu/build/riscv64-softmmu $E:HOME/os/qemu/build/riscv64-linux-user)
}
