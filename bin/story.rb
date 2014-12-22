#!/usr/bin/env ruby

require 'tracker_git_hook/installer'
require 'tracker_git_hook/repo'

repo = TrackerGitHook::Repo.discover(path: Dir.pwd)
hook = <<-BASH
/usr/bin/env ruby -e "require 'tracker_git_hook/prepare_commit_msg';
TrackerGitHook::PrepareCommitMsg.new.prepare message_file_path: ARGV[0]" $1
BASH
TrackerGitHook::Installer.new(target_dir: repo.root_path, hook: hook).install

story_id = ARGV[0]
if story_id
  repo.set_story_id(story_id)
end
