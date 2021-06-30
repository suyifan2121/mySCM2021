# delete all users to ensure a clean user database
User.delete_all

# Start creating all required data to initiate the system

member = Member.create({ name: 'SuYiFan', email: 'demo@demo.com', phone: '01234567890', role: 'superadmin'})
User.create({ name: 'SuYiFan', email: 'demo@demo.com', superadmin_role: true, member: member, password: "change_me", remember_created_at: nil })

# create superadmin
member = Member.create({ name: 'superadmin', email: 'superadmin@demo.com', phone: '01234567890', role: 'superadmin'})
User.create({ name: 'superadmin', email: 'superadmin@demo.com', superadmin_role: true, member: member, password: "change_me", remember_created_at: nil })

# create system admin
member = Member.create({ name: 'sysadmin', email: 'sysadmin@demo.com', phone: '01234567890', role: 'sysadmin'})
User.create({ name: 'sysadmin', email: 'sysadmin@demo.com', sysadmin_role: true, member: member, password: "change_me", remember_created_at: nil })

# create purchasing agent
member = Member.create({ name: 'purchasing_agent', email: 'purchasing_agent@demo.com', phone: '01234567890', role: 'purchasingagent'})
User.create({ name: 'purchasing_agent', email: 'purchasing_agent@demo.com', purchasingagent_role: true, member: member, password: "change_me", remember_created_at: nil })

# create sales agent
member = Member.create({ name: 'sales_agent', email: 'sales_agent@demo.com', phone: '01234567890', role: 'salesagent'})
User.create({ name: 'sales_agent', email: 'sales_agent@demo.com', salesagent_role: true, member: member, password: "change_me", remember_created_at: nil })

# create inventory admin
member = Member.create({ name: 'inventory_admin', email: 'inventory_admin@demo.com', phone: '01234567890', role: 'inventoryadmin'})
User.create({ name: 'inventory_admin', email: 'inventory_admin@demo.com', inventoryadmin_role: true, member: member, password: "change_me", remember_created_at: nil })

# create list of suppliers
supplier_a = Supplier.create({ name: 'Supplier A', contact_person: "Mr John Kim", phone: "0127759926", email: 'john.kim@gmail.com', address: '22A 3 Jln Pjs 3/36 Taman Sri Manja Petaling Jaya'})
supplier_b = Supplier.create({ name: 'Supplier B', contact_person: "Mr Tan Chok", phone: "0133744926", email: 'tan.chok@gmail.com', address: '612 Jln 17/10 Seksyen 17 Petaling Jaya'})
supplier_c = Supplier.create({ name: 'Supplier C', contact_person: "Mr Tammarudin", phone: "0176539979", email: 'tammaru.din@gmail.com', address: '57 Jln Andalas 1 Kawasan Perindustrian Ringan 7'})
supplier_d = Supplier.create({ name: 'Supplier D', contact_person: "Ms Jammie Tan", phone: "01155254467", email: 'jammie.tan@gmail.com', address: '36 Ltg Sungai 1'})
supplier_e = Supplier.create({ name: 'Supplier E', contact_person: "Ms Fatasha", phone: "0123359526", email: 'fata.sha@gmail.com', address: '5364 Jln 18/21 Seksyen 18 Petaling Jaya'})

# create a list of clients
client_a = Client.create({ name: 'Client A', contact_person: "Ms Farah", phone: "0123359526", email: 'farah@gmail.com', address: 'G 26 Jln 45A/26 Taman Sri Rampai'})
client_b = Client.create({ name: 'Client B', contact_person: "Ms Felisha", phone: "0124459526", email: 'feli.sha@gmail.com', address: '5364 Jln 18/21 Seksyen 18 Petaling Jaya'})
client_c = Client.create({ name: 'Client C', contact_person: "Ms Fatasha", phone: "0123359526", email: 'fata.sha@gmail.com', address: 'Prima Peninsular Jln Setiawangsa 11 Taman Setiawangsa Hulu'})
client_d = Client.create({ name: 'Client D', contact_person: "Mr Tom Kin", phone: "0133359526", email: 'tom.kin@gmail.com', address: '11 Jln Sri Ampang Taman Jaya'})

# create a list of commodities
Item.create({ name: 'Item 1', category: 'Meat', description: 'this is a meat', remaining_quantity: 100, purchase_price: 23.7, retail_price: 33.7})
Item.create({ name: 'Item 2', category: 'Hardware', description: 'this is a hardware', remaining_quantity: 100, purchase_price: 55.3, retail_price: 155.3})
Item.create({ name: 'Item 3', category: 'Tools', description: 'this is a tool', remaining_quantity: 100, purchase_price: 17.2, retail_price: 22.2})
Item.create({ name: 'Item 4', category: 'Beverage', description: 'this is a beverage', remaining_quantity: 100, purchase_price: 0.7, retail_price: 2.7})
Item.create({ name: 'Item 5', category: 'Hardware', description: 'this is a hardware', remaining_quantity: 100, purchase_price: 23, retail_price: 83.8})
Item.create({ name: 'Item 6', category: 'Other', description: 'this belongs in other category not listed', remaining_quantity: 100, purchase_price: 2.3, retail_price: 7.7})

# create a list of purchase orders
Order.create({ quantity: 5, status: 0, member_id: 1, supplier: supplier_a.name, price: 99, items: "[{\"id\":\"1\",\"name\":\"Item 1\",\"quantity\":\"2\",\"price\":23.7,\"amount\":47.4},{\"id\":\"2\",\"name\":\"Item 2\",\"quantity\":\"3\",\"price\":17.2,\"amount\":51.6}]", order_type: "purchase", date: "2021-07-15 00:00:00"})
Order.create({ quantity: 5, status: 0, member_id: 1, supplier: supplier_b.name, price: 99, items: "[{\"id\":\"1\",\"name\":\"Item 1\",\"quantity\":\"2\",\"price\":23.7,\"amount\":47.4},{\"id\":\"2\",\"name\":\"Item 2\",\"quantity\":\"3\",\"price\":17.2,\"amount\":51.6}]", order_type: "purchase", date: "2021-07-11 00:00:00"})
Order.create({ quantity: 5, status: 0, member_id: 1, supplier: supplier_c.name, price: 99, items: "[{\"id\":\"1\",\"name\":\"Item 1\",\"quantity\":\"2\",\"price\":23.7,\"amount\":47.4},{\"id\":\"2\",\"name\":\"Item 2\",\"quantity\":\"3\",\"price\":17.2,\"amount\":51.6}]", order_type: "purchase", date: "2021-07-12 00:00:00"})
Order.create({ quantity: 5, status: 0, member_id: 1, supplier: supplier_d.name, price: 99, items: "[{\"id\":\"1\",\"name\":\"Item 1\",\"quantity\":\"2\",\"price\":23.7,\"amount\":47.4},{\"id\":\"2\",\"name\":\"Item 2\",\"quantity\":\"3\",\"price\":17.2,\"amount\":51.6}]", order_type: "purchase", date: "2021-07-15 00:00:00"})
Order.create({ quantity: 5, status: 0, member_id: 1, supplier: supplier_c.name, price: 99, items: "[{\"id\":\"1\",\"name\":\"Item 1\",\"quantity\":\"2\",\"price\":23.7,\"amount\":47.4},{\"id\":\"2\",\"name\":\"Item 2\",\"quantity\":\"3\",\"price\":17.2,\"amount\":51.6}]", order_type: "purchase", date: "2021-07-21 00:00:00"})
Order.create({ quantity: 5, status: 0, member_id: 1, supplier: supplier_e.name, price: 99, items: "[{\"id\":\"1\",\"name\":\"Item 1\",\"quantity\":\"2\",\"price\":23.7,\"amount\":47.4},{\"id\":\"2\",\"name\":\"Item 2\",\"quantity\":\"3\",\"price\":17.2,\"amount\":51.6}]", order_type: "purchase", date: "2021-07-11 00:00:00"})

# create a list of sales orders
Order.create({ quantity: 5, status: 0, member_id: 1, client: client_a.name, price: 233.3, items: "[{\"id\":\"1\",\"name\":\"Item 1\",\"quantity\":\"2\",\"price\":33.7,\"amount\":67.4},{\"id\":\"2\",\"name\":\"Item 2\",\"quantity\":\"3\",\"price\":55.3,\"amount\":165.9}]", order_type: "sales", date: "2021-07-13 00:00:00"})
Order.create({ quantity: 5, status: 0, member_id: 1, client: client_b.name, price: 233.3, items: "[{\"id\":\"1\",\"name\":\"Item 1\",\"quantity\":\"2\",\"price\":33.7,\"amount\":67.4},{\"id\":\"2\",\"name\":\"Item 2\",\"quantity\":\"3\",\"price\":55.3,\"amount\":165.9}]", order_type: "sales", date: "2021-07-15 00:00:00"})
Order.create({ quantity: 5, status: 0, member_id: 1, client: client_c.name, price: 233.3, items: "[{\"id\":\"1\",\"name\":\"Item 1\",\"quantity\":\"2\",\"price\":33.7,\"amount\":67.4},{\"id\":\"2\",\"name\":\"Item 2\",\"quantity\":\"3\",\"price\":55.3,\"amount\":165.9}]", order_type: "sales", date: "2021-07-15 00:00:00"})
Order.create({ quantity: 5, status: 0, member_id: 1, client: client_b.name, price: 233.3, items: "[{\"id\":\"1\",\"name\":\"Item 1\",\"quantity\":\"2\",\"price\":33.7,\"amount\":67.4},{\"id\":\"2\",\"name\":\"Item 2\",\"quantity\":\"3\",\"price\":55.3,\"amount\":165.9}]", order_type: "sales", date: "2021-07-17 00:00:00"})
Order.create({ quantity: 5, status: 0, member_id: 1, client: client_d.name, price: 233.3, items: "[{\"id\":\"1\",\"name\":\"Item 1\",\"quantity\":\"2\",\"price\":33.7,\"amount\":67.4},{\"id\":\"2\",\"name\":\"Item 2\",\"quantity\":\"3\",\"price\":55.3,\"amount\":165.9}]", order_type: "sales", date: "2021-07-18 00:00:00"})
Order.create({ quantity: 5, status: 0, member_id: 1, client: client_c.name, price: 233.3, items: "[{\"id\":\"1\",\"name\":\"Item 1\",\"quantity\":\"2\",\"price\":33.7,\"amount\":67.4},{\"id\":\"2\",\"name\":\"Item 2\",\"quantity\":\"3\",\"price\":55.3,\"amount\":165.9}]", order_type: "sales", date: "2021-07-21 00:00:00"})
Order.create({ quantity: 5, status: 0, member_id: 1, client: client_d.name, price: 233.3, items: "[{\"id\":\"1\",\"name\":\"Item 1\",\"quantity\":\"2\",\"price\":33.7,\"amount\":67.4},{\"id\":\"2\",\"name\":\"Item 2\",\"quantity\":\"3\",\"price\":55.3,\"amount\":165.9}]", order_type: "sales", date: "2021-07-23 00:00:00"})
Order.create({ quantity: 5, status: 0, member_id: 1, client: client_a.name, price: 233.3, items: "[{\"id\":\"1\",\"name\":\"Item 1\",\"quantity\":\"2\",\"price\":33.7,\"amount\":67.4},{\"id\":\"2\",\"name\":\"Item 2\",\"quantity\":\"3\",\"price\":55.3,\"amount\":165.9}]", order_type: "sales", date: "2021-07-25 00:00:00"})