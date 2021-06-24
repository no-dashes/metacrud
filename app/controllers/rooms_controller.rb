class RoomsController < ApplicationController
  crudify

  private
    # Only allow a list of trusted parameters through.
    def room_params
      params.require(:room).permit(:title)
    end
end
