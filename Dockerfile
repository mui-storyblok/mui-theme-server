# FROM golang:alpine

# WORKDIR $GOPATH/src/github.com/mui-storyblok/mui-theme-server
# COPY . .
# # Build for linux 64 bit. Omit the symbol table, debug information and the DWARF table for smaller binary, declare static
# RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o /go/bin/server .

# RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

# # Port choice to play nicely with one click deploy to GCP button
# EXPOSE 3333
# # Run the server binary
# ENTRYPOINT ["/go/bin/server"]

############################
# STEP 1 build executable binary
############################
FROM golang:alpine AS builder
# Install git.
# Git is required for fetching the dependencies.
RUN apk update && apk add --no-cache git
WORKDIR $GOPATH/src/mui-storyblok/mui-theme-server/
COPY . .
# Fetch dependencies.
# Using go get.
RUN go get -d -v
# Build the binary.
RUN GOOS=linux GOARCH=amd64 go build -o /go/bin/server
############################
# STEP 2 build a small image
############################
FROM scratch
# Copy our static executable.
COPY --from=builder /go/bin/server /go/bin/server
# Port choice to play nicely with one click deploy to GCP button
EXPOSE 3333
# Run the server binary
ENTRYPOINT ["/go/bin/server"]
