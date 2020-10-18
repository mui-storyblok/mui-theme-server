Review Environments
Database
Set up development db with

```createdb mui-theme-db```

Run migration:

```psql -U {{ you user name }} -d mui-theme-db -a -f internal/storage/migrations/schema.sql```