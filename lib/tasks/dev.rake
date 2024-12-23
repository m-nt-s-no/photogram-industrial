desc "Fill the database tables with some sample data"
task sample_data: :environment do
  p "Creating sample data"

  if Rails.env.development?
    FollowRequest.destroy_all
    Comment.destroy_all
    Like.destroy_all
    Photo.destroy_all
    User.destroy_all
  end

  usernames = Array.new { Faker::Name.first_name }

  usernames << "alice"
  usernames << "bob"

  usernames.each do |username|
    User.create(
      email: "#{username}@example.com",
      password: "password",
      username: username.downcase,
      private: [true, false].sample,
    )
  end

  12.times do
    name = Faker::Name.first_name
    u = User.create(
      email: "#{name}@example.com",
      password: "password",
      username: name,
      private: [true, false].sample,
    )
    p u.errors.full_messages
  end
  p "There are now #{User.count} users."

  users = User.all
  users.each do |first_user|
    users.each do |second_user|
      if first_user != second_user
        first_user.sent_follow_requests.create(
          recipient: second_user,
          status: FollowRequest.statuses.keys.sample
        )

        second_user.sent_follow_requests.create(
          recipient: first_user,
          status: FollowRequest.statuses.keys.sample
        )
      end
    end
  end
  p "There are now #{FollowRequest.count} follow requests."

  users.each do |user|
    3.times do
      fake_quote = Faker::TvShows::Simpsons.quote
      fake_image = Faker::Avatar.image
      post = Photo.create(
        caption: fake_quote,
        image: fake_image,
        owner_id: user.id
      )

      user.followers.each do |fan|
        like = Like.create(fan_id: fan.id, photo_id: post.id)
        if [true, false].sample == true
          fake_comment = Faker::TvShows::Seinfeld.quote
          comm = Comment.create(
            body: fake_comment,
            author_id: fan.id,
            photo_id: post.id
          )
        end
      end
    end
  end

  p "There are now #{Photo.count} photos."
  p "There are now #{Like.count} likes."
  p "There are now #{Comment.count} comments."
end
