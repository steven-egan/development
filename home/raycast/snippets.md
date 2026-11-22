# Raycast snippets

Edit `template.json` to add snippets in [Raycast's JSON format](https://manual.raycast.com/snippets#importing-snippets). Plain text works as-is; use `${VARIABLE_NAME}` in a string to insert a literal `VARIABLE_NAME=value` from `.env`. Values are not evaluated as shell code. Missing or empty values cause generation to fail.
