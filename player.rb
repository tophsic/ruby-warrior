class Player
  attr_reader :done, :warrior, :health, :direction
  attr_writer :done, :action, :direction

  def play_turn(warrior)
    @warrior = warrior
    @done = false

    if @health == nil
      @health = @warrior.health
    end

    if @direction == nil
      @direction = :forward
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
    if @turn.done == false and @warrior.feel(@turn.direction).wall?
        @warrior.pivot!
        @turn.done = true
    end
  end
end

class Walk < Action
  attr_writer :direction
  def play
    super
    if @turn.done == false
      @warrior.walk!(@direction)
      @turn.done = true
    end
  end
end

class Attack < Action
  def play
    super
    if @turn.done == false and @warrior.feel(@turn.direction).enemy?
      @warrior.attack!(@turn.direction)
      @turn.done = true
    else
      Captive.new(@turn)
    end
  end
end

class Rest < Action
  def play
    super
    if @turn.done == false and can and need(15)
      @warrior.rest!
      @turn.done = true
    else
      direction = @turn.direction
      if need(10)
        direction = :backward
      end
      action = Walk.new(@turn)
      action.direction = direction
    end
  end

  def can
    return @warrior.health >= @turn.health
  end

  def need(health)
    return @warrior.health < health
  end
end

class Captive < Action
  def play
    super
    if @turn.done == false and @warrior.feel(@turn.direction).captive?
      @warrior.rescue!(@turn.direction)
      @turn.done = true
    else
      Rest.new(@turn)
    end
  end
end
