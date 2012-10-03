# coding: UTF-8
require 'rspec'

class Game

  def initialize
    @score = 0
    @current_frame_score = 0
    @current_frame_throw_count = 0
    @total_count = 0

    @frame = 1
  end

  def throw(point)
    @total_count += 1
    @current_frame_throw_count += 1
    @current_frame_score += point

    if @total_count <= 2
      @score += point
    elsif @total_count == 3 && @score == 10
      @score += point * 2
    end

    if @current_frame_throw_count == 2 || strike?
      @frame += 1
      @current_frame_throw_count = 0
      @current_frame_score = 0
    end
  end

  def current_frame
    @frame
  end

  def score()
    @score
  end

  def strike?
    @current_frame_throw_count == 1 && @current_frame_score == 10
  end

  def spare?
    @current_frame_throw_count == 2 && @current_frame_score == 10
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

    it '1回目ガーターだったら現在のフレームが1になること' do
      game = Game.new
      game.throw 0
      game.current_frame.should == 1
    end

    it '1回目も2回目もガーターだったら現在のフレームが2になること' do
      game = Game.new
      game.throw 0
      game.throw 0
      game.current_frame.should == 2
    end

  end
end
