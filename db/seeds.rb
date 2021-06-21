# delete all users to ensure a clean user database
User.delete_all
#create a new user to start initiating the application
member = Member.new([{ name: 'SuYiFan', email: 'demo@demo.com', phone: '01234567890', role: 'superadmin'}])
member.create

User.create([{ name: 'SuYiFan', email: 'demo@demo.com', superadmin_role: true, member: member, password: "change_me", remember_created_at: nil }])
