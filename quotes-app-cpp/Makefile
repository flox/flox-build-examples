
FLOXBIN ?= /usr/local/bin/flox

all:
	clang++ -O3 -std=c++17 quotes_server.cpp -o quotes-app-cpp -lboost_system -lboost_json -pthread


clean:
	rm -f quotes-app-cpp
	@$(FLOXBIN) build clean
