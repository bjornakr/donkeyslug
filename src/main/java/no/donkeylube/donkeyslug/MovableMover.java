package no.donkeylube.donkeyslug;


public class MovableMover {
    //private final HashMap<Movable, Coordinates> movables = new HashMap<Movable, Coordinates>();
    private final Movable movable;
    private final LevelMap levelMap;

    public MovableMover(LevelMap levelMap, Movable movable) {
	this.levelMap = levelMap;
	this.movable = movable;
	TileUtils tileUtils = new TileUtils(levelMap.getTiles());
	this.movable.setFieldOfVision(tileUtils.allTiles());
    }

    // TODO: Major refactoring
    public void move(Direction direction) {
	Coordinates currentCoordinatesForMovable = movable.getCoordinates();
	Tile tileToMoveFrom = levelMap.getTile(currentCoordinatesForMovable);
	Coordinates newCoordinatesForMovable = calculateNewCoordinates(currentCoordinatesForMovable, direction);
	Tile tileToMoveTo = levelMap.getTile(newCoordinatesForMovable);
	if (!tileToMoveTo.isWall()) {
	    Attackable attackable = tileToMoveTo.getAttackable();
	    if (attackable != null && !attackable.isDead() && movable instanceof Fighter) {
		((Fighter) movable).attack(attackable);
	    }
	    else {
		tileToMoveFrom.remove(movable);
		tileToMoveTo.add(movable);
		movable.setCoordinates(newCoordinatesForMovable);
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
}
