package api

import (
	"github.com/go-chi/chi"

	"github.com/mui-storyblok/mui-theme-server/internal/storage"
)

type messageRes struct {
	Message string `json:"message"`
}

// App ...
type App struct {
	themeStorage storage.ThemeRepository
}

// NewApp ...
func NewApp() (App, error) {
	db, err := storage.NewDB()
	if err != nil {
		return App{}, err
	}
	return App{
		themeStorage: db,
	}, nil
}

// Router ...
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
