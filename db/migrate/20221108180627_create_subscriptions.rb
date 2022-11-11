class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true, null: false
      t.belongs_to :subscribable, polymorphic: true
      
      t.timestamps
    end
  end
end
