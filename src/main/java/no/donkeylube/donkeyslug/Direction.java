package no.donkeylube.donkeyslug;

public enum Direction {
    NORTH, EAST, SOUTH, WEST;

    public Direction turnLeft() {
	switch(this) {
	case NORTH: return WEST;
	case EAST: return NORTH;
	case SOUTH: return EAST;
	case WEST: return SOUTH;	
	}
	return null;
    }
    
    public Direction turnRight() {
	switch(this) {
	case NORTH: return EAST;
	case EAST: return SOUTH;
	case SOUTH: return WEST;
	case WEST: return NORTH;	
	}
	return null;
    }
}
