package no.donkeylube.donkeyslug;


public class MovableMover {
    // private final HashMap<Movable, Coordinates> movables = new
    // HashMap<Movable, Coordinates>();
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
    
    public void move(Tile adjacentTile) {
	TileUtils tileUtils = new TileUtils(levelMap.getTiles());
	Direction directionToAdjacentTile = tileUtils.getDirectionBetweenTiles(levelMap.getTile(movable.getCoordinates()), adjacentTile);
	move(directionToAdjacentTile);
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

//    public Stack<Tile> findShortestPathTo(Coordinates destinationCoordinates) {
//	TileUtils tileUtils = new TileUtils(levelMap.getTiles());
//	LinkedList<PathStep> considering = new LinkedList<PathStep>();
//	List<PathStep> closed = new LinkedList<PathStep>();
//	Tile currentTile = levelMap.getTile(movable.getCoordinates());
//	Tile destinationTile = levelMap.getTile(destinationCoordinates);
//	considering.add(new PathStep(currentTile, destinationTile, null));
//	Stack<Tile> chosenPath = new Stack<Tile>();
//	
//	while (chosenPath.isEmpty()) {
////	    System.out.println("Sjekk: " + new PathStep(new Tile(Tile.Type.FLOOR, new Coordinates(1, 2)), null, null).equals(new PathStep(new Tile(Tile.Type.FLOOR, new Coordinates(1, 2)), null, null)));
//	    PathStep currentPathStep = considering.pollFirst();
////	    System.out.println("Current: " + currentPathStep);
////	    System.out.flush();
//	    closed.add(currentPathStep);
//	    Tile currentTile2 = currentPathStep.tile();
//	    for (Tile tile : tileUtils.getAdjacentTiles(currentTile2, Tile.Type.FLOOR)) {
////		System.out.println("Adjacent tile: " + tile.coordinates());
//		PathStep newPathStep = new PathStep(tile, destinationTile, currentPathStep);
//		if (!closed.contains(newPathStep)) {
////		    System.out.println("POW!");
//		    if (considering.contains(newPathStep)) {
////			System.out.println("BAM! Considering.contains: " + newPathStep + " = " + considering.contains(newPathStep));
//			if (newPathStep.getG() < currentPathStep.getG()) {
////			    System.out.println("Changing G");
//			    considering.remove(newPathStep);
//			    newPathStep.changeParentTo(currentPathStep);
//			    considering.add(newPathStep);
//			    Collections.sort(considering);
//			}
//		    }
//		    else {
//			considering.add(newPathStep);
//			for (PathStep pathStep : considering) {
////			    System.out.println("Considering: " + pathStep);
//			}
//		    }
//		}
//	    }
//	    
////	    if (considering.size() == 0) {
////		throw new IllegalStateException("Ran out of considered tiles at " + currentPathStep.tile().coordinates());
////	    }
//	    if (currentPathStep.tile().equals(destinationTile)) {
//		do {
//		    chosenPath.add(currentPathStep.tile());
//		    currentPathStep = currentPathStep.parent;
//		} while(currentPathStep != null);
//	    }
//	}
//	chosenPath.pop();
//	return chosenPath;
//    }
//
//    private class PathStep implements Comparable<PathStep> {
//	private final Tile currentTile;
//	private final Tile destinationTile;
//	private PathStep parent;
////	private final int G;
//	private final int H;
//
//	public PathStep(Tile currentTile, Tile destinationTile, PathStep parent) {
//	    this.currentTile = currentTile;
//	    this.destinationTile = destinationTile;
//	    this.parent = parent;
//	    if (parent == null) {
////		G = 0;
//		H = 0;
//	    }
//	    else {
////		G = parent.getG() + 1;
//		H = manhattan();
//	    }
//	}
//
//	private int manhattan() {
//	    int distanceToDestination = Math.abs(currentTile.coordinates().getX() -
//		    destinationTile.coordinates().getX()) +
//		    Math.abs(currentTile.coordinates().getY() -
//			    destinationTile.coordinates().getY());
//
//	    return distanceToDestination;
//	}
//
//	public int getG() {
//	    if (parent == null) {
//		return 0;
//	    }
//	    return parent.getG() + 1;
//	}
//
//	public int getH() {
//	    return H;
//	}
//
//	public int getF() {
//	    return getG() + H;
//	}
//	
//	public Tile tile() {
//	    return currentTile;
//	}
//	
//	public void changeParentTo(PathStep newParent) {
//	    parent = newParent;
//	}
//	
//	@Override
//	public boolean equals(Object comparison) {
//	    if (!(comparison instanceof PathStep)) {
//		return false;
//	    }
//	    else {
//		return currentTile.equals(((PathStep) comparison).tile());
//	    }
//	}
//	
//	@Override
//	public int hashCode() {
//	    return currentTile.hashCode();
//	}
//
//	@Override // NB! INCONSISTENT WITH EQUALS
//	public int compareTo(PathStep comparison) {
//	    PathStep comparisonPathStep = (PathStep) comparison;
//	    return getF() - comparisonPathStep.getF();
//	}
//	
//	@Override
//	public String toString() {
//	    return ("c: " + currentTile.coordinates() + ", G: " + getG() + ", H: " + getH() + ", F: " + getF());
//	}
//    }
}
