#!/usr/bin/env bash
PROJECT_FLAKES_DIR="project-flakes"

# Print lines of this script as they're executed, and exit on any failure.
set -ex

temp_projects=(
  "sygnal"
)

# Loop through each sub-directory in 'project-flakes'
#for project in "$PROJECT_FLAKES_DIR"/*/ ; do  
for project in "${temp_projects[@]}"; do
  # Remove the trailing '/'
  # project=${project%*/}
  # Extract the project name
  # project=${project##*/}
  # Echo the project name for logging
  echo "Running nix develop on project: $project"
  # Extract the git URL of the project. We often need the files of the
  # project locally in order to build the development shell:
  url=$(grep "^# ci.project-url:" "$PROJECT_FLAKES_DIR/$project/flake.nix" | awk -F': ' '{print $2}')
  echo "Cloning repo: $url"
  # Clone the project to a directory with the same name.
  git clone --depth 1 --single-branch -q "$url" "$project"
  # Enter the project directory.
  cd "$project"
  # Attempt to build and enter the development environment,
  # then run the tests for that project.
  #
  # `cat` the contents of the test script to avoid needing to
  # make `tests.sh` executable (to eliminate dev headache).
  nix develop --impure "../$PROJECT_FLAKES_DIR/$project" -c bash -c "$(cat ../$PROJECT_FLAKES_DIR/$project/tests.sh)"
  # Leave the project directory.
  cd ..
  # Delete the project directory.
  rm -rf "$project"
done