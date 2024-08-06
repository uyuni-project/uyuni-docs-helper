FROM opensuse/leap:15.5
MAINTAINER Julio Gonzalez Gil <jgonzalez@suse.com>

ARG REGULARUSER=docs

ENV GITREPO=https://github.com/uyuni-project/uyuni-docs.git
ENV GITREF=master
ENV PRODUCT=uyuni
ENV COMMAND=all-uyuni
ENV SERVE=0

USER root
RUN groupadd ${REGULARUSER} && \
    useradd -d /home/${REGULARUSER} -m ${REGULARUSER}

# All instructions extracted from
# https://github.com/uyuni-project/uyuni-docs/wiki/Install-the-latest-documentation-toolchain

# Base requirements
RUN zypper -q -n ref && \
    zypper -q -n in glibc-locale git gzip npm zip && \
    zypper -q -n in -t pattern devel_C_C++ devel_python3 devel_perl

# Install Ruby for building PDF’s
RUN zypper -q -n in libyaml-devel sqlite3-devel readline-devel libopenssl-devel

USER ${REGULARUSER}

RUN git clone --depth 1 https://github.com/rbenv/rbenv.git ~/.rbenv && \
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc && \
    source ~/.bashrc && \ 
    git clone --depth 1 https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build && \
    rbenv install 3.2.0 && \
    rbenv global 3.2.0
# End of Install Ruby for building PDF’s

# NVM and Node
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash && \
    source ~/.bashrc && \
    nvm install --lts && \
    nvm use --lts
# End of NVM and Node

# Antora 3.1 and Lunrjs extension
RUN source ~/.bashrc && \
    npm i -g @antora/cli@3.1 @antora/site-generator@3.1 && \
    npm i -g @antora/lunr-extension
    npm i -g asciidoctor @asciidoctor/tabs
# End of Antora 3.1 and Lunrjs extension

USER ${REGULARUSER}
# Asciidoctor
RUN source ~/.bashrc && gem install asciidoctor -v 2.0.18

# Asciidoctor-pdf
RUN source ~/.bashrc && \
    gem install asciidoctor-pdf -v 2.3.4 && \
    gem install rouge coderay rb-pygments concurrent-ruby asciidoctor-diagram

USER root
RUN zypper -q -n install GraphicsMagick GraphicsMagick-devel

USER ${REGULARUSER}
RUN source ~/.bashrc && gem install prawn-gmagick -v 0.0.9
# End of  Asciidoctor-pdf

# Po4a translation tools
USER root
RUN zypper -q -n in po4a

# Required po4a perl libraries
RUN cpan install Locale::gettext && \
    cpan install Text::WrapI18N && \
    cpan install Term::ReadKey && \
    cpan install Unicode::GCString

# Required python 3 libraries
RUN zypper -q -n install python3-Jinja2 python3-PyYAML

ADD startup.sh /usr/local/bin/startup.sh

USER ${REGULARUSER}

# Set locale
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US
ENV LC_ALL en_US.UTF-8

EXPOSE 8000
WORKDIR /home/docs
CMD /usr/local/bin/startup.sh
