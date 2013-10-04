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
#      @warrior.pivot!
#      @done = true
      @direction = :forward
    end

    # Attack
    # Arc
    # Rest
    # Captive
    # Walk
    Attack.new(self)
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

  def canRest
    return @warrior.health >= @turn.health
  end

  def needRest(health)
    return @warrior.health < health
  end
end

class Walk < Action
  attr_writer :direction
  def play
    super

    @direction = @turn.direction
    if needRest(10) and !canRest
      @direction = :backward
    end

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
      action = Arc.new(@turn)
      action.play
    end
  end
end

class Rest < Action
  def play
    super
    if @turn.done == false and canRest and needRest(15)
      @warrior.rest!
      @turn.done = true
    else
      action = Arc.new(@turn)
      action.play
    end
  end
end

class Captive < Action
  def play
    super
    if @turn.done == false and @warrior.feel(@turn.direction).captive?
      @warrior.rescue!(@turn.direction)
      @turn.done = true
    else
      action = Walk.new(@turn)
      action.play
    end
  end
end

class Arc < Action
  def play
    super

    if @turn.done == false and need
      @warrior.shoot!
      @turn.done = true
    else
      action = Captive.new(@turn)
      action.play
    end
  end

  def need
    spaces = @warrior.look

    need = false

    for space in spaces
      if space.to_s == 'Wizard' or space.to_s == 'Archer'
        need = true
      elsif space.to_s != 'nothing'
        break
      end
    end

    return need
  end
end
