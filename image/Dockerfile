FROM opensuse/leap:16.0
LABEL org.opencontainers.image.authors="jgonzalez@suse.com"

ARG REGULARUSER=docs

ENV GITREPO=https://github.com/uyuni-project/uyuni-docs.git
ENV GITREF=master
ENV PRODUCT=uyuni
ENV COMMAND=all-uyuni
ENV SERVE=0
ENV GEM_HOME="${REGULARUSER}/gems"
ENV PATH=$GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

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
    glibc-locale glibc-i18ndata git libyaml-devel readline-devel sqlite3-devel \
    # Python 3 and libraries
    python313-devel python3-Jinja2 python3-PyYAML \
    # Pearl
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
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \
    source ~/.bashrc && \
    nvm install --lts && \
    nvm use --lts

# Antora 3.1, Asciidoctor and Lunr.js extension
RUN source ~/.bashrc && \
    npm install -g npm@latest \
    @antora/cli@3.1 \
    @antora/site-generator@3.1\
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
    locale -a | grep -E "ja_JP|zh_CN|ko_KR|en_US"

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
WORKDIR /home/docs
CMD ["/usr/local/bin/startup.sh"]
