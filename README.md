# Repository purpose

To provide a way of building a container image to build the [Uyuni documentation](https://github.com/uyuni-project/uyuni-docs), as it requires to install a big set of tools using `zypper`, `nvm`, `cpan`, `gem` etc.

Besides the container, a helper is provider so people that does not know anything about containers can easily use them.

This a result of [SUSE's Hack Week 22](https://hackweek.opensuse.org/22/projects/testing-gnu-slash-linux-distributions-on-uyuni)

# Repository structure

## For everyone
- `uyuni-docs-helper`: The bash script that allows any contributor to build, inspect the outputs of the build procedure via HTTP and even get outputs at the local system.

### Example

`./uyuni-docs-helper -r master -o /tmp/test -c obs-packages-mlm-en -p mlm` would build the HTML and PDFs for English language, from the `master` branch at https://github.com/uyuni-project/uyuni-docs (default repository), for SUSE Multi-Linux Manager.

## For image maintainers

- `image` directory: Contains the Dockerfile, the `startup.sh` script for the container, and the `build-locally` helper (that can be used to build the container locally for testing, passing arguments to the build, such as `--no-cache` is allowed). See below for more details
- `.github/workflows`: Contains the `build-and-publish-container-images.yml` workflow definition to build and publish the image to the GitHub Container registry after each change on the repository

# Requirements

## For everyone

- Have `podman` installed (recommended)

or

- Have `docker` installed and an alias `podman` that calls `docker` (for bash that means adding `alias docker='podman'` to the file `~/.alias`)

## macOS users

Install the package `gnu-getopt` via e.g. Homebrew (https://brew.sh):

```bash
brew install gnu-getopt
```

Get Podman ready

```bash
podman machine init
podman machine start
# verify the connection
podman system connection list
```

## For image maintainers

The image is built and published automatically to `ghcr.io/<PROJECT>/uyuni-docs-helper:<BRANCH>` after each push to any repository branch.

By default:
- `<PROJECT>` will be `uyuni-project`, unless you are working with your fork
- `<BRANCH>` will be the branch name that got the push, it's the tag for the container image

You can also build the image locally with the script at `images/build-locally`. In that case the image will be generated as `local/uyuni-docs-helper:latest` (notice `local` is here the project).

You can then use `uyuni-docs-helper` with the `-j` and `-t` parameters to specify the right tag and project.

# Troubleshooting

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
