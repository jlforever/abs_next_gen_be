desc 'migrate data from parents to users and vice versa'
task migrate_user_date_to_parents_and_vice_versa: :environment do
  ActiveRecord::Base.transaction do
    User.find_each do |user|
      parent = user.parent

      if parent
        user.address1 = parent.address1
        user.address2 = parent.address2
        user.city = parent.city
        user.state = parent.state
        user.zip = parent.zip
        user.save!

        parent.emergency_contact = user.emergency_contact
        parent.emergency_contact_phone_number = user.emergency_contact_phone_number
        parent.save!
      end
    end
  end
end

desc 'populate all classes\'s zoom links'
task populate_all_classes_zoom_links: :environment do
  ActiveRecord::Base.transaction do
    Klass.find_each do |klass|
      klass.virtual_klass_platform_link = 'https://zoom.us/j/3405855003'
      klass.save!
    end
  end
end
