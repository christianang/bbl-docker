FROM cfinfrastructure/minimal
MAINTAINER https://github.com/christianang/bbl-docker

RUN \
      apt-get update && \
      apt-get -qqy install --fix-missing \
            awscli \
      && \
      apt-get clean

# Install ruby-install
RUN curl https://codeload.github.com/postmodern/ruby-install/tar.gz/v0.5.0 | tar xvz -C /tmp/ && \
          cd /tmp/ruby-install-0.5.0 && \
          make install

# Install Ruby
RUN ruby-install ruby 2.2.4 -- --disable-install-rdoc

# Add ruby to PATH
ENV PATH $PATH:/home/root/.gem/ruby/2.2.4/bin:/opt/rubies/ruby-2.2.4/lib/ruby/gems/2.2.4/bin:/opt/rubies/ruby-2.2.4/bin

# Set permissions on ruby directory
RUN chmod -R 777 /opt/rubies/

# Install bundler
RUN /opt/rubies/ruby-2.2.4/bin/gem install bundler --no-rdoc --no-ri

# Install bosh-init
RUN wget -P /usr/bin https://s3.amazonaws.com/bosh-init-artifacts/bosh-init-0.0.98-linux-amd64 && \
  mv /usr/bin/bosh-init-0.0.98-linux-amd64 /usr/bin/bosh-init && \
  chmod +x /usr/bin/bosh-init

# Install bbl
RUN wget -P /usr/bin https://github.com/cloudfoundry/bosh-bootloader/releases/download/v1.1.0/bbl-v1.1.0_linux_x86-64 && \
  mv /usr/bin/bbl-v1.1.0_linux_x86-64 /usr/bin/bbl && \
  chmod +x /usr/bin/bbl
