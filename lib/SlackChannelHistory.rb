require 'httparty'
require 'byebug'

class SlackChannelHistory
  include HTTParty

  WEBPAGE_REGEX = Regexp.new('<(?<link>(http\:\/\/|https\:\/\/)?([a-z0-9][a-z0-9\-]*\.)*[A-z0-9][A-z0-9\-/]*(\.[A-z]+)?)>')

  base_uri 'https://slack.com/api/channels.history'

  headers 'Content-Type' => 'application/x-www-form-urlencoded'

  def initialize(channel_id:)
    @channel_id = channel_id
  end

  def call
    messages = fetch_messages
    entries = Hash.new
    messages.each do |m|
      match = WEBPAGE_REGEX.match(m['text'])
      next unless match

      link = match.named_captures['link']
      entry = "#{m['ts']} #{m['user']} #{link}"
      entries[entry] = true
    end

    entries
  end

  private

  attr_reader :channel_id

  def fetch_messages
    response = self.class.post(
      '',
      body: {
        token: ENV["SLACK_OAUTH_ACCESS_TOKEN"],
        channel: channel_id
      }
    )

    data = JSON.parse(response.body)

    data['messages']
  end
end

if $PROGRAM_NAME == __FILE__
  response = SlackChannelHistory.new(channel_id: 'CBJE3MNGK').call
end
