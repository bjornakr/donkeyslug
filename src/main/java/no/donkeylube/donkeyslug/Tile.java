package no.donkeylube.donkeyslug;

import java.util.LinkedList;

public class Tile {
	public enum Type {
		WALL, FLOOR
	};

	private final Type type;
	private final LinkedList<Placeable> content = new LinkedList<Placeable>();

	public Tile(Type type) {
		this.type = type;
	}

	public boolean isWall() {
		return type == Type.WALL;
	}

	public boolean isFloor() {
		return type == Type.FLOOR;
	}

	public void add(Placeable placeable) {
		if (content.contains(placeable)) {
			throw new IllegalArgumentException("Tile already contains placeable.");
		} else if (isWall()) {
			throw new IllegalArgumentException("Cannot place content on a wall tile.");
		}
		content.add(placeable);
	}

	public boolean contains(Placeable placeable) {
		return content.contains(placeable);
	}

	public Attackable getAttackable() {
		for (Placeable placeable : content) {
			if (placeable instanceof Attackable) {
				return (Attackable) placeable;
			}
		}
		return null;
	}
	
	public Movable getMovable() {
		for (Placeable placeable : content) {
			if (placeable instanceof Movable) {
				return (Movable) placeable;
			}
		}
		return null;		
	}

	public boolean hasPlayer() {
		for (Placeable placeable : content) {
			if (placeable instanceof Player) {
				return true;
			}
		}
		return false;
	}

	public void remove(Placeable placeable) {
		content.remove(placeable);
	}
}
