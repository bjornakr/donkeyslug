package no.donkeylube.donkeyslug;

import no.donkeylube.donkeyslug.items.Item;

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
	item = mock(Item.class);
	CreatureStatistics creatureStatistics = mock(CreatureStatistics.class);
	when(creatureStatistics.getHitPoints()).thenReturn(100);
	creature = new Creature("Random guy", creatureStatistics);
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
	assertFalse("Item is removed from map after picking it up",
		levelMap.hasPlaceableAt(item, coordinatesForItem));
    }
    
    @Test
    public void canGiveItemToCreature() {
	creature.give(item);
	assertTrue(creature.getItems().contains(item));
    }
    
    @Test
    public void creatureDropsItem() {
	Coordinates coordinatesForPlayer = new Coordinates(1, 1);
	creature.give(item);
	levelMap.addPlaceableAt(creature, coordinatesForPlayer);
	creature.drop(item, levelMap.getTile(coordinatesForPlayer));
	assertFalse("Creature dropped item", creature.hasItem(item));
	assertTrue("Item is now on the ground", levelMap.hasPlaceableAt(item, coordinatesForPlayer));
    }
    
    @Test(expected=RuntimeException.class)
    public void pickingUpItemNotOnFloorShouldRaiseException() {
	creature.pickUp(item, new Tile(Tile.Type.FLOOR, mock(Coordinates.class)));
    }

    @Test(expected=RuntimeException.class)
    public void droppingItemNotInBackpackShouldRaiseException() {
	creature.drop(item, new Tile(Tile.Type.FLOOR, mock(Coordinates.class)));
    }
}
