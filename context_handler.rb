class ContextHandler
  attr_reader :context, :actor

  def initialize(context, actor)
    @context = context
    @actor = actor.respond_to?(:call) &&
      context.instance_exec(&actor) ||
      context.send("current_#{actor.to_s}")
  end
end
