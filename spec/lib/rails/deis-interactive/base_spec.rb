require 'spec_helper'
require 'deis-interactive/rails/base'

describe DeisInteractive::Rails::Base do
  let(:base) { DeisInteractive::Rails::Base.new(nil, nil) }

  describe "#inferred_app" do
    before do
      allow(base).to receive(:git_remote_response).and_return remotes
    end

    context "there is deis repo" do
      let(:remotes) { "deis\tssh://git@my.domain.com:2222/my-app.git (fetch)" }

      it "returns the name" do
        expect(base.inferred_app).to eq "my-app"
      end
    end

    context "there is no git repo" do
      let(:remotes) { "fatal: Not a git repository (or any of the parent directories): .git" }

      it "returns nil" do
        expect(base.inferred_app).to be_nil
      end
    end

    context "there is no deis repo" do
      let(:remotes) { "origin\tssh://git@my.domain.com:2222/my-app.git (fetch)" }

      it "returns nil" do
        expect(base.inferred_app).to be_nil
      end
    end
  end
end
