require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Validations" do
    it "is valid with valid attributes" do
      user = User.new(
        name: "Erik",
        phone_number: "(111)111-1111",
        age: 20,
        password: "testPass"
      )
      expect(user).to be_valid
    end

    it "is invalid without a name" do
      bad_user = User.new(
        name: nil,
        phone_number: "(111)111-1111",
        age: 20,
        password: "testPass"
      )
      expect(bad_user).to_not be_valid
    end

    it "is invalid without a phone number" do
      bad_user = User.new(
        name: "Erik",
        phone_number: nil,
        age: 20,
        password: "testPass"
      )
      expect(bad_user).to_not be_valid
    end

    it "is invalid without an age" do
      bad_user = User.new(
        name: "erik",
        phone_number: "(111)111-1111",
        age: nil,
        password: "testPass"
      )
      expect(bad_user).to_not be_valid
    end

    it "is invalid without a password" do
      bad_user = User.new(
        name: "Erik",
        phone_number: "(111)111-1111",
        age: 20,
        password: nil
      )
    end
  end
end
