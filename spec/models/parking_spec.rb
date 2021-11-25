require 'rails_helper'

RSpec.describe Parking, type: :model do
  describe ".validate_end_at_with_amount" do

    it "is invalid without amount" do
      parking = Parking.new :parking_type => "guest",
                            :start_at => Time.now - 6.hours,
                            :end_at => Time.now
                          
      expect(parking).to_not be_valid
    end

    it "is invalid without end_at" do
      parking = Parking.new :parking_type => "guest",
                            :start_at => Time.now - 6.hours,
                            :amount => 999

      expect(parking).to_not be_valid
    end
  end


  describe ".calculate_amount" do
    context "guest" do
      it "30 mins should be ¥2" do
        t = Time.now
        parking = Parking.new :parking_type => "guest", 
                              :start_at => t,
                              :end_at => t + 30.minutes
        parking.calculate_amount
        expect(parking.amount).to eq(200)
      end
  
      it "60 mins should be 2 yuan" do
        t = Time.now
        parking = Parking.new :parking_type => "guest", 
                              :start_at => t,
                              :end_at => t + 60.minutes
  
        parking.calculate_amount
        expect(parking.amount).to eq(200)
      end
  
      it "61 mins should be 3 yuan" do
        t = Time.now
        parking = Parking.new :parking_type => "guest",
                              :start_at => t,
                              :end_at => t + 61.minutes
        parking.calculate_amount
        expect(parking.amount).to eq(300)
      end
  
      it "90 mins should be 3 yuan" do
        t = Time.now
        parking = Parking.new :parking_type => "guest",
                              :start_at => t,
                              :end_at => t + 90.minutes
        parking.calculate_amount
        expect(parking.amount).to eq(300)
      end
  
      it "120 mins shoudl be 4 yuan" do
        t = Time.now
        parking = Parking.new :parking_type => "guest",
                              :start_at => t,
                              :end_at => t + 120.minutes
        parking.calculate_amount
        expect(parking.amount).to eq(400)
      end
  
    end

    context "short-term" do

      def create_parking_and_calculate_amount duration
        t = Time.now
        parking = Parking.new :parking_type => "short-term",
                              :start_at => t,
                              :end_at => t + duration.minutes
        parking.user = User.create(:email => "test@example.com", :password => "12345678")
        parking.calculate_amount
        parking
      end

      it "30 mins should be 2 yuan" do
        parking = create_parking_and_calculate_amount 30
        expect(parking.amount).to eq(200)
      end

      it "60 mins should be 2 yuan" do
        parking = create_parking_and_calculate_amount 60
        expect(parking.amount).to eq(200)
      end

      it "61 mins should be 2.5 yuan" do
        parking = create_parking_and_calculate_amount 61
        expect(parking.amount).to eq(250)
      end

      it "90 mins should be 2.5 yuan" do
        parking = create_parking_and_calculate_amount 90
        expect(parking.amount).to eq(250)
      end

      it "120 mins should be 3 yuan" do
        parking = create_parking_and_calculate_amount 120
        expect(parking.amount).to eq(300)
      end

    end


  end
end
