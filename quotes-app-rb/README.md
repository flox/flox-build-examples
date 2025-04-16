# quotes-app-rb

A tiny Sinatra-powered HTTP service for serving inspirational quotes.

## ✨ Features

- Returns all quotes or a specific one by index
- Easy to run locally or package in a Flox environment


## 🛠️ Building

There's nothing to build, it's ruby.


## 🏃 Running

From the git checkout: 

```bash
  bundle
  bundle exec ruby app.rb
```

Or from the Flox built artifact:

```bash
   ./result-quotes-app-rb/bin/quotes
```

## Client

The service can be accessed via HTTP GET requests on localhost:8080/quotes

### 📚 HTTP Routes

| Method | Path            | Description                    | Example Response                       |
|--------|------------------|--------------------------------|----------------------------------------|
| GET    | `/quotes`        | Returns a list of all quotes   | `["Quote 1", "Quote 2", "Quote 3"]`    |
| GET    | `/quotes/{i}`    | Returns quote at index `i`     | `"Quote 1"`                            |



## 📦 Packaging

```bash
flox build
```

## License
MIT
