class CreateEducations < ActiveRecord::Migration[8.1]
  def change
    create_table :educations do |t|
      t.string :institution
      t.string :qualification

      t.timestamps
    end
  end
end
