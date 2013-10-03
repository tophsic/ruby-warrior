class Player
  attr_reader :done, :warrior
  attr_writer :done, :action

  def play_turn(warrior)
    @warrior = warrior
    @done = false

    Attack.new(self)
    @action.play
    @action.play
    @action.play
  end
end

class Action
  @turn
  @warrior
  
  def initialize(turn)
    @turn = turn
    @warrior = @turn.warrior
    @turn.action = self
  end
  
  def play
  end
end

class Walk < Action
  def play
    if @turn.done == false
      @warrior.walk!
      @turn.done = true
    end
  end
end

class Attack < Action
  def play
    if @warrior.feel.enemy? and @turn.done == false
      @warrior.attack!
      @turn.done = true
    else
      Rest.new(@turn)
    end
  end
end

class Rest < Action
  def play
    if @warrior.health < 7 and @turn.done == false
      @warrior.rest!
      @turn.done = true
    else
      Walk.new(@turn)
    end
  end
end
