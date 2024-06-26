#!/usr/bin/env bash

# If anything fails, exit
set -eo pipefail

# Check if either curl or wget is available on the system
if command -v curl &>/dev/null; then
	downloader="curl"
elif command -v wget &>/dev/null; then
	downloader="wget"
else
	echo "Error: This script requires either curl or wget to be installed."
	exit 1
fi

function display_help() {
	cat <<EOM
Usage: $0 -v <nvim-version> -d <download-path> -o <os-name>
Options:
  -v       Specify the desired Neovim version to download.
  -d       Specify directory inside which Neovim release should be downloaded.
  -o       OS whose binary is to be downloaded.
  -h       Display this help message and exit.
EOM
}

# Download using wget/curl whatever is available
function download() {
	local url="$1"
	local output_file="$2"

	if [ "$downloader" = "curl" ]; then
		curl -fsSL -o "$output_file" "$url"
	elif [ "$downloader" = "wget" ]; then
		wget --quiet --output-document="$output_file" "$url"
	fi
}

function download_neovim() {
	local os="$1"
	local version="$2"
	local download_dir="$3"
	local download_url=""
	local download_path=""

	if [ "$os" == "Linux" ]; then
		download_url="https://github.com/neovim/neovim/releases/tag/${version}/nvim.appimage"
		download_path="$download_dir/nvim-$version-linux.appimage"
	elif [ "$os" == "macOS" ]; then
		download_url="https://github.com/neovim/neovim/releases/tag/${version}/nvim-macos.tar.gz"
		download_path="$download_dir/nvim-$version-macos.tar.gz"
	else
		echo "Error: Currently download support is present only for Linux and macOS"
		exit 1
	fi

	echo "Downloading Neovim..."
	download "$download_url" "$download_path"
	echo "Download completed."
}

# Parse command-line options
while getopts "v:d:o:h" opt; do
	case $opt in
	v)
		nvim_version="$OPTARG"
		;;
	d)
		download_dir="$OPTARG"
		;;
	o)
		os_name="$OPTARG"
		;;
	h)
		display_help
		exit 0
		;;
	\?)
		display_help
		exit 1
		;;
	:)
		echo "Option -$OPTARG requires an argument." >&2
		display_help
		exit 1
		;;
	esac
done

# Check if the required options are provided
if [[ -z $nvim_version || -z $os_name || -z $download_dir ]]; then
	echo "Missing options. Use -h to see the usage."
	exit 1
fi

if [[ ! -d $download_dir ]]; then
    # Make the directory if it does not exist
    mkdir -p "$download_dir"
fi

download_neovim "$os_name" "$nvim_version" "$download_dir"
