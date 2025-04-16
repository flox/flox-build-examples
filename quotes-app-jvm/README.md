# quotes-app

A tiny Micronaut-powered HTTP service for serving inspirational quotes.

## ✨ Features

- Returns all quotes or a specific one by index
- Fast, zero-dependency fat JAR via [Shadow plugin](https://imperceptiblethoughts.com/shadow/)
- Easy to run locally or package in a Flox environment


## 🛠️ Building

To build the application and produce a fat jar:

```bash
./gradle clean shadowJar
```

## 🏃 Running

From the git checkout: 

```bash
  ./gradle run
```

From the fat jar:

```bash
 java -jar build/libs/quotes-app-all.jar
```

Or from the Flox built artifact:

```bash
   ./result-quotes-app/bin/quotes
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
