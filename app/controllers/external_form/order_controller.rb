# frozen_string_literal: true

module ExternalForm
  class OrderController < ExternalForm::BaseController
    after_action :allow_iframe

    def new
      @order = ExternalForm::Order.new
    end

    def create
      @order = ExternalForm::Order.new(order_data)
      @order.register

      respond_with @order
    end

    def success; end

    def order_data
      params.require(:external_form_order).permit(
        :entity, :first_name, :last_name, :profession, :phone, :email, :email_confirmation,
        :administrative_area, :locality, :line_2, :line_1, :ref,
        :product, :quantity, :phone_confirmation
      )
    end

    def address_data(param_data)
      param_data.slice(:administrative_area, :locality, :line_2, :line_1, :ref)
    end
  end
end
