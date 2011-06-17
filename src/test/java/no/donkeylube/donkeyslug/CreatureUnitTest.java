package no.donkeylube.donkeyslug;

import org.junit.Before;
import org.junit.Test;
import static org.mockito.Mockito.*;

public class CreatureUnitTest {
    Creature creature;
    
    @Before
    public void createDeadCreature() {
	CreatureStatistics creatureStatistics = mock(CreatureStatistics.class);
	when(creatureStatistics.getHitPoints()).thenReturn(0);	
	creature = new Creature("Dead rat", creatureStatistics);
    }
    
    @Test(expected=IllegalStateException.class)
    public void testMoveThrowsExceptionIfCreatureIsDead() {
	creature.move(Direction.NORTH);
    }
    
    @Test(expected=IllegalStateException.class)
    public void testPicUpThrowsExceptionIfCreatureIsDead() {
	creature.pickUp(mock(Item.class), mock(Tile.class));
    }
}
