class CreateImportantInfos < ActiveRecord::Migration[7.1]
  def change
    create_table :important_infos do |t|

      t.timestamps
    end
  end
end
