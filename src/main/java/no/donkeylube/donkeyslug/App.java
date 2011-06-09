package no.donkeylube.donkeyslug;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.util.Set;
import java.util.Stack;
import java.util.TreeSet;

import view.LevelMapPainter;

import no.donkeylube.donkeyslug.view.MainWindow;

public class App implements KeyListener {
	Player player = new Player("Doodlestick", new CreatureStatistics.Builder(10, 10).build());
	Stack<Direction> directionsPressed = new Stack<Direction>();
	// LevelMapTextRenderer renderer;
	LevelMapPainter mapPainter;
	MainWindow mainWindow;
	Direction currentDirection;

	public App() {
		// mainWindow.addKeyListener(this);

		LevelMap levelMap = new LevelMapGenerator().generate(40, 40);
		levelMap.findRandomFloorTile().add(player);

		AttackableFighterCreature zergling = new AttackableFighterCreature("Zergling", new CreatureStatistics.Builder(5, 5).build());
		levelMap.findRandomFloorTile().add(zergling);
		player.setMoveListener(new MoveListener(levelMap));
		// mainWindow.setMap(levelMap.getTiles());
		mapPainter = new LevelMapPainter(levelMap.getTiles());
		mainWindow = new MainWindow(mapPainter);
		mainWindow.addKeyListener(this);
		mainWindow.setVisible(true);

		int sleepInterval = 20;
		while (true) {
			if (mapPainter.finishedMovingMovables() && !directionsPressed.isEmpty()) {
				player.move(directionsPressed.peek());
			}
				
			mapPainter.repaint();
			try {
				Thread.sleep(sleepInterval);
			} catch (InterruptedException e) {
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
		} else if (keyCode == KeyEvent.VK_UP) {
			direction = Direction.NORTH;
		} else if (keyCode == KeyEvent.VK_RIGHT) {
			direction = Direction.EAST;
		} else if (keyCode == KeyEvent.VK_DOWN) {
			direction = Direction.SOUTH;
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
		} else if (keyCode == KeyEvent.VK_UP) {
			direction = Direction.NORTH;
		} else if (keyCode == KeyEvent.VK_RIGHT) {
			direction = Direction.EAST;
		} else if (keyCode == KeyEvent.VK_DOWN) {
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
