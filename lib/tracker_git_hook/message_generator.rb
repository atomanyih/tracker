module TrackerGitHook
  class MessageGenerator
    def generate(original_message:, story_id:)
      unless message_is_tagged?(original_message)
        message_lines = original_message.split("\n")

        split_index = message_lines.find_index(&method(:is_info_line?))

        message_body = message_lines.slice(0, split_index)
        message_info = message_lines[split_index..-1]

        new_message = message_body << ["[##{story_id}]",''] << message_info << ['']
        new_message.join("\n")
      else
        original_message
      end
    end

    private

    def message_is_tagged?(original_message)
      original_message.match(/\[.*#\d*\]/)
    end

    def is_info_line?(line)
      line.start_with?('#')
    end
  end
end
