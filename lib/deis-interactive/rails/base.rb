module DeisInteractive
  module Rails
    class Base
      attr_reader :app, :process

      def initialize(app, process)
        @app = app || inferred_app
        @process = process
        if @app.nil?
          puts "App name can't be inferred. Please pass the app name with -a APP"
          exit 1
        end
      end

      def processes_pattern
        patterns = [app]
        patterns << process if process
        patterns.join("-")
      end

      def pod_ids
        @pod_ids ||= (
          puts "Fetching pod ids..."
          output= `kubectl get pods --namespace #{app} -o name | grep #{processes_pattern}`
          output.split("\n").reject(&:empty?).map do |str|
            str.split("/").last
          end
        )
      end

      def git_remote_response
        `git remote -v`
      end

      def deis_remote
        remotes = git_remote_response.split("\n")
        remotes.each do |remote|
          name, url, type = remote.split(" ")
          if name == "deis"
            return url
          end
        end

        nil
      end

      def inferred_app
        url = deis_remote
        return nil if url.nil?
        url.split("/").last.gsub(".git", "")
      end
    end
  end
end

