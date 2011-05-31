package no.donkeylube.donkeyslug;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

public class LevelMap {
    private Tile[][] tiles;

    private LevelMap() {
    }

    public static LevelMap loadMap(InputStream mapInputStream) throws IOException {
	LevelMap levelMap = new LevelMap();
	BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(mapInputStream));
	int noOfCols = levelMap.extractHeaderInfo("rows", bufferedReader.readLine());
	int noOfRows = levelMap.extractHeaderInfo("cols", bufferedReader.readLine());
	levelMap.tiles = new Tile[noOfRows][noOfCols];
	char currentTileRepresentation;

	for (int i = 0; i < noOfRows; i++) {
	    for (int j = 0; j < noOfCols; j++) {
		currentTileRepresentation = readCharacterAndSkipLinefeeds(bufferedReader);
		levelMap.tiles[i][j] = createTileFromTileRepresentation(currentTileRepresentation, i, j);
	    }
	}
	return levelMap;
    }

    private static char readCharacterAndSkipLinefeeds(BufferedReader bufferedReader) throws IOException {
	char c;
	while ((c = (char) bufferedReader.read()) == '\n');
	return c;
    }

    private static Tile createTileFromTileRepresentation(char c, int i, int j) {
	if (c == '#') {
	    return new Tile(Tile.Type.WALL);
	}
	else if (c == ' ') {
	    return new Tile(Tile.Type.FLOOR);
	}
	else {
	    throw new RuntimeException("Unexpected character: " + c);
	}
    }

    private int extractHeaderInfo(String setup, String line) {
	String extractedNumber = line.split(setup + ": ")[1];
	return Integer.parseInt(extractedNumber);
    }

    @Override
    public String toString() {
	System.out.println("tiles.length: " + tiles.length);
	String map = "";
	for (int i = 0; i < tiles.length; i++) {
	    for (int j = 0; j < tiles[i].length; j++) {
		System.out.println("tiles[i].length: " + tiles[i].length);
		map += tiles[i][j].isWall() ? "#" : " ";
	    }
	    map += "\n";
	}
	return map;
    }
}
