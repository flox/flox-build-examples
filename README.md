# What is this?

This repository is meant to be a demo-setup for several ecosystems to show how
to build a package using the manifest build approach from Flox.

# Supported Languages

* JVM (kotlin)
* Ruby
* Nodejs
* Go
* PHP
* C++

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





# Using
`cd` to the directory of the language you want to build and run the following command:

```bash
flox build
```
# License
MIT
