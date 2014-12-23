#!/usr/bin/env ruby

require 'tracker_git_hook/installer'
require 'tracker_git_hook/repo'

repo = TrackerGitHook::Repo.discover(path: Dir.pwd)
TrackerGitHook::Installer.new(repo: repo).install

story_id = ARGV[0]
if story_id
  repo.set_story_id(story_id)
end
