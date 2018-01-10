require_relative 'base'
require "shellwords"

module DeisInteractive
  module Rails
    class Logs < Base
      attr_reader :follow

      def initialize(app, process, follow: false)
        super(app, process)
        @follow = follow
      end

      def perform
        if process.nil?
          puts "Logging on all pods"
        else
          puts "Logging on pod of process #{process}"
        end

        log_pods
      end

      def kube_options
        if follow
          "-f"
        end
      end

      def log_pods
        pids = pod_ids.map do |pod_id|
          log_pod(pod_id)
        end

        at_exit do
          pids.each { |pid| Process.kill("KILL", pid) }
        end

        pids.each { |pid| Process.wait(pid) }
      end

      def log_pod(pod_id)
        fork do
          exec "kubectl logs #{kube_options} #{pod_id} --namespace #{app}"
        end
      end
    end
  end
end
