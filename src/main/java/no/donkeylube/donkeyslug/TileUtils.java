package no.donkeylube.donkeyslug;

import static no.donkeylube.donkeyslug.Tile.Type.*;

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Random;

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

    private int countNoOfReachableFloorTilesFrom(CoordinatesWrapper<Tile> baseTile, List<Tile> checkedTiles) {
	if (baseTile.get().isWall()) {
	    throw new IllegalArgumentException("Base tile cannot be a wall.");
	}
	int noOfReachableFloorTilesCount = 1;
	checkedTiles.add(baseTile.get());
	for (CoordinatesWrapper<Tile> adjacentFloorTile : getAdjacentTiles(baseTile, FLOOR)) {
	    if (!checkedTiles.contains(adjacentFloorTile.get())) {
		noOfReachableFloorTilesCount += countNoOfReachableFloorTilesFrom(adjacentFloorTile, checkedTiles);
	    }
	}
	return noOfReachableFloorTilesCount;
    }

    private int countAllTiles(Tile.Type type) {
	int totalNoOfTiles = 0;
	for (CoordinatesWrapper<Tile> tile : allTiles()) {
	    if (tile.get().getType() == type) {
		totalNoOfTiles++;
	    }
	}
	return totalNoOfTiles;
    }

    public List<CoordinatesWrapper<Tile>> getAdjacentTiles(CoordinatesWrapper<Tile> baseTile, Tile.Type type) {
	List<CoordinatesWrapper<Tile>> adjacentTiles = new LinkedList<CoordinatesWrapper<Tile>>();
	for (Coordinates coordinates : getAdjacentCoordinates(baseTile.getCoordinates())) {
	    if (tiles[coordinates.getY()][coordinates.getX()].getType() == type) {
		adjacentTiles.add(new CoordinatesWrapper<Tile>(tiles[coordinates.getY()][coordinates.getX()], coordinates));
	    }
	}
	return adjacentTiles;
    }
    
//    public List<CoordinatesWrapper<Tile>> getAdjacentTilesWithCoordinates(CoordinatesWrapper<Tile> baseTile) {
//	List<CoordinatesWrapper<Tile>> adjacentTiles = new LinkedList<CoordinatesWrapper<Tile>>();
//	for (Coordinates coordinates : getAdjacentCoordinates(baseTile.getCoordinates())) {
//	    adjacentTiles.add(new CoordinatesWrapper<Tile>(tiles[coordinates.getY()][coordinates.getY()], coordinates));
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

    public CoordinatesWrapper<Tile> findRandomTile(Tile.Type type) {
	if (countAllTiles(type) == 0) {
	    throw new IllegalStateException("No tiles of type " + type + " in the tile collection.");
	}
	List<CoordinatesWrapper<Tile>> allTiles = allTiles();
	Collections.shuffle(allTiles);

	for (CoordinatesWrapper<Tile> tile : allTiles) {
	    if (tile.get().getType() == type) {
		return tile;
	    }
	}
	return null;
    }

    private List<CoordinatesWrapper<Tile>> allTiles() {
	List<CoordinatesWrapper<Tile>> tileList = new LinkedList<CoordinatesWrapper<Tile>>();
	for (int y = 0; y < tiles.length; y++) {
	    for (int x = 0; x < tiles[0].length; x++) {
		tileList.add(new CoordinatesWrapper<Tile>(tiles[y][x], new Coordinates(x, y)));
	    }
	}
	return tileList;
    }

    public CoordinatesWrapper<Tile> findRandomFloorTileWithAdjacentWall() {
	List<CoordinatesWrapper<Tile>> allTiles = allTiles();
	Collections.shuffle(allTiles);
	for (CoordinatesWrapper<Tile> tile : allTiles) {
	    if (tile.get().isFloor() && getAdjacentTiles(tile, WALL).size() > 0) {
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

    public Direction getDirectionBetweenTiles(CoordinatesWrapper<Tile> fromTile, CoordinatesWrapper<Tile> toTile) {
	if (!getAdjacentTiles(fromTile).contains(toTile)) {
	    throw new IllegalArgumentException("Tiles are not adjacant to eachother.");
	}
	if (fromTile.getX() < toTile.getX()) {
	    return Direction.EAST;
	}
	else if (fromTile.getX() > toTile.getX()) {
	    return Direction.WEST;
	}
	else if (fromTile.getY() < toTile.getY()) {
	    return Direction.SOUTH;
	}
	else if (fromTile.getY() > toTile.getY()) {
	    return Direction.NORTH;
	}
	assert false;
	return null;
    }

    public List<CoordinatesWrapper<Tile>> getAdjacentTiles(CoordinatesWrapper<Tile> baseTile) {
	List<CoordinatesWrapper<Tile>> adjacentTiles = new LinkedList<CoordinatesWrapper<Tile>>();
	for (Tile.Type type : Tile.Type.values()) {
	    adjacentTiles.addAll(getAdjacentTiles(baseTile, type));
	}
	return adjacentTiles;
    }
}
