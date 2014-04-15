module RailsLogSorter
  class Log
    def self.new_with_file(file)
      new(File.read(file))
    end

    attr_reader :requests

    def initialize(log)
      @requests = []

      current_requests = {}

      log.split("\n").each {|line|
        begin
        line = Line.new(line)

        request = current_requests[line.pid]

        case line.type
        when :started
          current_requests[line.pid] = request = Request.new
          request.lines << line
          @requests << request
        when :processing
          if request
            request.action = line.action
            request.lines << line
          end
        when :completed
          if request
            request.runtime = line.runtime
            request.lines << line
          end
          current_requests[line.pid] = nil
        else
          request.lines << line if request
        end

        rescue
          p line
          raise
        end
      }
    end

    def find(action)
      @requests.select {|r| r.action == action}
    end

    def find_slowest(action, limit=5)
      find(action).sort_by {|r| r.runtime}.reverse[0..(limit - 1)]
    end
  end

  class Request
    attr_accessor :lines, :action, :runtime

    def initialize
      @lines = []
    end
  end

  class Line
    FORMAT = /\A(?<timestamp>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}) \[(?<loglevel>.*)\] (?<message>.*) \(pid:(?<pid>\d+)\)/

    attr_reader :message, :pid, :type, :action, :runtime, :original_line

    def initialize(line)
      @original_line = line
      match = line.match(FORMAT)
      if !match
        @type = :unknown
      else
        @message = match[:message]
        @pid = match[:pid]

        @type = case @message
                when /\AStarted (GET|POST|PUT|DELETE)/
                  :started
                when /\AProcessing by (\S+) as/
                  @action = $1
                  :processing
                when /Completed \d{3} .* in (\d+\.\d+)ms/
                  @runtime = $1.to_f
                  :completed
                else
                  :log
                end
      end
    end
  end
end
