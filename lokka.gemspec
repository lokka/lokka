# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{lokka}
  s.version = '0.1.1'

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ['Masaki KOMAGATA', 'Teppei Machida']
  s.date = %q{2010-11-21}
  s.default_executable = %q{lokka}
  s.description = %q{CMS written in Ruby for cloud computing.}
  s.email = %q{komagata@gmail.com}
  s.executables = ['lokka']
  s.extra_rdoc_files = [
    'LICENSE',
    'README.ja.rdoc',
    'README.rdoc'
  ]
  s.files = [
    'Gemfile',
    'LICENSE',
    'README.ja.rdoc',
    'README.rdoc',
    'Rakefile',
    'VERSION',
    'bin/autotest',
    'bin/bluefeather',
    'bin/convert_to_should_syntax',
    'bin/css2sass',
    'bin/edit_json.rb',
    'bin/erubis',
    'bin/exceptional',
    'bin/haml',
    'bin/html2haml',
    'bin/jeweler',
    'bin/lokka',
    'bin/prettify_json.rb',
    'bin/rackup',
    'bin/rake',
    'bin/rcov',
    'bin/sass',
    'bin/sass-convert',
    'bin/tilt',
    'bin/unit_diff',
    'config.ru',
    'config.yml',
    'i18n/en.yml',
    'i18n/ja.yml',
    'init.rb',
    'install.rb',
    'lib/lokka.rb',
    'lib/lokka/app.rb',
    'lib/lokka/before.rb',
    'lib/lokka/bread_crumb.rb',
    'lib/lokka/category.rb',
    'lib/lokka/comment.rb',
    'lib/lokka/entry.rb',
    'lib/lokka/helpers.rb',
    'lib/lokka/option.rb',
    'lib/lokka/site.rb',
    'lib/lokka/tag.rb',
    'lib/lokka/theme.rb',
    'lib/lokka/user.rb',
    'lib/sqlite3.dll',
    'lokka.exe',
    'lokka.exy',
    'lokka.gemspec',
    'lokka.ico',
    'lokka.rb',
    'public/admin/categories/edit.haml',
    'public/admin/categories/form.haml',
    'public/admin/categories/index.haml',
    'public/admin/categories/new.haml',
    'public/admin/comments/edit.haml',
    'public/admin/comments/form.haml',
    'public/admin/comments/index.haml',
    'public/admin/comments/new.haml',
    'public/admin/css/style.css',
    'public/admin/edit.haml',
    'public/admin/favicon.ico',
    'public/admin/images/add.png',
    'public/admin/images/aside_arrow.png',
    'public/admin/images/buttons.gif',
    'public/admin/images/category.png',
    'public/admin/images/comment.png',
    'public/admin/images/dashboard.png',
    'public/admin/images/file.png',
    'public/admin/images/files.png',
    'public/admin/images/mail-attachment.png',
    'public/admin/images/plugin.png',
    'public/admin/images/post.png',
    'public/admin/images/setting.png',
    'public/admin/images/tag.png',
    'public/admin/images/theme.png',
    'public/admin/images/toolbar.gif',
    'public/admin/images/user.png',
    'public/admin/index.haml',
    'public/admin/js/editor.js',
    'public/admin/js/jquery.cleditor.js',
    'public/admin/js/jquery.cleditor.min.js',
    'public/admin/layout.haml',
    'public/admin/pages/edit.haml',
    'public/admin/pages/form.haml',
    'public/admin/pages/index.haml',
    'public/admin/pages/new.haml',
    'public/admin/plugins/index.haml',
    'public/admin/posts/edit.haml',
    'public/admin/posts/form.haml',
    'public/admin/posts/index.haml',
    'public/admin/posts/new.haml',
    'public/admin/show.haml',
    'public/admin/signup.haml',
    'public/admin/site/edit.haml',
    'public/admin/tags/edit.haml',
    'public/admin/tags/form.haml',
    'public/admin/tags/index.haml',
    'public/admin/themes/index.haml',
    'public/admin/users/edit.haml',
    'public/admin/users/form.haml',
    'public/admin/users/index.haml',
    'public/admin/users/new.haml',
    'public/plugin/lokka-google_analytics/lib/lokka/google_analytics.rb',
    'public/plugin/lokka-google_analytics/views/index.haml',
    'public/plugin/lokka-hello/lib/lokka/hello.rb',
    'public/plugin/lokka-markdown/lib/lokka/markdown.rb',
    'public/plugin/lokka-rbconfig/lib/lokka/rbconfig.rb',
    'public/plugin/lokka-rbconfig/views/index.haml',
    'public/plugin/lokka-rbconfig/views/style.css',
    'public/system/404.haml',
    'public/system/500.haml',
    'public/system/comments/form.haml',
    'public/system/favicon.ico',
    'public/system/index.builder',
    'public/system/style.css',
    'public/theme/default/entries.erb',
    'public/theme/default/entry.erb',
    'public/theme/default/layout.erb',
    'public/theme/default/quote.gif',
    'public/theme/default/screenshot.png',
    'public/theme/default/style.css',
    'public/theme/jarvi/entries.erb',
    'public/theme/jarvi/entry.erb',
    'public/theme/jarvi/favicon.ico',
    'public/theme/jarvi/images/aside_dt.gif',
    'public/theme/jarvi/images/aside_dt.png',
    'public/theme/jarvi/images/footer.gif',
    'public/theme/jarvi/images/footer.psd',
    'public/theme/jarvi/images/header_deascription_ul.gif',
    'public/theme/jarvi/images/header_language.gif',
    'public/theme/jarvi/images/header_nav.gif',
    'public/theme/jarvi/images/html.gif',
    'public/theme/jarvi/images/index_content.gif',
    'public/theme/jarvi/images/index_content_footer.gif',
    'public/theme/jarvi/images/index_content_header.gif',
    'public/theme/jarvi/images/index_header_nav.gif',
    'public/theme/jarvi/images/section_header_title.gif',
    'public/theme/jarvi/images/wide_content.gif',
    'public/theme/jarvi/images/wide_content_body.gif',
    'public/theme/jarvi/images/wide_content_h3.gif',
    'public/theme/jarvi/layout.erb',
    'public/theme/jarvi/screenshot.png',
    'public/theme/jarvi/style.css',
    'public/theme/lokka-org/article.haml',
    'public/theme/lokka-org/entries.haml',
    'public/theme/lokka-org/entry.haml',
    'public/theme/lokka-org/favicon.ico',
    'public/theme/lokka-org/images/aside_dt.gif',
    'public/theme/lokka-org/images/aside_dt.png',
    'public/theme/lokka-org/images/download_button.jpg',
    'public/theme/lokka-org/images/footer.gif',
    'public/theme/lokka-org/images/footer.psd',
    'public/theme/lokka-org/images/header_capture.gif',
    'public/theme/lokka-org/images/header_capture.jpg',
    'public/theme/lokka-org/images/header_capture_a.gif',
    'public/theme/lokka-org/images/header_deascription_ul.gif',
    'public/theme/lokka-org/images/header_h1_a.gif',
    'public/theme/lokka-org/images/header_language.gif',
    'public/theme/lokka-org/images/header_nav.gif',
    'public/theme/lokka-org/images/heder_nav_home.gif',
    'public/theme/lokka-org/images/heder_nav_home.jpg',
    'public/theme/lokka-org/images/html.gif',
    'public/theme/lokka-org/images/index_content.gif',
    'public/theme/lokka-org/images/index_content_footer.gif',
    'public/theme/lokka-org/images/index_content_header.gif',
    'public/theme/lokka-org/images/index_header_h1.gif',
    'public/theme/lokka-org/images/index_header_nav.gif',
    'public/theme/lokka-org/images/language_a.png',
    'public/theme/lokka-org/images/section_header_title.gif',
    'public/theme/lokka-org/images/wide_content.gif',
    'public/theme/lokka-org/images/wide_content_body.gif',
    'public/theme/lokka-org/images/wide_content_h3.gif',
    'public/theme/lokka-org/index.haml',
    'public/theme/lokka-org/layout.haml',
    'public/theme/lokka-org/quote.gif',
    'public/theme/lokka-org/screenshot.png',
    'public/theme/lokka-org/style.css',
    'public/theme/p0t/article.haml',
    'public/theme/p0t/entries.haml',
    'public/theme/p0t/entry.haml',
    'public/theme/p0t/favicon.ico',
    'public/theme/p0t/images/quote.gif',
    'public/theme/p0t/layout.haml',
    'public/theme/p0t/screenshot.png',
    'public/theme/p0t/style.css',
    'public/theme/vicuna-mono/entries.erb',
    'public/theme/vicuna-mono/entry.erb',
    'public/theme/vicuna-mono/layout.erb',
    'public/theme/vicuna-mono/quote.gif',
    'public/theme/vicuna-mono/screenshot.png',
    'public/theme/vicuna-mono/style.css',
    'test/helper.rb',
    'test/lokka/app_test.rb',
    'test/lokka/post_test.rb'
  ]
  s.homepage = %q{http://github.com/lokka/lokka}
  s.licenses = ['MIT']
  s.require_paths = ['lib']
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{CMS for Cloud.}
  s.test_files = [
    'test/helper.rb',
    'test/lokka/app_test.rb',
    'test/lokka/post_test.rb'
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack-flash>, ['= 0.1.1'])
      s.add_runtime_dependency(%q<i18n>, ['= 0.4.1'])
      s.add_runtime_dependency(%q<sinatra>, '= 3.0.4')
      s.add_runtime_dependency(%q<sinatra-r18n>, ['= 0.4.7.1'])
      s.add_runtime_dependency(%q<sinatra-content-for>, ['= 0.2'])
      s.add_runtime_dependency(%q<dm-migrations>, ['= 1.0.2'])
      s.add_runtime_dependency(%q<dm-timestamps>, ['= 1.0.2'])
      s.add_runtime_dependency(%q<dm-validations>, ['= 1.0.2'])
      s.add_runtime_dependency(%q<dm-types>, ['= 1.0.2'])
      s.add_runtime_dependency(%q<dm-is-tree>, ['= 1.0.2'])
      s.add_runtime_dependency(%q<dm-tags>, ['= 1.0.2'])
      s.add_runtime_dependency(%q<dm-pager>, ['= 1.1.0'])
      s.add_runtime_dependency(%q<builder>, ['= 2.1.2'])
      s.add_runtime_dependency(%q<haml>, ['= 3.0.18'])
      s.add_runtime_dependency(%q<rake>, '= 12.3.3')
      s.add_runtime_dependency(%q<exceptional>, ['= 2.0.25'])
      s.add_runtime_dependency(%q<erubis>, ['= 2.6.6'])
      s.add_runtime_dependency(%q<activesupport>, '= 5.2.4.3')
      s.add_runtime_dependency(%q<bluefeather>, ['>= 0'])
      s.add_development_dependency(%q<dm-sqlite-adapter>, ['= 1.0.2'])
      s.add_development_dependency(%q<shoulda>, ['= 2.11.3'])
      s.add_development_dependency(%q<bundler>, ['~> 1.0.0'])
      s.add_development_dependency(%q<jeweler>, ['~> 1.5.1'])
      s.add_development_dependency(%q<rcov>, ['>= 0'])
      s.add_runtime_dependency(%q<rack-flash>, ['= 0.1.1'])
      s.add_runtime_dependency(%q<i18n>, ['= 0.4.1'])
      s.add_runtime_dependency(%q<sinatra>, '= 3.0.4')
      s.add_runtime_dependency(%q<sinatra-r18n>, ['= 0.4.7.1'])
      s.add_runtime_dependency(%q<sinatra-content-for>, ['= 0.2'])
      s.add_runtime_dependency(%q<dm-migrations>, ['= 1.0.2'])
      s.add_runtime_dependency(%q<dm-timestamps>, ['= 1.0.2'])
      s.add_runtime_dependency(%q<dm-validations>, ['= 1.0.2'])
      s.add_runtime_dependency(%q<dm-types>, ['= 1.0.2'])
      s.add_runtime_dependency(%q<dm-is-tree>, ['= 1.0.2'])
      s.add_runtime_dependency(%q<dm-tags>, ['= 1.0.2'])
      s.add_runtime_dependency(%q<dm-pager>, ['= 1.1.0'])
      s.add_runtime_dependency(%q<builder>, ['= 2.1.2'])
      s.add_runtime_dependency(%q<haml>, ['= 3.0.18'])
      s.add_runtime_dependency(%q<rake>, '= 12.3.3')
      s.add_runtime_dependency(%q<exceptional>, ['= 2.0.25'])
      s.add_runtime_dependency(%q<erubis>, ['= 2.6.6'])
      s.add_runtime_dependency(%q<activesupport>, '= 5.2.4.3')
      s.add_runtime_dependency(%q<bluefeather>, ['= 0.33'])
      s.add_runtime_dependency(%q<dm-sqlite-adapter>, ['= 1.0.2'])
    else
      s.add_dependency(%q<rack-flash>, ['= 0.1.1'])
      s.add_dependency(%q<i18n>, ['= 0.4.1'])
      s.add_dependency(%q<sinatra>, '= 3.0.4')
      s.add_dependency(%q<sinatra-r18n>, ['= 0.4.7.1'])
      s.add_dependency(%q<sinatra-content-for>, ['= 0.2'])
      s.add_dependency(%q<dm-migrations>, ['= 1.0.2'])
      s.add_dependency(%q<dm-timestamps>, ['= 1.0.2'])
      s.add_dependency(%q<dm-validations>, ['= 1.0.2'])
      s.add_dependency(%q<dm-types>, ['= 1.0.2'])
      s.add_dependency(%q<dm-is-tree>, ['= 1.0.2'])
      s.add_dependency(%q<dm-tags>, ['= 1.0.2'])
      s.add_dependency(%q<dm-pager>, ['= 1.1.0'])
      s.add_dependency(%q<builder>, ['= 2.1.2'])
      s.add_dependency(%q<haml>, ['= 3.0.18'])
      s.add_dependency(%q<rake>, '= 12.3.3')
      s.add_dependency(%q<exceptional>, ['= 2.0.25'])
      s.add_dependency(%q<erubis>, ['= 2.6.6'])
      s.add_dependency(%q<activesupport>, '= 5.2.4.3')
      s.add_dependency(%q<bluefeather>, ['>= 0'])
      s.add_dependency(%q<dm-sqlite-adapter>, ['= 1.0.2'])
      s.add_dependency(%q<shoulda>, ['= 2.11.3'])
      s.add_dependency(%q<bundler>, ['~> 1.0.0'])
      s.add_dependency(%q<jeweler>, ['~> 1.5.1'])
      s.add_dependency(%q<rcov>, ['>= 0'])
      s.add_dependency(%q<rack-flash>, ['= 0.1.1'])
      s.add_dependency(%q<i18n>, ['= 0.4.1'])
      s.add_dependency(%q<sinatra>, '= 3.0.4')
      s.add_dependency(%q<sinatra-r18n>, ['= 0.4.7.1'])
      s.add_dependency(%q<sinatra-content-for>, ['= 0.2'])
      s.add_dependency(%q<dm-migrations>, ['= 1.0.2'])
      s.add_dependency(%q<dm-timestamps>, ['= 1.0.2'])
      s.add_dependency(%q<dm-validations>, ['= 1.0.2'])
      s.add_dependency(%q<dm-types>, ['= 1.0.2'])
      s.add_dependency(%q<dm-is-tree>, ['= 1.0.2'])
      s.add_dependency(%q<dm-tags>, ['= 1.0.2'])
      s.add_dependency(%q<dm-pager>, ['= 1.1.0'])
      s.add_dependency(%q<builder>, ['= 2.1.2'])
      s.add_dependency(%q<haml>, ['= 3.0.18'])
      s.add_dependency(%q<rake>, '= 12.3.3')
      s.add_dependency(%q<exceptional>, ['= 2.0.25'])
      s.add_dependency(%q<erubis>, ['= 2.6.6'])
      s.add_dependency(%q<activesupport>, '= 5.2.4.3')
      s.add_dependency(%q<bluefeather>, ['= 0.33'])
      s.add_dependency(%q<dm-sqlite-adapter>, ['= 1.0.2'])
    end
  else
    s.add_dependency(%q<rack-flash>, ['= 0.1.1'])
    s.add_dependency(%q<i18n>, ['= 0.4.1'])
    s.add_dependency(%q<sinatra>, '= 3.0.4')
    s.add_dependency(%q<sinatra-r18n>, ['= 0.4.7.1'])
    s.add_dependency(%q<sinatra-content-for>, ['= 0.2'])
    s.add_dependency(%q<dm-migrations>, ['= 1.0.2'])
    s.add_dependency(%q<dm-timestamps>, ['= 1.0.2'])
    s.add_dependency(%q<dm-validations>, ['= 1.0.2'])
    s.add_dependency(%q<dm-types>, ['= 1.0.2'])
    s.add_dependency(%q<dm-is-tree>, ['= 1.0.2'])
    s.add_dependency(%q<dm-tags>, ['= 1.0.2'])
    s.add_dependency(%q<dm-pager>, ['= 1.1.0'])
    s.add_dependency(%q<builder>, ['= 2.1.2'])
    s.add_dependency(%q<haml>, ['= 3.0.18'])
    s.add_dependency(%q<rake>, '= 12.3.3')
    s.add_dependency(%q<exceptional>, ['= 2.0.25'])
    s.add_dependency(%q<erubis>, ['= 2.6.6'])
    s.add_dependency(%q<activesupport>, '= 5.2.4.3')
    s.add_dependency(%q<bluefeather>, ['>= 0'])
    s.add_dependency(%q<dm-sqlite-adapter>, ['= 1.0.2'])
    s.add_dependency(%q<shoulda>, ['= 2.11.3'])
    s.add_dependency(%q<bundler>, ['~> 1.0.0'])
    s.add_dependency(%q<jeweler>, ['~> 1.5.1'])
    s.add_dependency(%q<rcov>, ['>= 0'])
    s.add_dependency(%q<rack-flash>, ['= 0.1.1'])
    s.add_dependency(%q<i18n>, ['= 0.4.1'])
    s.add_dependency(%q<sinatra>, '= 3.0.4')
    s.add_dependency(%q<sinatra-r18n>, ['= 0.4.7.1'])
    s.add_dependency(%q<sinatra-content-for>, ['= 0.2'])
    s.add_dependency(%q<dm-migrations>, ['= 1.0.2'])
    s.add_dependency(%q<dm-timestamps>, ['= 1.0.2'])
    s.add_dependency(%q<dm-validations>, ['= 1.0.2'])
    s.add_dependency(%q<dm-types>, ['= 1.0.2'])
    s.add_dependency(%q<dm-is-tree>, ['= 1.0.2'])
    s.add_dependency(%q<dm-tags>, ['= 1.0.2'])
    s.add_dependency(%q<dm-pager>, ['= 1.1.0'])
    s.add_dependency(%q<builder>, ['= 2.1.2'])
    s.add_dependency(%q<haml>, ['= 3.0.18'])
    s.add_dependency(%q<rake>, '= 12.3.3')
    s.add_dependency(%q<exceptional>, ['= 2.0.25'])
    s.add_dependency(%q<erubis>, ['= 2.6.6'])
    s.add_dependency(%q<activesupport>, '= 5.2.4.3')
    s.add_dependency(%q<bluefeather>, ['= 0.33'])
    s.add_dependency(%q<dm-sqlite-adapter>, ['= 1.0.2'])
  end
end

