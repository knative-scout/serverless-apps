#!/usr/bin/env bash
# Configuration
repo_dir=$(realpath $(dirname "$0"))

# Helpers
function die() {
    echo "Error: $@" >&2
    exit
}

function bold() {
    echo $(tput bold)$@$(tput sgr0)
}

function usage() {
    progname=new.sh
    cat <<EOF
$progname - Create a new serverless app on kscout.io

Usage: $progname NAME

Arguments:
1. NAME - Name of new serverless app

Behavior:
Creates a folder in the root of the repository with NAME. 
Prompts user for manifest.yaml values and creates file.
EOF
}

function prompt() {
    # Arguments
    msg="$1"
    dest="$2"

    # Prompt
    while [ -z "${!dest}" ]; do
	bold "$msg"
	read "$dest"

	if [ -z "${!dest}" ]; then
	    echo "You must enter at least one character." >&2
	fi
    done
}

# Prompts for multiple items, stores them in an array.
# Requires at least 1 item to be inputed by user.
# After finished executing the resulting items will be in ${__items[@]}
# Arguments:
# 1. MSG        Message to show user before prompting
# 2. CHOICES    (Optional) If provided choices will be limited to
#               the values in this arrau
function prompt_list() {
    # Arguments
    msg="$1"
    choices=()

    while [ -n "$2" ]; do
	choices+=("$2")
	shift
    done

    # Prompt
    bold "$msg"

    if [ -n "$choices" ]; then # Show choices if given
	echo "May only enter the following choices:"

	for choice in "${choices[@]}"; do
	    echo "- $choice"
	done
    fi

    __items=()

    while true; do
	echo "Enter item (empty to exit): "
	read item

	if [ -z "$item" ] && [ -z "$__items" ]; then # Check at least 1 item provided
	    echo "You must enter at least 1 item." >&2
	    continue
	elif [ -z "$item" ]; then # Exit if empty
	    break
	fi

	if [ -n "$choices" ]; then # Check against choices if given
	    matched=false

	    for choice in "${choices[@]}"; do
		if [[ "$choice" == "$item" ]]; then
		    matched=true
		fi
	    done

	    if [[ "$matched" != "true" ]]; then # If entered item was not a valid choice
		echo "Your must enter one of the choices above." >&2
		continue
	    fi
	fi

	# Add item
	__items+=("$item")
    done
}

# Outputs a yaml list indented by INDENT_NUM spaces
# Arguments
# 1. INDENT_NUM    Number of spaces to indent each item
# 2. ITEMS         Array of items to output
function as_yaml_list() {
    # Arguments
    indent_num="$1"
    items=()

    while [ -n "$2" ]; do
	items+=("$2")
	shift
    done

    # Output items
    for item in "${items[@]}"; do
	# Indent
	for i in seq "$indent_num"; do
	    printf " "
	done

	# Output
	printf '-'
	printf ' '
	printf "'$item'"
	printf '\n'
    done
}

# Arguments
name="$1"
if [ -z "$name" ]; then
    usage
    echo
    die "NAME argument required"
fi

# Check if app with name already exists
if [ -d "$repo_dir/$name" ]; then
    die "App with name \"$name\" already exists"
fi

# Prompt user for manifest values
bold "You will now be asked to answer a few questions about your app:"

manifest_categories_choices=("analytics"
			     "automation"
			     "entertainment"
			     "hello world"
			     "internet of things"
			     "utilities"
			     "virtual assistant"
			     "other")


prompt "Tagline - What are a few words which describe your app?" manifest_tagline
prompt_list "Tags - What are a few keywords that fit your app?"
manifest_tags=("${__items[@]}")
prompt_list "Categories - Which of the following categories should the app be placed in?" "${manifest_categories_choices[@]}"
manifest_categories=("${__items[@]}")
prompt "Author - What is your name?" manifest_author_name
prompt "Author - What is your email?" manifest_author_email

# Make app directory and manifest
bold "Creating new app content"

app_dir=$(echo "$name" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-zA-Z0-9_-]/-/g')
app_dir="$repo_dir/$app_dir"

if ! mkdir -p "$app_dir"; then
    die "Failed to create new app directory \"$app_dir\""
fi

if ! mkdir -p "$app_dir/deployment"; then
    die "Failed to create new app's deployment directory \"$app_dir/deployment\""
fi

echo "Writing this manifest.yaml for your new app:"

tee "$app_dir/manifest.yaml" <<EOF
name: $name
tagline: $manifest_tagline
tags:
$(as_yaml_list 2 "${manifest_tags[@]}")
categories:
$(as_yaml_list 2 "${manifest_categories[@]}")
author:
  name: $manifest_author_name
  email: $manifest_author_email
EOF
if [[ "$?" != "0" ]]; then
    die "Failed to create new app \"$app_dir/manifest.yaml\" file"
fi

# Inform user of next steps
bold "Almost done!"
cat <<EOF
There are a few things you must do to submit your app:

1. Create a file named "$app_dir/README.md", in it describe a bit about your app
2. Make a logo for you app and save it as "$app_dir/logo.png"
3. Put Knative deployment resource manifests in the "$app_dir/deployment/" directory
4. (Optional) Add screenshots of your app to the "$app_dir/screenshots/" directory
5. Commit and push your changes, then make a pull request by going to https://github.com/kscout/serverless-apps/pulls

EOF

bold "Goodbye!"
