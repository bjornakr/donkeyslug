package no.donkeylube.donkeyslug;

import java.util.List;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class TileUtilsTest {
    private Tile[][] tiles;
    private TileUtils tileUtils;

    @Before
    public void initializeTileUtilsWithFloorTiles() {
	tiles = new Tile[3][3];
	for (int y = 0; y < tiles.length; y++) {
	    for (int x = 0; x < tiles[0].length; x++) {
		tiles[y][x] = new Tile(Tile.Type.FLOOR, new Coordinates(x, y));		
	    }
	}
	tileUtils = new TileUtils(tiles);
    }
    
    @Test
    public void testAllFloorTilesAreAccessible() {
	assertTrue(tileUtils.allFloorTilesAreAccessible());
	for (int x = 0; x < 3; x++) {
	    tiles[1][x] = new Tile(Tile.Type.WALL, new Coordinates(x, 1));
	}
	assertFalse(tileUtils.allFloorTilesAreAccessible());
    }
    
    @Test
    public void testGetAdjacentTiles() {
	List<Tile> adjacentTiles = tileUtils.getAdjacentTiles(tiles[1][1]);
	assertTrue(adjacentTiles.contains(tiles[1][0]));
	assertTrue(adjacentTiles.contains(tiles[0][1]));
	assertTrue(adjacentTiles.contains(tiles[2][1]));
	assertTrue(adjacentTiles.contains(tiles[1][2]));
    }
    
    @Test
    public void testGetDirectionBetweenTiles() {
	Tile fromTile = tiles[1][0];
	Tile toTile = tiles[1][1];
	assertEquals(Direction.EAST, tileUtils.getDirectionBetweenTiles(fromTile, toTile));
    }
    
    @Test(expected=RuntimeException.class)
    public void testGetDirectionBetweenTilesRaisesExceptionIfTilesAreNotAdjacent() {
	Tile fromTile = tiles[1][1];
	Tile toTile = tiles[0][0];
	tileUtils.getDirectionBetweenTiles(fromTile, toTile);	
    }
    
    @Test
    public void testFindRandomFloorTileWithAdjacentWallShouldReturnFloorTile() {
	for (int y = 0; y < tiles.length; y++) {
	    for (int x = 0; x < tiles[0].length; x++) {
		tiles[y][x] = new Tile(Tile.Type.WALL, new Coordinates(x, y));		
	    }
	}
	tiles[0][0] = new Tile(Tile.Type.FLOOR, new Coordinates(0, 0));
	Tile tile = tileUtils.findRandomFloorTileWithAdjacentWall();
	assertEquals(Tile.Type.FLOOR, tile.type());
    }
}
