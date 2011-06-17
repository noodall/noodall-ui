class PageA < Noodall::Node
  sub_templates PageA, PageB, PageC
  root_template!

  main_slots 1
  small_slots 20
  wide_slots 3

  searchable_keys :title, :body, :description, :keywords
end
