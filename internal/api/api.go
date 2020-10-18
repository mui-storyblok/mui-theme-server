package api

import (
	"github.com/go-chi/chi"

	"github.com/mui-storyblok/mui-storyblok-server/internal/storage"
)

type messageRes struct {
	Message string `json:"message"`
}

// App ...
type App struct {	
	themeRepo storage.ThemeRepository
}

// NewApp ...
func NewApp() (App, error) {
	db, err := storage.NewDB()
	if err != nil {
		return App{}, err
	}
	return App{
		themeRepo: db,
	}, nil
}

// Router ...
func Router(r chi.Router, app App) func(r chi.Router) {
	return func(r chi.Router) {
		r.Route("/v1", func(r chi.Router) {
			r.Get("/ping", ping)
			r.Get("/theme:id", app.themeRepo.GetTheme)
			r.Get("/themes", app.themeRepo.GetThemes)
			r.Post("/theme", app.themeRepo.CreateTheme)
		})
	}
}
