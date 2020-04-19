# frozen_string_literal: true

ActiveAdmin.register PrinterModel do
  permit_params :name, :x_mm, :y_mm, :z_mm, :petg, :abs
end
