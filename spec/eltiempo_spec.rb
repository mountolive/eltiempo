# frozen_string_literal: true

RSpec.describe Eltiempo do
  it "has a version number" do
    expect(Eltiempo::VERSION).not_to be nil
  end

  it 'can set a new base_url for the api' do
    url = 'new_url'
    Eltiempo::base_url = url
    expect(Eltiempo::base_url).to eq url
  end
end
