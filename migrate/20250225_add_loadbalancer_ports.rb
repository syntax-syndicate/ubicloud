# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:load_balancer_port) do
      uuid :id, primary_key: true
      uuid :load_balancer_id, null: false
      Integer :src_port, null: false
      Integer :dst_port, null: false
      String :health_check_endpoint, text: true, null: false, default: "/up"
      Integer :health_check_interval, null: false, default: 30
      Integer :health_check_timeout, null: false, default: 15
      Integer :health_check_up_threshold, null: false, default: 3
      Integer :health_check_down_threshold, null: false, default: 2
      String :health_check_protocol, text: true, null: false, default: "http"

      foreign_key [:load_balancer_id], :load_balancer, key: :id
      index [:load_balancer_id, :src_port, :dst_port], unique: true, name: :lb_port_unique_index

      check Sequel.lit("health_check_timeout > 0"), name: :chk_health_check_timeout
      check Sequel.lit("health_check_interval > 0 AND health_check_interval < 600"), name: :chk_health_check_interval
      check Sequel.lit("health_check_timeout <= health_check_interval"), name: :chk_timeout_interval
      check Sequel.lit("health_check_up_threshold > 0"), name: :chk_health_check_up_threshold
      check Sequel.lit("health_check_down_threshold > 0"), name: :chk_health_check_down_threshold
    end

    create_table(:load_balancer_vm_port) do
      uuid :id, primary_key: true
      uuid :load_balancer_id, null: false
      uuid :load_balancer_port_id, null: false
      uuid :vm_id, null: false
      column :state, :lb_node_state, null: false, default: "down"
      DateTime :last_checked_at, null: false, default: Sequel::CURRENT_TIMESTAMP

      foreign_key [:load_balancer_port_id], :load_balancer_port, key: :id
      foreign_key [:load_balancer_id], :load_balancer, key: :id, on_delete: :cascade
      foreign_key [:vm_id], :vm, key: :id

      index [:load_balancer_port_id, :vm_id], unique: true, name: :lb_vm_port_unique_index
    end

    alter_table(:load_balancer) do
      set_column_allow_null :src_port
      set_column_allow_null :dst_port
      set_column_allow_null :health_check_endpoint
      set_column_allow_null :health_check_interval
      set_column_allow_null :health_check_timeout
      set_column_allow_null :health_check_up_threshold
      set_column_allow_null :health_check_down_threshold
      set_column_allow_null :health_check_protocol
    end

    alter_table(:load_balancers_vms) do
      set_column_allow_null :state
    end
  end

  down do
    drop_table(:load_balancer_vm_port)
    drop_table(:load_balancer_port)

    self[:load_balancer].where(src_port: nil).update(src_port: 80)
    self[:load_balancer].where(dst_port: nil).update(dst_port: 8000)
    self[:load_balancer].where(health_check_endpoint: nil).update(health_check_endpoint: "/up")
    self[:load_balancer].where(health_check_interval: nil).update(health_check_interval: 30)
    self[:load_balancer].where(health_check_timeout: nil).update(health_check_timeout: 15)
    self[:load_balancer].where(health_check_up_threshold: nil).update(health_check_up_threshold: 3)
    self[:load_balancer].where(health_check_down_threshold: nil).update(health_check_down_threshold: 2)
    self[:load_balancer].where(health_check_protocol: nil).update(health_check_protocol: "http")

    alter_table(:load_balancer) do
      set_column_default :src_port, 80
      set_column_default :dst_port, 80
      set_column_default :health_check_endpoint, "/up"
      set_column_default :health_check_interval, 30
      set_column_default :health_check_timeout, 15
      set_column_default :health_check_up_threshold, 3
      set_column_default :health_check_down_threshold, 2
      set_column_default :health_check_protocol, "http"

      set_column_not_null :src_port
      set_column_not_null :dst_port
      set_column_not_null :health_check_endpoint
      set_column_not_null :health_check_interval
      set_column_not_null :health_check_timeout
      set_column_not_null :health_check_up_threshold
      set_column_not_null :health_check_down_threshold
      set_column_not_null :health_check_protocol
    end

    alter_table(:load_balancers_vms) do
      add_column :state, :lb_node_state, null: false, default: "down"
    end
  end
end
