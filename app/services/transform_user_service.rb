class TransformUserService
  require 'httparty'

  USERS_API_URL = 'https://test-users-2020.herokuapp.com/api/users'
  AUTHORIZATION_TOKEN = 'abc123'

  class << self
    def run
      transform_users #rescue false
    end

    private

    def transform_users
      File.open("trasformed.json", "w") do |f|
         f.write build_users.sort_by { |user| user.last_name }.to_json
      end
    end

    def build_users
      result = []

      fetch_users.each do |user_data|
        user = User.new(user_data)
        result << user if user.valid? && user.unique?(result)
      end

      result
    end

    def fetch_users
      headers = {
        'Authorization' => AUTHORIZATION_TOKEN,
        "Content-Type"  => 'application/json'
      }

      response = HTTParty.get(USERS_API_URL, headers: headers)

      if response.success?
        response.parsed_response
      else
        raise StandardError.new('Error in fetching users')
      end
    end
  end
end
