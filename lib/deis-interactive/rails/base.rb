module DeisInteractive
  module Rails
    class Base
      attr_reader :app, :process

      def initialize(app, process)
        @app = app
        @process = process
      end

      def processes_pattern
        patterns = [app]
        patterns << process if process
        patterns.join("-")
      end

      def container_ids
        puts "Fetching container ids to attach console process..."
        output= `kubectl get pods --namespace #{app} -o name | grep #{processes_pattern}`
        output.split("\n").reject(&:empty?).map do |str|
          str.split("/").last
        end
      end
    end
  end
end

