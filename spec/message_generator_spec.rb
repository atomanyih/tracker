require_relative '../lib/message_generator'

describe MessageGenerator do
  it 'adds tracker id to a message missing it' do
    message = MessageGenerator.generate(original_message: <<-TEXT, story_id: 12345)
hey I don't have a tracker story
TEXT

    expect(message).to eq(<<-TEXT)
hey I don't have a tracker story

[#12345]
TEXT
  end

  it 'does not add tracker id to a message with it' do
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
