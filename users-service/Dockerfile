FROM golang:1.10.3 as builder

RUN mkdir -p /go/src/gophercon-tests
ADD . /go/src/gophercon-tests

WORKDIR /go/src/gophercon-tests/users-service
RUN CGO_ENABLED=0 go install -a gophercon-tests/users-service/cmd/users-service

FROM scratch

WORKDIR /root/
COPY --from=builder /go/bin/users-service .
CMD ["./users-service"]
EXPOSE 80
