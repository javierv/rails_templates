module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { page_title.to_s }
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

  def css(*args)
    stylesheet *args
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