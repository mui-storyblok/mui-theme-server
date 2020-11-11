FROM golang:alpine

ARG MUI_THEME_ENV_API_DB_HOST
ARG MUI_THEME_ENV_API_DB_PORT
ARG MUI_THEME_ENV_API_DB_NAME
ARG MUI_THEME_ENV_API_DB_USER
ARG MUI_THEME_ENV_API_SSL_MODE

ENV MUI_THEME_ENV_API_DB_HOST=$MUI_THEME_ENV_API_DB_HOST
ENV MUI_THEME_ENV_API_DB_PORT=$MUI_THEME_ENV_API_DB_PORT
ENV MUI_THEME_ENV_API_DB_NAME=$MUI_THEME_ENV_API_DB_NAME
ENV MUI_THEME_ENV_API_DB_USER=$MUI_THEME_ENV_API_DB_USER
ENV MUI_THEME_ENV_API_SSL_MODE=$MUI_THEME_ENV_API_SSL_MODE
ENV MUI_THEME_ENV_API_DB_PASSWORD=

# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git
WORKDIR $GOPATH/src/mui-storyblok/mui-theme-server/
COPY . .
# Fetch dependencies
RUN go mod download
# Build the binary for amazon linux.
RUN GOOS=linux GOARCH=amd64 go build -o /go/bin/server
# Port choice to play nicely with one click deploy to GCP button
EXPOSE 3333
# Run the server binary
ENTRYPOINT ["/go/bin/server"]
