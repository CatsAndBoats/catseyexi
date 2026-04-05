FROM --platform=$BUILDPLATFORM busybox:latest

COPY ./losmeshes/*.obj /losmeshes/
COPY ./navmeshes/*.nav /navmeshes/
COPY ./ximeshes/*.ximesh /ximeshes/

VOLUME /navmeshes /losmeshes /ximeshes
