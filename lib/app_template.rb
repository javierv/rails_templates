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

gem 'rails3-generators', :group => :development

gem 'shoulda', :group => :test
gem 'factory_girl_rails', :group => :test
gem 'mocha', :group => :test
gem 'capybara', :group => :test
gem 'display_name'

run "bundle install"

def read_file(file)
  File.read(File.expand_path(file_path(file)))
end

def file_path(file)
  File.join(File.dirname(__FILE__), file)
end

# Layout
run "rm app/views/layouts/application.html.erb"
file "app/views/layouts/application.html.haml", read_file("application.html.haml")

# SASS
run "compass config --app rails --sass-dir app/stylesheets --css-dir public/stylesheets"
run "rm -r app/stylesheets/"
run "cp -R #{file_path("stylesheets")} app/"

# Templates
file "lib/templates/shoulda/model/model.rb",
  read_file("shoulda/model/model.rb")

file "lib/templates/active_record/model/model.rb",
  read_file("active_record/model/model.rb")

file "lib/templates/test_unit/scaffold/functional_test.rb",
  read_file("test_unit/scaffold/functional_test.rb")

file "lib/templates/rails/scaffold_controller/controller.rb",
  read_file("rails/scaffold_controller/controller.rb")

run "cp -R #{file_path("haml")} lib/templates/"

file "lib/templates/simple_form/scaffold/_form.html.haml.erb",
  read_file("simple_form/scaffold/_form.html.haml.erb")

run "cp -R #{file_path("shared")} app/views/"
run "cp -R #{file_path("javascripts/markitup")} public/javascripts/"
file "public/javascripts/form.js", read_file("javascripts/form.js")
# Gitignore
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore public/stylesheets/.gitignore"

# ¿Habrá forma de añadir sólo las 2 últimas líneas al final de un fichero ya existente?
run "rm .gitignore"
file  ".gitignore", read_file("gitignore")

# Logo e índice no necesitados
run "rm public/images/rails.png"
run "rm public/index.html"

# Javascript
run "wget -O public/javascripts/jquery.js http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.js"
run "wget -O public/javascripts/rails.js http://github.com/rails/jquery-ujs/raw/master/src/rails.js"

# Traducciones
run "wget -O config/locales/es.yml http://github.com/svenfuchs/rails-i18n/raw/master/rails/locale/es.yml"

run "rm config/initializers/inflections.rb"
file  "config/initializers/inflections.rb", read_file("inflections.rb")
file "test/unit/pluralize_test.rb", read_file("pluralize_test.rb")

file  "app/helpers/layout_helper.rb", read_file("layout_helper.rb")

# Idioma de la aplicación
application "  config.time_zone  = 'Madrid'"
application "  config.i18n.default_locale = :es"

# Generadores por defecto
application "  config.generators do |g|
      g.stylesheets false
      g.helper false
      g.template_engine :haml
      g.test_framework :shoulda
      g.fixture_replacement :factory_girl
      g.form_builder :simple_form
      g.fallbacks[:shoulda] = :test_unit
    end"

# Commit
run "echo TODO > README"
git :init
git :add => "."
git :commit => "-m 'Primer commit'"
