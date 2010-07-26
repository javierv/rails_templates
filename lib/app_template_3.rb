gem 'responders'
gem 'devise', ">= 1.1rc1"
gem 'will_paginate'
gem 'paperclip'
gem 'haml'
gem 'compass'
gem 'delayed_job'
gem 'acts-as-taggable-on'
gem 'validation_reflection'
gem 'RedCloth'
gem 'validates_date_time'
gem 'simple_form'
gem 'meta_where'
gem 'meta_search'

gem 'bullet', :group => :development
gem 'rails3-generators', :group => :development

gem 'shoulda', :group => :test
gem 'factory_girl_rails', :group => :test
gem 'mocha', :group => :test
gem 'capybara', :group => :test

run "bundle install"

# Layout
run "rm app/views/layouts/application.html.erb"
file "app/views/layouts/application.html.haml", <<-HAML
!!! Strict
%html{html_attrs(I18n.locale)}

  %head
    %title= h(yield(:title) || "Untitled")
    %meta{"http-equiv"=>"Content-Type", :content=>"text/html; charset=utf-8"}
    = stylesheet_link_tag 'application'
    = javascript_include_tag 'jquery', 'rails'
    = csrf_meta_tag
    = yield(:head)

  %body
    - flash.each do |name, msg|
      = content_tag :div, msg, :id => "flash_\#{name}"
      
    - if show_title?
      %h1= yield(:title)

    = yield
HAML

# SASS
run "compass config --app rails --sass-dir app/stylesheets --css-dir public/stylesheets"
run "rm app/stylesheets/*.sass"
run "mkdir app/stylesheets/partials"

file "app/stylesheets/partials/_base.sass", <<-CSS
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

file "app/stylesheets/partials/_utils.sass", <<-CSS
@import compass/utilities.sass

//** 
  removes all background images and colors from the element and offspring
  then adds a grid image of your choosing. highlights divs on modern browsers
=show-grid(!src)
  :background
    :image= image_url(!src)
    :repeat repeat 
    :position= side_gutter() + "% 0"
  *
    :background transparent
  div
    :background rgba(0,0,0,.125)

//**
  brings IE in line with inline-block display
  - using hacks if called automatically because !hacks == true
  - or without if you call it from ie.sass
=ie-inline-block(!hack = false)
  @if !hack
    /* ugly hacks for IE6-7 */
    :#display inline
    // fixes alignment against native input/button on IE6
    :#vertical-align auto
    /* end ugly hacks */
  @else
    :display inline
    // fixes alignment against native input/button on IE6
    :vertical-align auto

//**
  an override for compass inline-block that lets you take advantage
  of Susys !hacks constant. if true, hacks. if false, use ie-inline-block
  to help ie along in your ie.sass
=inline-block
  :display -moz-inline-box
  :-moz-box-orient vertical
  :display inline-block
  :vertical-align middle
  @if !hacks
    +ie-inline-block("*")

//** 
  an inline-block list that works in IE
  for those awkward moments when a floated horizontal list just wont cut it
  if global !hacks == false:
  - you'll need to fix list items in ie.sass with +ie-inline-block
=inline-block-list(!hpad = 0)
  +horizontal-list-container
  li
    +no-bullet
    :white-space no-wrap
    +inline-block
    :padding 
      :left= !hpad
      :right= !hpad

//** 
  hide an element from the viewport, but keep it around for accessability
=hide
  :position absolute
  :top -9999em

//** 
  a skip-to-content accessibility link that will appear on focus
  set the location arguments if you care where it appears
=skip-link(!t = 0, !r = false, !b = false, !l = false)
  +hide
  :display block
  &:focus
    @if !t
      :top= !t
    @if !r
      :right= !r
    @if !b
      :bottom= !b
    @if !l
      :left= !l
    :z-index 999

// EXPERIMENTAL

//**
  [Opacity rules based on those in Compass Core Edge as of 7.18.09]
  - These will be removed from Susy once they enter a major Compass release.
  Provides cross-browser css opacity.
  @param !opacity
    A number between 0 and 1, where 0 is transparent and 1 is opaque.
=opacity(!opacity)
  :opacity= !opacity
  :-moz-opacity= !opacity
  :-khtml-opacity= !opacity
  :-ms-filter= "progid:DXImageTransform.Microsoft.Alpha(Opacity=" + round(!opacity*100) + ")"
  :filter= "alpha(opacity=" + round(!opacity*100) + ")"
 
// Make an element completely transparent.
=transparent
  +opacity(0)
 
// Make an element completely opaque.
=opaque
  +opacity(1)

//**
  rounded corners for Mozilla, Webkit and the future
=border-radius(!r)
  /* Mozilla (FireFox, Camino)
  -moz-border-radius = !r
  /* Webkit (Safari, Chrome)
  -webkit-border-radius = !r
  -khtml-border-radius = !r
  /* CSS3
  border-radius = !r

=border-corner-radius(!vert, !horz, !r)
  /* Mozilla (FireFox, Camino)
  -moz-border-radius-\#{!vert}\#{!horz}= !r
  /* Webkit (Safari, Chrome)
  -webkit-border-\#{!vert}-\#{!horz}-radius= !r
  /* CSS3
  border-\#{!vert}-\#{!horz}-radius= !r

=border-top-left-radius(!r)
  +border-corner-radius("top", "left", !r)

=border-top-right-radius(!r)
  +border-corner-radius("top", "right", !r)

=border-bottom-right-radius(!r)
  +border-corner-radius("bottom", "right", !r)

=border-bottom-left-radius(!r)
  +border-corner-radius("bottom", "left", !r)

=border-top-radius(!r)
  +border-top-left-radius(!r)
  +border-top-right-radius(!r)

=border-right-radius(!r)
  +border-top-right-radius(!r)
  +border-bottom-right-radius(!r)

=border-bottom-radius(!r)
  +border-bottom-right-radius(!r)
  +border-bottom-left-radius(!r)

=border-left-radius(!r)
  +border-top-left-radius(!r)
  +border-bottom-left-radius(!r)

//**
  change the box model for Mozilla, Webkit, IE8 and the future
=box-sizing(!bs)
  /* Mozilla (FireFox, Camino)
  -moz-box-sizing= !bs
  /* Webkit (Safari, Chrome)
  -webkit-box-sizing= !bs
  /* IE (8)
  -ms-box-sizing= !bs
  /* CSS3
  box-sizing= !bs

//**
  box shadow for Webkit and the future
  - arguments are horizontal offset, vertical offset, blur and color
=box-shadow(!ho, !vo, !b, !c )
  /* Webkit (Safari, Chrome)
  -webkit-box-shadow= !ho !vo !b !c
  /* Mozilla (Firefox, Camino)
  -moz-box-shadow= !ho !vo !b !c
  /* CSS3
  box-shadow= !ho !vo !b !c


//**
  CSS3 columns for Mozilla, Webkit and the Future

=column-count(!n)
  :-moz-column-count= !n
  :-webkit-column-count= !n
  :column-count= !n

=column-gap(!u)
  :-moz-column-gap= !u
  :-webkit-column-gap= !u
  :column-gap= !u

=column-width(!u)
  :-moz-column-width= !u
  :-webkit-column-width= !u
  :column-width= !u

=column-rule-width(!w)
  :-moz-column-rule-width= !w
  :-webkit-column-rule-width= !w
  :column-rule-width= !w

=column-rule-style(!s)
  :-moz-column-rule-style= !s
  :-webkit-column-rule-style= !s
  :column-rule-style= !s

=column-rule-color(!c)
  :-moz-column-rule-color= !c
  :-webkit-column-rule-color= !c
  :column-rule-color= !c

=column-rule(!w, !s = "solid", !c = " ")
  +column-rule-width(!w)
  +column-rule-style(!s)
  +column-rule-color(!c)
CSS

file "app/stylesheets/application.sass", <<-CSS
@import partials/base.sass

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

# Gitignore
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore public/stylesheets/.gitignore"

# ¿Habrá forma de añadir sólo las 2 últimas líneas al final de un fichero ya existente?
run "rm .gitignore"
file  ".gitignore", <<-IGNORE
.bundle
db/*.sqlite3
log/*.log
tmp/**/*
nbproject/*
public/stylesheets/*.css
IGNORE

# Logo e índice no necesitados
run "rm public/images/rails.png"
run "rm public/index.html"

# Javascript
run "wget -O public/javascripts/jquery.js http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.js"
run "wget -O public/javascripts/rails.js http://github.com/rails/jquery-ujs/raw/master/src/rails.js"

# Traducciones
run "wget -O config/locales/es.yml http://github.com/svenfuchs/rails-i18n/raw/master/rails/locale/es.yml"

run "rm config/initializers/inflections.rb"
file  "config/initializers/inflections.rb", <<-PLURALES
# encoding: utf-8

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

file  "app/helpers/layout_helper.rb", <<-LAYOUT
module LayoutHelper
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    @stylesheets ||= []
    args.each do |stylesheet|
      if !@stylesheets.include?(stylesheet)
        content_for(:head) { stylesheet_link_tag(stylesheet) }
        @stylesheets << stylesheet
      end
    end
  end

  def javascript(*args)
    @javascripts ||= []
    args.each do |javascript|
      if !@javascripts.include?(javascript)
        content_for(:head) { javascript_include_tag(javascript) }
        @javascripts << javascript
      end
    end
  end
end
LAYOUT

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