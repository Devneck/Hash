############################################################
#
#  Name:        Sean Glover
#  Assignment:  Hash Assignment
#  Date:        02/27/2013
#  Class:       CIS 282
#  Description: Menu program with data in external file - use of hashes
#
############################################################

# method for displaying products from hash
def display_products(products)
  puts " ID          Description               Price"
  puts "-" * 50
  products.each do |key, value|
    #puts key.class
    #puts value[1] + 1
    puts "#{key}   #{value[0].rjust(25)}      $#{sprintf("%.2f", value[1]).to_s.rjust(6)}"
  end
end

def menu
  puts
  puts "1. View all products"
  puts "2. Add a new product"
  puts "3. Delete a product"
  puts "4. Update a product"
  puts
  puts "5. View highest priced product"
  puts "6. View lowest priced product"
  puts "7. View sum of all product prices"
  puts
  puts "8. Quit"
end

# hash to populate from file and update with application
products = {}

# open file and initialize hash
products_file = File.open("products.txt")

# loop through file for hash population
while ! products_file.eof?
  # read each line from file
  line = products_file.gets.chomp
  # split on comma separated values
  data_array = line.split(",")
  # populate hash with values from file
  products[data_array[0].to_i] = [data_array[1], data_array[2].to_f]
end
# close file
products_file.close

user_choice = 0

until user_choice == 8
  menu
  user_choice = gets.to_i

  if user_choice == 1
    display_products(products)

  elsif user_choice == 2
    print "Please enter a product description: "
    new_product = gets.chomp
    puts "Please enter product price: "
    print "Do not include dollar sign ($) in price. Decimal is acceptable: "
    new_price = gets.to_f.round(2)

    if new_product == "" or new_price == 0.0
      puts "Product name and price are required. Record was not updated."
    else
      new_id = rand(100..999)

      while products.has_key?(new_id)
        new_id = rand(100..999)
      end

      products[new_id] = [new_product, new_price]
      puts "#{new_product} was added to the records."
    end

  elsif user_choice == 3
    display_products(products)
    puts
    print "Enter ID number you would like to delete: "
    id_number = gets.to_i

    if products.has_key?(id_number)
      puts "Are you sure you want to permanently delete \"#{products[id_number][0]}\"?"
      puts "This cannot be reversed if you accept. (y/n)"
      user_delete = gets.chomp

      if user_delete == "y"
        products.delete(id_number)
        puts "Record was deleted."
      else
        puts "The record was not deleted."
      end
    else
      puts "That is not a valid id number."
    end

  elsif user_choice == 4
    display_products(products)
    puts
    print "Enter ID number you would like to delete: "
    id_number = gets.to_i

    if products.has_key?(id_number)
      print "Enter new product description (leave blank to retain current description): "
      new_name = gets.chomp
      puts "Enter new price (leave blank to retain current price): "
      print "Do not include dollar sign ($) in price. Decimal is acceptable: "
      new_price = gets.to_f

      if new_name == "" and new_price == 0.0
        puts "Record was not updated."

      else
        if new_name != ""
          products[id_number][0] = new_name
        end

        if new_price != 0.0
          products[id_number][1] = new_price
        end
        puts "Record was updated."

      end

    else
      puts "That is not a valid id number."
    end

  elsif user_choice == 5
    high_price = 0.0
    high_products = {}

    products.each do |key, value|
      if value[1] > high_price
        high_price = value[1]
        high_products.clear
        high_products[key] = value
      elsif value[1] == high_price
        high_products[key] = value
      end
    end

    puts "Highest priced products:"
    display_products(high_products)

  elsif user_choice == 6
    low_price = 999.99
    low_products = {}

    products.each do |key, value|
      if value[1] < low_price
        low_price = value[1]
        low_products.clear
        low_products[key] = value
      elsif value[1] == low_price
        low_products[key] = value
      end
    end

    puts "Lowest priced products:"
    display_products(low_products)

  elsif user_choice == 7
    sum = 0.0

    products.each_value do |value|
      sum += value[1]
    end

    puts "The Sum of all products is: #{sprintf("$%.2f", sum)}."

  elsif user_choice != 8
    puts "That is an invalid selection."
  end
end

# update flat file
products_file = File.open("products.txt", "w")

products.each do |key, value|
  products_file.puts "#{key},#{value[0]},#{value[1]}"
end

products_file.close