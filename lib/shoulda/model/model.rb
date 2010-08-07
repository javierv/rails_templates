require 'test_helper'

class <%= class_name %>Test < ActiveSupport::TestCase
  <%- for attribute in attributes -%>
    should validate_presence_of(:<%= attribute.name %>)
    should allow_mass_assignment_of(:<%= attribute.name %>)
  <%- end -%>
end