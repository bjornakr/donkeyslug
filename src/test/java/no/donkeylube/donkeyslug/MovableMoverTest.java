package no.donkeylube.donkeyslug;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class MovableMoverTest {
    private Player player;
    private LevelMap levelMap;
    
    @Before
    public void initializePlayer() {
	player = new Player("Player", mock(CreatureStatistics.class));
    }
    
    @Test
    public void testMovableShouldNotBeAbleToMoveThroughWalls() {
	levelMap = LevelMapFactory.createSimpleMap(3, 3);
	Coordinates initialCoordinates = new Coordinates(1, 1);
	levelMap.addPlaceableAt(player, initialCoordinates);
	player.createMovableMover(levelMap);
	player.move(Direction.NORTH);
	assertEquals(initialCoordinates, levelMap.getCoordinatesFor(player));
	player.move(Direction.EAST);
	assertEquals(initialCoordinates, levelMap.getCoordinatesFor(player));
	player.move(Direction.SOUTH);
	assertEquals(initialCoordinates, levelMap.getCoordinatesFor(player));
	player.move(Direction.WEST);
	assertEquals(initialCoordinates, levelMap.getCoordinatesFor(player));
    }
    
    @Test
    public void testGoNorth() {
	setupMapAndPlayer();
	player.move(Direction.NORTH);
	assertEquals(new Coordinates(2, 1), levelMap.getCoordinatesFor(player));
    }
    
    @Test
    public void testGoEast() {
	setupMapAndPlayer();
	player.move(Direction.EAST);
	assertEquals(new Coordinates(3, 2), levelMap.getCoordinatesFor(player));
    }

    @Test
    public void testGoSouth() {
	setupMapAndPlayer();
	player.move(Direction.SOUTH);
	assertEquals(new Coordinates(2, 3), levelMap.getCoordinatesFor(player));
    }

    @Test
    public void testGoWest() {
	setupMapAndPlayer();
	player.move(Direction.WEST);
	assertEquals(new Coordinates(1, 2), levelMap.getCoordinatesFor(player));
    }
    
    @Test
    public void testGoSouthTwoTimes() {
	levelMap = LevelMapFactory.createSimpleMap(5, 5);	
	Coordinates initialCoordinates = new Coordinates(2, 1);
	levelMap.addPlaceableAt(player, initialCoordinates);
	player.createMovableMover(levelMap);
	player.move(Direction.SOUTH);
	player.move(Direction.SOUTH);
	assertEquals(new Coordinates(2, 3), levelMap.getCoordinatesFor(player));
    }
    
    private void setupMapAndPlayer() {
	levelMap = LevelMapFactory.createSimpleMap(5, 5);
	Coordinates initialCoordinates = new Coordinates(2, 2);
	levelMap.addPlaceableAt(player, initialCoordinates);
	player.createMovableMover(levelMap);	
    }
}
