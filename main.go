package main

import (
	"log"
	"net/http"
	"time"

	"github.com/go-chi/chi"
	"github.com/go-chi/cors"

	"github.com/go-chi/chi/middleware"
	"github.com/go-chi/render"
	"github.com/mui-storyblok/mui-theme-server/internal/api"
)

func main() {
	app, err := api.NewApp()
	if err != nil {
		panic(err)
	}

	// Define cors rules
	cors := cors.New(cors.Options{
		AllowedOrigins:   []string{"*"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowedHeaders:   []string{"Accept", "Authorization", "Content-Type", "X-CSRF-Token"},
		ExposedHeaders:   []string{"Link"},
		AllowCredentials: false,
		MaxAge:           300, // Maximum value not ignored by any of major browsers
	})

	r := chi.NewRouter()

	r.Use(
		cors.Handler, // Allow * origins
		// set content-type headers as application/json
		render.SetContentType(render.ContentTypeJSON),
		// log api request calls
		middleware.Logger,
		// strip slashes to no slash URL versions
		middleware.StripSlashes,
		// recover from panics without crashing server
		middleware.Recoverer,
		// Set a timeout value on the request context (ctx), that will signal through ctx.Done()
		// that the request has timed out and furtherprocessing should be stopped.
		middleware.Timeout(30*time.Second),
	)

	r.Route("/api", api.Router(r, app))

	walkFunc := func(
		method string,
		route string,
		handler http.Handler,
		middlewares ...func(http.Handler) http.Handler,
	) error {
		log.Printf("%s %s\n", method, route) // walk and print all the routes
		return nil
	}
	if err := chi.Walk(r, walkFunc); err != nil {
		log.Panicf("Error Log: %s\n", err.Error()) // panic if there is an error
	}

	log.Println("Serving application on PORT :", ":3333")
	log.Fatal(http.ListenAndServe(":"+"3333", r))
}
