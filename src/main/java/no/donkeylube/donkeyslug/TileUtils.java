package no.donkeylube.donkeyslug;

import static no.donkeylube.donkeyslug.Tile.Type.FLOOR;
import static no.donkeylube.donkeyslug.Tile.Type.WALL;

import java.util.Collections;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

public class TileUtils {
    private final Tile[][] tiles;

    public TileUtils(Tile[][] tiles) {
	this.tiles = tiles;
    }

    public boolean allFloorTilesAreAccessible() {
	int totalNoOfFloorTiles = countAllTiles(FLOOR);
	int noOfReachableFloorTiles = countNoOfReachableFloorTilesFrom(findRandomTile(FLOOR), new LinkedList<Tile>());
	return (totalNoOfFloorTiles == noOfReachableFloorTiles);
    }

    private int countNoOfReachableFloorTilesFrom(Tile baseTile, List<Tile> checkedTiles) {
	if (baseTile.isWall()) {
	    throw new IllegalArgumentException("Base tile cannot be a wall.");
	}
	int noOfReachableFloorTilesCount = 1;
	checkedTiles.add(baseTile);
	for (Tile adjacentFloorTile : getAdjacentTiles(baseTile, FLOOR)) {
	    if (!checkedTiles.contains(adjacentFloorTile)) {
		noOfReachableFloorTilesCount += countNoOfReachableFloorTilesFrom(adjacentFloorTile, checkedTiles);
	    }
	}
	return noOfReachableFloorTilesCount;
    }

    private int countAllTiles(Tile.Type type) {
	int totalNoOfTiles = 0;
	for (Tile tile : allTiles()) {
	    if (tile.type() == type) {
		totalNoOfTiles++;
	    }
	}
	return totalNoOfTiles;
    }

    public List<Tile> getAdjacentTiles(Tile baseTile, Tile.Type type) {
	List<Tile> adjacentTiles = new LinkedList<Tile>();
	for (Coordinates coordinates : getAdjacentCoordinates(baseTile.coordinates())) {
	    if (tiles[coordinates.getY()][coordinates.getX()].type() == type) {
		adjacentTiles.add(tiles[coordinates.getY()][coordinates.getX()]);
	    }
	}
	return adjacentTiles;
    }

    // public List<Tile> getAdjacentTilesWithCoordinates(Tile baseTile) {
    // List<Tile> adjacentTiles = new LinkedList<Tile>();
    // for (Coordinates coordinates :
    // getAdjacentCoordinates(baseTile.getCoordinates())) {
    // adjacentTiles.add(new Tile(tiles[coordinates.getY()][coordinates.getY()],
    // coordinates));
    // }
    // return adjacentTiles;
    // }

    public List<Coordinates> getAdjacentCoordinates(Coordinates baseCoordinates) {
	int x = baseCoordinates.getX();
	int y = baseCoordinates.getY();

	List<Coordinates> adjacentCoordinates = new LinkedList<Coordinates>();
	if (x - 1 >= 0) {
	    adjacentCoordinates.add(new Coordinates(x - 1, y));
	}
	if (x < tiles[0].length - 1) {
	    adjacentCoordinates.add(new Coordinates(x + 1, y));
	}
	if (y - 1 >= 0) {
	    adjacentCoordinates.add(new Coordinates(x, y - 1));
	}
	if (y < tiles.length - 1) {
	    adjacentCoordinates.add(new Coordinates(x, y + 1));
	}
	return adjacentCoordinates;
    }

    public Tile findRandomTile(Tile.Type type) {
	if (countAllTiles(type) == 0) {
	    throw new IllegalStateException("No tiles of type " + type + " in the tile collection.");
	}
	List<Tile> allTiles = allTiles();
	Collections.shuffle(allTiles);

	for (Tile tile : allTiles) {
	    if (tile.type() == type) {
		return tile;
	    }
	}
	return null;
    }

    public List<Tile> allTiles() {
	List<Tile> tileList = new LinkedList<Tile>();
	for (int y = 0; y < tiles.length; y++) {
	    for (int x = 0; x < tiles[0].length; x++) {
		tileList.add(tiles[y][x]);
	    }
	}
	return tileList;
    }

    public Tile findRandomFloorTileWithAdjacentWall() {
	List<Tile> allTiles = allTiles();
	Collections.shuffle(allTiles);
	for (Tile tile : allTiles) {
	    if (tile.isFloor() && getAdjacentTiles(tile, WALL).size() > 0) {
		return tile;
	    }
	}
	if (countAllTiles(WALL) == 0) {
	    throw new IllegalStateException("There are no wall tiles.");
	}
	else {
	    throw new IllegalStateException("There are no floor tiles.");
	}
    }

    public Direction getDirectionBetweenTiles(Tile fromTile, Tile toTile) {
	if (!getAdjacentTiles(fromTile).contains(toTile)) {
	    throw new IllegalArgumentException("Tiles are not adjacant to eachother.");
	}
	if (fromTile.coordinates().getX() < toTile.coordinates().getX()) {
	    return Direction.EAST;
	}
	else if (fromTile.coordinates().getX() > toTile.coordinates().getX()) {
	    return Direction.WEST;
	}
	else if (fromTile.coordinates().getY() < toTile.coordinates().getY()) {
	    return Direction.SOUTH;
	}
	else if (fromTile.coordinates().getY() > toTile.coordinates().getY()) {
	    return Direction.NORTH;
	}
	assert false;
	return null;
    }

    public List<Tile> getAdjacentTiles(Tile baseTile) {
	List<Tile> adjacentTiles = new LinkedList<Tile>();
	for (Tile.Type type : Tile.Type.values()) {
	    adjacentTiles.addAll(getAdjacentTiles(baseTile, type));
	}
	return adjacentTiles;
    }

    public List<Tile> intersectRectange(Coordinates upperLeftCoordinates, Coordinates lowerRightCoordinates) {
	List<Tile> intersectedTiles = new LinkedList<Tile>();
	for (int y = upperLeftCoordinates.getY(); y <= lowerRightCoordinates.getY(); y++) {
	    for (int x = upperLeftCoordinates.getX(); x < lowerRightCoordinates.getX(); x++) {
		intersectedTiles.add(tiles[y][x]);
	    }
	}
	return intersectedTiles;
    }
    
    public void fillRectangle(Tile.Type type, Coordinates startCoordinates, Coordinates endCoordinates) {
	for (int y = startCoordinates.getY(); y < endCoordinates.getY(); y++) {
	    for (int x = startCoordinates.getX(); x < endCoordinates.getX(); x++) {
		tiles[y][x] = new Tile(type, new Coordinates(x, y));
	    }
	}
    }

    public List<Tile> getDiagonallyAdjacentTilesFor(Tile baseTile) {
	List<Tile> diagonallyAdjacentTiles = new LinkedList<Tile>();
	for (Coordinates coordinates : getDiagonallyAdjacentCoordinatesFor(baseTile.coordinates())) {
	    diagonallyAdjacentTiles.add(tiles[coordinates.getY()][coordinates.getX()]);
	}
	return diagonallyAdjacentTiles;
    }

    private Set<Coordinates> getDiagonallyAdjacentCoordinatesFor(Coordinates baseCoordinates) {
	int baseX = baseCoordinates.getX();
	int baseY = baseCoordinates.getY();
	Set<Coordinates> diagonallyAdjacentCoordinates = new HashSet<Coordinates>();
	diagonallyAdjacentCoordinates.add(new Coordinates(baseX-1, baseY-1));
	diagonallyAdjacentCoordinates.add(new Coordinates(baseX+1, baseY-1));
	diagonallyAdjacentCoordinates.add(new Coordinates(baseX-1, baseY+1));
	diagonallyAdjacentCoordinates.add(new Coordinates(baseX+1, baseY+1));
	Set<Coordinates> outOfBoundsCoordinates = new HashSet<Coordinates>();
	for (Coordinates coordinates : diagonallyAdjacentCoordinates) {
	    if (coordinates.getX() < 0 || coordinates.getX() > tiles[0].length - 1
		    || coordinates.getY() < 0 || coordinates.getY() > tiles.length - 1) {
		outOfBoundsCoordinates.add(coordinates);
	    }
	}
	diagonallyAdjacentCoordinates.removeAll(outOfBoundsCoordinates);
	return diagonallyAdjacentCoordinates;
    }
}
