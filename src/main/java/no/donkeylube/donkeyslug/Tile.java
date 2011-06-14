package no.donkeylube.donkeyslug;

import java.util.LinkedList;
import java.util.List;

public class Tile {
    public enum Type {
	WALL, FLOOR
    };

    private final Type type;
    private final LinkedList<Placeable> content = new LinkedList<Placeable>();
    private final Coordinates coordinates;

    public Tile(Type type, Coordinates coordinates) {
	this.type = type;
	this.coordinates = coordinates;
    }

    public boolean isWall() {
	return type == Type.WALL;
    }

    public boolean isFloor() {
	return type == Type.FLOOR;
    }

    public Type type() {
	return type;
    }
    
    public synchronized void add(Placeable placeable) {
	if (content.contains(placeable)) {
	    throw new IllegalArgumentException("Tile already contains placeable.");
	}
	else if (isWall()) {
	    throw new IllegalArgumentException("Cannot place content on a wall tile.");
	}	
	content.add(placeable);
	placeable.setCoordinates(coordinates);
    }

    public boolean contains(Placeable placeable) {
	return content.contains(placeable);
    }

    public synchronized Attackable getAttackable() {
	for (Placeable placeable : content) {
	    if (placeable instanceof Attackable) {
		return (Attackable) placeable;
	    }
	}
	return null;
    }

    public synchronized Movable getMovable() {
	for (Placeable placeable : content) {
	    if (placeable instanceof Movable) {
		return (Movable) placeable;
	    }
	}
	return null;
    }

    public synchronized boolean hasPlayer() {
	for (Placeable placeable : content) {
	    if (placeable instanceof Player) {
		return true;
	    }
	}
	return false;
    }

    public synchronized void remove(Placeable placeable) {
	content.remove(placeable);
    }

    public synchronized List<Item> getItems() {
	List<Item> items = new LinkedList<Item>(); 
	for (Placeable placeable : content) {
	    if (placeable instanceof Item) {
		items.add((Item) placeable);
	    }
	}
	return items;
    }
    
    public Coordinates coordinates() {
	return coordinates;
    }
}
