require 'spec_helper'

describe Noodall::UI do
  it "should return the defaut admin menu" do
    Noodall::UI.menu_items.should have(2).things

    Noodall::UI.menu_items['Contents'].should == :noodall_admin_nodes_path
  end
end
