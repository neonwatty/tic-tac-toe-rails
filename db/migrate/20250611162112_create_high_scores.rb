class CreateHighScores < ActiveRecord::Migration[8.0]
  def change
    create_table :high_scores do |t|
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true
      t.integer :score
      t.string :difficulty_level

      t.timestamps
    end
  end
end
