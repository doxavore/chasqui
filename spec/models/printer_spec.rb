# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Printer, type: :model do
  let(:user) { create(:user) }
  let(:printer_model) { create(:printer_model) }
  subject { create(:printer, user: user, printer_model: printer_model) }
  it 'can belong to a printer_model' do
    expect(subject.printer_model_id).to eq(printer_model.id)
  end

  it 'can belong to a user' do
    subject
    expect(user.printers.count).to eq(1)
  end
end
