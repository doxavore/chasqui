# frozen_string_literal: true

module ExternalForm
  class OrderController < ExternalForm::BaseController
    def new
      @order = ExternalForm::Order.new
    end

    def create
      @order = ExternalForm::Order.new(order_data)
      @order.register

      respond_with @order, location: "/"
    end

    def order_data
      params.require(:external_form_order).permit(
        :entity, :first_name, :last_name, :role, :phone, :email, :email_confirmation,
        :administrative_area, :locality, :line_2, :line_1, :ref,
        :product, :quantity, :phone_confirmation
      )
    end

    def address_data(param_data)
      param_data.slice(:administrative_area, :locality, :line_2, :line_1, :ref)
    end
  end
end
