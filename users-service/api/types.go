package api

type UserData struct {
	Email string
	Name string
}

type RegisteredUser struct {
	Id int
	UserData
}

type CreateUserRequest struct {
	UserData
}
type CreateUserResponse struct {
	Id int
}

type GetAllRequest struct {}
type GetAllResponse struct {
	Users []RegisteredUser
}
