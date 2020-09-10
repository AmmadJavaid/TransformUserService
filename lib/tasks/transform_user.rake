namespace :transform_user do
  task :run => :environment do
    puts '---------Initiate user transformation---------'
    result = TransformUserService.call
    puts "---------#{result.data}---------"
  end
end
