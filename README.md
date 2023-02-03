# Repository purpose

To provide a way of building a container image to build the [Uyuni documentation](https://github.com/uyuni-project/uyuni-docs), as it requires to install a big set of tools using `zypper`, `nvm`, `cpan`, `gem` etc.

Besides the container, a helper is provider so people that does not know anything about containers can easily use them.

This a result of [SUSE's Hack Week 22](https://hackweek.opensuse.org/22/projects/testing-gnu-slash-linux-distributions-on-uyuni)

# Repository structure

- `image` directory: Contains the Dockerfile, the `startup.sh` script for the container, and the `build-and-publish` helper (that can be used to build and publish the container after changing whatever is needed on the other two files)
- `uyuni-doc-helper`: The bash script that allows any contributor to build, inspect the outputs of the build procedure via HTTP and even get outputs if building from a git local clone.

# Requirements

## For everyone

- Have `podman` installed (recommended)

or

- Have `docker` installed and an alias `podman` that calls `docker` (for bash that means adding `alias docker='podman'` to the file `~/.alias`)


## For image maintainers

For publishing the image, you will need a [Docker Hub](https://hub.docker.com/) account, and then talk to [Julio González Gil](https://build.opensuse.org/users/juliogonzalezgil) to get added as maintainer at the Docker Hub.

We plan to move the images to [GitHub packages](https://docs.github.com/en/actions/publishing-packages/publishing-docker-images#publishing-images-to-github-packages) in the future.


