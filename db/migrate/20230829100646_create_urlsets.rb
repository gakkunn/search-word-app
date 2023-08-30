class CreateUrlsets < ActiveRecord::Migration[5.2]
  def change
    create_table :urlsets do |t|
      t.string :name
      t.string :address
      t.references :block, foreign_key: true

      t.timestamps
    end
  end
end