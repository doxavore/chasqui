# frozen_string_literal: true

ActiveAdmin.register Printer do
  permit_params :user_id, :printer_model_id, :name

  form do |f|
    f.inputs do
      f.input :name
      f.input :user
      f.input :printer_model
    end
    f.actions
  end
end
