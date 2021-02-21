---
title: Homebrew Cask Upgrade
categories:
- Software
- Tools
- Homebrew
---
# Homebrew Cask Upgrade

- `Homebrew Cask`是 `Homebrew`的扩展,借助它可以方便地在 macOS 上安装图形接口进程,即我们常用的各类应用

## 安装

```shell
brew tap buo/cask-upgrade
```

## 常用命令

### Upgrade outdated apps:

```
brew cu
```

### Upgrade a specific app:

```
brew cu [CASK]
```

- It is also possible to use `*` to install multiple casks at once, i.e. `brew cu flash-*` to install all casks starting with `flash-` prefix.

## 所有命令

```
Usage: brew cu [command=run] [CASK] [options]
Commands:
    run         Default command, doesn't have to be specified. Executes cask upgrades.
    pin         Pin the current app version, preventing it from being
                upgraded when issuing the `brew cu` command. See also `unpin`.
    unpin       Unpin the current app version, allowing them to be
                upgraded by `brew cu` command. See also `pin`.
    pinned      Print all pinned apps and its version. See also `pin`.

Options:
    -a, --all             Include apps that auto-update in the upgrade.
        --cleanup         Cleans up cached downloads and tracker symlinks after
                          updating.
    -f  --force           Include apps that are marked as latest
                          (i.e. force-reinstall them).
        --no-brew-update  Prevent auto-update of Homebrew, taps, and formulae
                          before checking outdated apps.
    -y, --yes             Update all outdated apps; answer yes to updating packages.
    -q, --quiet           Do not show information about installed apps or current options.
    -v, --verbose         Make output more verbose.
        --no-quarantine   Pass --no-quarantine option to `brew cask install`.
    -i, --interactive     Running update in interactive mode
```