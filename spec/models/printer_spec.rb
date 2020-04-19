# frozen_string_literal: true

require "rails_helper"

RSpec.describe Printer, type: :model do
  subject(:printer) { create(:printer, user: user, printer_model: printer_model) }

  let(:printer_model) { create(:printer_model) }
  let(:user) { create(:user) }

  describe "#printer_model" do
    it "has one printer model" do
      expect(printer.printer_model).to eq(printer_model)
    end

    it "must have a printer model" do
      expect { printer.update!(printer_model: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#user" do
    it "has one user" do
      printer
      expect(user.printers.count).to eq(1)
    end

    it "must have a user" do
      expect { printer.update!(user: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
