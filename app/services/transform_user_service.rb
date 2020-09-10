class TransformUserService
  class << self
    def perform
      result = FetchUserService.perform
      transform!(build_users(result))

      [true, "Transformed user store at: #{Rails.root}/trasformed.json"]
    rescue => e
      [false, e.message]
    end

    private

    def transform!(users)
      File.open("trasformed.json", "w") do |f|
         f.write users.sort_by { |user| user.last_name }.to_json
      end
    end

    def build_users(users_hash)
      result = []

      users_hash.each do |user_data|
        user = User.new(user_data)
        result << user if user.valid? && user.unique?(result)
      end

      result
    end
  end
end
