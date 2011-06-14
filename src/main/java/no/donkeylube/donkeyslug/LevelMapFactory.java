package no.donkeylube.donkeyslug;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

public class LevelMapFactory {
    private LevelMapFactory() {
    }
    
    public static LevelMap loadMap(InputStream mapInputStream) throws IOException {
	BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(mapInputStream));
	int noOfRows = extractHeaderInfo("rows", bufferedReader.readLine());
	int noOfCols = extractHeaderInfo("cols", bufferedReader.readLine());
	Tile[][] tiles = new Tile[noOfRows][noOfCols];
	char currentTileRepresentation;
	for (int y = 0; y < noOfRows; y++) {
	    for (int x = 0; x < noOfCols; x++) {
		currentTileRepresentation = readCharacterAndSkipLinefeeds(bufferedReader);
		tiles[y][x] = createTileFromCharRepresentation(currentTileRepresentation, y, x);
	    }
	}	
	return new LevelMap(tiles);
    }
    
    private static int extractHeaderInfo(String setup, String line) {
	String extractedNumber = line.split(setup + ": ")[1];
	return Integer.parseInt(extractedNumber);
    }
    
    private static char readCharacterAndSkipLinefeeds(BufferedReader bufferedReader) throws IOException {
	char c;
	do {
	    c = (char) bufferedReader.read();
	}
	while (c == '\n' || c == Character.LINE_SEPARATOR);
	return c;
    }

    private static Tile createTileFromCharRepresentation(char representation, int y, int x) {	
	if (representation == '#') {
	    return new Tile(Tile.Type.WALL, new Coordinates(x, y));
	}
	else if (representation == ' ') {
	    return new Tile(Tile.Type.FLOOR, new Coordinates(x, y));
	}
	else {
	    throw new IllegalArgumentException("Unexpected character: '" + representation + "'");
	}
    }
    
    public static LevelMap createSimpleMap(int noOfRows, int noOfCols) {
	String simpleMap = "rows: " + noOfRows + "\n" +
			"cols: " + noOfCols + "\n";

	simpleMap += constructSimpleMap(noOfRows, noOfCols);
	
	
	ByteArrayInputStream simpleMapStream = new ByteArrayInputStream(simpleMap.getBytes());	
	LevelMap levelMap = null; 
	try {
	    levelMap = loadMap(simpleMapStream);
	}
	catch (IOException e) {
	    e.printStackTrace();
	}
	return levelMap;
    }

    private static String constructSimpleMap(int noOfRows, int noOfCols) {
	String levelMap = "";
	for (int y = 0; y < noOfRows; y++) {
	    for (int x = 0; x < noOfCols; x++) {
		levelMap += isEdge(noOfRows, noOfCols, new Coordinates(x, y)) ? "#" : " ";
	    }
	    levelMap += "\n";
	}
	return levelMap;
    }

    private static boolean isEdge(int height, int width, Coordinates coordinates) {
	if (coordinates.getX() == 0 || coordinates.getY() == 0) {
	    return true;
	}
	else if (coordinates.getY() == height-1 || coordinates.getX() == width-1) {
	    return true;
	}
	else {
	    return false;
	}
    }
}
