# delete all users to ensure a clean user database
User.delete_all
#create a new user to start initiating the application
User.create([{ name: 'SuYiFan', email: 'demo@demo.com', password: "change_me", remember_created_at: nil }])
