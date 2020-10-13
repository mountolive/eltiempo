# frozen_string_literal: true

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
    #  plus the main parameter of the script
    def extract_flags(argv)
      splitted_args = argv.split(" ")
      # Removing trailing spaces of each possible flag
      splitted_args.map! { |arg| arg.strip }
      # We revert to be able to weed out the main parameter from
      # flag's params
      splitted_args.reverse!
      main_parameter = []
      splitted_args.each do |arg|
        break if arg[0] == '-'
        main_parameter << arg
      end
      unparsed_flags = splitted_args[main_parameter.length..]  
      # Re-reversing to make easier the flag's parsing
      unparsed_flags.reverse!
      flags = {}
      current_flag = nil
      unparsed_flags.each do |arg|
        is_flag = arg[0] == '-'
        # Means the previously parsed flag (saved on current_flag)
        # is a boolean flag
        if current_flag && is_flag 
          flags[current_flag] = true
          current_flag = arg
          next
        elsif current_flag
          unless flags[current_flag]
            flags[current_flag] = arg
          else
            flags[current_flag] << arg
          end
          next
        end
      end
    end

    ## 
    #  Returns true if the argument belongs to the supported_flags array
    def check_args_validity(argument, supported_flags)
    end
  end
end
