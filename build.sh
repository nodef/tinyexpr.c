#!/usr/bin/env bash
# Fetch the latest version of the library
fetch() {
if [ -d "tinyexpr" ]; then return; fi
URL="https://github.com/codeplea/tinyexpr/archive/refs/heads/master.zip"
ZIP="${URL##*/}"
DIR="tinyexpr-master"
mkdir -p .build
cd .build

# Download the release
if [ ! -f "$ZIP" ]; then
  echo "Downloading $ZIP from $URL ..."
  curl -L "$URL" -o "$ZIP"
  echo ""
fi

# Unzip the release
if [ ! -d "$DIR" ]; then
  echo "Unzipping $ZIP to .build/$DIR ..."
  cp "$ZIP" "$ZIP.bak"
  unzip -q "$ZIP"
  rm "$ZIP"
  mv "$ZIP.bak" "$ZIP"
  echo ""
fi
cd ..

# Copy the libs to the package directory
echo "Copying libs to tinyexpr/ ..."
rm -rf tinyexpr
mkdir -p tinyexpr
cp -f ".build/$DIR/tinyexpr.c" tinyexpr/
cp -f ".build/$DIR/tinyexpr.h" tinyexpr/
echo ""
}


# Test the project
test() {
echo "Running 01-basic.c ..."
clang -I. -o 01.exe examples/01-basic.c     && ./01 && echo -e "\n"
echo "Running 02-variables.c ..."
clang -I. -o 02.exe examples/02-variables.c && ./02 && echo -e "\n"
echo "Running 03-functions.c ..."
clang -I. -o 03.exe examples/03-functions.c && ./03 && echo -e "\n"
}


# Main script
if [[ "$1" == "test" ]]; then test
elif [[ "$1" == "fetch" ]]; then fetch
else echo "Usage: $0 {fetch|test}"; fi
