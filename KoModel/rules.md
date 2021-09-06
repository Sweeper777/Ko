- A hare's move is valid when:
    - the destination is a vertical/horizontal line from the start, and the destination is empty, and between the destination and start there are only opponent fields, OR
    - the destination is at most taxicab distance 3 from the start, and the destination square is empty, field, rabbit or hare.
    - If it is the first case, the fields between the start and destination are conquered
- A moon's move is valid when:
    - the four-neighbours of the destination is not an opponent empress, and
    - the eight-neighbours of the destination is not an opponent moon, and,
    - the destination is reachable by only moving horizontally and vertically from the start, and the destination is empty, field, rabbit, or hare.
    - If the destination is field, capture occurs and the field piece goes to the owner of the moon
    - If the destination is rabbit or hare, capture occurs and the piece goes to its owner
- If turn number < 4, only placing fields is valid. Fields must be connected to each other by four-neighbourhood, and it must be on that player's side of the board
    - If turn number == 3, player can only place field, and it must create an L shape
- When a player has 14 fields, they can have 1 rabbit/hare
- When a player has 28 fields, they can have 2 rabbits/hares
- When a player has 43 fields, they can have 2 rabbits/hares, and a moon
- When a player has built the empress' castle, has 3 burrows and 60 fields, they win
- Any move that produces more than one grassland is invalid.