# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  REGIONS = %w[
    Amazonas
    Áncash
    Apurímac
    Arequipa
    Ayacucho
    Cajamarca
    Callao
    Cusco
    Huancavelica
    Huánuco
    Ica
    Junín
    La\ Libertad
    Lambayeque
    Lima
    Loreto
    Madre\ de\ Dios
    Moquegua
    Pasco
    Piura
    Puno
    San\ Martín
    Tacna
    Tumbes
    Ucayali
  ].freeze

  def to_s
    "#{line_1}, #{line_2}, #{locality}, #{administrative_area} - #{country}"
  end
end
