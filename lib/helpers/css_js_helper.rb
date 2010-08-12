module CssJsHelper
  def js_form
    markitup
    css 'form'
    javascript 'form'
  end

  def markitup
    css '/javascripts/markitup/skins/simple/style.css',
      '/javascripts/markitup/sets/textile/style.css'
    javascript 'markitup/jquery.markitup', 'markitup/sets/textile/set'
  end
end