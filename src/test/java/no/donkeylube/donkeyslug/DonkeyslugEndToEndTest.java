package no.donkeylube.donkeyslug;

import static org.junit.Assert.assertEquals;

import java.awt.AWTException;
import java.awt.Robot;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import org.junit.Test;

public class DonkeyslugEndToEndTest {
    private Player player;
    private Game game;

    @Test
    public void loadMapAndWalkAround() {
	game = new Game();
	loadMapFromFile();
	player = new Player();
	game.insertPlaceableAt(player, 20, 2);
	movePlayerToBottomRightCorner();
	String expectedOverview =
		"#######################\n"
			+ "#                     #\n"
			+ "#                     #\n"
			+ "#                     #\n"
			+ "#     #################\n"
			+ "#                     #\n"
			+ "#                    P#\n"
			+ "#######################";
	assertEquals(expectedOverview, game.overview());
    }

    private void loadMapFromFile() {
	try {
	    game.loadMap(new FileInputStream(new File("src/test/resources/testlevel.map")));
	}
	catch (IOException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	}
    }

    private void movePlayerToBottomRightCorner() {
	try {
	    Robot robot = new Robot();
	}
	catch (AWTException e) {
	    e.printStackTrace();
	}
	movePlayer(Direction.WEST, 100); // Hitting walls as we go
	movePlayer(Direction.SOUTH, 100);
	movePlayer(Direction.EAST, 100);
    }

    private void movePlayer(Direction direction, int noOfMoves) {
	for (int i = 0; i < noOfMoves; i++) {
	    player.move(direction);
	}
    }
}
