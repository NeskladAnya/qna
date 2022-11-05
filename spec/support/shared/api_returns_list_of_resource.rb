shared_examples_for 'API returns list of resource' do
  it 'returns list of all contents' do
    resource_contents.each do |content|
      expect(resource_response[content].size).to eq resource.send(content).size
    end
  end
end
