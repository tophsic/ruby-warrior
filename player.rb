class Player
  def play_turn(warrior)
    context = Context.new(warrior)
    context.handle('attack')
    context.handle('walk')
  end
end

class Context
  @warrior
  @state
  @done
    
  def initialize(warrior)
    @warrior = warrior
    @done = false
  end
    
  def handle(action)
    if @done == false
      case action
        when 'attack'
          @state = AttackState.new(@warrior, self)
        else
          @state = WalkState.new(@warrior, self)
      end
      @state.handle()
    end
  end
    
  def done
    @done = true
  end
end

class State
  @warrior
  @context
  
  def initialize(warrior, context)
    @warrior = warrior
    @context = context
  end
  
  def handle
  end
end

class WalkState < State
  def handle
    @warrior.walk!
    @context.done
  end
end

class AttackState < State
  def handle
    if @warrior.feel.enemy?
      @warrior.attack!
      @context.done
    end
  end
end
