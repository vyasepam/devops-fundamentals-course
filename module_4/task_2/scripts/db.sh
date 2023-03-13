
db_file="./../data/users.db"
backup_file="./../data/$(date +%F)-users.db.backup"

check_db_file() {
   if [[ ! -f "$db_file" ]]; then
      read -p "The users.db file does not exist. Would you like to create new one? (y/n)"     create_db
      if [[ $create_db == "y" ]]; then
        touch "$db_file"
        echo "Created users.db file in $db_file"
      else
        echo "Aborting script."
        exit 1
      fi
   fi
}

add_user() {
   check_db_file
   read -p "Enter a username: " username
   if [[ ! "$username" =~ ^[A-Za-z]+$ ]]; then
     echo "Invalid username. Username should contain only latin letters."
     exit 1
   fi
   read -p "Enter a role: " role
   if [[ ! "$role" =~ ^[A-Za-z]+$ ]]; then
     echo "Invalid role. Role should contain only Latin letters."
     exit 1
   fi
   echo "$username, $role" >> "$db_file"
   echo "Added $username, $role to $db_file"
}

backup_db() {
   check_db_file
   cp "$db_file" "$backup_file"
   echo "Created backup file: $backup_file"
}

replace_with_backup() {
   check_db_file
   last_backup="$(ls -t ./../data/*-users.db.backup | head -n1)"
   if [ -z "$last_backup" ]; then
     echo "No backup file found."
     exit 1
   fi
   cp "$last_backup" "$db_file"
   echo "Database replaced with $last_backup"
}

find_user() {
   check_db_file
   read -p "Please enter username: " username
   results=$(grep -i "^$username," "$db_file")
   if [ -z "$results" ]; then
     echo "User not found"
   else
     echo "$results"
   fi
}

list_users() {
   check_db_file
   local line_number=$(wc -l < "$db_file")
   local inverse=false
   
   while [[ $# -gt 0 ]]; do
     case "$1" in
        --inverse)
          inverse=true
         ;;
        *)
          echo "Invalid parameter: $1"
          return 1
          ;;
      esac
      shift
    done
   
   if [[ "$inverse" = true ]]; then
     tac "$db_file" | awk -v LN="$line_number" -F "," '{printf "%s. %s,%s\n", LN--, $1, $2}'
   else
     awk -v LN=1 -F "," '{printf "%s. %s,%s\n", LN++, $1, $2}' "$db_file"
   fi
}

case "$1" in
   add)
      add_user
      ;;
   backup)
      backup_db
      ;;
   restore)
      replace_with_backup
      ;;
   find)
      find_user
      ;;
   list)
      if [[ $# -eq 2 && $2 == "--inverse" ]]; then
        list_users --inverse
      else
        list_users
      fi
      ;;
   help)
      echo "Available comands: "
      echo " add      - Add a new user to the db file"
      echo " backup   - Create a new backup file"
      echo " restore  - Replace dataset with backup"
      echo " find     - Find a user in the db by username"
      echo " list     - List all users in the db"
      echo " help     - Show awailable commands"
      ;;
   *)
      echo "Invalid comand. Type 'db.sh help' to see a list of available commands"
      ;;
esac
      
