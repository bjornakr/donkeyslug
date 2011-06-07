package no.donkeylube.donkeyslug;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class LevelMapTest {
    private final String mapLayout =
	    "##########\n"
		    + "#        #\n"
		    + "#  #######\n"
		    + "#  ##    #\n"
		    + "#        #\n"
		    + "##########\n";
    private LevelMap levelMap;

    @Before
    public void loadMap() {
	InputStream mapInputStream = createMap();
	try {
	    levelMap = LevelMapFactory.loadMap(mapInputStream);
	}
	catch (IOException e) {
	    e.printStackTrace();
	}

    }

    private InputStream createMap() {
	String map = "rows: 6\n" + "cols: 10\n" + mapLayout;
	return new ByteArrayInputStream(map.getBytes());
    }

    @Test
    public void testLoadMap() {
	LevelMapTextRenderer renderer = new LevelMapTextRenderer(levelMap);
	assertEquals(mapLayout, renderer.render());
    }

    @Test
    public void testInsertPlaceableAt() {
	Placeable placeable = mock(Placeable.class);
	levelMap.addPlaceableAt(placeable, new Coordinates(1, 1));
	assertTrue(levelMap.hasPlaceableAt(placeable, new Coordinates(1, 1)));
    }

    @Test(expected = RuntimeException.class)
    public void testPlacingSomethingOnAWallRaisesException() {
	Placeable placeable = mock(Placeable.class);
	levelMap.addPlaceableAt(placeable, new Coordinates(0, 0));
    }

    @Test
    public void testMapShowsPlayer() {
	Placeable player = mock(Player.class);
	levelMap.addPlaceableAt(player, new Coordinates(1, 1));
	char[] mapWithPlayer = mapLayout.toCharArray();
	mapWithPlayer[12] = 'P';
	LevelMapTextRenderer renderer = new LevelMapTextRenderer(levelMap);
	assertEquals(String.valueOf(mapWithPlayer), renderer.render());
    }

    @Test
    public void testGetHeight() {
	LevelMap fourByThreeMap = LevelMapFactory.createSimpleMap(4, 3);
	assertEquals(4, fourByThreeMap.getHeight());
    }

    @Test
    public void testGetWidth() {
	LevelMap fourByThreeMap = LevelMapFactory.createSimpleMap(4, 3);
	assertEquals(3, fourByThreeMap.getWidth());
    }
}
