package api

import (
	"encoding/json"
	"net/http"

	"github.com/go-chi/render"
)

type createRes struct {
	JSONTheme string `json:"jsonTheme"`
	Name      string `json:"name"`
}

func (a *App) createTheme(w http.ResponseWriter, r *http.Request) {
	var res createRes
	if err := json.NewDecoder(r.Body).Decode(&res); err != nil {
		http.Error(w, "send valid JSON", http.StatusUnprocessableEntity)
		return
	}

	if res.JSONTheme == "" {
		render.JSON(w, r, "theme json is required")
		return
	}

	if res.Name == "" {
		render.JSON(w, r, "theme name is required")
		return
	}

	t, err := a.themeStorage.CreateTheme(res.JSONTheme, res.Name)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	render.JSON(w, r, t)
}
