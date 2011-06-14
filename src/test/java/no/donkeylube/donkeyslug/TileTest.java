package no.donkeylube.donkeyslug;

import static org.mockito.Mockito.mock;
import no.donkeylube.donkeyslug.Tile.Type;

import org.junit.Test;
import static org.junit.Assert.*;

public class TileTest {
 
    @Test(expected=RuntimeException.class)
    public void placingSamePlaceableTwiceShouldRaiseRuntimeException() {
	Tile tile = new Tile(Type.FLOOR, mock(Coordinates.class));
	Placeable placeable = mock(Placeable.class); 
	tile.add(placeable);
	tile.add(placeable);
    }
    
    @Test(expected=RuntimeException.class)
    public void placingSomethingOnAWallTileShouldRaiseRuntimeException() {
	Tile tile = new Tile(Type.WALL, mock(Coordinates.class));
	Placeable placeable = mock(Placeable.class);
	tile.add(placeable);
    }
    
    public void testPlaceItemOnTile() {
	Tile tile = new Tile(Type.FLOOR, mock(Coordinates.class));
	Item item = mock(Item.class);
	tile.add(item);
	assertTrue(tile.getItems().contains(item));
    }
}
