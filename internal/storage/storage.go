// Package storage describes the interface for interacting with our datastore, and provides a PostgreSQL
// implementation for the slice-it-api.
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
	GetTheme(id int) (string, error)
	GetThemes() (string, error)
	CreateTheme(token string) error
}

// GetTheme returns json_theme from user after look up with email
func (db *Db) GetTheme(id int) (string, error) {
	query := "SELECT json_theme FROM themes WHERE id = $1;"

	var theme Theme
	row := db.QueryRow(query, id)
	fmt.Println(row)
	if err := row.Scan(&theme.JsonTheme); err != nil {
		fmt.Println(err)

		return "", err
	}

	fmt.Println(theme)
	return theme.JsonTheme, nil
}

// GetThemes ...
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
			&t.JsonTheme,
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

// CreateTheme ...
func (db *Db) CreateTheme(theme string) error {
	query := "INSERT INTO themes(json_theme) VALUES ($1)"

	_, err := db.Exec(query, theme)
	if err != nil {
		return err
	}

	return nil
}

// Theme ...
type Theme struct {
	ID        int    `json:"id,omitempty"`
	JsonTheme string `json:"json_theme,omitempty"`
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
		"host=%s port=%s user=%s password=%s dbname=%s sslmode=%s",
		os.Getenv("MUI_THEME_ENV_API_DB_HOST"),
		os.Getenv("MUI_THEME_ENV_API_DB_PORT"),
		os.Getenv("MUI_THEME_ENV_API_DB_USER"),
		os.Getenv("MUI_THEME_ENV_API_DB_PASSWORD"),
		os.Getenv("MUI_THEME_ENV_API_DB_NAME"),
		os.Getenv("MUI_THEME_ENV_API_SSL_MODE"),
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
