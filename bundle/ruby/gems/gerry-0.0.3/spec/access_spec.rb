require 'spec_helper'

describe '.list_access_rights' do
  it 'lists the access rights for projects' do
    projects = ['All-Projects', 'MyProject']
    stub = stub_get("/access/?project=#{projects.join('&project=')}", 'access_rights.json')

    client = MockGerry.new
    access_rights = client.access(projects)
    expect(stub).to have_been_requested

    expect(access_rights['All-Projects']['revision']).to eq('edd453d18e08640e67a8c9a150cec998ed0ac9aa')
    expect(access_rights['MyProject']['revision']).to eq('61157ed63e14d261b6dca40650472a9b0bd88474')
  end
end
