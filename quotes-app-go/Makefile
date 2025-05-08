

FLOXBIN ?= /usr/local/bin/flox

all: build

fmt:
	go fmt ./...

tidy: fmt
	go mod tidy

build: fmt
	go build .

clean:
	rm -f quotes-app-go
	@$(FLOXBIN) build clean
