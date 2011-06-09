package no.donkeylube.donkeyslug;

import java.util.HashMap;

public class MoveListener {
    private final HashMap<Movable, Coordinates> movables = new HashMap<Movable, Coordinates>();
    private final LevelMap levelMap;

    public MoveListener(LevelMap levelMap) {
	this.levelMap = levelMap;
    }

    // TODO: Major refactoring
    public void move(Movable movable, Direction direction) {
	Coordinates currentCoordinatesForMovable = movables.get(movable);
	Tile tileToMoveFrom = levelMap.getTile(currentCoordinatesForMovable);
	Coordinates newCoordinatesForMovable = calculateNewCoordinates(currentCoordinatesForMovable, direction);
	Tile tileToMoveTo = levelMap.getTile(newCoordinatesForMovable);
	if (!tileToMoveTo.isWall()) {
	    Attackable attackable = tileToMoveTo.getAttackable();
	    if (attackable != null && !attackable.isDead() &&  movable instanceof Fighter) {
		((Fighter) movable).attack(attackable);
	    }
	    else {
		tileToMoveFrom.remove(movable);
		tileToMoveTo.add(movable);
		movables.put(movable, newCoordinatesForMovable);
	    }
	}
    }

    private Coordinates calculateNewCoordinates(Coordinates currentCoordinatesForMovable, Direction direction) {
	int x = currentCoordinatesForMovable.getX();
	int y = currentCoordinatesForMovable.getY();
	switch (direction) {
	case NORTH:
	    y--;
	    break;
	case EAST:
	    x++;
	    break;
	case SOUTH:
	    y++;
	    break;
	case WEST:
	    x--;
	    break;
	default:
	    throw new IllegalArgumentException("Illegal direction: " + direction.toString());
	}

	return new Coordinates(x, y);
    }

    public void registerMovable(Movable movable) {
	Coordinates coordinatesForMovable = levelMap.getCoordinatesFor(movable);
	if (coordinatesForMovable == null) {
	    throw new IllegalStateException("Cannot register a movable before it is placed on the map.");
	}
	
	movables.put(movable, coordinatesForMovable);
    }

    public void unregisterMovable(Movable movable) {
	movables.remove(movable);
    }
}
