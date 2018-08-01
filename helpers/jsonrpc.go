package helpers

import (
	"net/http"
	"bytes"

	"github.com/gorilla/rpc/json"
	"github.com/pkg/errors"
)

func RpcCall(url, method string, request, reply interface{}) error {
	params, err := json.EncodeClientRequest(method, request)
	if err != nil {
		return errors.Wrap(err, "failed to encode requests")
	}
	response, err := http.Post(url, "application/json", bytes.NewReader(params))
	if err != nil {
		return errors.Wrap(err, "failed to post")
	}
	defer response.Body.Close()
	err = json.DecodeClientResponse(response.Body, reply)
	if err != nil {
		return err
	}
	return nil
}
