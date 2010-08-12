def generate_application
  install_gems
  configure_generators
  run_initializers
  configure_sass
  copy_templates
  copy_layout
  copy_helpers
  copy_javascripts
  remove_unneeded_files
  configure_spanish_language
  generate_readme
  configure_git
  first_commit
end

def read_file(file)
  File.read(File.expand_path(file_path(file)))
end

def file_path(file)
  File.join(File.dirname(__FILE__), file)
end

def install_gems
  gem 'devise'
  gem 'will_paginate', ">= 3.0.pre"
  gem 'paperclip'
  gem 'haml'
  gem 'compass'
  gem 'acts-as-taggable-on'
  gem 'validation_reflection'
  gem 'RedCloth'
  gem 'validates_date_time'
  gem 'simple_form', :git => 'git://github.com/javierv/simple_form.git'
  gem 'meta_where'
  gem 'meta_search'
  gem 'tabletastic', ">= 0.2.0pre4"
  gem 'display_name'

  install_development_gems
  install_test_gems
  run "bundle install"
end

def install_development_gems
  gem 'rails3-generators', :group => :development
end

def install_test_gems
  ['shoulda', 'factory_girl_rails', 'mocha', 'capybara'].each do |gem_name|
    gem gem_name, :group => :test
  end
end

def configure_generators
  application "  config.generators do |g|
      g.stylesheets false
      g.helper false
      g.template_engine :haml
      g.test_framework :shoulda
      g.fixture_replacement :factory_girl
      g.form_builder :simple_form
      g.fallbacks[:shoulda] = :test_unit
    end"
end

def run_initializers
  generate :"jquery:install"
  generate :"haml:install"
  generate :"simple_form:install"
end

def configure_sass
  run "compass config --app rails --sass-dir app/stylesheets --css-dir public/stylesheets"
  run "rm -r app/stylesheets/"
  run "cp -R #{file_path("stylesheets")} app/"
end

def copy_templates
  run "cp -R #{file_path("templates")} lib/"
  run "cp -R #{file_path("shared")} app/views/"
end

def copy_layout
  run "rm app/views/layouts/application.html.erb"
  file "app/views/layouts/application.html.haml", read_file("application.html.haml")
end

def copy_helpers
  run "cp #{file_path("helpers")}/* app/helpers/"
end

def copy_javascripts
  run "cp -R #{file_path("javascripts/markitup")} public/javascripts/"
  file "public/javascripts/form.js", read_file("javascripts/form.js")
end

def remove_unneeded_files
  run "rm public/images/rails.png"
  run "rm public/index.html"
end

def configure_spanish_language
  application "  config.time_zone  = 'Madrid'"
  application "  config.i18n.default_locale = :es"
  run "wget -O config/locales/es.yml http://github.com/svenfuchs/rails-i18n/raw/master/rails/locale/es.yml"
  run "rm config/initializers/inflections.rb"
  file  "config/initializers/inflections.rb", read_file("inflections.rb")
  file "test/unit/pluralize_test.rb", read_file("pluralize_test.rb")
end

def generate_readme
  run "echo TODO > README"
end

def configure_git
  run "touch tmp/.gitignore log/.gitignore vendor/.gitignore public/stylesheets/.gitignore"
  run "rm .gitignore"
  file  ".gitignore", read_file("gitignore")
end

def first_commit
  git :init
  git :add => "."
  git :commit => "-m 'Primer commit'"
end

generate_application