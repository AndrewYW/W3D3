# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortenedURL < ActiveRecord::Base
  validates :long_url, :short_url, :user_id, presence: true
  validates :short_url, uniqueness: true

  belongs_to :submitter,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :user_id

  def self.make_entry(user, long_url)
    ShortenedURL.create!(
      user_id: user.id,
      long_url: long_url,
      short_url: ShortenedURL.random_code
    )
  end

  def self.random_code
    code = SecureRandom.urlsafe_base64
    code = SecureRandom.urlsafe_base64 while ShortenedUrl.exists?(short_url: code)
    code
  end
end
