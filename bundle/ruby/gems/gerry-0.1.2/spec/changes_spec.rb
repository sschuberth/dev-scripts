require 'spec_helper'

describe '.changes' do
  it 'should fetch all changes' do
    stub = stub_get('/changes/', 'changes.json')

    client = MockGerry.new
    changes = client.changes

    expect(stub).to have_been_requested

    expect(changes[0]['project']).to eq('awesome')
    expect(changes[0]['branch']).to eq('master')

    expect(changes[1]['project']).to eq('clean')
    expect(changes[1]['subject']).to eq('Refactor code')
    expect(changes[1]['owner']['name']).to eq('Batman')
  end

  it 'should fetch all changes in batches' do
    stub_batch_0 = stub_get('/changes/', 'changes_batch_0.json')
    stub_batch_1 = stub_get('/changes/?S=1', 'changes_batch_1.json')
    stub_batch_2 = stub_get('/changes/?S=2', 'changes_batch_2.json')

    client = MockGerry.new
    changes = client.changes

    expect(stub_batch_0).to have_been_requested
    expect(stub_batch_1).to have_been_requested

    expect(changes[0]['project']).to eq('awesome')
    expect(changes[0]['branch']).to eq('master')
    expect(changes[0]['owner']['name']).to eq('The Duke')

    expect(changes[1]['project']).to eq('clean')
    expect(changes[1]['subject']).to eq('Refactor code')
    expect(changes[1]['owner']['name']).to eq('Batman')

    expect(changes[2]['project']).to eq('X')
    expect(changes[2]['subject']).to eq('Remove unused imports')
    expect(changes[2]['owner']['name']).to eq('Bill')
  end

  it 'should fetch all open changes' do
    stub = stub_get('/changes/?q=is:open+owner:self', 'open_changes.json')

    client = MockGerry.new
    changes = client.changes(['q=is:open+owner:self'])

    expect(stub).to have_been_requested

    expect(changes[0]['status']).to eq('OPEN')
    expect(changes[0]['owner']['name']).to eq('The Duke')
  end
end
