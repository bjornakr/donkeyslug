package no.donkeylube.donkeyslug;

import org.junit.Test;
import static org.junit.Assert.*;

public class FieldOfVisionTest {
    
    @Test
    public void creatureShouldNotSeePlaceableOutOfSight() {
	CreatureStatistics creatureStats = new CreatureStatistics.Builder(10, 10).sightRange(5).build();
	Creature creature = new Creature("Half-blind rat", creatureStats);
	LevelMap levelMap = LevelMapFactory.createSimpleMap(10, 10);
	levelMap.addPlaceableAt(creature, new Coordinates(1, 1));
	Item item = new Item();
	levelMap.addPlaceableAt(item, new Coordinates(9, 1));
	assertFalse(creature.sees(item));
    }
}
