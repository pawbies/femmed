class RemoveIpAndUserAgentFromSessions < ActiveRecord::Migration[8.1]
  def change
    remove_column :sessions, :ip_address, :string
    remove_column :sessions, :user_agent, :string
  end
end
