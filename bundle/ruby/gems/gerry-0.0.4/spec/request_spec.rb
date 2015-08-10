require 'spec_helper'

describe '.map_options' do
  it 'should map the query options' do

    client = MockGerry.new
    options = client.map_options(['q=createAccount', 'q=createGroup'])

    expect(options).to eq('q=createAccount&q=createGroup')
  end
end

describe '.get' do
  it 'should request projects as anoymous' do
    stub = stub_get('/projects/', 'projects.json')

    client = MockGerry.new
    client.projects

    expect(stub).to have_been_requested
  end

  it 'should request projects as user' do
    username = 'gerry'
    password = 'whoop'

    body = get_fixture('projects.json')
    
    stub = stub_request(:get, "http://localhost/a/projects/").
      with(:headers => {'Accept'=>'application/json'}).
        to_return(:status => 200, :body => body, :headers => {})

    client = Gerry.new(MockGerry::URL, 'gerry', 'whoop')
    projects = client.projects

    # twice because the first is the auth challenge and then the actual request
    expect(stub).to have_been_requested.twice

    expect(projects['awesome']['description']).to eq('Awesome project')
    expect(projects['clean']['description']).to eq('Clean code!')
  end
end