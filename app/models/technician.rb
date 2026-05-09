class Technician < ApplicationRecord
  has_many :work_orders, -> { order(:time) }, dependent: :destroy
end
