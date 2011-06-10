package no.donkeylube.donkeyslug;

import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Random;

import no.donkeylube.donkeyslug.helpers.RandomDistributor;

public class LevelMapGenerator {

    private Tile[][] tiles;

    public LevelMap generate(int height, int width) {
	tiles = new Tile[height][width];
	fillRectangle(Tile.Type.WALL, new Coordinates(0, 0), new Coordinates(width, height));

	int noOfRooms = 0;
	final int INIT_ROOM_SIZE = 8; 
	while (noOfRooms < 25) {	    
	    makeRoom(INIT_ROOM_SIZE + RandomDistributor.walk(0, 1, 0.6),
		    INIT_ROOM_SIZE + RandomDistributor.walk(0, 1, 0.6));
	    noOfRooms++;
	}
	LevelMap levelMap = new LevelMap(tiles);

	while (!levelMap.allFloorTilesAreAccessible()) {
//	    digTunnel();
	}

	return new LevelMap(tiles);
    }

    private Tile findFloorTileWithAdjacentWallTile(LevelMap levelMap) {
	Tile tile = levelMap.findRandomFloorTileWithCoordinates().get();
	List<CoordinatesWrapper<Tile>> ajacentTiles = levelMap.getAdjacentTilesWithCoordinates(tile);
	Collections.shuffle(ajacentTiles);
	for (CoordinatesWrapper<Tile> tileCoordinatesWrapper : ajacentTiles) {
	    if (tileCoordinatesWrapper.get().isWall()) {
		return tile;
	    }
	}	
	return findFloorTileWithAdjacentWallTile(levelMap);
    }

    private void makeRoom(int roomHeight, int roomWidth) {
	Coordinates roomStartCoordinates = findRandomWallCoordinates();
	Coordinates roomEndCoordinates = new Coordinates(roomStartCoordinates.getX() + roomWidth,
		roomStartCoordinates.getY() + roomHeight);
	if (!collission(roomStartCoordinates, roomEndCoordinates)) {
	    fillRectangle(Tile.Type.FLOOR, roomStartCoordinates, roomEndCoordinates);
	}
    }

    private boolean collission(Coordinates roomStartCoordinates, Coordinates roomEndCoordinates) {
	if (roomEndCoordinates.getX() >= tiles[0].length - 1 || roomEndCoordinates.getY() >= tiles.length - 1) {
	    return true;
	}
	for (int y = roomStartCoordinates.getY(); y < roomEndCoordinates.getY(); y++) {
	    for (int x = roomStartCoordinates.getX(); x < roomEndCoordinates.getX(); x++) {
		if (!tiles[y][x].isWall()) {
		    return true;
		}
	    }
	}
	return false;
    }

    private Coordinates findRandomWallCoordinates() {
	Random random = new Random();
	int x;
	int y;
	do {
	    x = random.nextInt(tiles[0].length - 1) + 1;
	    y = random.nextInt(tiles.length - 1) + 1;
	}
	while (!tiles[y][x].isWall());
	return new Coordinates(x, y);
    }

    private void fillRectangle(Tile.Type type, Coordinates startCoordinates, Coordinates endCoordinates) {
	for (int y = startCoordinates.getY(); y < endCoordinates.getY(); y++) {
	    for (int x = startCoordinates.getX(); x < endCoordinates.getX(); x++) {
		tiles[y][x] = new Tile(type);
	    }
	}
    }
}
