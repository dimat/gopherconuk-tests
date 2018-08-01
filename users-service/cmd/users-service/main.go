// server.go
package main

import (
	"github.com/gorilla/rpc"
	"github.com/gorilla/rpc/json"

	"gophercon-tests/users-service/api"
	"net/http"
	"github.com/gorilla/mux"
	"fmt"
	"log"
	"github.com/caarlos0/env"
)

type Config struct {
	ListenAddr string `env:"LISTEN_ADDR" envDefault:":80"`
}

type Users struct{
	Config Config
	storage map[string]api.RegisteredUser
	id int
}

func (t *Users) Create(r *http.Request, args *api.CreateUserRequest, reply *api.CreateUserResponse) error {
	log.Println("Creating a new user")
	if len(args.Email) == 0 {
		log.Println("Invalid arguments")
		return api.ErrInvalidArguments
	}

	if _, ok := t.storage[args.Email]; ok {
		log.Println("User already exists")
		return api.ErrUserAlreadyExist
	}

	// concurrency is not handled for the sake of simplicity of the demo
	newId := t.id + 1
	registeredUser := api.RegisteredUser{Id: newId, UserData: args.UserData}

	if t.storage == nil {
		t.storage = make(map[string]api.RegisteredUser)
	}

	t.storage[args.Email] = registeredUser

	t.id = newId

	*reply = api.CreateUserResponse{Id: newId}
	return nil
}

func (t *Users) GetAll(r *http.Request, args *api.GetAllRequest, reply *api.GetAllResponse) error {
	log.Println("Requesting all users")
	result := make([]api.RegisteredUser, 0, len(t.storage))

	for _, user := range t.storage {
		result = append(result, user)
	}

	*reply = api.GetAllResponse{Users: result}
	return nil
}

func (t *Users) ReadyHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "ok - users")
}

func main() {
	users := new(Users)
	if err := env.Parse(&users.Config); err != nil {
		log.Fatal("Failed to parse the configuration")
	}

	r := mux.NewRouter()

	// mux rpc
	muxServer := rpc.NewServer()
	muxServer.RegisterCodec(json.NewCodec(), "application/json")

	muxServer.RegisterService(users, "")
	r.Handle("/rpc", muxServer)
	r.HandleFunc("/ready", users.ReadyHandler)

	log.Printf("Listening on %s", users.Config.ListenAddr)
	http.ListenAndServe(users.Config.ListenAddr, r)
}