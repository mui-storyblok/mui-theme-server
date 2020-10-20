package api

import (
	"github.com/go-chi/chi"

	"github.com/mui-storyblok/mui-theme-server/internal/storage"
)

// App defines the aviliable interactions in this app
type App struct {
	themeStorage storage.ThemeRepository
}

// NewApp connects to the DB and sets up our App
func NewApp() (App, error) {
	db, err := storage.NewDB()
	if err != nil {
		return App{}, err
	}
	return App{
		themeStorage: db,
	}, nil
}

// Router - all of the routes dealing with the App
func Router(r chi.Router, app App) func(r chi.Router) {
	return func(r chi.Router) {
		r.Route("/v1", func(r chi.Router) {
			r.Get("/ping", ping)
			r.Get("/theme/{id}", app.getTheme)
			r.Get("/themes", app.getThemes)
			r.Post("/theme", app.createTheme)
		})
	}
}
