#!/bin/bash

usage() {
    echo "install_python_ls <venv-dir>"
    exit 1
}

install_language_server() {
    $1/bin/pip install 'python-language-server[all]' pyls-mypy pyls-black pyls-isort
}

if [ $# -eq 1 ]; then
    install_language_server $1
else
    usage
fi
