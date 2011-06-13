package no.donkeylube.donkeyslug;

import static no.donkeylube.donkeyslug.Tile.Type.*;

import java.util.Collections;
import java.util.List;
import java.util.Random;

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
	createRooms(2);

	while (!tileUtils.allFloorTilesAreAccessible()) {
//	for (int i = 0; i < 1; i++) {
	    digTunnel();
	}

	return new LevelMap(tiles);
    }

    private void createRooms(int noOfRooms) {
	final int INIT_ROOM_SIZE = 8;
	int createdRooms = 0;
	while (createdRooms < noOfRooms) {
	    makeRoom(INIT_ROOM_SIZE + RandomDistributor.walk(0, 1, 0.7),
		    INIT_ROOM_SIZE + RandomDistributor.walk(0, 1, 0.7), 0);
	    createdRooms++;
	}
    }

    private void digTunnel() {
	CoordinatesWrapper<Tile> baseTile = tileUtils.findRandomFloorTileWithAdjacentWall();
	List<CoordinatesWrapper<Tile>> adjacentWalls = tileUtils.getAdjacentTiles(baseTile, Tile.Type.WALL);
	Collections.shuffle(adjacentWalls);
	CoordinatesWrapper<Tile> wallTile = adjacentWalls.get(0);
	Direction direction = tileUtils.getDirectionBetweenTiles(baseTile, wallTile);
	dig(baseTile, direction);
    }

    private void dig(CoordinatesWrapper<Tile> baseTile, Direction direction) {
	final double CHANCE_OF_TURN = 0.1;
	
	int nextX = baseTile.getX();
	int nextY = baseTile.getY();
	switch (direction) {
	case NORTH:
	    nextY--; break;
	case EAST:
	    nextX++; break;
	case SOUTH:
	    nextY++; break;
	case WEST:
	    nextX--; break;
	}
	if (nextX < 0 || nextX >= tiles[0].length) {
	    nextX = baseTile.getX();
	}
	if (nextY < 0 || nextY >= tiles.length) {
	    nextY = baseTile.getY();
	}
	Coordinates nextCoordinates = new Coordinates(nextX, nextY);
	if (baseTile.getCoordinates().equals(nextCoordinates)) {
	    return;
	}
	CoordinatesWrapper<Tile> nextTile = new CoordinatesWrapper<Tile>(tiles[nextY][nextX], nextCoordinates);
	if (nextTile.get().isFloor()) {
	    return;
	}
	else {
	    tiles[nextY][nextX] = new Tile(FLOOR);
	    double random = Math.random();
	    if (random < CHANCE_OF_TURN) {
		direction = direction.turnLeft();
	    }
	    if (random > 1-CHANCE_OF_TURN) {
		direction = direction.turnRight();
	    }
//	    if (tileUtils.getAdjacentTiles(nextTile, FLOOR).size() > 1) {
//		direction = direction.turnLeft();
//	    }
	    dig(nextTile, direction);
	}
    }

    // private CoordinatesWrapper<Tile>
    // findFloorTileWithAdjacentWallTile(LevelMap levelMap) {
    // CoordinatesWrapper<Tile> tileWithCoordinates =
    // levelMap.findRandomFloorTileWithCoordinates();
    // List<CoordinatesWrapper<Tile>> ajacentTiles =
    // levelMap.getAdjacentTilesWithCoordinates(tileWithCoordinates);
    // for (CoordinatesWrapper<Tile> tileCoordinatesWrapper : ajacentTiles) {
    // if (tileCoordinatesWrapper.get().isWall()) {
    // return tileWithCoordinates;
    // }
    // }
    // return findFloorTileWithAdjacentWallTile(levelMap);
    // }

    private void makeRoom(int roomHeight, int roomWidth, int noOfIterations) {
	Coordinates roomStartCoordinates = tileUtils.findRandomTile(WALL).getCoordinates();
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
    
    // private Coordinates findRandomWallCoordinates() {
    // Random random = new Random();
    // int x;
    // int y;
    // do {
    // x = random.nextInt(tiles[0].length - 1) + 1;
    // y = random.nextInt(tiles.length - 1) + 1;
    // }
    // while (!tiles[y][x].isWall());
    // return new Coordinates(x, y);
    // }

    private void fillRectangle(Tile.Type type, Coordinates startCoordinates, Coordinates endCoordinates) {
	for (int y = startCoordinates.getY(); y < endCoordinates.getY(); y++) {
	    for (int x = startCoordinates.getX(); x < endCoordinates.getX(); x++) {
		tiles[y][x] = new Tile(type);
	    }
	}
    }
}
