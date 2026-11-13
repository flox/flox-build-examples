

test:
	./test.sh

cpp:
	./test.sh quotes-app-cpp

go:
	./test.sh quotes-app-go

jvm:
	./test.sh quotes-app-jvm

nodejs:
	./test.sh quotes-app-nodejs

php:
	./test.sh quotes-app-php

ruby:
	./test.sh quotes-app-ruby

rust:
	./test.sh quotes-app-rust

python: python-uv python-requirements python-pyproject python-poetry

python-uv:
	./test.sh quotes-app-python-uv

python-requirements:
	./test.sh quotes-app-python-requirements

python-pyproject:
	./test.sh quotes-app-python-pyproject

python-poetry:
	./test.sh quotes-app-python-poetry


clean:
	@for dir in $(shell ls -d */ | tr -d '/'); do \
	if [ -f $$dir/Makefile ]; then \
          echo $$dir ;\
          $(MAKE) -C $$dir clean; \
	fi; \
	done
