package api

import (
	"net/http"

	"github.com/go-chi/render"
)

func ping(w http.ResponseWriter, r *http.Request) {
	if r.Method != "GET" {
		http.Error(w, "405 method not allowed", http.StatusMethodNotAllowed)
	}
	render.JSON(w, r, "pong")
}