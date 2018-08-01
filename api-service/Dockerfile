FROM golang:1.10.3 as builder

RUN mkdir -p /go/src/gophercon-tests
ADD . /go/src/gophercon-tests

WORKDIR /go/src/gophercon-tests/api-service
RUN CGO_ENABLED=0 go install -a gophercon-tests/api-service/cmd/api-service

FROM scratch

WORKDIR /root/
COPY --from=builder /go/bin/api-service .
CMD ["./api-service"]
EXPOSE 80
