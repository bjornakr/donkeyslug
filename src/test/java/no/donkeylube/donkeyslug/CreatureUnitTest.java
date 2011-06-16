package no.donkeylube.donkeyslug;

import org.junit.Test;
import static org.mockito.Mockito.*;

public class CreatureUnitTest {
    
    @Test(expected=IllegalStateException.class)
    public void testMoveThrowsExceptionIfCreatureIsDead() {
	CreatureStatistics creatureStatistics = mock(CreatureStatistics.class);
	when(creatureStatistics.getHitPoints()).thenReturn(0);
	Creature creature = new Creature("Dead rat", creatureStatistics);
	creature.move(Direction.NORTH);
    }
}
