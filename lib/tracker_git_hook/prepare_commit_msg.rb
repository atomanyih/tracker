require 'tracker_git_hook/message_generator'

module TrackerGitHook
  class PrepareCommitMsg
    def prepare(message_file_path:)
      original_message = File.read(message_file_path)
      story_id = ENV['TRACKER_STORY_ID']

      message = MessageGenerator.new.generate(
        original_message: original_message,
        story_id: story_id
      )

      File.open(message_file_path, 'w') { |f| f.write(message) }
    end
  end
end
