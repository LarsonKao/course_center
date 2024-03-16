class Course < ApplicationRecord
  has_many :course_assignments, dependent: :destroy
  has_many :teachers, through: :course_assignments
  has_many :course_registrations, dependent: :destroy
  has_many :students, through: :course_registrations

  validates :credit, numericality: { greater_than: 0 }

  WEEKDAYS = {
    1 => 'Mon',
    2 => 'Tue',
    3 => 'Wed',
    4 => 'Thu',
    5 => 'Fri',
    6 => 'Sat',
    7 => 'Sun'
  }
  TIME_SLOTS = {
    1 => '0800-0850',
    2 => '0900-0950',
    3 => '1000-1050',
    4 => '1100-1150',
    5 => '1200-1250',
    6 => '1300-1350',
    7 => '1400-1450',
    8 => '1500-1550',
    9 => '1600-1650',
    10 => '1700-1750',
    11 => '1800-1850'
  }

  def readable
    dup = self.dup
    dup[:id] = id
    readable_sche = {}
    schedules.each do |day, slots|
      readable_sche[WEEKDAYS[day.to_i]] = slots.map { |slot| TIME_SLOTS[slot.to_i] }
    end
    dup[:schedules] = readable_sche
    dup
  end
end
