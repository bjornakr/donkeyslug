package no.donkeylube.donkeyslug;

import static org.mockito.Mockito.mock;
import no.donkeylube.donkeyslug.Tile.Type;

import org.junit.Test;

public class TileTest {
 
    @Test(expected=RuntimeException.class)
    public void placingSamePlaceableTwiceShouldRaiseRuntimeException() {
	Tile tile = new Tile(Type.FLOOR);
	Placeable placeable = mock(Placeable.class); 
	tile.add(placeable);
	tile.add(placeable);
    }
    
    @Test(expected=RuntimeException.class)
    public void placingSomethingOnAWallTileShouldRaiseRuntimeException() {
	Tile tile = new Tile(Type.WALL);
	Placeable placeable = mock(Placeable.class);
	tile.add(placeable);
    }
}
