package no.donkeylube.donkeyslug;

import java.util.LinkedList;
import java.util.List;

public class Creature implements Placeable, Movable {
    private final String name;
    private final CreatureStatistics creatureStats;
    private MoveListener moveListener;
    private final List<Item> backpack = new LinkedList<Item>();
    
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
	moveListener.move(this, direction);
    }

    @Override
    public void setMoveListener(MoveListener moveListener) {
	this.moveListener = moveListener;
	moveListener.registerMovable(this);
    }
    
    public void kill() {
	creatureStats.decreaseHitPointsBy(creatureStats.getHitPoints());
    }

    public void pickUp(Item item, Tile tile) {
	if (!tile.contains(item)) {
	    throw new IllegalArgumentException("Tile does not contain specified item.");
	}
	tile.remove(item);
	backpack.add(item);
    }

    public boolean hasItem(Item item) {
	return backpack.contains(item);
    }

    public void drop(Item item, Tile tile) {
	if (!backpack.contains(item)) {
	    throw new IllegalArgumentException("Cannot drop item, because the creature is not carrying it.");
	}	
	backpack.remove(item);
	tile.add(item);
    }
}
