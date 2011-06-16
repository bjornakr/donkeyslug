package no.donkeylube.donkeyslug;

import static org.junit.Assert.assertEquals;

import java.util.LinkedList;

import org.junit.Before;
import org.junit.Test;


public class MoveListenerTest {
    private AttackableFighterCreature player;
    private LevelMap levelMap;
    private TestListener testListener;
    
    @Before
    public void initializeLevelMapAndCreature() {
	testListener = new TestListener();
	levelMap = LevelMapFactory.createSimpleMap(5, 5);
	player = new Player("Guy", new CreatureStatistics.Builder(10, 10).build());
	levelMap.addPlaceableAt(player, new Coordinates(1, 1));	
    }
    
    @Test
    public void testMoveNotification() {
	player.addMoveListener(testListener);
	player.move(Direction.EAST);
	assertEquals("Movable moved", testListener.poll());	
    }
    
    @Test
    public void testAttackNotification() {
	player.addAttackListener(testListener);
	AttackableFighterCreature zerglingToTheEast =
	    new AttackableFighterCreature("Zergling", new CreatureStatistics.Builder(10, 10).build());
	levelMap.addPlaceableAt(zerglingToTheEast, new Coordinates(2, 1));	
	player.move(Direction.EAST);
	assertEquals("Fighter attacked", testListener.poll());
    }
    
    private class TestListener extends LinkedList<String> implements MoveListener, AttackListener {
	private static final long serialVersionUID = 1L;

	@Override
	public void movePerformed(Movable source) {
	    offer("Movable moved");
	}
	
	@Override
	public void attackPerformed(AttackReport attackReport) {
	    offer("Fighter attacked");
	}
    }
}
