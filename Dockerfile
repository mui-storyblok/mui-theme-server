FROM golang:alpine
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
