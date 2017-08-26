class CustomMentionProcessor < MentionSystem::MentionProcessor

  def extract_mentioner_content(post)
    post.message
  end

  def find_mentionees_by_handles(*handles)
    User.where(name: handles)
  end
end
