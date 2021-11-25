require 'rails_helper'

RSpec.describe Parking, type: :model do
  describe ".validate_end_at_with_amount" do

    it "is invalid without end_at" do
      parking = Parking.new :parking_type => "guest",
                            :start_at => Time.now - 6.hours,
                            :amount => 999

      expect(parking).to_not be_valid
    end
  end

  describe ".calculate_amount" do
    before do
      @time = Time.new(2021, 11, 25, 8, 0, 0)
    end

    context "guest" do

      before do
        @parking = Parking.new :parking_type => "guest", :start_at => @time
      end

      it "30 mins should be ¥2" do
        @parking.end_at = @time + 30.minutes
        @parking.save
        expect(@parking.amount).to eq(200)
      end
  
      it "60 mins should be 2 yuan" do
        @parking.end_at = @time + 60.minutes
        @parking.save
        expect(@parking.amount).to eq(200)
      end
  
      it "61 mins should be 3 yuan" do
        @parking.end_at = @time + 61.minutes
        @parking.save
        expect(@parking.amount).to eq(300)
      end
  
      it "90 mins should be 3 yuan" do
        @parking.end_at = @time + 90.minutes
        @parking.save
        expect(@parking.amount).to eq(300)
      end
  
      it "120 mins shoudl be 4 yuan" do
        @parking.end_at = @time + 120.minutes
        @parking.save
        expect(@parking.amount).to eq(400)
      end
  
    end

    context "short-term" do

      before do
        @user = User.create(:email => "test@example.com", :password => "12345678")
        @parking = Parking.new :parking_type => "short-term", :user => @user, :start_at => @time
      end

      it "30 mins should be 2 yuan" do
        @parking.end_at = @time + 30.minutes
        @parking.save
        expect(@parking.amount).to eq(200)
      end

      it "60 mins should be 2 yuan" do
        @parking.end_at = @time + 60.minutes
        @parking.save
        expect(@parking.amount).to eq(200)
      end

      it "61 mins should be 2.5 yuan" do
        @parking.end_at = @time + 61.minutes
        @parking.save
        expect(@parking.amount).to eq(250)
      end

      it "90 mins should be 2.5 yuan" do
        @parking.end_at = @time + 90.minutes
        @parking.save
        expect(@parking.amount).to eq(250)
      end

      it "120 mins should be 3 yuan" do
        @parking.end_at = @time + 120.minutes
        @parking.save
        expect(@parking.amount).to eq(300)
      end
    end

    context "long-term" do
      before do
        @user = User.create email: 'test@example.com', password: '12345678'
        @parking = Parking.new parking_type: 'long-term', user: @user, start_at: @time
      end

      it "3 hours should be 12 yuan" do
        @parking.end_at = @time + 3.hours
        @parking.save
        expect(@parking.amount).to eq(1200)
      end

      it "6 hours should be 12 yuan" do
        @parking.end_at = @time + 6.hours
        @parking.save
        expect(@parking.amount).to eq(1200)
      end

      it "9 hours should be 16 yuan" do
        @parking.end_at = @time + 9.hours
        @parking.save
        expect(@parking.amount).to eq(1600)
      end

      it "24 hours should be 16 yuan" do
        @parking.end_at = @time + 1.day
        @parking.save
        expect(@parking.amount).to eq(1600)
      end

      it "25 hours should be 32 yuan" do
        @parking.end_at = @time + 25.hours
        @parking.save
        expect(@parking.amount).to eq(3200)
      end

      it "2 days should be 32 yuan" do
        @parking.end_at = @time + 2.days
        @parking.save
        expect(@parking.amount).to eq(3200)
      end

      it "50 hours should be 48 yuan" do
        @parking.end_at = @time + 50.hours
        @parking.save
        expect(@parking.amount).to eq(4800)
      end

    end
  end
end
