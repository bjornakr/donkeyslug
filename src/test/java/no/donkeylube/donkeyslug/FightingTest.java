package no.donkeylube.donkeyslug;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;
import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;

public class FightingTest {
    AttackableFighterCreature player;
    AttackableFighterCreature trainingDummy;
    
    @Before
    public void setupFighters() {
	player = new Player("Player", 
		new CreatureStatistics.Builder(10, 20).hitPoints(100).build());
	trainingDummy = new AttackableFighterCreature("Training dummy",
		new CreatureStatistics.Builder(0, 0).hitPoints(100).build());	
    }
    
    @Test
    public void playerShouldKillTrainingDummy() {
	int noOfRounds = 0;
	while (!trainingDummy.isDead()) {
	    player.attack(trainingDummy);
	    noOfRounds++;
	    if (noOfRounds > 1000) {
		fail("It looks like the fight is stuck in an endless loop.");
	    }
	}
	assert(trainingDummy.isDead());
    }
    
    @SuppressWarnings("unchecked")
    @Test
    public void testFightReport() {
	GameReporter gameReporter = GameReporter.getInstance();
	gameReporter.clear();
	player.attack(trainingDummy);
	assertThat(gameReporter, hasItem("Player attacks Training dummy with bare hands."));
	assertThat(gameReporter, anyOf(hasItem(containsString("Training dummy takes")),
			hasItem(containsString("Player misses."))));
	player.equipWeapon(new Weapon("Sword", 10, 15));
	player.attack(trainingDummy);
	assertThat(gameReporter, hasItem("Player attacks Training dummy with sword."));
    }
    
    @Test
    public void playerShouldFightsEnemyWhenTryingToMoveToItsLocation() {
	LevelMap levelMap = LevelMapFactory.createSimpleMap(3, 4);
	placePlayerAndTrainingDummy(levelMap, new Coordinates(1, 1), new Coordinates(2, 1));
	int moves = 0;
	while (!trainingDummy.isDead()) {
	    player.move(Direction.EAST);
	    moves++;
	    if (moves > 1000) {
		fail("It looks like the fight is stuck in an endless loop.");	
	    }
	}
    }

    private void placePlayerAndTrainingDummy(LevelMap levelMap,
	    Coordinates coordinatesForPlayer, Coordinates coordinatesForTrainingDummy) {
	levelMap.addPlaceableAt(player, coordinatesForPlayer);
	player.createMovableMover(levelMap);
	levelMap.addPlaceableAt(trainingDummy, coordinatesForTrainingDummy);	
    }
    
    @Test
    public void testPlayerShouldBeAbleToMoveOverDeadEnemies() {
	LevelMap levelMap = LevelMapFactory.createSimpleMap(3, 4);
	Coordinates coordinatesForTrainingDummy = new Coordinates(2, 1);
	placePlayerAndTrainingDummy(levelMap, new Coordinates(1, 1), coordinatesForTrainingDummy);
	trainingDummy.kill();
	player.move(Direction.EAST);
	assertThat(levelMap.getCoordinatesFor(player), is(coordinatesForTrainingDummy));
    }
}
