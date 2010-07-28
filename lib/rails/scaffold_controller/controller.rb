class <%= controller_class_name %>Controller < ApplicationController
  respond_to :html
  before_filter :find_<%= file_name %>, :only => :show, :edit, :update, :destroy

<% unless options[:singleton] -%>
  def index
    @<%= table_name %> = <%= orm_class.all(class_name) %>
    respond_with(@<%= table_name %>)
  end
<% end -%>

  def show    
    respond_with(@<%= file_name %>)
  end

  def new
    @<%= file_name %> = <%= orm_class.build(class_name) %>
    respond_with(@<%= file_name %>)
  end

  def edit
  end

  def create
    @<%= file_name %> = <%= orm_class.build(class_name, "params[:#{file_name}]") %>
    <%= "flash[:notice] = '#{class_name} was successfully created.' if " %>@<%= orm_instance.save %>
    respond_with(@<%= file_name %>)
  end

  def update
    <%= "flash[:notice] = '#{class_name} was successfully updated.' if " %>@<%= orm_instance.update_attributes("params[:#{file_name}]") %>
    respond_with(@<%= file_name %>)
  end

  def destroy
    @<%= orm_instance.destroy %>
    respond_with(@<%= file_name %>)
  end

private
  def find_<%= file_name %>
    @<%= file_name %> = <%= orm_class.find(class_name, "params[:id]") %>
  end
end
