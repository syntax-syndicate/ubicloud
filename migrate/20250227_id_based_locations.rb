# frozen_string_literal: true

Sequel.migration do
  up do
    alter_table(:vm_host) do
      add_foreign_key :location_id, :location, type: :uuid
    end

    alter_table(:vm) do
      add_foreign_key :location_id, :location, type: :uuid
    end

    alter_table(:vm_pool) do
      add_foreign_key :location_id, :location, type: :uuid
    end

    alter_table(:private_subnet) do
      add_foreign_key :location_id, :location, type: :uuid
    end

    alter_table(:firewall) do
      add_foreign_key :location_id, :location, type: :uuid
    end

    alter_table(:postgres_resource) do
      add_foreign_key :location_id, :location, type: :uuid
    end

    alter_table(:minio_cluster) do
      add_foreign_key :location_id, :location, type: :uuid
    end

    alter_table(:inference_endpoint) do
      add_foreign_key :location_id, :location, type: :uuid
    end

    alter_table(:kubernetes_cluster) do
      add_foreign_key :location_id, :location, type: :uuid
    end

    run "UPDATE vm_host SET location_id = (SELECT id FROM location WHERE name = vm_host.location);"
    run "UPDATE vm SET location_id = (SELECT id FROM location WHERE name = vm.location);"
    run "UPDATE vm_pool SET location_id = (SELECT id FROM location WHERE name = vm_pool.location);"
    run "UPDATE private_subnet SET location_id = (SELECT id FROM location WHERE name = private_subnet.location);"
    run "UPDATE firewall SET location_id = (SELECT id FROM location WHERE name = firewall.location);"
    run "UPDATE postgres_resource SET location_id = (SELECT id FROM location WHERE name = postgres_resource.location);"
    run "UPDATE minio_cluster SET location_id = (SELECT id FROM location WHERE name = minio_cluster.location);"
    run "UPDATE inference_endpoint SET location_id = (SELECT id FROM location WHERE name = inference_endpoint.location);"
    run "UPDATE kubernetes_cluster SET location_id = (SELECT id FROM location WHERE name = kubernetes_cluster.location);"

    alter_table(:vm_host) do
      drop_column :location
    end

    alter_table(:vm) do
      drop_column :location
    end

    alter_table(:private_subnet) do
      drop_column :location
    end

    alter_table(:firewall) do
      drop_column :location
    end

    alter_table(:postgres_resource) do
      drop_column :location
    end

    alter_table(:minio_cluster) do
      drop_column :location
    end

    alter_table(:inference_endpoint) do
      drop_column :location
    end

    alter_table(:vm_pool) do
      drop_column :location
    end

    alter_table(:kubernetes_cluster) do
      drop_column :location
    end
  end

  down do
    alter_table(:vm_host) do
      drop_column :location_id
      add_column :location, :text
    end

    alter_table(:vm) do
      drop_column :location_id
      add_column :location, :text
    end

    alter_table(:private_subnet) do
      drop_column :location_id
      add_column :location, :text
    end

    alter_table(:firewall) do
      drop_column :location_id
      add_column :location, :text
    end

    alter_table(:postgres_resource) do
      drop_column :location_id
      add_column :location, :text
    end

    alter_table(:minio_cluster) do
      drop_column :location_id
      add_column :location, :text
    end

    alter_table(:inference_endpoint) do
      drop_column :location_id
      add_column :location, :text
    end

    alter_table(:vm_pool) do
      drop_column :location_id
      add_column :location, :text
    end
  end
end
