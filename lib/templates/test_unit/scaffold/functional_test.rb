# encoding: utf-8

require 'test_helper'

class <%= controller_class_name %>ControllerTest < ActionController::TestCase
  tests <%= controller_class_name %>Controller

  setup do
    @<%= singular_name %> = Factory(:<%= singular_name %>)
  end

  context "index action" do
    setup do
      get :index
    end

    should respond_with(:success)
    should assign_to(:<%= plural_name %>)
  end

  context "new action" do
    setup do
      get :new
    end
    should render_template :new
  end

  context "create action" do
    context "when model is invalid" do
      setup do
        errors = ActiveModel::Errors.new(<%= class_name %>.new)
        errors.add_on_blank(:id)
        <%= class_name %>.any_instance.stubs(:errors).returns(errors)
        <%= class_name %>.any_instance.stubs(:valid?).returns(false)
        post :create
      end

      should render_template :new
    end

    context "when model is valid" do
      setup do
        <%= class_name %>.any_instance.stubs(:errors).returns({})
        <%= class_name %>.any_instance.stubs(:valid?).returns(true)
        post :create
      end
      should redirect_to('') {<%= singular_name %>_path(assigns(:<%= singular_name %>))}
    end
  end

  context "show action" do
    setup do
      get :show, :id => @<%= singular_name %>.to_param
    end
    should respond_with(:success)
  end

  context "edit action" do
    setup do
      get :edit, :id => @<%= singular_name %>.to_param
    end
    should render_template 'edit'
  end

  context "update action" do
    context "when model is invalid" do
      setup do
        errors = ActiveModel::Errors.new(<%= class_name %>.new)
        errors.add_on_blank(:id)
        <%= class_name %>.any_instance.stubs(:errors).returns(errors)
        <%= class_name %>.any_instance.stubs(:valid?).returns(false)
        put :update, :id => @<%= singular_name %>.to_param, :<%= singular_name %> => @<%= singular_name %>.attributes
      end

      should render_template :edit
    end

    context "when model is valid" do
      setup do
        <%= class_name %>.any_instance.stubs(:errors).returns({})
        <%= class_name %>.any_instance.stubs(:valid?).returns(true)
        put :update, :id => @<%= singular_name %>.to_param, :<%= singular_name %> => @<%= singular_name %>.attributes
      end
      should redirect_to('') {<%= singular_name %>_path(@<%= singular_name %>)}
    end
  end

  context "destroy action" do
    setup do
      delete :destroy, :id => @<%= singular_name %>.to_param
    end

    should redirect_to('index') { <%= plural_name %>_path }
    should set_the_flash
    should "destroy model" do
      assert !<%= class_name %>.exists?(@<%= singular_name %>.id)
    end
  end
end
