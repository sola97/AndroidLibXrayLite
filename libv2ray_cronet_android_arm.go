//go:build android && arm

package libv2ray

import (
	_ "github.com/sagernet/cronet-go"
	_ "github.com/sagernet/cronet-go/lib/android_arm"
)
