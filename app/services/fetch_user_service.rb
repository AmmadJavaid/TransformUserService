class FetchUserService
  require 'httparty'

  USERS_API_URL = 'https://test-users-2020.herokuapp.com/api/users'
  AUTHORIZATION_TOKEN = 'abc123'

  def self.perform
    headers = {
      'Authorization' => AUTHORIZATION_TOKEN,
      "Content-Type"  => 'application/json'
    }

    response = HTTParty.get(USERS_API_URL, headers: headers)

    if response.success?
      response.parsed_response
    else
      raise StandardError.new('Error in consuming users api')
    end
  end
end
