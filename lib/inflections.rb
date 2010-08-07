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
      inflect.plural /(.*)#{final_singular}$/i, '\\1' + final_plural
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
