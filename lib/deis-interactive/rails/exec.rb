require_relative 'base'
require "shellwords"

module DeisInteractive
  module Rails
    class Exec < Base
      attr_reader :cmd
      attr_reader :params

      def initialize(app, cmd, params)
        super(app, ENV['DEIS_CONSOLE_PROCESS'] || "web")
        @cmd = cmd
        @params = params
      end

      def args
        result = [cmd]
        if params
          result += params
        end
        result
      end

      def escaped_args
        args.map do |arg|
          Shellwords.escape(arg)
        end.join(" ")
      end

      def perform
        puts "Execute #{args} on #{pod_id}"
        exec "kubectl exec -it --namespace #{app} #{pod_id} -- bash -c #{escaped_args}"
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
    end
  end
end
