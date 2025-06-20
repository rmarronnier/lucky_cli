# Builds and runs a file (typically tasks.cr) with the passed in args
class LuckyCli::BuildAndRunTask
  private getter tasks_file : String
  private getter args : Array(String)
  private getter temp_stdout = IO::Memory.new
  private getter temp_stderr = IO::Memory.new
  private getter tasks_binary_path = "tmp/tasks_binary"

  def initialize(@tasks_file, args : String)
    # Parse args string into array, respecting quoted strings
    @args = parse_args(args)
  end

  def self.call(*args, **named_args)
    new(*args, **named_args).call
  end

  def call
    FileUtils.mkdir_p("tmp")
    build_status = build_tasks_binary
    copy_temp_io_to_real_io

    if build_status.success?
      run_tasks_file
    else
      STDERR.puts "\n❌ Failed to compile #{tasks_file}".colorize(:red).bold
      STDERR.puts "Exit code: #{build_status.exit_code}".colorize(:red)

      # Provide helpful error messages for common issues
      error_output = temp_stderr.to_s
      if error_output.includes?("Error: can't find file")
        STDERR.puts "\n💡 Tip: Make sure #{tasks_file} exists in your project root".colorize(:yellow)
      elsif error_output.includes?("undefined method") || error_output.includes?("undefined constant")
        STDERR.puts "\n💡 Tip: Check for typos in your task names or missing imports".colorize(:yellow)
      elsif error_output.includes?("syntax error")
        STDERR.puts "\n💡 Tip: Review the syntax error above and check your Crystal syntax".colorize(:yellow)
      end

      exit build_status.exit_code
    end
  end

  private def build_tasks_binary
    crystal_args = ["build", tasks_file, "-o", tasks_binary_path]
    crystal_args << "--error-trace" if args.includes?("--error-trace")

    with_spinner("Compiling...") do
      Process.run(
        command: "crystal",
        args: crystal_args,
        input: STDIN,
        output: temp_stdout,
        error: temp_stderr
      )
    end
  end

  # STDOUT/STDERR needs to be printed after the tasks binary is built,
  # otherwise the spinner will overwrite the output from building the binary
  # (like if there is a compilation error when building).
  #
  # By creating "fake" io with IO::Memory we can collect the output and then
  # print it after the build is finished.
  private def copy_temp_io_to_real_io
    STDOUT.print(temp_stdout.to_s)
    STDERR.print(temp_stderr.to_s)
  end

  private def run_tasks_file
    begin
      result = Process.run(
        command: tasks_binary_path,
        args: args,
        input: STDIN,
        output: STDOUT,
        error: STDERR
      )
      exit result.exit_code
    rescue ex : File::NotFoundError
      STDERR.puts "❌ Could not find compiled task binary at #{tasks_binary_path}".colorize(:red).bold
      STDERR.puts "💡 This might be a permission issue or disk space problem".colorize(:yellow)
      exit 1
    rescue ex : Exception
      STDERR.puts "❌ Failed to run task: #{ex.message}".colorize(:red).bold
      exit 1
    end
  end

  private def parse_args(args_string : String) : Array(String)
    # Simple argument parsing that respects quoted strings
    args = [] of String
    current_arg = IO::Memory.new
    in_quotes = false
    escape_next = false

    args_string.each_char do |char|
      if escape_next
        current_arg << char
        escape_next = false
      elsif char == '\\'
        escape_next = true
      elsif char == '"' || char == '\''
        in_quotes = !in_quotes
      elsif char == ' ' && !in_quotes
        arg = current_arg.to_s
        args << arg unless arg.empty?
        current_arg = IO::Memory.new
      else
        current_arg << char
      end
    end

    arg = current_arg.to_s
    args << arg unless arg.empty?

    args
  end

  private def with_spinner(start_text, &)
    if ENV.has_key?("CI")
      STDERR.puts start_text.colorize.bold
      yield
    else
      LuckyCli::Spinner.start(start_text) { yield }
    end
  end
end
