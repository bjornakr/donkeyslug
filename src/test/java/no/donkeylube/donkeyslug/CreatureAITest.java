package no.donkeylube.donkeyslug;

import org.junit.Before;
import org.junit.Test;
import static org.junit.Assert.*;

public class CreatureAITest {
    private AttackableFighterCreature creature;
    private Player player;
    
    @Before
    public void initializeCreature() {
	creature = new AttackableFighterCreature("Zergling",
		new CreatureStatistics.Builder(10, 10).build());
	Behavior chaseAndAttackBehavior = new ChaseAndAttackBehavior();	
	creature.setBehavior(chaseAndAttackBehavior);		
    }
    
    @Before
    public void initializePlayer() {
	player = new Player("Test guy", new CreatureStatistics.Builder(10, 10).build());
    }
    
    
    @Test
    public void creatureShouldChaseAndAttackPlayer() {
	setupLevelMap();
	int moves = 0;
	while (!player.isDead()) {
	    creature.performBehavior();
	    moves++;
	    if (moves > 1000) {
		fail("Creature failed to chase and kill player.");
	    }
	}
    }
    
    private void setupLevelMap() {
	LevelMap levelMap = LevelMapFactory.createSimpleMap(5, 5);
	levelMap.addPlaceableAt(creature, new Coordinates(1, 1));
	levelMap.addPlaceableAt(player, new Coordinates(3, 3));	
    }
}
