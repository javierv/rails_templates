class <%= controller_class_name %>Controller < ApplicationController
  respond_to :html
  before_filter :find_<%= file_name %>, :only => :show, :edit, :update, :destroy
  before_filter :new_<%= file_name %>, :only => [:new, :create]
  before_filter :update_<%= file_name %>, :only => :update

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
    respond_with(@<%= file_name %>)
  end

  def edit
  end

  def create
    <%= "flash[:notice] = '#{class_name} was successfully created.' if " %>@<%= orm_instance.save %>
    respond_with(@<%= file_name %>)
  end

  def update
    <%= "flash[:notice] = '#{class_name} was successfully updated.' if " %>@<%= orm_instance.save %>
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

  def new_<%= file_name %>
    @<%= file_name %> = <%= orm_class.build(class_name, "params[:#{file_name}]") %>
  end

  def update_<%= file_name %>
    @<%= file_name %>.attributes = params[:<%= file_name %>]
  end
end
