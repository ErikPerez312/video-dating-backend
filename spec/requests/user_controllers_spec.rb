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
          first_name: "Erik",
          last_name: "Perez",
          gender: "male",
          phone_number: "(111)111-1111",
          age: 20,
          password: "testPass"
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
          first_name: "Erik",
          last_name: "Perez",
          gender: "male",
          phone_number: "(111)111-1111",
          age: 20,
          password: "testPass"
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
          first_name: "test",
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
