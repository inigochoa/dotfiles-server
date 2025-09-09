# My Server Dotfiles Repository 🧑🏻‍💻

Welcome to my server dotfiles repo! This repository contains all my
configuration files and tools to quickly set up and customize my server
environments. Everything is managed with [Dotbot] for a smooth installation
process.

## Tools 🛠️

- [atuin]: Modern shell history with search.
- [bat]: A `cat` clone with syntax highlighting.
- [bottom]: A graphical system monitor.
- [ctop]: Top-like interface for container metrics.
- [dry]: A terminal application to manage and monitor Docker containers.
- [duf]: A disk usage/free utility.
- [eza]: A modern replacement for `ls`.
- [fastfetch]: A system info fetcher.
- [fzf]: A command-line fuzzy finder.
- [git-delta]: A syntax-highlighting pager for `git diffs`.
- [lnav]: A log file viewer for the terminal.
- [onefetch]: A tool to display repository information.
- [procs]: A replacement for `ps`.
- [starship]: A minimal, blazing-fast, and customizable prompt.
- [zoxide]: A smarter way to navigate your filesystem.

## Directory Structure & Files 📁

```shell
.
├── .dotbot/              # dotbot submodule
├── .dotbot-omnipkg/      # omnipkg submodule
├── .dotbot-scripts/      # dotbot shell scripts folder
├── dotfiles/             # dotfiles containing folder
│   ├── bashrc.d/         # modularized bash configuration folder
│   │   ├── bash          # atuin, copy, paste, grep, ...
│   │   ├── directories   # cd, ls, eza, zoxide, ...
│   │   ├── docker        # docker aliases
│   │   ├── files         # bat, confirmations, safeties, ...
│   │   ├── git           # gclone, onefetch, ...
│   │   ├── internet      # certificates, pings, ...
│   │   ├── prompt        # default and starship (if installed)
│   │   └── system        # actions, bottom, screeenFetch, ...
│   ├── config/           # config files and folders
│   │   ├── atuin/
│   │   ├── bat/
│   │   ├── bottom/
│   │   ├── fastfetch/
│   │   ├── procs/
│   │   └── starship.toml
│   ├── bash_logout       # executed when login shell exits
│   ├── bash_profile      # used in login shells
│   ├── bashrc            # default user bashrc file
│   ├── gitconfig         # git aliases
│   └── gitignore_global  # global git ignored files
├── .install.conf.yaml    # dotbot install config
├── install               # dotfiles install script
└── uptade                # repo update script
```

## Installation with Dotbot 🚀

1. **Clone the repository:**

    ```bash
    git clone https://github.com/inigochoa/dotfiles-server.git dotfiles
    cd dotfiles
    ```

1. Run Dotbot to install the dotfiles:

    ```bash
    ./install
    ```

## Customization & Usage 🎨

- **Shell Configurations:**

    All Bash configurations are organized in bashrc.d/. Customize each file
    individually to tailor your shell experience.

- **Tool Settings:**

    Tool-specific configuration files are located in the config/ directory.
    Update these as needed to change themes, shortcuts, and other preferences.

- **Git Settings:**

    The gitconfig and gitignore_global files contain your Git settings and
    global ignore rules to maintain a consistent development environment.

## Contributing & Feedback 🤝

If you have suggestions or improvements, feel free to open an issue or submit a
pull request. Let's keep these dotfiles evolving!

[dotbot]: https://github.com/anishathalye/dotbot
[atuin]: https://atuin.sh/
[bat]: https://github.com/sharkdp/bat
[bottom]: https://github.com/ClementTsang/bottom
[ctop]: https://github.com/bcicen/ctop
[dry]: https://moncho.github.io/dry/
[duf]: https://github.com/muesli/duf
[eza]: https://github.com/eza-community/eza
[fastfetch]: https://github.com/fastfetch-cli/fastfetch
[fzf]: https://github.com/junegunn/fzf
[git-delta]: https://github.com/dandavison/delta
[lnav]: https://lnav.org/
[onefetch]: https://onefetch.dev/
[procs]: https://github.com/dalance/procs
[starship]: https://starship.rs/
[zoxide]: https://github.com/ajeetdsouza/zoxide
