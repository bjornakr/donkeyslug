package no.donkeylube.donkeyslug;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.LinkedList;
import java.util.List;
import java.util.Stack;

import no.donkeylube.donkeyslug.view.LevelMapPainter;
import no.donkeylube.donkeyslug.view.MainWindow;

public class App implements KeyListener {
    Player player = new Player("Doodlestick", new CreatureStatistics.Builder(10, 10).build());
    Stack<Direction> directionsPressed = new Stack<Direction>();
    LevelMapPainter mapPainter;
    MainWindow mainWindow;
    Direction currentDirection;
    LevelMap levelMap;

    public App() {
	levelMap = new LevelMapGenerator().generate(40, 70);
	levelMap.addPlaceableToRandomFloorTile(player);
	AttackableFighterCreature zergling = new AttackableFighterCreature("Zergling", new CreatureStatistics.Builder(
		5, 5).build());
	zergling.setBehavior(new ChaseAndAttackBehavior());
	AttackableFighterCreature zergling2 = new AttackableFighterCreature("Zergling", new CreatureStatistics.Builder(
		5, 5).build());
	zergling2.setBehavior(new ChaseAndAttackBehavior());
	levelMap.addPlaceableToRandomFloorTile(zergling);
	levelMap.addPlaceableToRandomFloorTile(zergling2);
	levelMap.addPlaceableToRandomFloorTile(new Item());
//	player.createMovableMover(levelMap);
	mapPainter = new LevelMapPainter(levelMap.getTiles());
	mainWindow = new MainWindow(mapPainter);
	mainWindow.addKeyListener(this);
	mainWindow.setVisible(true);

	int sleepInterval = 20;
	while (true) {
	    if (mapPainter.finishedMovingMovables() && !directionsPressed.isEmpty()) {
		player.move(directionsPressed.peek());
		zergling.performBehavior();
		zergling2.performBehavior();
	    }

	    mapPainter.repaint();
	    try {
		Thread.sleep(sleepInterval);
	    }
	    catch (InterruptedException e) {
		e.printStackTrace();
	    }
	}
    }

    public static void main(String[] args) {
	new App();
    }

    @Override
    public void keyPressed(KeyEvent e) {
	int keyCode = e.getKeyCode();
	Direction direction = null;
	if (keyCode == KeyEvent.VK_LEFT) {
	    direction = Direction.WEST;
	}
	else if (keyCode == KeyEvent.VK_UP) {
	    direction = Direction.NORTH;
	}
	else if (keyCode == KeyEvent.VK_RIGHT) {
	    direction = Direction.EAST;
	}
	else if (keyCode == KeyEvent.VK_DOWN) {
	    direction = Direction.SOUTH;
	}
	else if (keyCode == KeyEvent.VK_P) {
	    Coordinates coordinatesForPlayer = levelMap.getCoordinatesFor(player);
	    Tile tile = levelMap.getTile(coordinatesForPlayer);
	    for (Item item : tile.getItems()) {
		player.pickUp(item, tile);
	    }	    
	}
	else if (keyCode == KeyEvent.VK_D) {
	    Coordinates coordinatesForPlayer = levelMap.getCoordinatesFor(player);
	    Tile tile = levelMap.getTile(coordinatesForPlayer);
	    List<Item> itemsToDrop = new LinkedList<Item>();
	    for (Item item : player.getItems()) {
		itemsToDrop.add(item);
	    }	    
	    for (Item item : itemsToDrop) {
		player.drop(item, tile);
	    }
	}
	else if (keyCode == KeyEvent.VK_SPACE) {
	    Coordinates coordinatesForPlayer = levelMap.getCoordinatesFor(player);
	    Tile tile = levelMap.getTile(coordinatesForPlayer);
	    tile.remove(player);
	    levelMap.addPlaceableToRandomFloorTile(player);
	}
	
	if (direction != null && !directionsPressed.contains(direction)) {
	    directionsPressed.push(direction);
	}
	System.out.println(keyCode);
    }

    @Override
    public void keyReleased(KeyEvent e) {
	int keyCode = e.getKeyCode();
	Direction direction = null;
	if (keyCode == KeyEvent.VK_LEFT) {
	    direction = Direction.WEST;
	}
	else if (keyCode == KeyEvent.VK_UP) {
	    direction = Direction.NORTH;
	}
	else if (keyCode == KeyEvent.VK_RIGHT) {
	    direction = Direction.EAST;
	}
	else if (keyCode == KeyEvent.VK_DOWN) {
	    direction = Direction.SOUTH;
	}
	if (direction != null) {
	    directionsPressed.remove(direction);
	}

	System.err.println(keyCode);
    }

    @Override
    public void keyTyped(KeyEvent e) {
    }
}
