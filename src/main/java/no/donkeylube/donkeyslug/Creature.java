package no.donkeylube.donkeyslug;

import java.util.LinkedList;
import java.util.List;
import java.util.Stack;

public class Creature implements Placeable, Movable {
    private final String name;
    private final CreatureStatistics creatureStats;
    private MovableMover movableMover;
    private List<MoveListener> moveListeners = new LinkedList<MoveListener>();
    private final List<Item> backpack = new LinkedList<Item>();
    private Coordinates coordinates;
    private List<Tile> fieldOfVision;
    private Behavior behavior;
    private PathFinder pathFinder;
    
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
	if (isDead()) {
	    throw new IllegalStateException("Cannot move dead creature.");
	}
	movableMover.move(direction);
	notifyMoveListeners();
    }
    
    public void kill() {
	creatureStats.decreaseHitPointsBy(creatureStats.getHitPoints());
    }

    public synchronized void pickUp(Item item, Tile tile) {
	if (isDead()) {
	    throw new IllegalStateException("Dead creatures cannot pick up items.");
	}
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
    public void setMovableMover(MovableMover movableMover) {
	this.movableMover = movableMover;
    }

    @Override
    public void addMoveListener(MoveListener moveListener) {
	moveListeners.add(moveListener);
    }

    @Override
    public void notifyMoveListeners() {
	for (MoveListener moveListener : moveListeners) {
	    moveListener.movePerformed(this);
	}
    }
    
    public void setBehavior(Behavior behavior) {
	behavior.setCreature(this);
	this.behavior = behavior;
    }
    
    public void performBehavior() {
	if (!isDead()) {
	    behavior.execute();
	}
    }
    
    public void setFieldOfVision(List<Tile> tiles) {
	fieldOfVision = tiles;
    }
    
    public List<Attackable> attackablesInFieldOfVision() {
	List<Attackable> attackables = new LinkedList<Attackable>();
	for (Tile tile : fieldOfVision) {
	    Attackable attackable = tile.getAttackable();
	    if (attackable != null && !attackable.equals(this) && !attackable.isDead()) {
		attackables.add(attackable);
	    }
	}
	return attackables;
    }

    public void moveTowards(Coordinates targetCoordinates) {	
	Stack<Tile> shortestPath = pathFinder.findShortestPathTo(targetCoordinates);
	Tile destinationTile = shortestPath.pop();
	movableMover.move(destinationTile);
	// no movelistener
    }

    @Override
    public void setPathFinder(PathFinder pathFinder) {
	this.pathFinder = pathFinder;
    }

    public boolean sees(Placeable placeable) {
	return false;
    }
}
