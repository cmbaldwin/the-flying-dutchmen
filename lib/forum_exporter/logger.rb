class ForumExporter
  class Logger
    def initialize(export_path)
      @export_path = export_path
      @log_file = File.join(export_path, 'metadata', 'export_log.txt')
      @console_enabled = true
    end

    def info(message)
      log('INFO', message)
    end

    def warn(message)
      log('WARN', message)
    end

    def error(message)
      log('ERROR', message)
    end

    def close
      @file&.close
    end

    private

    def log(level, message)
      timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      formatted = "[#{timestamp}] #{level}: #{message}"

      # Write to console
      puts formatted if @console_enabled

      # Write to file
      ensure_log_file
      @file.puts(formatted)
      @file.flush
    end

    def ensure_log_file
      return if @file

      FileUtils.mkdir_p(File.dirname(@log_file))
      @file = File.open(@log_file, 'a')
    end
  end
end
