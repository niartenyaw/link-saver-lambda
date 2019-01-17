require 'httparty'
require 'byebug'

class SlackChannelHistory
  # HTTParty setup
  include HTTParty
  base_uri 'https://slack.com/api/channels.history'
  headers 'Content-Type' => 'application/x-www-form-urlencoded'

  #rubocop:disable Metrics/LineLength
  WEBPAGE_REGEX = Regexp.new('<(?<link>(http\:\/\/|https\:\/\/)?([a-z0-9][a-z0-9\-]*\.)*[A-z0-9][A-z0-9\-/%_=?+]*(\.[A-z]+)?)>')
  #rubocop:enable Metrics/LineLength

  CHANNEL_ID_MAP = {
    'ethics' => 'CBJE3MNGK',
    'effective-altruism' => 'CELS5419U'
  }.freeze

  def initialize(channels:)
    @channels = channels
  end

  def call
    entries = Hash.new
    channels.each do |channel|
      channel_entries = entries[channel] = Hash.new
      messages(channel).each do |m|
        #match = WEBPAGE_REGEX.match(m['text'])
        #next unless match
        #link = match.named_captures['link']
        #entry = "#{m['ts']} #{m['user']} #{link}"
        #channel_entries[entry] = true

        id = "#{m['ts']} #{m['user']}"
        channel_entries[id] = m
      end
    end

    entries
  end

  private

  attr_reader :channels

  def messages(channel)
    response = self.class.post(
      '',
      body: {
        token: ENV["SLACK_OAUTH_ACCESS_TOKEN"],
        channel: CHANNEL_ID_MAP[channel]
      }
    )

    data = JSON.parse(response.body)

    data['messages']
  end
end

if $PROGRAM_NAME == __FILE__
  p SlackChannelHistory.new(channels: ['ethics']).call
end
