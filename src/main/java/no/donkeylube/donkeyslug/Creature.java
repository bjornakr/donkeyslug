package no.donkeylube.donkeyslug;

import java.util.LinkedList;
import java.util.List;

public class Creature implements Placeable, Movable {
    private final String name;
    private final CreatureStatistics creatureStats;
    private MovableMover movableMover;
    private final List<Item> backpack = new LinkedList<Item>();
    private Coordinates coordinates;
    
    public Creature(String name, CreatureStatistics creatureStats) {
	this.name = name;
	this.creatureStats = creatureStats;
    }
    
    public boolean isDead() {
	return creatureStats.getHitPoints() <= 0;
    }
    
    public String getName() {
	return name;
    }
    
    public CreatureStatistics getStatistics() {
	return creatureStats;
    }
    
    @Override
    public void move(Direction direction) {
	movableMover.move(direction);
    }
    
    public void kill() {
	creatureStats.decreaseHitPointsBy(creatureStats.getHitPoints());
    }

    public synchronized void pickUp(Item item, Tile tile) {
	if (!tile.contains(item)) {
	    throw new IllegalArgumentException("Tile does not contain specified item.");
	}
	tile.remove(item);
	backpack.add(item);
    }

    public synchronized boolean hasItem(Item item) {
	return backpack.contains(item);
    }

    public synchronized void drop(Item item, Tile tile) {
	if (!backpack.contains(item)) {
	    throw new IllegalArgumentException("Cannot drop item, because the creature is not carrying it.");
	}	
	backpack.remove(item);
	tile.add(item);
    }

    public synchronized void give(Item item) {
	backpack.add(item);
    }

    public synchronized List<Item> getItems() {
	return backpack;
    }

    @Override
    public Coordinates getCoordinates() {
	return coordinates;
    }

    @Override
    public void setCoordinates(Coordinates coordinates) {
	this.coordinates = coordinates;
    }

    @Override
    public void createMovableMover(LevelMap levelMap) {
	this.movableMover = new MovableMover(levelMap, this);
    }
}
