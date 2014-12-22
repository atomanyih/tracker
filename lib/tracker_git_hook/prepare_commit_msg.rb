require 'tracker_git_hook/message_generator'
require 'tracker_git_hook/repo'

module TrackerGitHook
  class PrepareCommitMsg
    def prepare(message_file_path:)
      original_message = File.read(message_file_path)

      message = MessageGenerator.new.generate(
        original_message: original_message,
        story_id: story_id
      )

      File.open(message_file_path, 'w') { |f| f.write(message) }
    end

    private

    def story_id
      Repo.new(root_path: Dir.pwd).get_story_id
    end
  end
end
