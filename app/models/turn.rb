class Turn < ApplicationRecord
    belongs_to :game
    belongs_to :first_player, class_name: "Player"
    belongs_to :second_player, class_name: "Player"
end
