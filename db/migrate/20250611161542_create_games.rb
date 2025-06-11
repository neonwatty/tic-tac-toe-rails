class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.references :player1, null: false, foreign_key: { to_table: :users }
      t.references :player2, null: true, foreign_key: { to_table: :users }
      t.json :moves
      t.string :result
      t.integer :status
      t.string :difficulty_level

      t.timestamps
    end
  end
end
