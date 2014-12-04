module MessageGenerator
  def self.generate(original_message:, story_id:)
    unless original_message.match(/\[.*#\d*\]/)
      message_lines = original_message.split("\n")
      message_body = message_lines.reject do |line|
        line.start_with?('#')
      end
      message_info = message_lines.select do |line|
        line.start_with?('#')
      end

      new_message = message_body << ["[##{story_id}]",''] << message_info << ['']
      new_message.join("\n")
    else
      original_message
    end
  end
end
