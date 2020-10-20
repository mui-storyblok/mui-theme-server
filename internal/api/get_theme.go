package api

import (
	"net/http"

	"github.com/go-chi/chi"
	"github.com/go-chi/render"
)

func (a *App) getTheme(w http.ResponseWriter, r *http.Request) {
	themeID := chi.URLParam(r, "id")

	theme, err := a.themeStorage.GetTheme(themeID)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	render.JSON(w, r, theme)
}
