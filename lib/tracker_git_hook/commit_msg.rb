require 'tracker_git_hook/repo'
require 'tracker_git_hook/check_story_status'

module TrackerGitHook
  class CommitMsg
    def run(message_file_path:)
      message = File.read(message_file_path)

      repo = Repo.discover(path: Dir.pwd)

      CheckStoryStatus.new(repo: repo).check(message)
    end
  end
end
