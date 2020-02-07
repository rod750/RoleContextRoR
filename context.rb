# frozen_string_literal: true

class Context < Module
  def initialize(context_name, as: :default)
    @context_name = context_name
    @as = as
  end

  def self.constantize(input)
    input = input.map(&:to_s).join("::") if input.respond_to?(:each)
    input.to_s.split("::").map { |i| i.split("_").map(&:capitalize).join }.
      join("::")
  end

  def self.role_classname(context, actor)
    actor.respond_to?(:call) &&
      "#{ context.instance_exec(&actor).class.name }Role" ||
      "#{ constantize(actor) }Role"
  end

  def helper_definer
    lambda { |actor, context_name, method_name, role_class|
      define_method method_name do
        instance_variable_get("@#{method_name}") ||
          instance_variable_set("@#{method_name}", instance_exec(context_name, actor, &role_class))
      end

      if context_name.respond_to?(:each)
        alias_method context_name.last, method_name
        helper_method [context_name.last, method_name]
      else
        helper_method context_name
      end
    }
  end

  def included(target)
    target.instance_exec @as, @context_name, method_name, role_class,
                         &helper_definer
  end

  def method_name
    @method_name ||= @context_name.respond_to?(:each) &&
      @context_name.map(&:to_s).join("_").to_sym ||
      @context_name.to_sym
  end

  def role_class
    lambda { |context_name, actor|
      role_classname = Context.role_classname(self, actor)
      context_namespace = Context.constantize(context_name)

      Object.const_get("#{context_namespace}::#{role_classname}").new(self, actor)
    }
  end
end
