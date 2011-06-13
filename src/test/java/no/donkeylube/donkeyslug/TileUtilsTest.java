package no.donkeylube.donkeyslug;

import java.util.List;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class TileUtilsTest {
    private Tile[][] tiles;
    private TileUtils tileUtils;

    @Before
    public void initializeTileUtilsWithTiles() {
	tiles = new Tile[3][3];
	for (int y = 0; y < tiles.length; y++) {
	    for (int x = 0; x < tiles[0].length; x++) {
		tiles[y][x] = new Tile(Tile.Type.FLOOR);		
	    }
	}
	tileUtils = new TileUtils(tiles);
    }
    
    @Test
    public void testGetAdjacentTiles() {
	List<CoordinatesWrapper<Tile>> adjacentTiles = tileUtils.getAdjacentTiles(
		new CoordinatesWrapper<Tile>(tiles[1][1], new Coordinates(1, 1)));
	assertTrue(adjacentTiles.contains(new CoordinatesWrapper<Tile>(
		tiles[1][0], new Coordinates(1, 0))));
    }
    
    @Test
    public void testGetDirectionBetweenTiles() {
	CoordinatesWrapper<Tile> fromTile = new CoordinatesWrapper<Tile>(tiles[1][0], new Coordinates(0, 1));
	CoordinatesWrapper<Tile> toTile = new CoordinatesWrapper<Tile>(tiles[1][1], new Coordinates(1, 1));
	assertEquals(Direction.EAST, tileUtils.getDirectionBetweenTiles(fromTile, toTile));
    }
    
    @Test
    public void testFindRandomFloorTileWithAdjacentWall() {
	for (int y = 0; y < tiles.length; y++) {
	    for (int x = 0; x < tiles[0].length; x++) {
		tiles[y][x] = new Tile(Tile.Type.WALL);		
	    }
	}
	tiles[0][0] = new Tile(Tile.Type.FLOOR);
	CoordinatesWrapper<Tile> tile = tileUtils.findRandomFloorTileWithAdjacentWall();
	assertEquals(Tile.Type.FLOOR, tile.get().getType());
    }
}
