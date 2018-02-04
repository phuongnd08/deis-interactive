require_relative 'base'
require "shellwords"
require 'concurrent'
require 'open3'

module DeisInteractive
  module Rails
    class Logs < Base
      attr_reader :follow
      attr_reader :count
      attr_reader :pids
      attr_reader :outputs

      def initialize(app, process, follow: false, count: nil)
        super(app, process)
        @follow = follow
        @pids = Concurrent::Array.new
        @outputs = Concurrent::Array.new
        @count = count || 20

        at_exit do
          pids.each do |pid|
            Process.kill("KILL", pid) if pid_alive?(pid)
          end
        end
      end

      def perform
        if process.nil?
          puts "Logging on all pods"
        else
          puts "Logging on pod of process #{process}"
        end

        log_pods
      end

      def pid_alive?(pid)
        begin
          Process.getpgid( pid )
          true
        rescue Errno::ESRCH
          false
        end
      end

      def any_pid_alive?
        20.times {
          break if pids.count > 0
          sleep 0.1
        }

        return false if pids.count == 0
        pids.any? { |pid| pid_alive?(pid) }
      end

      def follow_option
        if follow
          "-f"
        end
      end

      def log_pods
        pod_ids.each do |pod_id|
          log_pod(pod_id)
        end

        loop do
          while (outputs.count > 0)
            puts outputs.shift
          end
          if any_pid_alive?
            sleep 0.01
          else
            break
          end
        end
      end

      def log_pod(pod_id)
        Thread.new do
          cmd = "kubectl logs #{follow_option} --tail #{count} #{pod_id} --namespace #{app}"
          Open3.popen2e(cmd) do |_, out_err, wait_thr|
            pids << wait_thr.pid
            out_err.each { |line| outputs << line }
          end
        end
      end
    end
  end
end
