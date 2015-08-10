require 'spec_helper'

describe '.account_capabilities' do
  it 'should fetch all account capabilities' do
    stub = stub_get('/accounts/self/capabilities', 'capabilities.json')

    client = MockGerry.new
    capabilities = client.account_capabilities

    expect(capabilities['queryLimit']['min']).to eq(0)
    expect(capabilities['queryLimit']['max']).to eq(500)
  end

  it 'should fetch some account capabilities' do
    stub = stub_get('/accounts/self/capabilities?q=createAccount&q=createGroup', 'query_capabilities.json')

    client = MockGerry.new
    capabilities = client.account_capabilities(['q=createAccount', 'q=createGroup'])
    expect(stub).to have_been_requested

    expect(capabilities['createAccount']).to eq(true)
    expect(capabilities['createGroup']).to eq(true)
  end
end

describe '.groups_for_account' do
  it "fetches all groups for which the account is a member" do
    user = "jane.roe@example.com"

    stub = stub_get("/accounts/#{user}/groups/", "account_groups.json")

    client = MockGerry.new
    new_group = client.groups_for_account(user)
    expect(stub).to have_been_requested
  end
end