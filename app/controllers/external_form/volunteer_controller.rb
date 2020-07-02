# frozen_string_literal: true

module ExternalForm
  class VolunteerController < ExternalForm::BaseController
    after_action :allow_iframe

    def new
      @user = User.new
      @user.address = Address.new
      @user.number_of_printers = 0
    end

    def create
      @user = User.new(user_data)
      if @user.save
        if @user.number_of_printers.to_i.positive?
          printer_model = PrinterModel.last
          (1..@user.number_of_printers.to_i).each do
            @user.printers.create!(name: @user.printer_type, printer_model: printer_model)
          end
        end

        comm = ActiveAdmin::Comment.new
        comm.resource = @user
        comm.body = "Rubro que desea trabajar: #{@user.work_area}"
        comm.author = User.admins.first
        comm.namespace = "admin"
        comm.save!
      end

      respond_with @user
    end

    def success; end

    def user_data
      params.require(:user).permit(
        :first_name, :last_name, :profession, :phone, :email, :email_confirmation,
        :product, :quantity, :phone_confirmation, :number_of_printers, :printer_type,
        :work_area, :password, :password_confirmation,
        address_attributes: %i[administrative_area locality line_2 line_1 ref]
      )
    end
  end
end
