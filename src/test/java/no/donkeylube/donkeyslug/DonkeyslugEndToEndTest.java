package no.donkeylube.donkeyslug;

import static org.junit.Assert.assertEquals;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import org.junit.Before;
import org.junit.Test;

public class DonkeyslugEndToEndTest {
    private Player player;
    
    @Before
    public void createPlayer() {
	player = new Player("Player", new CreatureStatistics.Builder(50, 50).build());	
    }
    
    @Test
    public void loadMapAndWalkAround() {
	LevelMap levelMap = loadMapFromFile();
	levelMap.addPlaceableAt(player, new Coordinates(20, 2));
	player.setMoveListener(new MoveListener(levelMap));
	movePlayerToBottomRightCornerWhileHittingWalls();
	String expectedOverview =
		"#######################\n"
			+ "#                     #\n"
			+ "#                     #\n"
			+ "#                     #\n"
			+ "#     #################\n"
			+ "#                     #\n"
			+ "#                    P#\n"
			+ "#######################\n";		
	LevelMapTextRenderer renderer = new LevelMapTextRenderer(levelMap);
	assertEquals(expectedOverview, renderer.render());
    }

    private LevelMap loadMapFromFile() {
	LevelMap levelMap = null;
	try {
	    InputStream mapInputStream = new FileInputStream(new File("src/test/resources/testlevel.map")); 
	    levelMap = LevelMapFactory.loadMap(mapInputStream);
	}
	catch (IOException e) {
	    e.printStackTrace();
	}
	return levelMap;
    }

    private void movePlayerToBottomRightCornerWhileHittingWalls() {
	movePlayer(Direction.WEST, 100);
	movePlayer(Direction.SOUTH, 100);
	movePlayer(Direction.EAST, 100);
    }

    private void movePlayer(Direction direction, int noOfMoves) {
	for (int i = 0; i < noOfMoves; i++) {
	    player.move(direction);
	}
    }
}
