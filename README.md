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
