class AddAcceptReleaseFormToRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_column :registrations, :accept_release_form, :boolean, null: false, default: false
  end
end
