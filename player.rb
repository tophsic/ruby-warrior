class Player
  attr_reader :done, :warrior
  attr_writer :done, :action

  def play_turn(warrior)
    @warrior = warrior
    @done = false

    Attack.new(self)
    @action.play
    @action.play
  end
end

class Action
  @turn
  
  def initialize(turn)
    @turn = turn
    @turn.action = self
  end
  
  def play
  end
end

class Walk < Action
  def play
    if @turn.done == false
      @turn.warrior.walk!
      @turn.done = true
    end
  end
end

class Attack < Action
  def play
    if @turn.warrior.feel.enemy? and @turn.done == false
      @turn.warrior.attack!
      @turn.done = true
    else
      Walk.new(@turn)
    end
  end
end
