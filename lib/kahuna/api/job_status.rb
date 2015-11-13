module Kahuna
  module Api
    class JobStatus
      ENDPOINT = '/api/campaign/populate'.freeze

      def initialize(job_id)
        @job_id = job_id

        validate
      end

      def request_url(env)
        "#{Api::JobStatus::ENDPOINT}/#{@job_id}?env=#{env}"
      end

      def validate
        raise(ArgumentError, 'job_id is missing') if @job_id.nil?
      end
    end
  end
end
