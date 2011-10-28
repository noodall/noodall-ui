Factory(:page_a, :title => "Home", :publish => true)

5.times do |i|
  page = Factory(:page_c, :publish => true)
  4.times do |i|
    Factory(:page_c, :publish => true, :parent => page)
  end
end
