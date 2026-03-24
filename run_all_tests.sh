#!/bin/bash

# Default values
TAG=""
TEST=""
DIR="Tests/"
OUTPUT="$(pwd)/Results"

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -i|--include) TAG="$2"; shift ;;
        -t|--test) TEST="$2"; shift ;;
        -d|--dir) DIR="$2"; shift ;;
        -o|--output) OUTPUT="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Prepare output directory
mkdir -p "$OUTPUT"
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT="$OUTPUT/$timestamp"
mkdir -p "$OUTPUT"

# Build robot command
CMD="robot -d $OUTPUT"

if [[ -n "$TAG" ]]; then
    CMD="$CMD -i $TAG"
fi

if [[ -n "$TEST" ]]; then
    CMD="$CMD -t \"$TEST\""
fi

CMD="$CMD $DIR"

# Execute command
echo "➡️ Running: $CMD"
eval $CMD

# Summary
echo ""
echo "✅ Testy zakończone. Wyniki w: $OUTPUT"
echo "📄 Log:     $OUTPUT/log.html"
echo "📄 Report:  $OUTPUT/report.html"
echo "📄 Output:  $OUTPUT/output.xml"
