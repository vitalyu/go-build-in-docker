#!/bin/bash

[ $# -lt 1 ] && echo "Usage: $(basename $0) <go project src dir>" && exit 1;

SCRIPT_DIR=$(cd $(dirname $0) && pwd) # without ending /
SRC_DIR=$(cd "$(dirname "$1")"; pwd)/$(basename "$1")

COLOR_PURPLE='\033[0;35m'
COLOR_CYAN='\033[0;36m'
COLOR_N='\033[0m'

echo -e "${COLOR_PURPLE}--- Building project from${COLOR_N} ${SRC_DIR}"

docker run --rm -i \
  -v "${SRC_DIR}":"${SRC_DIR}" \
  -w "${SRC_DIR}" \
  -e COLOR_PURPLE="${COLOR_PURPLE}" \
  -e COLOR_CYAN="${COLOR_CYAN}" \
  -e COLOR_N="${COLOR_N}" \
golang:1.8 bash <<'EOF'

###---------------------------

echo -e "${COLOR_PURPLE}--- Downloading project dependencies ${COLOR_N}"
go get -d

for GOOS in darwin; do 	# darwin linux win
  for GOARCH in amd64; do 	# 386 amd64
    echo -e "${COLOR_PURPLE}--- Building for${COLOR_CYAN} ${GOOS} ${GOARCH} ${COLOR_N} "
    export GOOS=$GOOS
    export GOARCH=$GOARCH
    go build -v -o app-$GOOS-$GOARCH
  done
done

exit

###---------------------------

EOF

echo -e "${COLOR_PURPLE}--- Done ${COLOR_N}"

docker system prune -f
