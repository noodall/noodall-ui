Factory.define :node do |node|
  node.title { Faker::Lorem.words(3).join(' ') }
  node.body { Faker::Lorem.paragraphs(6) }
  node.published_at { Time.now }
end

Factory.define :home, :parent => :node, :class => Home do |node|
end

Factory.define :page_a, :parent => :node, :class => PageA do |node|
end

Factory.define :page_b, :parent => :node, :class => PageB do |node|
end

Factory.define :page_c, :parent => :node, :class => PageC do |node|
end

