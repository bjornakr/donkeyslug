package no.donkeylube.donkeyslug;

import no.donkeylube.donkeyslug.items.Item;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class FieldOfVisionTest {
    private Creature creature;
    private LevelMap levelMap;
    private Item item;
    
    @Before
    public void initializeMapAndPlaceables() {
	CreatureStatistics creatureStats = new CreatureStatistics.Builder(10, 10).sightRange(5).build();
	creature = new Creature("Half-blind rat", creatureStats);
	levelMap = LevelMapFactory.createSimpleMap(10, 10);
	item = mock(Item.class);
	
    }
    
    @Test
    public void creatureShouldSeePlaceableInSight() {
	levelMap.addPlaceableAt(creature, new Coordinates(1, 1));
	levelMap.addPlaceableAt(item, new Coordinates(1, 2));
	assertTrue("Creature should see item", creature.sees(item));
    }
    
    @Test
    public void creatureShouldNotSeePlaceableOutOfSight() {
	levelMap.addPlaceableAt(creature, new Coordinates(1, 1));
	levelMap.addPlaceableAt(item, new Coordinates(8, 1));
	assertFalse("Creature should not see item", creature.sees(item));
    }
}
