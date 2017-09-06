class Calculation < ApplicationRecord
  validates :base, presence: true
  validates :target, presence: true
  validates :amount, numericality: {only_float: true}
  validates :wait_time, inclusion: { in: 1..250 }
end
