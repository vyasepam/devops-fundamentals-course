
count_files() {
  local dir="$1"
  local count=$(find "$dir" -type f | wc -l)
  echo "$dir: $count file(s)"
}

for dir in "$@"
do
 if [ -d "$dir" ]; then
  count_files "$dir"
  find "$dir" -type d -print0 | while read -d '' -r subdir; do
   count_files "$subdir"
  done
 else
  echo "$dir is not a valid directory"
 fi
done
