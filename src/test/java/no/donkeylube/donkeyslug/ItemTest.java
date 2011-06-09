package no.donkeylube.donkeyslug;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class ItemTest {
    private LevelMap levelMap;
    private Item item;
    private Creature creature;
    
    @Before
    public void initialize() {
	levelMap = LevelMapFactory.createSimpleMap(3, 3);
	item = new Item();
	creature = new Creature("Random guy", mock(CreatureStatistics.class));
    }
    
    @Test
    public void canPlaceItemOnLevelMap() {	
	Coordinates coordinatesForItem = new Coordinates(1, 1);
	levelMap.addPlaceableAt(item, coordinatesForItem);
	assertTrue(levelMap.hasPlaceableAt(item, coordinatesForItem));
    }
    
    @Test
    public void creaturePicksUpItem() {
	Coordinates coordinatesForItem = new Coordinates(1, 1);
	levelMap.addPlaceableAt(item, coordinatesForItem);
	creature.pickUp(item, levelMap.getTile(coordinatesForItem));
	assertTrue("Creature picked up potion", creature.hasItem(item));
	assertFalse("Potion no longer exists after picking it up",
		levelMap.hasPlaceableAt(item, coordinatesForItem));
    }
    
    @Test
    public void playerDropsItem() {
	
    }
    
    @Test(expected=RuntimeException.class)
    public void pickingUpItemNotOnFloorShouldRaiseException() {
	creature.pickUp(new Item(), new Tile(Tile.Type.FLOOR));
    }

    @Test(expected=RuntimeException.class)
    public void droppingItemNotInBackpackShouldRaiseException() {
	creature.drop(new Item(), new Tile(Tile.Type.FLOOR));
    }
}
