#!/usr/bin/env ruby

require 'tracker_git_hook/installer'

target_dir = Dir.pwd
hook = <<-BASH
/usr/bin/env ruby -e "require 'tracker_git_hook/prepare_commit_msg';
TrackerGitHook::PrepareCommitMsg.new.prepare message_file_path: ARGV[0]" $1
BASH
TrackerGitHook::Installer.new(target_dir: target_dir, hook: hook).install
