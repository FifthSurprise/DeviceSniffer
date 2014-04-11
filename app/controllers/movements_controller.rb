class MovementsController < ApplicationController
  def index
    @movements = Movements.all
  end
end
