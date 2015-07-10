FROM ubuntu

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
    xvfb \
    curl \
    ca-certificates \
    libqt5webkit5-dev \
    qt5-default && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# Get the rvm signing key
RUN mkdir /tmp/gpg
WORKDIR /tmp/gpg
RUN chmod 700 /tmp/gpg && \
  gpg --homedir /tmp/gpg --keyserver keys.gnupg.net --recv D39DC0E3 && \
  gpg --homedir /tmp/gpg --export 409B6B1796C275462A1703113804BB82D39DC0E3 | gpg --import - && \
  rm -rf /tmp/gpg
WORKDIR /

ADD https://raw.githubusercontent.com/wayneeseguin/rvm/master/binscripts/rvm-installer /rvm-installer
ADD https://raw.githubusercontent.com/wayneeseguin/rvm/master/binscripts/rvm-installer.asc /rvm-installer.asc
RUN gpg --verify /rvm-installer.asc

RUN bash rvm-installer stable
RUN bash -l -c 'rvm install ruby-2.2.0'

RUN mkdir /test
WORKDIR /test
ADD Gemfile /test/Gemfile
RUN bash -l -c 'bundle install'
ADD test_capybara_webkit.rb /test/capybara_webkit.rb

CMD ["bash", "-l", "-c", "bundle console < ./capybara_webkit.rb"]
