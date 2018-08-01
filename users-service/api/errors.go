package api

import "errors"

var (
	ErrInvalidArguments = errors.New("invalid arguments")
	ErrUserAlreadyExist = errors.New("user already exists")
)
