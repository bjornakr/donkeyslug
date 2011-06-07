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
	for (int i = 0; i < noOfRows; i++) {
	    for (int j = 0; j < noOfCols; j++) {
		currentTileRepresentation = readCharacterAndSkipLinefeeds(bufferedReader);
		tiles[i][j] = createTileFromCharRepresentation(currentTileRepresentation, i, j);
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

    private static Tile createTileFromCharRepresentation(char representation, int i, int j) {	
	if (representation == '#') {
	    return new Tile(Tile.Type.WALL);
	}
	else if (representation == ' ') {
	    return new Tile(Tile.Type.FLOOR);
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
	for (int i = 0; i < noOfRows; i++) {
	    for (int j = 0; j < noOfCols; j++) {
		levelMap += shouldBeWall(noOfRows, noOfCols, i, j) ? "#" : " ";
	    }
	    levelMap += "\n";
	}
	return levelMap;
    }

    private static boolean shouldBeWall(int noOfRows, int noOfCols, int i, int j) {
	if (i == 0 || j == 0) {
	    return true;
	}
	else if (i == noOfRows-1 || j == noOfCols-1) {
	    return true;
	}
	else {
	    return false;
	}
    }
}
