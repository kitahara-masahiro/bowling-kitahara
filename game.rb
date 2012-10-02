# coding: UTF-8
require 'rspec'

class Game

  def initialize
    @score = 0
    @throw_count = 0
  end

  def throw(point)
    @throw_count += 1
    if @throw_count <= 2
      @score += point
    elsif @throw_count == 3 && @score == 10
      @score += point * 2
    end
  end

  def score()
    @score
  end
end


unless __FILE__ == $0
  describe Game do
    it '1投目1点、2投目2点だったら3ptになること' do
      game = Game.new
      game.throw 1
      game.throw 2
      game.score.should == 3
    end

    it '1フレーム目がスペア、2フレーム目1投目5点だったら20ptになること' do
      game = Game.new
      game.throw 5
      game.throw 5  # 10 + 5

      game.throw 5 # 5
      game.throw 0
      game.score.should == 20
    end

    it '1フレーム目がスペア、2フレーム目0点だったら10ptになること' do
      game = Game.new
      game.throw 5
      game.throw 5  # 10

      game.throw 0
      game.throw 0
      game.score.should == 10
    end

  end
end

game = Game.new
game.throw(1)
game.throw(2)
puts game.score()
