class Parking < ApplicationRecord
    belongs_to :user, :optional => true

    validates_presence_of :parking_type, :start_at
    validates_inclusion_of :parking_type, :in => %w(guest short-term long-term)

    validate :validate_end_at_with_amount

    before_validation :setup_amount

    def validate_end_at_with_amount
        if end_at.blank? && amount.present?
            errors.add(:end_at, "There must be an end time if there is an amout.")
        end
    end

    def duration
        (end_at - start_at) / 60
    end

    def setup_amount
        factor = (self.user.present?) ? 50 : 100

        if self.amount.blank? && self.start_at.present? && self.end_at.present?
            if self.user.blank?
                calculate_guest_term_amount
            elsif self.parking_type == "long-term"
                calculate_long_term_amount
            elsif self.parking_type == "short-term"
                calculate_short_term_amount
            end
        end
    end

    def calculate_guest_term_amount
        if duration <= 60
            self.amount = 200
          else
            self.amount = 200 + ((duration - 60).to_f / 30).ceil * 100
        end
    end

    def calculate_short_term_amount
        if duration <= 60
          self.amount = 200
        else
          self.amount = 200 + ((duration - 60).to_f / 30).ceil * 50
        end
    end

    def calculate_long_term_amount
        if duration <= 6 * 60
            self.amount = 1200
        else
            self.amount = (duration.to_f / (24 * 60)).ceil * 1600
        end
    end
end
