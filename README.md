# dotvim

My personal neovim setup.

## Requirements

Neovim 0.7.0 or greater

## Initial setup

```console
cd ~/.config
git clone -b nvim https://github.com/larsyencken/dotvim nvim
```

Then open neovim and run `:PlugInstall` to install plugins.

## Language server plugins

### Python

This setup uses `pyright` as the language server, which requires a functioning node installation to run:

```
npm install --location=global pyright
```

### Javascript/javascript-typescript-langserver

```
npm install --location=global typescript
```
