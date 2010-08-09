class <%= class_name %> < ActiveRecord::Base
  attr_accessible <%= attributes.map { |a| ":#{a.name}" }.join(", ") %>
  <%- for attribute in attributes -%>
  validates :<%= attribute.name %>, :presence => true
  <%- end -%>
  display_name :<%= attributes.first.name %>
end