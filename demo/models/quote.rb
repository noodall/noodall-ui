class Quote < Content
  allowed_positions :small

  key :name, String
  key :quote, String
end
