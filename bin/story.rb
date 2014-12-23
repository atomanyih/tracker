#!/usr/bin/env ruby

require 'tracker_git_hook/installer'
require 'tracker_git_hook/repo'
require 'tracker_git_hook/cli'

repo = TrackerGitHook::Repo.discover(path: Dir.pwd)
TrackerGitHook::Installer.new(repo: repo).install

TrackerGitHook::Cli.new(repo: repo).process_arguments(*ARGV)
