puts "Clearing existing data..."
Review.destroy_all
OrderItem.destroy_all
Order.destroy_all
CartItem.destroy_all
Product.destroy_all
Category.destroy_all
User.destroy_all

puts "Creating categories..."
categories = [
  { name: "Electronics", description: "Latest gadgets and electronic devices" },
  { name: "Clothing", description: "Fashion and apparel for all ages" },
  { name: "Books", description: "Books across all genres and topics" },
  { name: "Home & Garden", description: "Everything for your home and garden" },
  { name: "Sports", description: "Sports equipment and accessories" },
  { name: "Beauty", description: "Beauty and personal care products" }
]

created_categories = categories.map do |cat_data|
  Category.create!(cat_data)
end

puts "Creating users..."
# Create admin user
admin = User.create!(
  first_name: "Admin User",
  last_name: "Marketplace",
  email_address: "admin@marketplace.com",
  password: "password",
  password_confirmation: "password",
  role: "admin",
  phone: "123-456-7890",
  address: "123 Admin Street, Admin City, Admin Country"
)

# Create sellers
sellers = []
5.times do |i|
  sellers << User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email_address: "seller#{i+1}@marketplace.com",
    password: "password",
    password_confirmation: "password",
    role: "seller",
    phone: Faker::PhoneNumber.phone_number,
    address: Faker::Address.full_address
  )
end

# Create customers
customers = []
10.times do |i|
  customers << User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email_address: "customer#{i+1}@marketplace.com",
    password: "password",
    password_confirmation: "password",
    role: "customer",
    phone: Faker::PhoneNumber.phone_number,
    address: Faker::Address.full_address
  )
end

puts "Creating products..."
products = []
50.times do
  category = created_categories.sample
  seller = sellers.sample

  products << Product.create!(
    name: Faker::Commerce.product_name,
    description: Faker::Lorem.paragraph(sentence_count: 3),
    price: Faker::Commerce.price(range: 10.0..500.0),
    stock_quantity: rand(0..100),
    user: seller,
    category: category
  )
end

puts "Creating reviews..."
products.each do |product|
  # Random number of reviews for each product
  rand(0..8).times do
    customer = customers.sample

    # Avoid duplicate reviews
    next if Review.exists?(user: customer, product: product)

    Review.create!(
      user: customer,
      product: product,
      rating: rand(1..5),
      comment: Faker::Lorem.paragraph(sentence_count: 2)
    )
  end
end

puts "Creating sample orders..."
customers.each do |customer|
  # Some customers have orders
  next if rand > 0.6

  rand(1..3).times do
    order_products = products.sample(rand(1..4))

    # Calculate total amount before creating order
    total_amount = order_products.sum do |product|
      quantity = rand(1..3)
      quantity * product.price
    end

    order = Order.create!(
      user: customer,
      total_amount: total_amount,
      # FIXED: Changed :confirmed to :paid to match the Order model's enum
      status: [ :pending, :paid, :shipped, :delivered, :cancelled ].sample
    )

    # Create order items
    order_products.each do |product|
      quantity = rand(1..3)
      price = product.price
      total_price = quantity * price

      OrderItem.create!(
        order: order,
        product: product,
        quantity: quantity,
        price: price,
        total_price: total_price
      )
    end
  end
end

puts "Creating sample cart items..."
customers.each do |customer|
  # Some customers have items in cart
  next if rand > 0.4

  cart_products = products.sample(rand(1..3))
  cart_products.each do |product|
    next unless product.in_stock?

    CartItem.create!(
      user: customer,
      product: product,
      quantity: rand(1..3)
    )
  end
end

puts "Seed data created successfully!"
puts "Admin user: admin@marketplace.com / password"
puts "Seller users: seller1@marketplace.com to seller5@marketplace.com / password"
puts "Customer users: customer1@marketplace.com to customer10@marketplace.com / password"
