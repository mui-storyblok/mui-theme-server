// Package storage describes the interface for interacting with our datastore, and provides a PostgreSQL implementation
package storage

import (
	"database/sql"
	"fmt"
	"os"

	// postgres driver
	_ "github.com/lib/pq"
)

// ThemeRepository describes the interface for interacting with our datastore. This can viewed
// like a plug in adapter, making testing and/or switching datastores much more trivial.
type ThemeRepository interface {
	GetTheme(id string) (Theme, error)
	GetThemes() ([]Theme, error)
	CreateTheme(JSONTheme string, name string) (Theme, error)
}

// GetTheme returns a theme by the given id
func (db *Db) GetTheme(id string) (Theme, error) {
	query := "SELECT * FROM themes WHERE id = $1;"

	var t Theme
	row := db.QueryRow(query, id)

	err := row.Scan(
		&t.ID,
		&t.Name,
		&t.JSONTheme,
		&t.CreatedAt,
		&t.UpdatedAt,
	)
	if err != nil {
		return t, err
	}

	return t, nil
}

// GetThemes returns all themes in the theme table
func (db *Db) GetThemes() ([]Theme, error) {
	query := "SELECT * FROM themes;"
	var themes []Theme

	rows, err := db.Query(query)
	if err != nil {
		return themes, err
	}
	defer rows.Close()

	for rows.Next() {
		var t Theme

		err := rows.Scan(
			&t.ID,
			&t.Name,
			&t.JSONTheme,
			&t.CreatedAt,
			&t.UpdatedAt,
		)
		if err != nil {
			return themes, err
		}

		themes = append(themes, t)
	}

	return themes, nil
}

// CreateTheme inserts a new theme along with a name into the theme table
func (db *Db) CreateTheme(theme string, name string) (Theme, error) {
	query := "INSERT INTO themes (json_theme, name) VALUES ($1, $2) RETURNING *;"

	var t Theme
	row := db.QueryRow(query, theme, name)

	err := row.Scan(
		&t.ID,
		&t.Name,
		&t.JSONTheme,
		&t.CreatedAt,
		&t.UpdatedAt,
	)
	if err != nil {
		return t, err
	}

	return t, nil
}

// Theme struct describes the shape of a theme in the DB
type Theme struct {
	ID        int    `json:"id,omitempty"`
	Name      string `json:"name,omitempty"`
	JSONTheme string `json:"json_theme,omitempty"`
	CreatedAt string `json:"created_at,omitempty"`
	UpdatedAt string `json:"updated_at,omitempty"`
}

// Db provides a set of methods for interacting with our database.
type Db struct {
	*sql.DB
}

// NewDB creates a connection with our postgres database and returns it, otherwise an error.
func NewDB() (*Db, error) {

	connStr := fmt.Sprintf(
		"host=%s port=%s user=%s password=%s dbname=%s",
		os.Getenv("DB_HOST"),
		os.Getenv("DB_PORT"),
		os.Getenv("DB_USER"),
		os.Getenv("DB_PASSWORD"),
		os.Getenv("DB_NAME"),
	)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return nil, err
	}

	if err := db.Ping(); err != nil {
		return nil, err
	}

	return &Db{db}, nil
}
