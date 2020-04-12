# frozen_string_literal: true

class PrinterModel < ApplicationRecord
  has_many :printers, dependent: :nullify
end
