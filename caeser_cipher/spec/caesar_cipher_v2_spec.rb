# frozen_string_literal: true

# spec/caesar_cipher_v2_spec.rb
require './lib/caesar_cipher_v2'

describe '#caeser_cipher' do
  it 'returns string with a default shift factor of 5' do
    expect(caeser_cipher('string')).to eql('xywnsl')
  end

  it 'returns string with a custom shift factor' do
    expect(caeser_cipher('string', 10)).to eql('cdbsxq')
  end

  it 'returns string capital letters' do
    expect(caeser_cipher('WhAt A sTrInG')).to eql('BmFy F xYwNsL')
  end

  it 'returns string with punctuation' do
    expect(caeser_cipher('What a string!@#$%^&*')).to eql('Bmfy f xywnsl!@#$%^&*')
  end
end
