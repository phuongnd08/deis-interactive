require_relative 'base'
require "shellwords"

module DeisInteractive
  module Rails
    class Console < Base
      def initialize(app)
        super(app, ENV['DEIS_CONSOLE_PROCESS'] || "web")
      end

      def perform
        puts "Run rails console attaching to #{container_id}"
        exec "kubectl exec -it --namespace #{app} #{container_id} -- bash -c #{Shellwords.escape(bash)}"
      end

      def container_id
        @container_id ||= (
          sample_container_id = container_ids.sample
          if (sample_container_id.nil?)
            raise "Error. None container of #{process} is found. kubectl won't be able to attach to run a console session"
          end
          sample_container_id
        )
      end

      def bash
        ". /app/.profile.d/ruby.sh && PATH=/app/.heroku/node/bin:$PATH /app/bin/rails c"
      end
    end
  end
end
