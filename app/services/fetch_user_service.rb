class FetchUserService < HttpPartyService
  def initialize
    @headers = {
      'Authorization' => ENV.fetch('AUTHORIZATION_TOKEN', 'abc123'),
      "Content-Type"  => 'application/json'
    }
  end

  def call
    handle.get('/users', headers: @headers)
  end
end
