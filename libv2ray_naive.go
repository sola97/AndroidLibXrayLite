package libv2ray

import (
	_ "github.com/sagernet/cronet-go/all"
	"github.com/xtls/xray-core/proxy/naive"
)

// NotifyNetworkChanged closes pooled Naive connections so new requests use the
// active Android network. It does not stop or recreate the Xray core instance.
func (x *CoreController) NotifyNetworkChanged() {
	naive.CloseAllConnections()
}
