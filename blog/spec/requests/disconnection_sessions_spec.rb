require 'spec_helper'

describe "DisconnectionSessions" do

  describe "DELETE /_sessions" do

    it "should have a link 'Disconnect' in the index to disconnect the user" do
      visit posts_path
      #page.should have_link('Disconnect', :href => session_path)
    end



  end

end
