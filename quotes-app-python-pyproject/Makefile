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
	quotes-app-python-pyproject

install:
	uv pip install -e .

clean:
	rm -rf dist build __pycache__ *.egg-info
	@$(FLOXBIN) build clean
