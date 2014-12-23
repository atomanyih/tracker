require 'tracker_git_hook/cli'

module TrackerGitHook
  describe Cli do
    subject(:cli) { Cli.new(repo: repo) }
    let(:repo) { double(:repo) }

    context 'without argument' do
      it 'prints current story' do
        expect(repo).to receive(:current_story_id).and_return('12355')
        expect {
          cli.process_arguments
        }.to output("12355\n").to_stdout
      end
    end

    context 'with argument' do
      context 'argument is story id' do
        it 'sets the story id' do
          expect(repo).to receive(:current_story_id=).with('12355')
          cli.process_arguments('12355')
        end
      end

      context 'argument is "finish"' do
        it 'clears the story id' do
          expect(repo).to receive(:clear_story_id)
          cli.process_arguments('finish')
        end
      end

      context 'argument is something else' do
        it 'shows usage' do
          expect {
            cli.process_arguments('beluga_whale')
          }.to output(/Usage/).to_stdout
        end
      end
    end
  end
end
