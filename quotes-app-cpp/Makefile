
UNAME_S := $(shell uname)

ifeq ($(origin FLOXBIN), undefined)
  ifeq ($(UNAME_S), Darwin)
    FLOXBIN := /usr/local/bin/flox
  else ifeq ($(UNAME_S), Linux)
    FLOXBIN := /usr/bin/flox
  else
    $(error Unsupported OS: $(UNAME_S))
  endif
endif

all:
	clang++ -O3 -std=c++17 quotes_server.cpp -o quotes-app-cpp -lboost_system -lboost_json -pthread


clean:
	rm -f quotes-app-cpp
	@$(FLOXBIN) build clean
