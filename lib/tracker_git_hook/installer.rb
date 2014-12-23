module TrackerGitHook
  class Installer
    def initialize(repo:)
      @repo = repo
    end

    def install
      @repo.install_hook(AddStoryIdHook.new)
      @repo.install_hook(CheckStoryIdHook.new)
    end
  end

  class AddStoryIdHook
    def script
      <<-BASH
/usr/bin/env ruby -e "require 'tracker_git_hook/prepare_commit_msg';
TrackerGitHook::PrepareCommitMsg.new.prepare message_file_path: ARGV[0]" $1
      BASH
    end

    def filename
      'prepare-commit-msg'
    end
  end

  class CheckStoryIdHook
    def script
      <<-BASH
/usr/bin/env ruby -e "require 'tracker_git_hook/commit_msg';
TrackerGitHook::CommitMsg.new.run(message_file_path: ARGV[0])" $1
      BASH
    end

    def filename
      'commit-msg'
    end
  end
end
