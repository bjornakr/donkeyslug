package no.donkeylube.donkeyslug;

import java.io.File;
import java.io.FileReader;

import org.junit.*;

public class DonkeyslugEndToEndTest {
    private final ApplicationRunner application = new ApplicationRunner();
    private Player player;
    
    @Test
    public void loadMapAndWalkAround() {
	Game game = application.createGame();
	game.loadMap(new FileReader(new File("resources/testlevel.map")));	
	player = game.getPlayer();
	movePlayer(Direction.WEST, 7);
	playerHitWall	
    }

    @After
    public void stopApplication() {
	application.stop();
    }
    
    private void movePlayer(Direction direction, int noOfMoves) {
	for (int i = 0; i < noOfMoves; i++) {
	    player.move(direction);
	}
    }
}
