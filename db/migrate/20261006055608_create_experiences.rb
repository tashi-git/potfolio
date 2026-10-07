class CreateExperiences < ActiveRecord::Migration[8.1]
  def change
    create_table :experiences do |t|
      t.string :company
      t.string :position
      t.string :description
      t.integer :period

      t.timestamps
    end
  end
end
