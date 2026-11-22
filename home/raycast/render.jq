def env_values:
  split("\n")
  | map(select(test("^[A-Za-z_][A-Za-z0-9_]*="))
    | capture("^(?<key>[A-Za-z_][A-Za-z0-9_]*)=(?<value>.*)$"))
  | from_entries;

def substitute($values):
  reduce [match("\\$\\{[A-Za-z_][A-Za-z0-9_]*\\}"; "g") | .string][] as $token
    (.; ($token[2:-1]) as $key
      | if ($values[$key] // "") == "" then error("Missing .env value: " + $key)
        else split($token) | join($values[$key]) end);

($env | env_values) as $values
| walk(if type == "string" then substitute($values) else . end)
