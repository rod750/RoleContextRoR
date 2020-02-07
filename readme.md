I wrote this module when using and old RoR version that didn't support concerns, there was many code repetition because we
need to make differentation between user roles of devise... the admin controllers, repeated what the user controllers had and so on.
I designed this solution to have a simple way to define and extend helpers by user role.


The first step is to define our context to do this we need to create a folder to keep the contexts organized. I had
a folder structure like this:

- contexts
  - context_name
   - rolename_role.rb
   - otherrole_role.rb

For this example suppose we need to return a message that depends on the user role, both need to return the user name:

- contexts
  - say_hi
    - admin_role.rb
    - default_role.rb
- sample_admin_controller.rb

sample_admin_controller.rb
```ruby
class SampleAdminController < ApplicationController
  # We include the helper methods dinamically passing the name of the context, 
  # in this case `:say_hi` for SayHi module and the role of the user
  # for this example is `:admin`
  include Context.new :say_hi, as: :admin

  def index
    # The include will dinamically generate the say_hi helper and include the
    # methods of say_hi/admin_role.rb
    say_hi.now() # output: Hi #{actor.name} you have the admin role! That's awesome!
  end
end
```

say_hi/admin_role.rb
```ruby
class SayHi::AdminRole < SayHi::DefaultRole
  def now
    # Actor is the model returned by Devise's session
    "Hi #{actor.name} you have the admin role! That's awesome!"
  end
end
```

say_hi/default_role.rb
```ruby
class SayHi::DefaultRole < ContextHandler
  def now
    "Hi #{actor.name} you have the default role!"
  end
end
```
