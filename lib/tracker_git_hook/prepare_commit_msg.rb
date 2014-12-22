require 'tracker_git_hook/message_generator'
require 'tracker_git_hook/repo'

module TrackerGitHook
  class PrepareCommitMsg
    def prepare(message_file_path:)
      if story_id
        original_message = File.read(message_file_path)

        message = MessageGenerator.new.generate(
          original_message: original_message,
          story_id: story_id
        )

        File.open(message_file_path, 'w') do |f|
          f.write(message)
        end
      end
    end

    private

    def story_id
      Repo.discover(path: Dir.pwd).get_story_id
    end
  end
end
