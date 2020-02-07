class SayHi::AdminRole < SayHi::DefaultRole
  def now
    "Hi #{actor.name} you have the admin role!"
  end
end
