class AddChartNumToBooks < ActiveRecord::Migration
  def change
    add_column :books, :chart_num, :integer
  end
end
