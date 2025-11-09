class Volunteer < ApplicationRecord
  # Shifts stored as JSONB array
  validates :name, :email, :phone, :city, :date, :training, presence: true
  validates :waiver, acceptance: true
  validate :shift_selection_rules

  # Maximum slots per shift
  SHIFT_SLOTS = {
    "Friday 5PM–9PM (Setup & Event Support)" => 6,
    "Friday Float 5PM–9PM" => 1,
    "Saturday 7AM–12PM" => 6,
    "Saturday 11:30AM–4:30PM" => 6,
    "Saturday 4PM–9PM" => 6,
    "Saturday Float 9AM–2PM" => 1,
    "Saturday Float 2PM–7PM" => 1,
    "Sunday 8AM–12PM" => 6,
    "Sunday 11AM–3PM" => 6,
    "Sunday Float 9AM–2PM" => 1
  }

  private

  def shift_selection_rules
    return if shifts.blank?

    selected_shifts = shifts.is_a?(Array) ? shifts : []

    # Must be 2–3 shifts
    errors.add(:shifts, "must be 2–3 total") unless selected_shifts.size.between?(2, 3)

    # At least one Saturday shift
    errors.add(:shifts, "must include at least one Saturday shift") unless selected_shifts.any? { |s| s.start_with?("Saturday") }

    # Only one shift per day
    days = selected_shifts.map { |s| s.split.first }
    errors.add(:shifts, "cannot include more than one per day") unless days.uniq.size == selected_shifts.size

    # Check database counts for slot availability (PostgreSQL JSONB)
    selected_shifts.each do |shift|
      taken = Volunteer.where("shifts @> ?", [shift].to_json).count
      if taken >= SHIFT_SLOTS[shift]
        errors.add(:shifts, "#{shift} is full")
      end
    end
  end

  # Helper to calculate remaining spots for a shift
  def self.spots_left(shift)
    taken = Volunteer.where("shifts @> ?", [shift].to_json).count
    [SHIFT_SLOTS[shift] - taken, 0].max
  end
end

