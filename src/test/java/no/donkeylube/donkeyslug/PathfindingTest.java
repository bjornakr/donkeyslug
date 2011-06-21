package no.donkeylube.donkeyslug;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class PathfindingTest {
    private Creature zergling;
    private LevelMap levelMap;
    
    @Before
    public void initializeCreature() {
	CreatureStatistics creatureStatistics = mock(CreatureStatistics.class);
	when(creatureStatistics.getHitPoints()).thenReturn(100);
	zergling = new Creature("Zergling", creatureStatistics);
    }

    @Before
    public void initializeMap() {
	levelMap = loadMapFromFile();	
    }
    
    @Test
    public void creatureShouldFindShortestPath() {	
	levelMap.addPlaceableAt(zergling, new Coordinates(10, 1));
	int moves = 0;
	Coordinates targetCoordinates = new Coordinates(10, 5);
	while (!zergling.getCoordinates().equals(targetCoordinates)) {
	    System.out.println(zergling.getCoordinates());
	    System.out.println("Moves: " + moves);
	    zergling.moveTowards(targetCoordinates);
	    moves++;
	    if (moves > 100) {
		fail("Creature could not reach destination.");
	    }
	}
	final int MIN_REQUIRED_MOVES = 26;
	assertEquals(MIN_REQUIRED_MOVES, moves);
    }
    
    private LevelMap loadMapFromFile() {
	LevelMap levelMap = null;
	try {
	    InputStream mapInputStream = new FileInputStream(new File("src/test/resources/shortest_path.map")); 
	    levelMap = LevelMapFactory.loadMap(mapInputStream);
	}
	catch (IOException e) {
	    e.printStackTrace();
	}
	return levelMap;
    }
}
