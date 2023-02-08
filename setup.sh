#!/bin/bash

print_help() {
    printf "Usage: ./setup.sh [options]\n"
    printf "Options:\n"
    printf "  --no-prompts, -N: Run without prompting for user input.\n"
    printf "        --help, -h: Print this help message.\n"
    exit 0
}
if [ "$1" = "--help" ]; then
    print_help
elif [ "$1" = "-h" ]; then
    print_help
elif [ "$1" = "help" ]; then
    print_help
fi

# Update apt
sudo apt update > /dev/null 2>&1

# Install git
if ! type git > /dev/null 2>&1; then
    sudo apt install git
    printf "Finished installing git.\n"
fi
git --version

# Install python
if ! type python > /dev/null 2>&1; then
    sudo apt install python3
    printf "Finished installing python.\n"
fi
python3 --version

# Install pip3
if ! type python > /dev/null 2>&1; then
    sudo apt install python3-pip
    printf "Finished installing pip.\n"
fi
python -m pip install --upgrade pip > /dev/null 2>&1
pip3 --version

# Install pre-commit
if ! type pre-commit > /dev/null 2>&1; then
    pip3 install pre-commit
    printf "Finished installing pre-commit.\n"
fi
pre-commit --version
pre-commit autoupdate > /dev/null 2>&1
pre-commit install

# Install and configure aftman
if ! type aftman > /dev/null 2>&1; then
    wget "https://github.com/LPGhatguy/aftman/releases/download/v0.2.7/aftman-0.2.7-linux-x86_64.zip"
    unzip "aftman-0.2.7-linux-x86_64.zip"
    ./aftman self-install
    source ~/.bashrc
    rm aftman "aftman-0.2.7-linux-x86_64.zip"
    aftman install --no-trust-check
    printf "Finished installing aftman and it's packages.\n"
fi
aftman self-update > /dev/null 2>&1
aftman --version

# Install wally packages
if ! type wally > /dev/null 2>&1; then
    aftman add UpliftGames/wally
    printf "Added wally to aftman.\n"
fi
wally --version

currentLine=1
ranWithoutUpdating=true
if [ ! -d "Packages/" ]; then
    printf "Installing wally packages.\n"
    wally install
    ranWithoutUpdating=false
fi
while IFS= read -r line; do
    if [ $currentLine -lt 8 ]; then
        currentLine=$((currentLine + 1))
        continue
    fi
    packageVersion=$(echo $line | cut -d '=' -f 2 | tr -d '[:space:]' | cut -d '@' -f 2 | tr -d '"')
    packageAuthor=$(echo $line | cut -d '=' -f 2 | tr -d '[:space:]' | cut -d '@' -f 1 | cut -d '/' -f 1 | tr -d '"')
    packageName=$(echo $line | cut -d '=' -f 2 | tr -d '[:space:]' | cut -d '@' -f 1 | cut -d '/' -f 2)
    folderName=$(echo "$packageAuthor/$packageName@$packageVersion" | tr '/' '_')
    if [ ! -d "Packages/_Index/$folderName" ]; then
        printf "Updating installed wally packages.\n"
        wally install
        ranWithoutUpdating=false
        break
    fi
done < wally.toml
if [ $ranWithoutUpdating = true ]; then
    printf "All wally packages are up to date.\n"
fi

noPrompts=false
if [ "$1" = "--no-prompts" ]; then
    noPrompts=true
elif [ "$1" = "-N" ]; then
    noPrompts=true
fi
prompt() {
    if [ $noPrompts = true ]; then
        return 0
    fi
    printf "$1 [Y/n] "
    read -r response
    case $response in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

install_extension() {
    printf "Installing extension $1...\n"
    code --install-extension "$1" --force > /dev/null 2>&1
}

# Prompt to install extensions for VSCode
if type code > /dev/null 2>&1; then
    if prompt "Would you like to install the recommended Roblox Luau VSCode extensions?"; then
        install_extension "JohnnyMorganz.stylua"
        install_extension "Kampfkarren.selene-vscode"
        install_extension "Nightrains.robloxlsp"
    fi
    if prompt "Would you like to install other recommended extensions?"; then
        install_extension "aaron-bond.better-comments"
        install_extension "eamodio.gitlens"
        install_extension "GitHub.copilot"
        install_extension "GitHub.vscode-pull-request-github"
        install_extension "Gruntfuggly.todo-tree"
        install_extension "redhat.vscode-yaml"
        install_extension "usernamehw.errorlens"
    fi
fi

printf "Done.\n"
