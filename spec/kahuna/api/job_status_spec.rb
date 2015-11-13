require 'spec_helper'

describe Kahuna::Api::JobStatus do
  describe '#request_url' do
    let(:js) { Kahuna::Api::JobStatus.new('jobid') }

    it 'returns correct request url' do
      expect(js.request_url('staging')).to(eq("/api/campaign/populate/jobid?env=staging"))
    end
  end

  describe '#validate' do
    context 'job_id' do
      it 'raises error if missing' do
        expect {
          Kahuna::Api::JobStatus.new(nil)
        }.to(raise_error(Kahuna::ArgumentError, 'job_id is missing'))
      end
    end
  end
end
