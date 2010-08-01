class <%= controller_class_name %>Controller < ApplicationController
  respond_to :html

  before_filter :find_<%= file_name %>, :only => :show, :edit, :update, :destroy
  before_filter :new_<%= file_name %>, :only => [:new, :create]
  before_filter :update_<%= file_name %>, :only => :update

  after_filter :respond_with_<%= file_name %>, :except => :index

<% unless options[:singleton] -%>
  def index
    @search = <%= class_name %>.search params[:search]
    @<%= table_name %> = @search.paginate :page => params[:page],
      :per_page => <%= class_name %>.per_page
    respond_with @<%= table_name %>
  end
<% end -%>

  def show
  end

  def new
  end

  def edit
  end

  def create
    <%= "flash[:notice] = '#{class_name} se creó correctamente.' if " %>@<%= orm_instance.save %>
  end

  def update
    <%= "flash[:notice] = '#{class_name} se actualizó correctamente.' if " %>@<%= orm_instance.save %>
  end

  def destroy
    <%= "flash[:notice] = '#{class_name} se borró correctamente.' if " %>@<%= orm_instance.destroy %>
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

  def respond_with_<%= file_name %>
    respond_with @<%= file_name %>
  end
end
