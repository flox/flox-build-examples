
FLOXBIN ?= /usr/local/bin/flox

build:
	bundle config set --local path ./vendor
	bundle install

clean:
	rm -rf vendor .bundle
	@$(FLOXBIN) build clean
