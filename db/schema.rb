Sequel.migration do
  change do
    create_table(:schema_migrations) do
      column :filename, "varchar(255)", :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:web_stats) do
      primary_key :id, :type=>"int(11)"
      column :url, "varchar(255)"
      column :referrer, "varchar(255)"
      column :created_at, "datetime"
      column :hash, "varchar(255)"
      
      index [:url, :referrer, :created_at]
    end
  end
end
Sequel.migration do
  change do
    self << "INSERT INTO `schema_migrations` (`filename`) VALUES ('20140120052613_create_web_stats.rb')"
  end
end
