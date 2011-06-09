package no.donkeylube.donkeyslug;

import java.util.Random;

public class LevelMapGenerator {

    private Tile[][] tiles;

    public LevelMap generate(int height, int width) {
	tiles = new Tile[height][width];
	fillRectangle(Tile.Type.WALL, new Coordinates(0, 0), new Coordinates(width, height));

	int noOfRooms = 0;
	while (noOfRooms < 8) {
	    Coordinates roomStartCoordinates = findRandomWallCoordinates();
	    int roomHeight = height / 5;
	    int roomWidth = width / 5;
	    Coordinates roomEndCoordinates = new Coordinates(roomStartCoordinates.getX() + roomWidth,
		    roomStartCoordinates.getY() + roomHeight);
	    if (!collission(roomStartCoordinates, roomEndCoordinates)) {
		fillRectangle(Tile.Type.FLOOR, roomStartCoordinates, roomEndCoordinates);
		noOfRooms++;
	    }
	}

	return new LevelMap(tiles);
    }

    private boolean collission(Coordinates roomStartCoordinates, Coordinates roomEndCoordinates) {
	if (roomEndCoordinates.getX() >= tiles[0].length - 1
		|| roomEndCoordinates.getY() >= tiles.length - 1) {
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
