class PageA < Noodall::Node
  sub_templates PageA, PageB, PageC
  root_template!

  main_slots 1
  small_slots 4
  wide_slots 3

end
