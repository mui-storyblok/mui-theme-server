FROM golang:alpine

WORKDIR $GOPATH/src/github.com/mui-storyblok/mui-theme-server
COPY . .
# Build for linux 64 bit. Omit the symbol table, debug information and the DWARF table for smaller binary, declare static
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o /go/bin/server .

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

# Port choice to play nicely with one click deploy to GCP button
EXPOSE 3333
# Run the server binary
ENTRYPOINT ["/go/bin/server"]