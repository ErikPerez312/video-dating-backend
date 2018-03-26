require 'rails_helper'
#bundle exec rspec spec/requests
RSpec.describe "UserControllers", type: :request do
  describe "GET /user_controllers" do
    context "unauthorized" do
      before {
        get "/users"
      }
      it "fails when there is no authentication" do
        expect(response).to_not be_success
      end
    end

    context "authorized" do
      before {
        user = User.new(
          name: "erik",
          email: "erik@test.com",
          age: 20,
          phone_number: "1111111111",
          password: "testpassword"
        )
        user.save
        # Compose token for request
        full_token = "Token token=#{user.token}"

        get "/users", headers: { 'Authorization' => full_token }
      }
      it "succeeds when there is authentication" do
        expect(response).to be_success
      end
    end
  end

  # Test signing up a user
  describe "POST /user_controllers" do
    context "valid params" do
      before {
        valid_params = {
          name: "Erik",
          email: "Erik@test.com",
          password: "testpassword",
          age: 20,
          phone_number: "1111111111"
        }
        post "/users", params: valid_params
      }

      it "creates and sends success of creating a user with valid params" do
        expect(response).to be_success
      end
    end

    context "invalid params" do
      before {
        invalid_params = {
          email: "erik@test.com",
          password: "testpassword"
        }
        post "/users", params: invalid_params
      }

      it "should fail and send 400" do
        expect(response).to_not be_success
      end
    end
  end
end
