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

    public static LevelMap generateLevelMap(int width, int height) {
	Tile[][] tiles = new Tile[height][width];	
	for (int y = 0; y < tiles.length; y++) {
	    for (int x = 0; x < tiles[y].length; x++) {
		if (isEdge(height, width, new Coordinates(x, y))) {
		    tiles[y][x] = new Tile(Tile.Type.WALL);
		}
		else {
		    tiles[y][x] = createRandomTile(tiles, new Coordinates(x, y));
		}
	    }
	}	
	return new LevelMap(tiles);
    }

    private static Tile createRandomTile(Tile[][] tiles, Coordinates coordinates) {
	double chanceOfWall = calculateChanceOfWall(tiles, coordinates); 
	Tile randomTile;
	if (Math.random() < chanceOfWall && hasAdjacentWall(tiles, coordinates)) {
	    randomTile = new Tile(Tile.Type.WALL);
	}
	else {
	    randomTile = new Tile(Tile.Type.FLOOR);
	}
	return randomTile;
    }

    private static boolean hasAdjacentWall(Tile[][] tiles, Coordinates coordinates) {
	if (tiles[coordinates.getY()-1][coordinates.getX()].isWall()) {
	    return true;
	}
	if (tiles[coordinates.getY()][coordinates.getX()-1].isWall()) {
	    return true;
	}
	else {
	    return false;
	}
    }

    private static double calculateChanceOfWall(Tile[][] tiles, Coordinates coordinates) {
	return 0.60;
    }
}
