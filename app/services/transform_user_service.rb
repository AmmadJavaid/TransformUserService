class TransformUserService < ApplicationService
  def call
    response = FetchUserService.call
    return Result.new('Error in fetching users', status: response.code) unless response.success?

    users = build_users(response.parsed_response)
    transform!(users)
    Result.new('User transformed successully')
  rescue => e
    Result.new(e.message, status: 400)
  end

  private

  def transform!(users)
    File.open("trasformed.json", "w") do |f|
       f.write users.sort_by { |user| user.last_name }.to_json
    end
  end

  def build_users(users_hash)
    users = []
    users_hash.collect do |user_data|
      user = User.new(user_data)
      users << user if user.valid? && user.unique?(users)
    end

    users
  end
end
