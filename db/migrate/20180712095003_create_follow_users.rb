class CreateFollowUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :followUsers do |t|
      t.references :user, foreign_key: true
      t.integer :follower

      t.timestamps
    end
  end
end
