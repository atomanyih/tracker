require_relative '../lib/message_generator'

describe MessageGenerator do
  context 'original message does not have a story tag' do
    it 'adds the story id' do
      message = MessageGenerator.generate(original_message: <<-TEXT, story_id: 12345)
hey I don't have a tracker story

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch master
# Changes to be committed:
# deleted:   .ego
# modified:  .super-ego
#
# Untracked files:
# .id
#
      TEXT

      expect(message).to eq(<<-TEXT)
hey I don't have a tracker story

[#12345]

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch master
# Changes to be committed:
# deleted:   .ego
# modified:  .super-ego
#
# Untracked files:
# .id
#
      TEXT
    end
  end

  context 'original message has a tracker tag' do
    it 'returns the original message' do
      message = MessageGenerator.generate(original_message: <<-TEXT, story_id: 12345)
hey I have a tracker story

[#54321]
      TEXT

      expect(message).to eq(<<-TEXT)
hey I have a tracker story

[#54321]
      TEXT
    end
  end
end
