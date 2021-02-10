package main

import (
	"github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm"
	"github.com/tetratelabs/proxy-wasm-go-sdk/proxywasm/types"
)

type httpBody struct {
	// you must embed the default context so that you need not to reimplement all the methods by yourself
	proxywasm.DefaultHttpContext
	contextID uint32
}

func main() {
	proxywasm.SetNewHttpContext(newContext)
}

func newContext(rootContextID, contextID uint32) proxywasm.HttpContext {
	return &httpBody{contextID: contextID}
}

func (ctx *httpBody) OnHttpRequestHeaders(numHeaders int, _ bool) types.Action {
	if numHeaders > 0 {
		headers, err := proxywasm.GetHttpRequestHeaders()
		if err != nil {
			proxywasm.LogErrorf("WASM: failed to get request headers with '%v'", err)
			return types.ActionContinue
		}
		proxywasm.LogInfof("WASM: request headers: '%+v'", headers)
	}

	return types.ActionContinue
}

// override
func (ctx *httpBody) OnHttpRequestBody(bodySize int, endOfStream bool) types.Action {
	proxywasm.LogInfof("WASM: body size: %d", bodySize)
	if bodySize != 0 {
		initialBody, err := proxywasm.GetHttpRequestBody(0, bodySize)
		if err != nil {
			proxywasm.LogErrorf("WASM: failed to get request body: %v", err)
			return types.ActionContinue
		}
		proxywasm.LogInfof("WASM: initial request body: %s", string(initialBody))

		b := []byte(`{ "another": "body" }`)

		err = proxywasm.SetHttpRequestBody(b)
		if err != nil {
			proxywasm.LogErrorf("WASM: failed to set request body: %v", err)
			return types.ActionContinue
		}

		proxywasm.LogInfof("WASM: on http request body finished")
	}

	return types.ActionContinue
}
