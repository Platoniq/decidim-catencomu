# frozen_string_literal: true
# This migration comes from decidim_civicrm_verifications_groups (originally 20210720102430)

class CreateDecidimCivicrmUserGroupAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :decidim_civicrm_user_group_assignments do |t|
      t.references :decidim_user, null: false, foreign_key: true, index: { name: "civicrm_user_group_assignments_user" }
      t.integer :civicrm_group_id, null: false, foreign_key: true, index: { name: "civicrm_user_group_assignments_group" }
      t.jsonb :data, default: {}

      t.timestamps
    end
  end
end
