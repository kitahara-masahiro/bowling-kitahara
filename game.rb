# coding: UTF-8
require 'rspec'

class Game

  def initialize
    @score = 0
    @current_frame_score = 0
    @current_frame_throw_count = 0
    @total_count = 0

    @frame = 1

    @total_score_array = []
    @score_array_each_frame = []
    @score_each_frame = 0
  end

  def throw(point)
    #総投数の計算
    @total_count += 1

    #フレーム内投数の計算
    @current_frame_throw_count += 1

    #現在のフレームのスコアの計算
    @current_frame_score += point

    @total_score_array << point

    #フレーム毎の得点計算
    if @current_frame_throw_count == 1 && point != 10 #not strike
      if @score_array_each_frame.last != 10 #前のフレームがスペアでない場合
        @score_each_frame += point
      elsif @score_array_each_frame.last == 10 #前のフレームがスペアの場合
        @score_each_frame += point * 2
      end
    elsif @current_frame_throw_count == 2
      @score_each_frame += point
      @score_array_each_frame << @score_each_frame
      @score_each_frame = 0
    end

    #総得点計算
    @score = 0
    @score_array_each_frame.each do |elem|
      @score += elem
    end

    #フレーム数の計算、フレーム内のスコアと投数の初期化
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

    it '[1, 4], [4, 5], [6, 4], [5, 4]のときスコアが38になること' do
      game = Game.new
      game.throw 1
      game.throw 4 # 1フレーム目 5
      game.throw 4
      game.throw 5 # 2フレーム目 9
      game.throw 6
      game.throw 4 # 3フレーム目 10 + 5 = 15
      game.throw 5
      game.throw 4 # 4フレーム目 9
      game.score.should == 38
    end

  end
end
