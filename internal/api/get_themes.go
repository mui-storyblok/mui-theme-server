package api

import (
	"net/http"

	"github.com/go-chi/render"
)

func (a *App) getThemes(w http.ResponseWriter, r *http.Request) {
	theme, err := a.themeStorage.GetThemes()
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	render.JSON(w, r, theme)
}
