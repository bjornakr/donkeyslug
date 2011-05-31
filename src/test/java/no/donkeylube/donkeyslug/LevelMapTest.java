package no.donkeylube.donkeyslug;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;

import org.junit.Test;
import static org.junit.Assert.*;

public class LevelMapTest {
    private final String mapLayout =
	    "##########\n" +
		    "#        #\n" +
		    "#  #######\n" +
		    "#  ##    #\n" +
		    "#        #\n" +
		    "##########\n";

    @Test
    public void testLoadMap() {
	LevelMap levelMap;
	InputStream mapInputStream = createMap();
	try {
	    levelMap = LevelMap.loadMap(mapInputStream);
	    assertEquals(mapLayout, levelMap.toString());
	}
	catch (IOException e) {
	    e.printStackTrace();
	}
    }

    private InputStream createMap() {
	String map = "rows: 6\n" + "cols: 10\n" + mapLayout;
	return new ByteArrayInputStream(map.getBytes());
    }
}