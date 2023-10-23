## Creates image with sqlite misc extensions
```
podman buildx build -t sqlite-misc-ext:latest --load --platform linux/amd64 .
```

## Injects sqlite misc extensions
```
FROM sqlite-ext:latest AS sqlite-ext-base

FROM amd64/alpine:3.14

RUN apk update && apk upgrade
RUN apk add --no-cache sqlite

COPY --from=sqlite-ext-base /opt/sqlite-misc-extensions /opt/sqlite-misc-extensions
```

## Creates sqlite image with misc extensions
```
podman buildx build -t sqlite-ext-test:latest --load --platform linux/amd64 -f test/Dockerfile.test .
```

## It works
```
podman run -ti --rm sqlite-ext-test sqlite3

sqlite> select load_extension('/opt/sqlite-misc-extensions/uuid');

sqlite> select uuid();
fbd77fba-3c17-4156-9741-59a3e5493981
```