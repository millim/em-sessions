require 'em-sessions'
require 'json'
RSpec.describe 'test em sessions' do

  it 'init sessions' do
    Em::Sessions.init
    expect(Em::Sessions.client.class).to eql Em::Sessions::Client
  end

  it 'use create rest-sessions' do
    Em::Sessions.init
    id = "id#{Time.now.to_i}"
    code, json  = Em::Sessions.client.create "id#{Time.now.to_i}", 60, '0.0.0.0'
    expect(code).to eq 200

    code, json  = Em::Sessions.client.get_by_token json['token']
    expect(code).to eq 200
    expect(json['id']).to eql id
  end


  context 'set id, have token action' do
    before(:all) do
      Em::Sessions.init
      @id = "id#{Time.now.to_i}-set-action"
      @client = Em::Sessions.client
      _, json  = @client.create @id, 60, '0.0.0.0'
      @token = json['token']
    end

    it 'set params' do
      code, json = @client.set_params_by_token @token, {name: '名字', age: '年龄'}
      _, find_json = @client.get_by_token(@token)
      expect(code).to eq 200
      expect(json).to eq find_json
      expect(find_json['d']['name']).to eql '名字'
    end

    it 'test activity' do
      code, json = @client.activity?
      expect(code).to eq 200
      expect(json['activity'].class).to eql Fixnum
    end

    it 'get sessions use id' do
      @client.create @id, 60, 'localhost'
      code, json = @client.get_by_id @id
      expect(code).to eq 200
      expect(json['sessions'].class).to eql Array
      expect(json['sessions'].size).to eql 2
    end

    it 'kill by token' do
      code, json = @client.delete_by_token @token
      expect(code).to eq 200
      expect(json['kill']).to eq 1
    end

    it 'kill by token' do
      code, json = @client.delete_by_id @id
      expect(code).to eq 200
      expect(json['kill']).to eq 1
    end

    it 'kill all' do
      _, json = @client.activity?
      now_number = json['activity']
      code, json = @client.delete_all
      expect(code).to eq 200
      expect(json['kill']).to eq now_number
    end

  end

end