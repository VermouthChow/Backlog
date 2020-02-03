class InstallSomeContribPackages < ActiveRecord::Migration[5.1]
  def change
    execute "CREATE EXTENSION IF NOT EXISTS btree_gin;"
    execute "CREATE EXTENSION IF NOT EXISTS btree_gist;"
  end
end