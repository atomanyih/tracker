require 'tmpdir'

describe 'workflow' do
  it 'does' do
    build_and_install_gem

    in_git_repo do |repo_path|
      add_new_file_to_commit(repo_path, filename: 'file.txt')

      set_current_story(repo_path, story_id: 12345)
      expect(commit(repo_path, commit_message: 'adds new file')).to include('[#12345]')

      add_new_file_to_commit(repo_path, filename: 'other_file.txt')

      commit(repo_path, commit_message: 'adds other file [finishes #12345]')

      add_new_file_to_commit(repo_path, filename: 'another_file.txt')

      expect(commit(repo_path, commit_message: 'adds another file')).not_to include('12345')
    end
  end

  def in_git_repo(&blk)
    Dir.mktmpdir do |repo_path|
      `cd #{repo_path} && git init`

      blk.call repo_path
    end
  end

  def set_current_story(repo_path, story_id:)
    `cd #{repo_path} && story #{story_id}`
  end

  def add_new_file_to_commit(repo_path, filename:)
    `cd #{repo_path} && echo some_text > #{filename}`
    `cd #{repo_path} && git add #{filename}`
  end

  def commit(repo_path, commit_message:)
    `cd #{repo_path} && git commit -m "#{commit_message}"`
  end

  def build_and_install_gem
    `gem build tracker_git_hook.gemspec && gem install tracker_git_hook`
  end
end
