FROM opensuse/leap:16.0@sha256:859560554b625c225fa767b76d61253d529b95d082c2d68579ad69168d5e3da7
LABEL org.opencontainers.image.authors="jgonzalez@suse.com"

ARG REGULARUSER=docs

ENV GITREPO=https://github.com/uyuni-project/uyuni-docs.git
ENV GITREF=master
ENV PRODUCT=uyuni
ENV COMMAND=all-uyuni
ENV SERVE=0
ENV GEM_HOME="/home/${REGULARUSER}/gems"
ENV PATH=$GEM_HOME/bin:$PATH

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN groupadd ${REGULARUSER} && \
    useradd -d /home/${REGULARUSER} -m ${REGULARUSER} -g ${REGULARUSER}

# All instructions extracted from
# https://github.com/uyuni-project/uyuni-docs/wiki/Install-the-latest-documentation-toolchain

RUN zypper -q -n refresh && \
    zypper -q -n update && \
    # Base requirements installable via patterns
    zypper -q -n install -t pattern devel_C_C++ && \
    zypper -q -n install \
    # Base requirements
    glibc-locale-base glibc-locale glibc-i18ndata git libyaml-devel readline-devel sqlite3-devel zip \
    # Python 3 and libraries
    python313-devel python313-Jinja2 python313-PyYAML \
    # Perl
    perl \
    # Ruby 3 for building PDFs
    libopenssl-devel ruby3.4 ruby3.4-devel ruby3.4-rubygem-bundler \
    # GraphicsMagick
    GraphicsMagick GraphicsMagick-devel \
    # Po4a translation tools
    po4a \
    && zypper clean

USER ${REGULARUSER}

# NVM and Node
# see https://docs.antora.org/antora/latest/install/linux-requirements/
# renovate: datasource=github-releases depName=nvm-sh/nvm
ARG NVM_VERSION=v0.40.3
ARG NVM_INSTALL_SHA256=2d8359a64a3cb07c02389ad88ceecd43f2fa469c06104f92f98df5b6f315275f
RUN curl -sL -o /tmp/nvm-install.sh "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" && \
    echo "${NVM_INSTALL_SHA256}  /tmp/nvm-install.sh" | sha256sum -c - && \
    bash /tmp/nvm-install.sh && \
    rm -f /tmp/nvm-install.sh && \
    source ~/.bashrc && \
    nvm install --lts && \
    nvm use --lts

# Antora 3.1, Asciidoctor and Lunr.js extension
RUN source ~/.bashrc && \
    npm install -g npm@11.4.1 \
    @antora/cli@3.1 \
    @antora/site-generator@3.1 \
    @antora/lunr-extension \
    @asciidoctor/tabs

USER root

# Required Po4a Perl libraries
RUN cpan install Locale::gettext \
    Text::WrapI18N \
    Term::ReadKey \
    Unicode::GCString

RUN localedef -i ja_JP -f UTF-8 ja_JP.UTF-8 && \
    localedef -i zh_CN -f UTF-8 zh_CN.UTF-8 && \
    localedef -i ko_KR -f UTF-8 ko_KR.UTF-8 && \
    localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    localedef -i en_US -f UTF-8 en && \
    locale -a | grep -E "ja_JP|zh_CN|ko_KR|en_US|en"

COPY startup.sh /usr/local/bin/startup.sh

USER ${REGULARUSER}

# Install Ruby gems
COPY Gemfile /home/${REGULARUSER}/Gemfile
WORKDIR /home/${REGULARUSER}
RUN bundle install

# Set locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US
ENV LC_ALL=en_US.UTF-8

EXPOSE 8000
WORKDIR /home/${REGULARUSER}
CMD ["/usr/local/bin/startup.sh"]
