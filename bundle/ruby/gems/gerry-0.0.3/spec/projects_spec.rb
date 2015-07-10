require 'spec_helper'

describe '.projects' do    
  it 'should fetch all projects' do
    stub = stub_get('/projects/', 'projects.json')                     
    
    client = MockGerry.new
    projects = client.projects
    
    expect(stub).to have_been_requested
    
    expect(projects['awesome']['description']).to eq('Awesome project')
    expect(projects['clean']['description']).to eq('Clean code!')
  end
  
  it 'should fetch a project' do
    stub = stub_get('/projects/awesome', 'projects.json')                     
    
    client = MockGerry.new
    projects = client.find_project('awesome')
    
    expect(stub).to have_been_requested
    
    expect(projects['awesome']['description']).to eq('Awesome project')
  end
end