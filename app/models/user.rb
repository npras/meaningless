class User < ApplicationRecord

  has_secure_password

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
