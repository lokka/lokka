#!/bin/sh
export PATH=`pwd`/vendor/rubygems/bin:$PATH
export RUBYLIB=`pwd`/vendor/rubygems/lib
export GEM_HOME=`pwd`/vendor/gem
gem environment
gem install bundler             --no-ri --no-rdoc --version="1.0.9"
gem install rack-flash          --no-ri --no-rdoc --version="0.1.1"
gem install i18n                --no-ri --no-rdoc --version="0.4.1"
gem install sinatra             --no-ri --no-rdoc --version="1.1.2"
gem install sinatra-r18n        --no-ri --no-rdoc --version="0.4.7.1"
gem install sinatra-content-for --no-ri --no-rdoc --version="0.2"
gem install dm-migrations       --no-ri --no-rdoc --version="1.0.2"
gem install dm-timestamps       --no-ri --no-rdoc --version="1.0.2"
gem install dm-validations      --no-ri --no-rdoc --version="1.0.2"
gem install dm-types            --no-ri --no-rdoc --version="1.0.2"
gem install dm-is-tree          --no-ri --no-rdoc --version="1.0.2"
gem install dm-tags             --no-ri --no-rdoc --version="1.0.2"
gem install dm-pager            --no-ri --no-rdoc --version="1.1.0"
gem install builder             --no-ri --no-rdoc --version="3.0.0"
gem install haml                --no-ri --no-rdoc --version="3.0.18"
gem install slim                --no-ri --no-rdoc --version="0.8.4"
gem install rake                --no-ri --no-rdoc --version="0.8.7"
gem install exceptional         --no-ri --no-rdoc --version="2.0.25"
gem install erubis              --no-ri --no-rdoc --version="2.6.6"
gem install activesupport       --no-ri --no-rdoc --version="3.0.0"
gem install dm-sqlite-adapter   --no-ri --no-rdoc --version="1.0.2"
