!/bin/bash

package_name=""

function installPackage() {
    if [[ -z "$package_name" ]]; then
        echo "Error: package_name is not defined."
        exit 1
    fi

    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        if [[ -x "$(command -v apt-get)" ]]; then
            sudo apt-get install -y "$package_name"
        elif [[ -x "$(command -v yum)" ]]; then
            sudo yum install -y "$package_name"
        else
            echo "Error: Could not find a package manager for Linux."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if [[ -x "$(command -v brew)" ]]; then
            brew install "$package_name"
        else
            echo "Error: Could not find a package manager for macOS."
            exit 1
        fi
    elif [[ "$OSTYPE" == "msys" ]]; then
        if [[ -x "$(command -v choco)" ]]; then
            choco install "$package_name"
        else
            echo "Error: Could not find a package manager for Windows."
            exit 1
        fi
    else
        echo "Error: Could not find a package manager for $OSTYPE."
        exit 1
    fi
}

function installForeman {
    package_name="foreman"
    installPackage

    if [ -x "$(command -v foreman)" ]; then
        foreman install
    fi
}

function installGit {
    package_name="git"
    installPackage

    if [ -x "$(command -v git)" ]; then
        git checkout .
    fi
}

function serve {
    if [ ! -x "$(command -v rojo)" ]; then
        echo "Error: rojo is not a valid command. Please add it to your foreman.toml file."
        exit 1
    fi

    rojo serve --port 34872
}

function styleCheck {
    if ! [ -x "$(command -v selene)" ]; then
        echo "Error: selene is not installed. Please add it to your foreman.toml file."
        exit 1
    fi

    if ! [ -x "$(command -v stylua)" ]; then
        echo "Error: stylua is not installed. Please add it to your foreman.toml file."
        exit 1
    fi

    selene src
    if [ $? -ne 0 ]; then
        echo "Error: selene failed."
        exit 1
    fi

    stylua --check .
    if [ $? -ne 0 ]; then
        echo "Error: stylua --check failed."
        exit 1
    fi

    stylua src
    if [ $? -ne 0 ]; then
        echo "Error: stylua failed."
        exit 1
    fi

    echo "Finished styling!"
}

function commit {
    installGit
    styleCheck

    git add -A
    if [ $? -ne 0 ]; then
        echo "Error: git add -A failed."
        exit 1
    fi

    read -p "Enter a commit message: " message
    if [[ -z "$message" ]]; then
        message="No commit message"
    fi

    git commit -m "$message"
    if [ $? -ne 0 ]; then
        echo "Error: git commit -m \"$message\" failed."
        exit 1
    fi

    git push
    if [ $? -ne 0 ]; then
        echo "Error: git push failed."
        exit 1
    fi

    echo "Finished committing!"
}

function update {
    installGit
    git fetch
    if [ $? -ne 0 ]; then
        echo "Error: git fetch failed."
        exit 1
    fi

    git pull
    if [ $? -ne 0 ]; then
        echo "Error: git pull failed."
        exit 1
    fi

    echo "Finished updating!"
}

 If the user enters an invalid command, it will print an error message and exit.
read -p "Enter a command: " command
if [[ "$command" == "help" ]]; then
    echo "Available commands: style, commit, fetch, serve"
elif [[ "$command" == "style" ]]; then
    styleCheck
elif [[ "$command" == "commit" ]]; then
    commit
elif [[ "$command" == "fetch" ]]; then
    update
elif [[ "$command" == "serve" ]]; then
    serve
else
    echo "Error: Invalid command."
    exit 1
fi