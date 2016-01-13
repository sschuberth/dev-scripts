require 'spec_helper'

describe '.list_groups' do    
  it 'fetchs all groups' do
    stub = stub_get('/groups/', 'groups.json')                     
    
    client = MockGerry.new
    groups = client.groups
    expect(stub).to have_been_requested

    expect(groups.size).to eq(6)
    expect(groups).to include('Project Owners')
  end
end

describe '.group_members' do
  it "fetchs all members of the specified group" do
    stub = stub_get('/groups/834ec36dd5e0ed21a2ff5d7e2255da082d63bbd7/members/', 'group_members.json')

    client = MockGerry.new
    group_members = client.group_members('834ec36dd5e0ed21a2ff5d7e2255da082d63bbd7')
    expect(stub).to have_been_requested

    expect(group_members.size).to eq(2)
    expect(group_members[1]['email']).to eq('john.doe@example.com')
  end
end

describe '.create_group' do
  let(:name) { "my_new_group_name" }
  let(:description) { "group description" }
  let(:visible) { true }
  let(:owner_id) { nil }
  
  it "creates a group" do
    input = {
      description: description,
      visible_to_all: visible
    }

    response = %Q<)]}'
      {
        "kind": "gerritcodereview#group",
        "id": "9999c971bb4ab872aab759d8c49833ee6b9ff320",
        "name": "#{name}",
        "url": "#/admin/groups/uuid-9999c971bb4ab872aab759d8c49833ee6b9ff320",
        "options": {
          "visible_to_all": true
        },
        "description":"#{description}",
        "group_id": 551,
        "owner": "#{name}",
        "owner_id": "9999c971bb4ab872aab759d8c49833ee6b9ff320"
      }
    >
    stub = stub_put('/groups/my_new_group_name', input.to_json, response)

    client = MockGerry.new
    new_group = client.create_group(name, description, visible, owner_id)
    expect(stub).to have_been_requested
  end
end

describe '.add_to_group' do
  it "adds users to a group" do
    users = %w(jane.roe@example.com john.doe@example.com)
    group_id = "9999c971bb4ab872aab759d8c49833ee6b9ff320"
    input = {
      members: users
    }
    stub = stub_post("/groups/#{group_id}/members", input.to_json, get_fixture('group_members.json'))

    client = MockGerry.new
    new_group = client.add_to_group(group_id, users)
    expect(stub).to have_been_requested
  end
end

describe '.remove_from_group' do
  it "removes users from a group" do
    users = %w(jane.roe@example.com john.doe@example.com)
    group_id = "9999c971bb4ab872aab759d8c49833ee6b9ff320"
    input = {
      members: users
    }
    stub = stub_post("/groups/#{group_id}/members.delete", input.to_json, "")

    client = MockGerry.new
    new_group = client.remove_from_group(group_id, users)
    expect(stub).to have_been_requested
  end
end
