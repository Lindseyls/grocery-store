require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'
require_relative '../lib/order'

require 'csv'

describe "Order Wave 1" do
  describe "#initialize" do
    it "Takes an ID and collection of products" do
      # Arrange
      id = 1337
      order = Grocery::Order.new(id, {})

      # Act
      order.must_respond_to :id
      order.id.must_equal id
      order.id.must_be_kind_of Integer

      # Assert
      order.must_respond_to :products
      order.products.length.must_equal 0
    end
  end # describe "#initialize"

  describe "#total" do
    it "Returns the total from the collection of products" do
      # Arrange
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      # Act
      sum = products.values.inject(0, :+)
      expected_total = sum + (sum * 0.075).round(2)

      # Assert
      order.total.must_equal expected_total
    end
    it "Returns a total of zero if there are no products" do
      order = Grocery::Order.new(1337, {})

      order.total.must_equal 0
    end
  end # describe "#total"

  describe "#add_product" do
    it "Increases the number of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      before_count = products.count
      order = Grocery::Order.new(1337, products)

      order.add_product("salad", 4.25)
      expected_count = before_count + 1
      order.products.count.must_equal expected_count
    end
    it "Is added to the collection of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      order.add_product("sandwich", 4.25)
      order.products.include?("sandwich").must_equal true
    end
    it "Returns false if the product is already present" do
      products = { "banana" => 1.99, "cracker" => 3.00 }

      order = Grocery::Order.new(1337, products)
      before_total = order.total

      result = order.add_product("banana", 4.25)
      after_total = order.total

      result.must_equal false
      before_total.must_equal after_total
    end
    it "Returns true if the product is new" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Grocery::Order.new(1337, products)

      result = order.add_product("salad", 4.25)
      result.must_equal true
    end
  end # describe "#add_product"

end # describe "Order Wave 1"

describe "Order Wave 2" do
  describe "Order.all" do
    it "Returns an array of all orders" do
      order = Grocery::Order.all

      order.must_be_kind_of Array
    end

    it "Returns accurate information about the first order" do
      order = Grocery::Order.all

      order[0].must_be_kind_of Grocery::Order
    end

    it "Returns accurate information about the last order" do
      order = Grocery::Order.all

      order[99].must_be_kind_of Grocery::Order
    end
  end # describe "Order.all"

  describe "Order.find" do
    it "Can find the first order from the CSV" do
      find_id = Grocery::Order.find(1)

      find_id.must_be_kind_of Grocery::Order
    end

    it "Can find the last order from the CSV" do
      find_id = Grocery::Order.find(100)

      find_id.must_be_kind_of Grocery::Order
    end

    it "Raises an error for an order that doesn't exist" do
      find_id = Grocery::Order.find(101)

      find_id.must_be_kind_of NilClass
    end
  end # describe "Order.find"

end # describe "Order Wave 2"
