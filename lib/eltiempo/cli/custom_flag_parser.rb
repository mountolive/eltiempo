# frozen_string_literal: true

require 'eltiempo/cli/errors/unsupported_name_error'

module Eltiempo

  ##
  #  Class used for parsing ARGV parameters and flags for
  #  conditional execution of a cli.
  class CustomFlagParser

    ##
    #  Assumes that the last element in the ARGV passed
    #  is the main parameter of the cli command to be executed  
    #
    #  Extracts the flag names and its corresponding parameters in a hash,
    #  plus the main parameter of the script.
    #
    #  returns [Main parameter, flag hash { name => value }]
    #  both empty if argv is nil or empty
    def extract_flags(argv)
      # hash where flags will be registerd
      flags = {}
      # the script was called with no arguments/flags
      return [nil, {}] unless argv && argv.length > 0
      # last string is the main param (under certain conditions)
      last_str = argv.last
      # The script was called without flags
      return [last_str, flags] if argv.length == 1
      # main parameter holder
      main_parameter = nil
      unless is_flag last_str
        main_parameter = last_str
      else
        # The script was called with no main param and a flag at the end
        flags[last_str] = true
      end
      # Keeps track. Checks if we're tracing a flag
      current_flag = nil
      argv[..argv.length - 2].each do |arg|
        # Means the previously parsed flag (saved on current_flag)
        # is a boolean flag
        if is_flag(arg)
          flags[current_flag] = true if current_flag
          current_flag = arg
        elsif current_flag
          flags[current_flag] = arg
        else
          # Means this is nor a flag, nor a param
          raise Eltiempo::UnsupportedNameError.new arg
        end
      end
      # Means the last element in the ARGV (not counting the param) was a flag
      flags[current_flag] = true if current_flag
      [main_parameter, flags]
    end
 
    private
      def is_flag(str)
        str.length > 0 && str[0] == '-'
      end
  end
end
