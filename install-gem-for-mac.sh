#!/bin/sh
export PATH=`pwd`/vendor/rubygems/bin:$PATH
export RUBYLIB=`pwd`/vendor/rubygems/lib
export GEM_HOME=`pwd`/vendor/gem
gem environment
gem install bundler             --version="1.0.7"
gem install rack-flash          --version="0.1.1"
gem install i18n                --version="0.4.1"
gem install sinatra             --version="1.1.2"
gem install sinatra-r18n        --version="0.4.7.1"
gem install sinatra-content-for --version="0.2"
gem install dm-migrations       --version="1.0.2"
gem install dm-timestamps       --version="1.0.2"
gem install dm-validations      --version="1.0.2"
gem install dm-types            --version="1.0.2"
gem install dm-is-tree          --version="1.0.2"
gem install dm-tags             --version="1.0.2"
gem install dm-pager            --version="1.1.0"
gem install builder             --version="2.1.2"
gem install haml                --version="3.0.18"
gem install rake                --version="0.8.7"
gem install exceptional         --version="2.0.25"
gem install erubis              --version="2.6.6"
gem install activesupport       --version="3.0.0"
gem install dm-sqlite-adapter   --version="1.0.2"
