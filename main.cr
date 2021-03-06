require "option_parser"
require "./ltnp/ltnp_operator"
require "./modules/command_runner"

OptionParser.parse do |parser|
  parser.banner = "Welcome to eznetstat!"

  parser.on "-v", "--version", "Show version" do
    puts "0.1"
    exit
  end

  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end

  parser.on "-c PORT", "--check-port=PORT", "Get the process name and ID of process on port" do |port|
    ltnp_operator = CommandRunner.run_ltnp
    record = ltnp_operator.get_port_record port

    unless record.nil?
      puts record.out_s
    else
      puts "No processes found on port %s" % port
    end

    exit
  end

  parser.on "-p PNAME", "--find-process=PNAME", "Find the port and ID of a process by name" do |p_name|
    ltnp_operator = CommandRunner.run_ltnp
    record = ltnp_operator.search_p_name p_name

    unless record.nil?
      puts record.out_s
    else
      puts "No process found by the name %s" % p_name
    end

    exit
  end

  parser.on "-k PORT", "--kill-port=PORT", "Kill process on port" do |port|
    ltnp_operator = CommandRunner.run_ltnp
    record = ltnp_operator.get_port_record port

    unless record.nil?
      puts record.out_s
      puts "Would you like to kill %s? (y/n)" % [record.p_name]
      input = gets
      unless input.nil?
        if input.downcase == "y"
          CommandRunner.run_kill record.pid
        end
      end
    else
      puts "No processes found on port %s" % port
    end

    exit
  end
end
