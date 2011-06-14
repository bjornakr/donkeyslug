package no.donkeylube.donkeyslug;

import static no.donkeylube.donkeyslug.Tile.Type.FLOOR;
import static no.donkeylube.donkeyslug.Tile.Type.WALL;

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;

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
    
//    public List<Tile> getAdjacentTilesWithCoordinates(Tile baseTile) {
//	List<Tile> adjacentTiles = new LinkedList<Tile>();
//	for (Coordinates coordinates : getAdjacentCoordinates(baseTile.getCoordinates())) {
//	    adjacentTiles.add(new Tile(tiles[coordinates.getY()][coordinates.getY()], coordinates));
//	}
//	return adjacentTiles;
//    }
    
    
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

    private List<Tile> allTiles() {
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

}
