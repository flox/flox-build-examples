package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"

	"github.com/gorilla/mux"
)

var quotes []interface{}

func loadQuotes(filename string) {
	data, err := os.ReadFile(filename)
	if err != nil {
		log.Fatalf("Failed to read quotes file: %v", err)
	}
	if err := json.Unmarshal(data, &quotes); err != nil {
		log.Fatalf("Failed to parse JSON: %v", err)
	}
}

func getAllQuotes(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(quotes)
}

func getQuoteByIndex(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	indexStr, ok := vars["index"]
	if !ok {
		http.Error(w, `{"error":"Index not provided"}`, http.StatusBadRequest)
		return
	}

	index, err := strconv.Atoi(indexStr)
	if err != nil || index < 0 || index >= len(quotes) {
		http.Error(w, `{"error":"Index out of bounds"}`, http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(quotes[index])
}

func main() {
	loadQuotes("quotes.json")

	r := mux.NewRouter()
	r.HandleFunc("/quotes", getAllQuotes).Methods("GET")
	r.HandleFunc("/quotes/{index}", getQuoteByIndex).Methods("GET")

	addr := ":3000"
	fmt.Printf("Server running on %s\n", addr)
	log.Fatal(http.ListenAndServe(addr, r))
}
