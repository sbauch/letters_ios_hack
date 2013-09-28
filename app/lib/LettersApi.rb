class LettersApi

  def self.root_url
    RMENV['HOST']
  end

  def self.submitWord(word, &block)
    token = UIApplication.sharedApplication.delegate.settings.device_token
    id = UIApplication.sharedApplication.delegate.settings.game_id
    BW::HTTP.get(root_url + "games/#{id}/word/#{word}?device_token=#{token}") do |response|
      if response.ok?
        json = BW::JSON.parse(response.body.to_str)
        block.call(json, false)
      else
        block.call(nil, true)
      end
    end
  end

  def self.addPlayer(name, code, &block)
    token = UIApplication.sharedApplication.delegate.settings.device_token
    BW::HTTP.get(root_url + "games/#{code}/join?user_name=#{name}&device_token=#{token}") do |response|
      if response.ok?
        json = BW::JSON.parse(response.body.to_str)
        block.call(json, false)
      else
        block.call(nil, true)
      end
    end
  end
end
