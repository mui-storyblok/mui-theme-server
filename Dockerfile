FROM golang:alpine AS builder

WORKDIR $GOPATH/src/mui-storyblok/mui-theme-server
COPY . .
# Build for linux 64 bit. Omit the symbol table, debug information and the DWARF table for smaller binary, declare static
RUN GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -o /go/bin/server .

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

# Copy our static executable
COPY --from=builder /go/bin/server /go/bin/server
# Port choice to play nicely with one click deploy to GCP button
EXPOSE 3333
# Run the server binary
ENTRYPOINT ["/go/bin/server"]

# docker build -f Dockerfile -t 413774799288.dkr.ecr.us-west-2.amazonaws.com/mui-theme-server:latest .
# docker tag 413774799288.dkr.ecr.us-west-2.amazonaws.com/mui-theme-server:latest 413774799288.dkr.ecr.us-west-2.amazonaws.com/mui-theme-server:latest
# docker push 413774799288.dkr.ecr.us-west-2.amazonaws.com/mui-theme-server:latest