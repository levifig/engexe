Sequel.migration do 
  change do
    create_table :web_stats do
      primary_key   :id
      varchar       :url
      varchar       :referrer
      datetime      :created_at
      varchar       :hash
    end
    add_index :web_stats, [:url, :referrer, :created_at]
  end
end