class CreateTravels < Jennifer::Migration::Base
  def up
    create_table :travels do |t|
      t.bigint :travel_stops, {:null => false, :array => true}
    end
  end

  def down
    drop_table :travels if table_exists? :travels
  end
end
