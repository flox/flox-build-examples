# What is this?

A collection of examples and tests for using Flox [manifest builds](https://flox.dev/docs/concepts/manifest-builds/) and [Nix expression builds](https://flox.dev/docs/concepts/nix-expression-builds/) with a variety of popular language ecosystems.

# Supported Languages

* C++
* Go
* JVM (kotlin)
* Nodejs
* PHP
* Python
* Ruby
* Rust

Feel free to add more.

## Python

There are four Python examples, one per repository shape. They share one
manifest skeleton and differ only in the line that installs the project's
dependencies and in how the launcher is produced:

* `quotes-app-python-uv`: a `uv.lock` project with no console script; the build writes a uvicorn launcher into `$out/bin`.
* `quotes-app-python-requirements`: a pinned `requirements.txt` Django project; the build ships the source tree and a gunicorn launcher.
* `quotes-app-python-pyproject`: a `pyproject.toml` with no lockfile and a console script entry point, plus a Nix expression build of the same project.
* `quotes-app-python-poetry`: a `poetry.lock` project with a console script.

Each imports numpy so the package carries a native-code wheel, which is what the
Linux `auto-patchelf` step in the build exists for. The recipe itself is explained
in the [Python guide](https://flox.dev/docs/languages/python).


# Testing

All applications are designed to built by:

```bash
 cd $dir
 flox build
 # then run the resulting binary in result-*/bin/quotes*
```

To test, you should be able to run

```bash
  curl localhost:3000/quotes/1
```

If that returns a 200, it's working.

The test script checks each build twice: once by running the result directly, and
once in run mode, by installing the result's store path into a scratch environment
and starting it with `flox activate --mode run`. Run mode is how a build is used
outside the project, with no dev shell or hook, so it catches packages that only
work because the dev environment supplied something.


# Automated Testing

`make test` at the top level of the project will build and test all directories.

You can also run `make ruby` or `make go`, etc

An alternate Flox binary can be provided with `FLOXBIN` which can also be used to provide different versions ad-hoc:

``` bash
FLOXBIN="nix run github:flox/flox/v1.4.4 --"
```


# Using
`cd` to the directory of the language you want to build and run the following command:

```bash
flox build
```

# License
MIT
