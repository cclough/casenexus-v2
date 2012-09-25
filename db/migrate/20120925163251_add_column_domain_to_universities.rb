class AddColumnDomainToUniversities < ActiveRecord::Migration
  def change
    add_column :universities, :domain, :string
  end
end
