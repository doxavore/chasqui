# frozen_string_literal: true

class Printer < ApplicationRecord
  belongs_to :printer_model
  belongs_to :user
end
