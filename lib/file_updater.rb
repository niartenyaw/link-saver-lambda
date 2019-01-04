class FileUpdater

  def initialize(channels:, histories:, repo_location:)
    @channels = channels
    @histories = histories
    @repo_location = repo_location
  end

  def call
    channels.each do |channel|
      filename = File.join(repo_location, 'histories', "#{channel}.json")
      File.open(filename, 'w+') do |file|
        channel_entries = histories[channel]
        all_entries = file_entries(file).merge(channel_entries)
        entries_str = all_entries.to_json

        file.write(entries_str)
      end
    end
  end

  private

  attr_reader :channels, :histories, :repo_location

  def file_entries(file)
    content = file.read
    content.empty? ? {} : JSON.parse(content)
  end
end

