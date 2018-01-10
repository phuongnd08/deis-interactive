require_relative 'base'
require "shellwords"

module DeisInteractive
  module Rails
    class Console < Base
      def initialize(app)
        super(app, ENV['DEIS_CONSOLE_PROCESS'] || "web")
      end

      def perform
        puts "Run rails console attaching to #{pod_id}"
        exec "kubectl exec -it --namespace #{app} #{pod_id} -- bash -c #{Shellwords.escape(bash)}"
      end

      def pod_id
        @pod_id ||= (
          sample_pod_id = pod_ids.sample
          if (sample_pod_id.nil?)
            raise "Error. No pod of #{process} is found. kubectl won't be able to attach to run a console session"
          end
          sample_pod_id
        )
      end

      def bash
        ". /app/.profile.d/ruby.sh && PATH=/app/.heroku/node/bin:$PATH /app/bin/rails c"
      end
    end
  end
end
