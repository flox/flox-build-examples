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
	gunicorn quotes_site.wsgi:application --bind 0.0.0.0:3000

install:
	uv pip install -r requirements.txt

clean:
	rm -rf __pycache__
	@$(FLOXBIN) build clean
