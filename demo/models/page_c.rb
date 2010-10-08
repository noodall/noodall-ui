class PageC < Noodall::Node
  sub_templates PageA, PageB
  root_template!
  
  main_slots 1
  wide_slots 3
end
