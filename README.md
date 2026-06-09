# Repository purpose

To provide a way of building a container image to build the [Uyuni documentation](https://github.com/uyuni-project/uyuni-docs) for the legacy documentation branches that still use this helper.

Besides the container, a helper is provider so people that does not know anything about containers can easily use them.

This a result of [SUSE's Hack Week 22](https://hackweek.opensuse.org/22/projects/testing-gnu-slash-linux-distributions-on-uyuni)

# Which toolchain to use

The `uyuni-docs` repository has moved to the new `task` + `make` toolchain for current development branches.

- `master`: use the new toolchain in `uyuni-docs`
- `manager-5.1`: use the new toolchain in `uyuni-docs`
- `manager-5.0`: use `uyuni-docs-helper`
- `manager-4.3`: use `uyuni-docs-helper`

Uyuni is built from `master`, so Uyuni documentation builds also use the new `task` toolchain.

For the new workflow, use the setup guides in `uyuni-docs`:

- [Container Build Setup](https://github.com/uyuni-project/uyuni-docs/blob/master/docs/container-setup.md)
- [Local Toolchain Setup](https://github.com/uyuni-project/uyuni-docs/blob/master/docs/local-toolchain-setup.md)

# Repository structure

## For everyone
- `uyuni-docs-helper`: The bash script that allows any contributor to build, inspect the outputs of the build procedure via HTTP and even get outputs at the local system.

### Example

`./uyuni-docs-helper -r manager-5.0 -o /tmp/test -c obs-packages-mlm-en -p mlm` would build the HTML and PDFs for English language, from the `manager-5.0` branch at https://github.com/uyuni-project/uyuni-docs (default repository), for SUSE Multi-Linux Manager.

Do not use this helper for `master` or `manager-5.1`; those branches now use the upstream `task`-based toolchain documented above.

## For image maintainers

- `image` directory: Contains the Dockerfile, the `startup.sh` script for the container, and the `build-locally` helper (that can be used to build the container locally for testing, passing arguments to the build, such as `--no-cache` is allowed). See below for more details
- `.github/workflows`: Contains the `build-and-publish-container-images.yml` workflow definition to build and publish the image to the GitHub Container registry after each change on the repository
- build targets are `x86_64` (`amd64`) and `arm64`

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
