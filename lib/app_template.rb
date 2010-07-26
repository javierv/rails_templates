#Gems
gem "inherited_resources"
gem "acts-as-taggable-on"
gem "will_paginate"
gem "searchlogic"
gem "formtastic"
gem "validation_reflection"
gem "paperclip"
gem "RedCloth", :lib => "redcloth"
gem "haml"
gem "compass"
# gem "compass-susy-plugin", :lib => 'susy'
gem "shoulda"
gem "webrat"
gem "factory_girl"
gem "mocha"

rake "gems:install", :sudo => true

# Layout + HAML + SASS
run "haml --rails ."
run "script/generate nifty_layout --haml"
run "rm app/views/layouts/application.html.haml"
file "app/views/layouts/application.html.haml", <<-HAML
!!! Strict
%html{html_attrs(I18n.locale)}

  %head
    %title= h(yield(:title) || "Untitled")
    %meta{"http-equiv"=>"Content-Type", :content=>"text/html; charset=utf-8"}
    = stylesheet_link_tag 'application'
    = javascript_tag "var AUTH_TOKEN = \#{form_authenticity_token.inspect};" if protect_against_forgery?
    = javascript_include_tag "jquery", "application"
    = yield(:head)

  %body
    - flash.each do |name, msg|
      = content_tag :div, msg, :id => "flash_\#{name}"
      
    - if show_title?
      %h1=h yield(:title)

    = yield
HAML
run "rm -r public/stylesheets/sass"
run "compass --rails --sass-dir app/stylesheets --css-dir public/stylesheets ."
run "rm app/stylesheets/*.sass"
run "mkdir app/stylesheets/partials"

file "app/stylesheets/partials/_base.sass", <<-CSS
# @import susy/susy.sass # TODO: descomentar cuando SUSY deje de estar roto (se rompió con el cambio a gemcutter).
!extension = ""

=font-face(!font,!filename, !type = "opentype")
  font-family:  \#{!font}
  src: url("fonts/\#{!filename}.eot")
  @if !type == "opentype"
    !extension = "otf"
  @else
    !extension = "ttf"

  src: local("\#{!font} Regular"), local("\#{!font}-Regular"), local("\#{!font}"), url("fonts/\#{!filename}.\#{!extension}") format("\#{!type}")
CSS
file "app/stylesheets/application.sass", <<-CSS
@import partials/base.sass
@import form.sass

*
  padding:          0
  margin:           0
  font-family:      helvetica, arial, verdana, sans-serif
  font-size:        1em

html
  background-color: #4b7399

body
  padding:          0.5em 1%
  margin:           1em auto
  font-size:        0.85em
  width:            80em
  max-width:        98%
  border:           solid 1px black
  background-color: #fdfdfd
  color:            #333


a img
  border:           none

#flash_notice,
#flash_error
  padding:          5px 8px
  margin:           10px 0

#flash_notice
  background-color: #CFC
  border:           1px solid #6C6

#flash_error
  background-color: #FCC
  border:           solid 1px #C66

.fieldWithErrors
  display:          inline
CSS

# Formtastic
generate :formtastic
run "rm public/stylesheets/*.css"
run "wget -O app/stylesheets/partials/_formtastic_base.sass http://github.com/activestylus/formtastic-sass/raw/master/_formtastic_base.sass"
file "app/stylesheets/form.sass", <<-CSS
@import partials/formtastic_base.sass
.formtastic
    +float-form
CSS

# Base de datos
app_name = `pwd`.split('/').last.strip

run "rm config/database.yml"
file "config/database.yml", <<-FILE
development:
  adapter: mysql
  database: #{app_name}_development
  encoding: utf8
 
test:
  adapter: mysql
  database: #{app_name}_test
  encoding: utf8
 
production:
  username: root
  password: password
  adapter: mysql
  database: #{app_name}_production
  pool: 5
  encoding: utf8
FILE
rake "db:create:all"
run "cp config/database.yml config/example_database.yml"

#Git ignore
file ".gitignore", <<-END
log/*.log
nbproject/private/*
nbproject/*
coverage/*
tmp/**/*
tmp/*.html
public/stylesheets/*.css
config/database.yml
.DS_Store
webrat-*.html
db/*.sqlite3
END
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore public/stylesheets/.gitignore"

# Imágenes y Javascript
run "rm public/images/rails.png"
run "rm -f public/javascripts/*"
run "wget -O public/javascripts/jquery.js http://jqueryjs.googlecode.com/files/jquery-1.3.2.js"
file "public/javascripts/application.js", <<-JS
$.extend({URLEncode:function(c){var o='';var x=0;c=c.toString();var r=/(^[a-zA-Z0-9_.]*)/;
  while(x<c.length){var m=r.exec(c.substr(x));
    if(m!=null && m.length>1 && m[1]!=''){o+=m[1];x+=m[1].length;
    }else{if(c[x]==' ')o+='+';else{var d=c.charCodeAt(x);var h=d.toString(16);
    o+='%'+(h.length<2?'0':'')+h.toUpperCase();}x++;}}return o;},
URLDecode:function(s){var o=s;var binVal,t;var r=/(%[^%]{2})/;
  while((m=r.exec(o))!=null && m.length>1 && m[1]!=''){b=parseInt(m[1].substr(1),16);
  t=String.fromCharCode(b);o=o.replace(m[1],t);}return o;}
});
 
$(document).ajaxSend(function(event, request, settings) {
    if (typeof(AUTH_TOKEN) == "undefined") return;
    if (settings.type == 'GET' || settings.type == 'get') return;
    settings.data = settings.data || "";
    settings.data += (settings.data ? "&" : "") + "authenticity_token=" + $.URLEncode(AUTH_TOKEN);
    request.setRequestHeader("Content-Type", settings.contentType);
});

$(document).ready( function()
{
  // Sustituye al método de confirmar borrado que hace Prototype por defecto en
  // el scaffold de Rails
  function confirm_destroy(action)
  {
    if (confirm('Are you sure?'))
    {
      $form = $('<form></form>')
       .attr('method', 'post')
       .attr('action', action)
       .append( $('<input />')
                .attr('type', 'hidden')
                .attr('name', '_method')
                .val('delete')
              )
       .append( $('<input />')
                .attr('type', 'hidden')
                .attr('name', 'authenticity_token')
                .val(AUTH_TOKEN)
              )
       .appendTo('body')
       .submit();
    }

  }

  $('a.destroy').click( function()
  {
    confirm_destroy(this.href.replace("/confirm_destroy", ""));
    return false;
  });
});
JS

# Traducciones
run "wget -O config/locales/es.yml http://github.com/svenfuchs/rails-i18n/raw/master/rails/locale/es.yml"
file  "config/initializers/inflections.rb", <<-PLURALES
ActiveSupport::Inflector.inflections do |inflect|
  inflect.plural /([^aeiouáéó])$/i, '\\1es'
  inflect.singular /(.*)es$/i, '\\1'
 
  inflect.plural /(.*)z$/i, '\\1ces'
  inflect.singular /(.*)ces$/i, '\\1z'
 
  vocales = {'a' => 'á', 'e' => 'é', 'i' => 'í', 'o' => 'ó', 'u' => 'ú'}
  vocales.each do |vocal_sin_acento, vocal_con_acento|
    ['n', 's'].each do |consonante|
      final_singular = vocal_con_acento + consonante
      final_plural = vocal_sin_acento + consonante + 'es'
      inflect.plural /(.*)\#{final_singular}$/i, '\\1' + final_plural
      #La siguiente línea la comento porque los nombres de tablas no tienen acentos
      #inflect.singular /(.*)\#{final_plural}$/i, '\\1' + final_singular
    end
  end
 
  inflect.irregular 'post', 'posts'
  inflect.irregular 'tagging', 'taggings'
  inflect.irregular 'tag', 'tags'
  inflect.irregular 'session', 'sessions'
  inflect.irregular 'job', 'jobs'
#   inflect.uncountable %w( fish sheep )
end
PLURALES

# Commit
run "echo TODO > README"
git :init
git :add => "."
git :commit => "-m 'Primer commit'"
