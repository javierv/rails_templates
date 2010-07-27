gem 'responders'
gem 'devise'
gem 'will_paginate', ">= 3.0.pre"
gem 'paperclip'
gem 'haml'
gem 'compass'
gem 'acts-as-taggable-on'
gem 'validation_reflection'
gem 'RedCloth'
gem 'validates_date_time'
gem 'simple_form'
gem 'meta_where'
gem 'meta_search'

gem 'rails3-generators', :group => :development

gem 'shoulda', :group => :test
gem 'factory_girl_rails', :group => :test
gem 'mocha', :group => :test
gem 'capybara', :group => :test

run "bundle install"

def read_file(file)
  File.read(File.expand_path(File.join(File.dirname(__FILE__), file)))
end

# Layout
run "rm app/views/layouts/application.html.erb"
file "app/views/layouts/application.html.haml", read_file("application.html.haml")

# SASS
run "compass config --app rails --sass-dir app/stylesheets --css-dir public/stylesheets"
run "rm app/stylesheets/*.sass"
run "mkdir app/stylesheets/partials"

file "app/stylesheets/partials/_base.sass", read_file("_base.sass")
file "app/stylesheets/partials/_utils.sass", read_file("_utils.sass")
file "app/stylesheets/application.sass", read_file("application.sass")

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
file  "app/helpers/layout_helper.rb", read_file("layout_helper.rb")

# Commit
run "echo TODO > README"
git :init
git :add => "."
git :commit => "-m 'Primer commit'"

# Generadores (aparte)
#config.generators do |g|
#  g.stylesheets false
#  g.template_engine :haml
#  g.test_framework :shoulda
#  g.fixture_replacement :factory_girl
#  g.form_builder :simple_form
#  g.fallbacks[:shoulda] = :test_unit 
#end