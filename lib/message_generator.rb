module MessageGenerator
  def self.generate(original_message:, story_id:)
    unless original_message.match(/\[.*#\d*\]/)
      original_message + "\n[##{story_id}]\n"
    else
      original_message
    end
  end
end
