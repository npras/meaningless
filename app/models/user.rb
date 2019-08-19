class User < ApplicationRecord

  has_secure_password

  def send_password_reset!
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.now.utc
    save!
    UserMailer.with(user: self).password_reset.deliver_later
  end

  def send_confirmation_instructions!
    generate_token(:confirmation_token)
    self.confirmation_sent_at = Time.now.utc
    save!
    UserMailer.with(user: self).email_confirmation.deliver_later
  end

  # token_type is:
  # confirmation for confirmation_token,
  # password_reset for password_reset_token
  # etc.
  def generate_token_and_send_instructions!(token_type:)
    generate_token(:"#{token_type}_token")
    self[:"#{token_type}_sent_at"] = Time.now.utc
    save!
    UserMailer.with(user: self).send(:"email_#{token_type}").deliver_later
  end

  def forget_me!
    return unless persisted?
    self.remember_token = nil
    save(validate: false)
  end

  def generate_token(column)
    loop do
      token = friendly_token
      self[column] = token
      break token unless User.exists?(column => token)
    end
  end

  # Generate a friendly string randomly to be used as token.
  # By default, length is 20 characters.
  private def friendly_token(length = 20)
    # To calculate real characters, we must perform this operation.
    # See SecureRandom.urlsafe_base64
    rlength = (length * 3) / 4
    SecureRandom.urlsafe_base64(rlength).tr('lIO0', 'sxyz')
  end

end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           not null
#  name                   :string
#  password_digest        :string
#  password_reset_sent_at :datetime
#  password_reset_token   :string
#  remember_token         :string
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_password_reset_token  (password_reset_token) UNIQUE
#  index_users_on_remember_token        (remember_token) UNIQUE
#  index_users_on_unconfirmed_email     (unconfirmed_email) UNIQUE
#
