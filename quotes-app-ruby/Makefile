

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

build:
	bundle config set --local path ./vendor
	bundle install

clean:
	rm -rf vendor .bundle
	@$(FLOXBIN) build clean
