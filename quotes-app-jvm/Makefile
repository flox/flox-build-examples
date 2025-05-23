

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

jar:
	gradle shadowJar
	@echo "Build is at ./build/libs/quotes-app-jvm-all.jar"

clean:
	gradle clean
	gradle --stop || true
	rm -rf build .gradle
	@$(FLOXBIN) build clean

