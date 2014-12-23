module TrackerGitHook
  class MessageGenerator
    def generate(original_message:, story_id:)
      if message_is_tagged?(original_message)
        original_message
      else
        message_lines = original_message.split("\n")

        new_message = insert_into_message(message_lines, "[##{story_id}]")

        new_message.join("\n")
      end
    end

    private

    def message_is_tagged?(original_message)
      original_message.match(/\[.*#\d*\]/)
    end

    def insert_into_message(message_lines, story_line)
      split_index = message_lines.find_index(&method(:info_line?))

      if split_index
        message_body = message_lines[0..split_index - 1]
        message_info = message_lines[split_index..-1]
        message_body << [story_line, ''] << message_info << ['']
      else
        message_lines << [story_line, '']
      end
    end

    def info_line?(line)
      line.start_with?('#')
    end
  end
end
