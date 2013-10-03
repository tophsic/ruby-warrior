class Player
  attr_reader :done, :warrior, :health
  attr_writer :done, :action

  def play_turn(warrior)
    @warrior = warrior
    @done = false

    if @health == nil
      @health = @warrior.health
    end

    Attack.new(self)
    @action.play
    @action.play
    @action.play
    @action.play

    @health = @warrior.health
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
    if @turn.done == false and @warrior.feel.enemy?
      @warrior.attack!
      @turn.done = true
    else
      Captive.new(@turn)
    end
  end
end

class Rest < Action
  def play
    if @turn.done == false and can and @warrior.health < 15 
      @warrior.rest!
      @turn.done = true
    else
      Walk.new(@turn)
    end
  end

  def can
    return @warrior.health >= @turn.health
  end
end

class Captive < Action
  def play
    if @turn.done == false and @warrior.feel.captive?
      @warrior.rescue!
      @turn.done = true
    else
      Rest.new(@turn)
    end
  end
end
