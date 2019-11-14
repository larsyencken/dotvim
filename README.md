# dotvim

My personal neovim setup.

```console
cd ~/.config
git clone -b nvim https://github.com/larsyencken/dotvim nvim
```

Then open neovim and run `:PlugInstall` to install plugins.

## Linting requirements

### Python

Set the python version to use, e.g. in `init-local.vim`:

```
let g:python_host_prog = '/Users/lars/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/Users/lars/.pyenv/versions/neovim3/bin/python'
```

Install packages you need there: `pip install black flake8 pyls`

Also set up the language server:

```
let g:LanguageClient_serverCommands = {
    \ 'python': ['/Users/lars/.pyenv/versions/neovim3/bin/pyls'],
    \ }
```

### JSON

```
brew install node
npm install -g jsonlint
```

## Sierra workarounds

```
brew install reattach-to-user-namespace
```

Then in `.zshrc-local`:

```
alias nvim='reattach-to-user-namespace -l nvim'
alias vim='reattach-to-user-namespace -l nvim'
alias vi='reattach-to-user-namespace -l nvim'
export EDITOR='/usr/local/bin/reattach-to-user-namespace -l nvim'
```
