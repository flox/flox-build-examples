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

run: install
	uvicorn quotes_app.main:app --host 0.0.0.0 --port 3000

install:
	uv sync --frozen

clean:
	rm -rf dist __pycache__
	@$(FLOXBIN) build clean
