class EmailProcessor


  def self.process(email)
    # Post.create!({ body: email.body, email: email.from })

    user = User.find(email.subject)
    Notification.create!(user: user, sender_id: 2, ntype: "welcome")
    # .to
    # .from
    # .subject
    # .body
    # .raw_text
    # .raw_html
    # .raw_body
    # .attachments
    # .headers
    # .raw_headers

  end


end