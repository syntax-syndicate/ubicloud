# frozen_string_literal: true

require_relative "../spec_helper"

RSpec.describe KubernetesCluster do
  subject(:kc) {
    described_class.new(
      name: "kc-name",
      kubernetes_version: "v1.32.0",
      location: "hetzner-fsn1",
      cp_node_count: 3
    ) { _1.id = "3ebf43d3-118a-4af7-87d2-59a3b9bf9116" }
  }

  it "displays location properly" do
    expect(kc.display_location).to eq("eu-central-h1")
  end

  it "returns path" do
    expect(kc.path).to eq("/location/eu-central-h1/kubernetes-cluster/kc-name")
  end
end
