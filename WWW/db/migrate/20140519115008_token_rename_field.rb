class TokenRenameField < ActiveRecord::Migration
  def change
  	rename_column :tokens, :token, :token_name
  end
end
