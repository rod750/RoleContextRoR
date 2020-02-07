class SampleAdminController < ApplicationController
  include Context.new :say_hi, as: :admin

  def index
    say_hi.now() # output: Hi #{actor.name} you have the admin role! That's awesome!
  end
end
