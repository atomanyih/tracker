require 'message_generator'

  context 'whatever git ci -v puts out' do
    it 'adds the story id without messing everything up' do
      original_message = <<-TEXT

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch master
# Changes to be committed:
# =>new file:   .ruby-version
#
# ------------------------ >8 ------------------------
# Do not touch the line above.
# Everything below will be removed.
diff --git a/.ruby-version b/.ruby-version
new file mode 100644
index 0000000..eca07e4
--- /dev/null
+++ b/.ruby-version
@@ -0,0 +1 @@
+2.1.2
      TEXT

      expected_message = <<-TEXT

[#12345]

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.
# On branch master
# Changes to be committed:
# =>new file:   .ruby-version
#
# ------------------------ >8 ------------------------
# Do not touch the line above.
# Everything below will be removed.
diff --git a/.ruby-version b/.ruby-version
new file mode 100644
index 0000000..eca07e4
--- /dev/null
+++ b/.ruby-version
@@ -0,0 +1 @@
+2.1.2
      TEXT

      message = MessageGenerator.new.generate(original_message: original_message, story_id: 12345)

      expect(message).to eq(expected_message)
    end
  end