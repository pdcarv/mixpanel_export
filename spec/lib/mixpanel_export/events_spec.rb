require 'spec_helper'

describe MixpanelExport::Events do
  subject(:events) { MixpanelExport::Events.new('api_secret', 'api_key') }

  describe "#all" do
    let(:response) do
      { 'data': {
          'series': ['2010-05-29', '2010-05-30', '2010-05-31'],
          'values': {'account-page': { '2010-05-30': 1, },
          'splash features': { '2010-05-29': 6,
                               '2010-05-30': 4,
                               '2010-05-31': 5, }
          }
      },
      'legend_size': 2 }.to_json
    end

    it "returns empty if body is empty" do
      stub_request(:get, "http://mixpanel.com/api/2.0/events").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(:status => 200, :body => "", :headers => {})

      expect(events.all).to eq("")
    end

    it "return a json string if request succeeded" do
      stub_request(:get, "http://mixpanel.com/api/2.0/events").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(:status => 200, :body => response, :headers => {})

      expect(events.all).to eq(response)
    end
  end

  describe "#top" do
    let(:response) do
      { 'events': [
        { 'amount': 2,
          'event': 'funnel',
          'percent_change': -0.35635745999582824},
        { 'amount': 75,
          'event': 'pages',
          'percent_change': -0.20209602478821687},
        { 'amount': 2, 'event': 'projects', 'percent_change': 1.0 }],
        'type': 'unique' }.to_json
    end

    it "returns empty if body is empty" do
      stub_request(:get, "http://mixpanel.com/api/2.0/top").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(:status => 200, :body => "", :headers => {})

      expect(events.top).to eq("")
    end

    it "return a json string if request succeeded" do
      stub_request(:get, "http://mixpanel.com/api/2.0/top").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(:status => 200, :body => response, :headers => {})

      expect(events.top).to eq(response)
    end
  end

  describe "#names" do
    let(:response) do
      [ 'battle','click signup button','send message','View homepage'].to_json
    end

    it "returns empty if body is empty" do
      stub_request(:get, "http://mixpanel.com/api/2.0/names").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(:status => 200, :body => "", :headers => {})

      expect(events.names).to eq("")
    end

    it "return a json string if request succeeded" do
      stub_request(:get, "http://mixpanel.com/api/2.0/names").
        with(query: hash_including(:api_key, :sig, :expire, :format)).
        to_return(:status => 200, :body => response, :headers => {})

      expect(events.names).to eq(response)
    end
  end
end
