require 'tmpdir'

describe 'workflow' do
  it 'does' do
    `gem build tracker_git_hook.gemspec && gem install tracker_git_hook`

    Dir.mktmpdir do |repo_path|
      `cd #{repo_path} && git init`

      add_new_file_to_commit(repo_path, filename: 'file.txt')

      `cd #{repo_path} && story 12345`
      expect(`cd #{repo_path} && git commit -m "adds new file"`).to include('[#12345]')

      add_new_file_to_commit(repo_path, filename: 'other_file.txt')

      `cd #{repo_path} && git commit -m "adds other file [finishes #12345]"`

      add_new_file_to_commit(repo_path, filename: 'another_file.txt')

      expect(`cd #{repo_path} && git commit -m "adds another file"`).not_to include('12345')
    end
  end

  def add_new_file_to_commit(repo_path, filename:)
    `cd #{repo_path} && echo some_text > #{filename}`
    `cd #{repo_path} && git add #{filename}`
  end
end
