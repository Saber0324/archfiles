# How to use

## Dependencies

- Chezmoi
- Git

## Installation

In a clean Arch Linux installation,
optionally with the settings in my [user config.](user_configuration.json)
Run the following command:

```bash
chezmoi init --apply https://github.com/Saber0324/archfiles
```

It will clone the repository at `~/local/share/chezmoi/`,
run all the [scripts](.chezmoiscripts/) and apply the dotfiles.
