use alias

use platform
if !=s platform:hostname "study" {
  use proxy
  proxy:__set_proxy
}
