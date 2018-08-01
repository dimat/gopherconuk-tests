package main

import (
	"gophercon-tests/api-service/service"

	"log"
	"net/http"

	"github.com/caarlos0/env"
	"github.com/gorilla/mux"
)

func main() {
	service := service.Service{}

	if err := env.Parse(&service.Config); err != nil {
		log.Fatal("Failed to parse the configuration")
	}

	r := mux.NewRouter()

	r.HandleFunc("/users", service.CreateUserHandler).Methods(http.MethodPost)
	r.HandleFunc("/users", service.GetAllUsersHandler).Methods(http.MethodGet)
	r.HandleFunc("/ready", service.ReadyHandler).Methods(http.MethodGet)

	srv := &http.Server{
		Handler: r,
		Addr:    service.Config.ListenAddr,
	}

	log.Fatal(srv.ListenAndServe())
}
