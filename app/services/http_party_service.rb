class HttpPartyService < ApplicationService
  include HTTParty

  base_uri ENV.fetch('USERS_API_URL', 'https://test-users-2020.herokuapp.com/api')

  def self.call(*args, &block)
    super
  end

  def handle
    self.class
  end
end
