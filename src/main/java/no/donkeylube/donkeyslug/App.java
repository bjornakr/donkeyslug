package no.donkeylube.donkeyslug;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

import view.MainWindow;

public class App implements KeyListener {
	Player player = new Player("Doodlestick", new CreatureStatistics.Builder(10, 10).build());
	LevelMapTextRenderer renderer;
	MainWindow mainWindow = new MainWindow(this);
	
	public App() {
		mainWindow.setVisible(true);
//		mainWindow.addKeyListener(this);
		
		LevelMap levelMap = LevelMapFactory.createSimpleMap(10, 20);
		renderer = new LevelMapTextRenderer(levelMap);
		levelMap.addPlaceableAt(player, new Coordinates(1, 1));
		
		AttackableFighterCreature zergling = new AttackableFighterCreature("Zergling", new CreatureStatistics.Builder(5, 5).build());
		levelMap.addPlaceableAt(zergling, new Coordinates(2, 1));
		player.setMoveListener(new MoveListener(levelMap));
		mainWindow.setMap(renderer.render());
	}
	
	public static void main(String[] args) {
		new App();
	}
		

	@Override
	public void keyPressed(KeyEvent e) {
		int keyCode = e.getKeyCode();
		if (keyCode == KeyEvent.VK_LEFT) {
			player.move(Direction.WEST);
		}
		else if (keyCode == KeyEvent.VK_UP) {
			player.move(Direction.NORTH);
		}
		else if (keyCode == KeyEvent.VK_RIGHT) {
			player.move(Direction.EAST);
		}
		else if (keyCode == KeyEvent.VK_DOWN) {
			player.move(Direction.SOUTH);
		}
		
		mainWindow.setMap(renderer.render());
	}

	@Override
	public void keyReleased(KeyEvent e) {
	}

	@Override
	public void keyTyped(KeyEvent e) {
	}
}
