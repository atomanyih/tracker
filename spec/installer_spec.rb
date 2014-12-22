require 'installer'
require 'tmpdir'

describe Installer do
  it 'creates a prepare-commit-msg file in the .git/hooks directory' do
    Dir.mktmpdir do |target_dir|
      `cd #{target_dir} && git init`

      installer = Installer.new(target_dir: target_dir, hook: 'yo what')

      installer.install

      expected_hook_path = File.join(target_dir, '.git', 'hooks', 'prepare-commit-msg')

      expect(File.exists?(expected_hook_path)).to eq(true)
      expect(File.read(expected_hook_path)).to eq('yo what')
    end
  end
end
