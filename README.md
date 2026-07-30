# AndroidLibXrayLite

## Build requirements
* JDK 17 or newer
* Android SDK and NDK 29.0.14206865
* Go 1.26
* gomobile matching the `golang.org/x/mobile` version in `go.mod`

## Build instructions
1. `git clone [repo] && cd AndroidLibXrayLite`
2. `gomobile init`
3. `go mod tidy -v`
4. `gomobile bind -v -androidapi 24 -trimpath -ldflags='-s -w -buildid= -checklinkname=0' ./`

The native Naive outbound imports the four Android Cronet platform modules
behind architecture build tags. gomobile therefore links only the matching
Android static library instead of resolving the non-Android libraries included
by `cronet-go/all`; building Chromium is not required.

Call `CoreController.NotifyNetworkChanged()` after Android changes its active
network. The method closes pooled Naive connections without restarting Xray,
so subsequent requests are established through the new network.
