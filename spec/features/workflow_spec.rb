require 'tmpdir'

describe 'workflow' do
  before do
    build_and_install_gem
  end

  it 'sets story id and finishes it via commit message' do
    Workflow.in_git_repo do |flow|
      flow.add_new_file_to_commit(filename: 'file.txt')

      flow.assign_current_story(story_id: '12345')
      expect(
        flow.commit(commit_message: 'adds new file')
      ).to include('[#12345]')

      expect(
        flow.show_current_story
      ).to include('12345')

      flow.add_new_file_to_commit(filename: 'other_file.txt')

      flow.commit(commit_message: 'adds other file [finishes #12345]')

      flow.add_new_file_to_commit(filename: 'another_file.txt')

      expect(
        flow.commit(commit_message: 'adds another file')
      ).not_to include('12345')
    end
  end

  it 'clears story id via cli' do
    Workflow.in_git_repo do |flow|
      flow.assign_current_story(story_id: '12345')

      flow.add_new_file_to_commit(filename: 'file.txt')
      expect(
        flow.commit(commit_message: 'adds new file')
      ).to include('[#12345]')

      flow.clear_current_story

      flow.add_new_file_to_commit(filename: 'another_file.txt')

      expect(
        flow.show_current_story
      ).to eq("\n")

      expect(
        flow.commit(commit_message: 'adds another file')
      ).not_to include('12345')

      flow.add_new_file_to_commit(filename: 'a_different_file.txt')

      expect(
        flow.commit(commit_message: 'adds another file [FINISHES#54321]')
      ).not_to include('12345')
    end
  end

  class Workflow
    def self.in_git_repo(&blk)
      Dir.mktmpdir do |repo_path|
        `cd #{repo_path} && git init`

        blk.call Workflow.new(repo_path: repo_path)
      end
    end

    def initialize(repo_path:)
      @repo_path = repo_path
    end

    attr_reader :repo_path

    def assign_current_story(story_id:)
      `cd #{repo_path} && story #{story_id}`
    end

    def show_current_story
      `cd #{repo_path} && story`
    end

    def clear_current_story
      `cd #{repo_path} && story finish`
    end

    def add_new_file_to_commit(filename:)
      `cd #{repo_path} && echo some_text > #{filename}`
      `cd #{repo_path} && git add #{filename}`
    end

    def commit(commit_message:)
      `cd #{repo_path} && git commit -m "#{commit_message}"`
    end
  end

  def build_and_install_gem
    `gem build tracker_git_hook.gemspec && gem install tracker_git_hook`
  end
end
