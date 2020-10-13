# frozen_string_literal: true

require 'eltiempo/cli/custom_flag_parser'
require 'eltiempo/cli/errors/unsupported_name_error'

require 'spec_helper'

describe Eltiempo::CustomFlagParser do
  before(:all) do
    @parser = Eltiempo::CustomFlagParser.new
  end

  context 'extract_flags' do
    it 'should return no argument and empty flags when ARGV is nil' do
      argv = nil
      param, flag = @parser.extract_flags argv
      expect(param).to be nil
      expect(flag).to be_empty
    end

    it 'should return no argument and empty flags when ARGV is empty' do
      argv = []
      param, flag = @parser.extract_flags argv
      expect(param).to be nil
      expect(flag).to be_empty
    end

    it 'should return the argument and empty flags when ARGV has size 1' do
      argv = ['argument']
      param, flag = @parser.extract_flags argv
      expect(param).to eq argv[0]
      expect(flag).to be_empty
    end

    it 'should return a flag with a single element when ARGV only contains a flag -flag' do
      argv = ['-flag']
      param, flag = @parser.extract_flags argv
      expect(param).to be nil
      expect(flag).not_to be_empty
      expect(flag['-flag']).to eq true
    end

    it 'should return a flag with a single element when ARGV only contains a flag --flag' do
      argv = ['--flag']
      param, flag = @parser.extract_flags argv
      expect(param).to be nil
      expect(flag).not_to be_empty
      expect(flag['--flag']).to eq true
    end

    it 'should return a flag with a single element when ARGV only contains a flag -f' do
      argv = ['-f']
      param, flag = @parser.extract_flags argv
      expect(param).to be nil
      expect(flag).not_to be_empty
      expect(flag['-f']).to eq true
    end

    it 'should throw an UnsupportedNameError when passed nor a flag nor a param' do
      argv = ['something', 'else']
      expect { @parser.extract_flags argv }.to(
        raise_error(Eltiempo::UnsupportedNameError)
      )
    end

    it 'should assign flag parameter correctly in flag hash' do
      argv = ['-f1', 'something', '-f2', '-f3']
      param, flags = @parser.extract_flags argv
      expect(param).to be nil
      expect(flags['-f1']).to eq 'something'
      expect(flags['-f2']).to eq true
      expect(flags['-f3']).to eq true
    end

    it 'should contain the second to last flag passed in the flags hash returned' do
      argv = ['-a', '-d', '--foo', '-bar']
      param, flags = @parser.extract_flags argv
      expect(param).to be nil
      expect(flags).not_to be_empty
      argv.each do |f|
        expect(flags[f]).to eq true
      end
    end

    it 'should parse properly "-today --av_min -u city"' do
      argv = %w{-today --av_min -u city}
      param, flags = @parser.extract_flags argv
      expect(param).to eq 'city'
      argv[..argv.length - 2].each do |arg|
        expect(flags[arg]).to eq true
      end
    end
  end
end

