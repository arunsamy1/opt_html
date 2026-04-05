#!/bin/bash

# Generate index.html with a table of all HTML files found in subdirectories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT="$SCRIPT_DIR/index.html"

cat > "$OUTPUT" <<'HTMLHEAD'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>HTML File Index</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; font-size: 1.2em; }
    h1 { color: #333; }
    table { border-collapse: collapse; width: 100%; background: #fff; box-shadow: 0 1px 4px rgba(0,0,0,0.1); }
    th { background: #4a6fa5; color: #fff; padding: 10px 14px; text-align: left; }
    td { padding: 8px 14px; border-bottom: 1px solid #ddd; }
    tr:hover td { background: #f0f4ff; }
    a { color: #2a5db0; text-decoration: none; }
    a:hover { text-decoration: underline; }
    .folder { color: #888; font-size: 0.9em; }
    .open-btn { margin-left: 10px; padding: 2px 10px; font-size: 0.8em; background: #4a6fa5; color: #fff; border: none; border-radius: 4px; cursor: pointer; }
    .open-btn:hover { background: #2a5db0; }
  </style>
</head>
<body>
<h1>HTML File Index</h1>
<table>
  <thead>
    <tr>
      <th>#</th>
      <th>Folder</th>
      <th>File</th>
    </tr>
  </thead>
  <tbody>
HTMLHEAD

count=0
while IFS= read -r filepath; do
  # Get path relative to script dir
  relpath="${filepath#$SCRIPT_DIR/}"
  folder="$(dirname "$relpath")"
  filename="$(basename "$relpath")"
  count=$((count + 1))
  echo "    <tr>" >> "$OUTPUT"
  echo "      <td>$count</td>" >> "$OUTPUT"
  echo "      <td class=\"folder\">$folder</td>" >> "$OUTPUT"
  echo "      <td><a href=\"$relpath\">$filename</a><button class=\"open-btn\" onclick=\"window.open('$relpath','_blank')\">Open</button></td>" >> "$OUTPUT"
  echo "    </tr>" >> "$OUTPUT"
done < <(find "$SCRIPT_DIR" -mindepth 2 -name "*.html" | sort)

cat >> "$OUTPUT" <<'HTMLFOOT'
  </tbody>
</table>
</body>
</html>
HTMLFOOT

echo "Generated $OUTPUT with $count entries."
