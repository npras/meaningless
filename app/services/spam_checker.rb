require 'cgi'

class SpamChecker

  def initialize(blog:, user_ip:, user_agent:,
                 referrer: nil, comment_author: nil, comment_author_email: nil,
                 comment_content: nil, user_role: nil,
                 api_key: Rails.application.credentials.akimset[:api_key])
    method(__method__).parameters.map do |_, name|
      instance_variable_set(:"@#{name}", binding.local_variable_get(name))
    end
  end

  def spam?
    opts = {
      blog: @blog,
      user_ip: @user_ip,
      user_agent: @user_agent,
      referrer: @referrer,
      comment_type: 'comment',
      comment_author: @comment_author,
      comment_author_email: @comment_author_email,
      comment_content: @comment_content,
      user_role: @user_role,
    }
    response = http_client.post(comment_check_url, body: parameterize(opts))
    is_spam = (response.body.to_s == 'true')
    if is_spam
      Rails.logger.warn("👺 👺  Comment is a spam! Akimset response headers: #{response.headers.to_h}")
    end
    is_spam
  end

  def validate_key!
    opts = {
      key: @api_key,
      blog: @blog
    }
    response = http_client.post(key_verification_url, body: parameterize(opts))
  end

  private def parameterize(h)
    h
      .map { |k, v| "#{k}=#{CGI.escape(v.to_s)}" }
      .join('&')
  end

  private def http_client
    HTTP
      .timeout(3) # raises HTTP::TimeoutError
      .headers(
      'User-Agent' => "PrasBlog/1.0 | Meaningless/1.0",
      'Content-Type' => 'application/x-www-form-urlencoded'
    )
  end

  private def key_verification_url
    "https://rest.akismet.com/1.1/verify-key"
  end

  private def comment_check_url
    "https://#{@api_key}.rest.akismet.com/1.1/comment-check"
  end

end


if __FILE__ == $0
  opts = {
    blog: 'npras.in',
    user_ip: '123.201.249.243',
    user_agent: 'Mozilla/5.0 (platform; rv:geckoversion) Gecko/geckotrail Firefox/firefoxversion',
    referrer: 'https://developer.mozilla.org/en-US/docs/Web/JavaScript',
    comment_author: 'viagra-test-123',
    #comment_author: 'Prasanna',
    comment_author_email: 'pras@pras.co',
    comment_content: 'this is really nice. I love it',
    user_role: '',
    #user_role: 'administrator',
    api_key: '48d606a4e16f',
  }

  require 'http'
  s = SpamChecker.new(opts)
  #p s.validate_key!
  p s.spam?
end
