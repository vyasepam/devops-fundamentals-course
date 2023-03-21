#!/bin/bash

display_help() {
  echo "Usage: $0 [path/to/pipeline.json] [OPTIONS]"
  echo ""
  echo "Options:"
  echo "-h, --help                          Display help message."
  echo "-c, --configuration <CONFIG>        The build configuration value."
  echo "-o, --owner <OWNER>                 The owner name of the GitHub repository."
  echo "-b, --branch <BRANCH>               The branch name of the GitHub repository."
  echo "-p, --poll-for-source-changes       Activates and deactivates the automatic pipeline execution when source code is changed."
  echo ""
}


if ! command -v jq &> /dev/null; then
  echo "Error: JQ is not installed. Please install JQ and try again."
  echo "       For Ubuntu/Debian, run: sudo apt-get install jq"
  echo "       For macOS, run: brew install jq"
  echo "       For CentOS/RHEL, run: sudo yum install jq"
  exit 1
fi


if [ $# -eq 0 ]
then
  echo "Please provide the path to the pipeline definition JSON file as the first arg."
  exit 1
fi

if ! jq -e '.pipeline.version' "$1" >/dev/null; then
   echo "Missing version property in the pipeline definition."
   exit 1
fi

if ! jq -e '.pipeline.stages[0].actions[0].configuration.Owner' "$1" >/dev/null; then
    echo "Missing Owner property in the pipeline definition."
    exit 1
fi

if ! jq -e '.pipeline.stages[0].actions[0].configuration.Branch' "$1" >/dev/null; then
    echo "Missing Branch property in the pipeline definition."
    exit 1
fi


POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -c|--configuration)
        CONFIGURATION="$2"
        shift
        shift
        ;;
        -o|--owner)
        OWNER="$2"
        shift
        shift
        ;;
        -b|--branch)
        BRANCH="$2"
        shift
        shift
        ;;
        -p|--poll-for-source-changes)
        POLL="$2"
        shift
        shift
        ;;
        -h|--help)
        display_help
        shift
        shift
        ;;
        *)
        POSITIONAL+=("$1") # save it in an array for later
        shift
        ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters


PIPELINE=$(cat "$1")

PIPELINE=$(echo "$PIPELINE" | jq 'del(.metadata)')

VERSION=$(echo "$PIPELINE" | jq -r '.pipeline.version + 1')

PIPELINE=$(echo "$PIPELINE" | jq ".pipeline.version = $VERSION")


if [ ! -z "$BRANCH" ]
then
    PIPELINE=$(echo "$PIPELINE" | jq ".pipeline.stages[0].actions[0].configuration.Branch = \"$BRANCH\"")
fi

if [ ! -z "$OWNER" ]
then
    PIPELINE=$(echo "$PIPELINE" | jq ".pipeline.stages[0].actions[0].configuration.Owner = \"$OWNER\"")
fi
if [ ! -z "$POLL" ]
then
    PIPELINE=$(echo "$PIPELINE" | jq ".pipeline.stages[0].actions[0].configuration.PollForSourceChanges = \"$POLL\"")
fi


ENV_VARS=$(echo "{\"name\":\"BUILD_CONFIGURATION\",\"value\":\"$CONFIGURATION\",\"type\":\"PLAINTEXT\"}")
PIPELINE=$(echo "$PIPELINE" | jq ".pipeline.stages[].actions[].configuration.EnvironmentVariables = [$ENV_VARS]")


DATE=$(date +%Y-%m-%d)
NEW_FILE="pipeline-$DATE.json"
echo "$PIPELINE" > "$NEW_FILE"

echo "Pipeline definition updated and saved to $NEW_FILE"
