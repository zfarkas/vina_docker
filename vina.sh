#!/bin/bash

INPUTS=()
OUTPUTS=()

OPTIND=1

while getopts "i:o:" opt; do
  case "$opt" in
    i)
      INPUTS+=("$OPTARG")
      ;;
    o)
      OUTPUTS+=("$OPTARG")
      ;;
  esac
done

shift $((OPTIND-1))

echo "Inputs: ${INPUTS[@]}"
echo "Outputs: ${OUTPUTS[@]}"
echo "Arguments: $*"

WORKDIR=`mktemp -d`
pushd "$WORKDIR"

for input in "${INPUTS[@]}"; do
    INDATA=(${input//=/ })
    BN="${INDATA[1]}"
    URL="${INDATA[0]}"
    echo "Downloading $URL to file $BN"
    curl -o "$BN" "$URL"
done

vina.run $*

for output in "${OUTPUTS[@]}"; do
    OUTDATA=(${output//=/ })
    BN="${OUTDATA[0]}"
    URL="${OUTDATA[1]}"
    FNAME="${OUTDATA[2]}"
    echo "Uploading file $BN to $URL using filename $FNAME"
    curl -X POST -F filename=$FNAME -F filedata=@$BN $URL
done

popd
rm -rf "$WORKDIR"
