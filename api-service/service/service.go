package service

import (
	"fmt"
	"gophercon-tests/helpers"
	"gophercon-tests/users-service/api"
	"net/http"
	"encoding/json"
	"log"
)

type Config struct {
	ListenAddr string `env:"LISTEN_ADDR" envDefault:":80"`
	UserServiceUrl string `env:"USER_SERVICE_URL" envDefault:"http://users-service/rpc"`
}

type Service struct {
	Config Config
}

type CreateUserBody struct {
	Email string `json:"email"`
	Name string `json:"name"`
}

func (s *Service) CreateUserHandler(w http.ResponseWriter, r *http.Request) {
	log.Println("Creating a new user")
	decoder := json.NewDecoder(r.Body)
	var request CreateUserBody
	err := decoder.Decode(&request)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	rpcRequest := api.CreateUserRequest{
		UserData: api.UserData{
			Email:request.Email,
			Name: request.Name,
		},
	}

	var rpcResponse api.CreateUserResponse
	err = helpers.RpcCall(s.Config.UserServiceUrl, "Users.Create", rpcRequest, &rpcResponse)

	if err != nil {
		if err.Error() == api.ErrInvalidArguments.Error() {
			w.WriteHeader(http.StatusBadRequest)
		} else if err.Error() == api.ErrUserAlreadyExist.Error() {
			w.WriteHeader(http.StatusConflict)
		} else {
			w.WriteHeader(http.StatusInternalServerError)
		}
		return
	}

	w.WriteHeader(http.StatusCreated)
	fmt.Fprintf(w, "%d", rpcResponse.Id)
}

func (s *Service) GetAllUsersHandler(w http.ResponseWriter, r *http.Request) {
	log.Println("Requesting all users")
	var rpcResponse api.GetAllResponse
	err := helpers.RpcCall(s.Config.UserServiceUrl, "Users.GetAll", api.GetAllRequest{}, &rpcResponse)
	if err != nil {
		log.Printf("Error: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		return
	}

	log.Println("Success")
	b, err := json.Marshal(rpcResponse.Users)
	w.Write(b)
}

func (t *Service) ReadyHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "ok - api")
}
