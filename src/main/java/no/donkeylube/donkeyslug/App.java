package no.donkeylube.donkeyslug;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.LinkedList;
import java.util.List;
import java.util.Stack;

import no.donkeylube.donkeyslug.ai.ChaseAndAttackBehavior;
import no.donkeylube.donkeyslug.items.Consumable;
import no.donkeylube.donkeyslug.items.Item;
import no.donkeylube.donkeyslug.items.Weapon;
import no.donkeylube.donkeyslug.view.LevelMapPainter;
import no.donkeylube.donkeyslug.view.MainWindow;

public class App implements KeyListener {
    private Player player = new Player("Doodlestick", new CreatureStatistics.Builder(10, 10).build());
    private Stack<Direction> directionsPressed = new Stack<Direction>();
    private LevelMapPainter mapPainter;
    private MainWindow mainWindow;
    private LevelMap levelMap;
    private List<Creature> enemies = new LinkedList<Creature>();
    
    public App() {
	levelMap = new LevelMapGenerator().generate(50, 70);
	levelMap.addPlaceableToRandomFloorTile(player);
	
	for (int i = 0; i < 100; i++) {
	    AttackableFighterCreature enemy = new AttackableFighterCreature("Zergling", new CreatureStatistics.Builder(
			5, 5).sightRange(4).build());
	    enemy.setBehavior(new ChaseAndAttackBehavior());
	    levelMap.addPlaceableToRandomFloorTile(enemy);
	    enemies.add(enemy);
	}
	Weapon weapon = new Weapon("Bastard Sword of the Craptolyffe");
//	weapon.setName("Bastard Sword of the Craptolyffe");
	weapon.setType(Weapon.Type.SLASHING);
	weapon.setMinDamage(20);
	weapon.setMaxDamage(30);
	weapon.setChanceOfCritical(0.4);
	weapon.setCriticalModifier(2);
	levelMap.addPlaceableToRandomFloorTile(weapon);
	
	for (int i = 0; i < 5; i++) {
	    levelMap.addPlaceableToRandomFloorTile(new Consumable("Health potion", ConsumationEffectFactory.createModifyHealthEffect(20)));
	}
	
	mapPainter = new LevelMapPainter(levelMap.getTiles());
	mainWindow = new MainWindow(mapPainter, player.getStatistics());
	mainWindow.addKeyListener(this);
	mainWindow.setVisible(true);

	int sleepInterval = 20;
	while (true) {
	    if (mapPainter.finishedMovingMovables() && !directionsPressed.isEmpty()) {
		player.move(directionsPressed.peek());
		for (Creature enemy : enemies) {
		    enemy.performBehavior();
		}
	    }

	    mainWindow.repaint();
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
