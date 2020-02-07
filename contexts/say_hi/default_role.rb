class SayHi::DefaultRole < ContextHandler
  def now
    "Hi #{actor.name} you have the admin role! That's awesome!"
  end
end
