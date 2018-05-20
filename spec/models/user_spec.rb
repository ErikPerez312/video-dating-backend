require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    it "is valid with valid attributes" do
      user = User.new(
        first_name: "Erik",
        last_name: "Perez",
        gender: 0,
        phone_number: "(111)111-1111",
        age: 20,
        seeking: 1,
        password: "testPass"
      )
      expect(user).to be_valid
    end

    it "is invalid without a first name" do
      bad_user = User.new(
        first_name: nil,
        last_name: "Perez",
        gender: 0,
        phone_number: "(111)111-1111",
        age: 20,
        seeking: 1,
        password: "testPass"
      )
      expect(bad_user).to_not be_valid
    end

    it "is invalid without a last name" do
      bad_user = User.new(
        first_name: "Erik",
        last_name: nil,
        gender: 0,
        phone_number: "(111)111-1111",
        age: 20,
        seeking: 1,
        password: "testPass"
      )
      expect(bad_user).to_not be_valid
    end

    it "is invalid without a gender" do
      bad_user = User.new(
        first_name: "Erik",
        last_name: "perez",
        gender: nil,
        phone_number: "(111)111-1111",
        age: 20,
        seeking: 1,
        password: "testPass"
      )
      expect(bad_user).to_not be_valid
    end

    it "is invalid without a phone number" do
      bad_user = User.new(
        first_name: "Erik",
        last_name: "perez",
        gender: 0,
        phone_number: nil,
        age: 20,
        seeking: 1,
        password: "testPass"
      )
      expect(bad_user).to_not be_valid
    end

    it "is invalid without an age" do
      bad_user = User.new(
        first_name: "Erik",
        last_name: "perez",
        gender: 0,
        phone_number: "(111)111-1111",
        age: nil,
        seeking: 1,
        password: "testPass"
      )
      expect(bad_user).to_not be_valid
    end

    it "is invalid without a seeking value" do
      bad_user = User.new(
        first_name: "Erik",
        last_name: "perez",
        gender: 0,
        phone_number: "(111)111-1111",
        age: 20,
        seeking: nil,
        password: "testPass"
      )
      expect(bad_user).to_not be_valid
    end

    it "is invalid without a password" do
      bad_user = User.new(
        first_name: "Erik",
        last_name: "perez",
        gender: 0,
        phone_number: "(111)111-1111",
        age: 20,
        seeking: 1,
        password: nil
      )
    end
  end
end
