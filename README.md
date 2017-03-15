# dotvim

My personal neovim setup.

```console
cd ~/.config
git clone -b nvim https://github.com/larsyencken/dotvim nvim
```

Then open neovim and run `:PlugInstall` to install plugins.

## Linting requirements

### Python

```
pip install flake8
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
