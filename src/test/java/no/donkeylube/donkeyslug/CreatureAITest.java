package no.donkeylube.donkeyslug;

import org.junit.Test;
import static org.junit.Assert.*;

public class CreatureAITest {
    
    @Test
    public void creatureShouldChaseAndAttackPlayer() {
	AttackableFighterCreature zergling = new AttackableFighterCreature("Zergling",
		new CreatureStatistics.Builder(10, 10).build());
	Behavior chaseAndAttackBehavior = new ChaseAndAttackBehavior();	
	zergling.setBehavior(chaseAndAttackBehavior);	
	LevelMap levelMap = LevelMapFactory.createSimpleMap(5, 5);
	levelMap.addPlaceableAt(zergling, new Coordinates(1, 1));
	
	Player player = new Player("Guy", new CreatureStatistics.Builder(10, 10).build());
	levelMap.addPlaceableAt(player, new Coordinates(3, 3));
//	zergling.performBehavior();
//	assertEquals(new Coordinates(1, 2), zergling.getCoordinates());
	int moves = 0;
	while (!player.isDead()) {
	    zergling.performBehavior();
	    moves++;
	    if (moves > 1000) {
		fail("Creature failed to chase and kill player.");
	    }
	}
    }
}
