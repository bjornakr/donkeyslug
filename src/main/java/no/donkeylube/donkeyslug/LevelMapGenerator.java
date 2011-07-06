package no.donkeylube.donkeyslug;

import static no.donkeylube.donkeyslug.Tile.Type.FLOOR;
import static no.donkeylube.donkeyslug.Tile.Type.WALL;

import java.util.Collections;
import java.util.List;

import no.donkeylube.donkeyslug.helpers.RandomDistributor;

public class LevelMapGenerator {
    private Tile[][] tiles;
    private TileUtils tileUtils;

    private void initializeTilesAndTileUtils(int height, int width) {
	tiles = new Tile[height][width];
	tileUtils = new TileUtils(tiles);
    }

    public LevelMap generate(int height, int width) {
	initializeTilesAndTileUtils(height, width);
	fillRectangle(WALL, new Coordinates(0, 0), new Coordinates(width, height));
	createRooms(20, 8);

	while (!tileUtils.allFloorTilesAreAccessible()) {
//	for (int i = 0; i < 10; i++) {
	    digTunnel();
	}

	return new LevelMap(tiles);
    }

    private void createRooms(int noOfRooms, int meanRoomSize) {
	int createdRooms = 0;
	while (createdRooms < noOfRooms) {
	    makeRoom(meanRoomSize + RandomDistributor.walk(0, 1, 0.7),
		    meanRoomSize + RandomDistributor.walk(0, 1, 0.7), 0);
	    createdRooms++;
	}
    }

    private void digTunnel() {
	Tile baseTile = tileUtils.findRandomFloorTileWithAdjacentWall();
	List<Tile> adjacentWalls = tileUtils.getAdjacentTiles(baseTile, Tile.Type.WALL);
	Collections.shuffle(adjacentWalls);
	Tile wallTile = adjacentWalls.get(0);
	Direction direction = tileUtils.getDirectionBetweenTiles(baseTile, wallTile);
	dig(baseTile, direction);
    }

    private void dig(Tile baseTile, Direction direction) {
	final double CHANCE_OF_TURN = 0.1;
	
	Tile nextTile = getNextTile(baseTile.coordinates(), direction);
	if (canDigFrom(baseTile, nextTile)) {
	    tiles[nextTile.coordinates().getY()][nextTile.coordinates().getX()] = new Tile(FLOOR, nextTile.coordinates());
	    double random = Math.random();
	    if (random < CHANCE_OF_TURN) {
		direction = direction.turnLeft();
	    }
	    if (random > 1-CHANCE_OF_TURN) {
		direction = direction.turnRight();
	    }
	    dig(nextTile, direction);
	}
    }

    private Tile getNextTile(Coordinates fromCoordinates, Direction directionToNextTile) {
	int nextX = fromCoordinates.getX();
	int nextY = fromCoordinates.getY();
	switch (directionToNextTile) {
	case NORTH:
	    nextY--; break;
	case EAST:
	    nextX++; break;
	case SOUTH:
	    nextY++; break;
	case WEST:
	    nextX--; break;	
	}
	Coordinates coordinatesForNextTile = Coordinates.getInstanceWithCutoffs(nextX, nextY, tiles.length, tiles[0].length);
	return tiles[coordinatesForNextTile.getY()][coordinatesForNextTile.getX()];
    }
    
    private boolean canDigFrom(Tile currentTile, Tile tileToDig) {
	return (tileToDig.isWall() && !currentTile.coordinates().equals(tileToDig.coordinates()));
    }
    
    
    private void makeRoom(int roomHeight, int roomWidth, int noOfIterations) {
	Coordinates roomStartCoordinates = tileUtils.findRandomTile(WALL).coordinates();
	Coordinates roomEndCoordinates = new Coordinates(roomStartCoordinates.getX() + roomWidth,
		roomStartCoordinates.getY() + roomHeight);
	if (!collission(roomStartCoordinates, roomEndCoordinates)) {
	    fillRectangle(Tile.Type.FLOOR, roomStartCoordinates, roomEndCoordinates);
	}
	else {
	    if (noOfIterations % 1000000 == 0) {
		roomHeight--;
		roomWidth--;
	    }
	    makeRoom(roomHeight,  roomWidth, noOfIterations);
	}
    }

    private boolean collission(Coordinates roomStartCoordinates, Coordinates roomEndCoordinates) {
	if (roomEndCoordinates.getX() >= tiles[0].length - 1 || roomEndCoordinates.getY() >= tiles.length - 1) {
	    return true;
	}
	for (int y = roomStartCoordinates.getY()-1; y < roomEndCoordinates.getY()+1; y++) {
	    for (int x = roomStartCoordinates.getX()-1; x < roomEndCoordinates.getX()+1; x++) {
		x = restrainBounds(x, 0, tiles[0].length);
		y = restrainBounds(y, 0, tiles.length);
		if (!tiles[y][x].isWall()) {
		    return true;
		}
	    }
	}
	return false;
    }

    private int restrainBounds(int value, int minValue, int maxValueNotInclusive) {
	if (value < minValue) {
	    return minValue;
	}
	else if (value >= maxValueNotInclusive) {
	    return maxValueNotInclusive-1;
	}
	else {
	    return value;
	}
    }
    
    private void fillRectangle(Tile.Type type, Coordinates startCoordinates, Coordinates endCoordinates) {
	for (int y = startCoordinates.getY(); y < endCoordinates.getY(); y++) {
	    for (int x = startCoordinates.getX(); x < endCoordinates.getX(); x++) {
		tiles[y][x] = new Tile(type, new Coordinates(x, y));
	    }
	}
    }
}
