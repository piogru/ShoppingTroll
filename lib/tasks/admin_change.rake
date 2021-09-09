desc "Make an user an admin"
task :make_user_admin, [:admin_mail] => :environment do |_, args|
  User.find_by!(email: args.admin_mail).update_attribute(:admin, true)
end
