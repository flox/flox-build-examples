


all: build

fmt:
	go fmt ./...

tidy: fmt
	go mod tidy

build: fmt
	go build .

clean:
	rm -f quotes-app-go
	@flox build clean
