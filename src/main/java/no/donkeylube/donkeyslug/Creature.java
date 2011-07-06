package no.donkeylube.donkeyslug;

import java.util.LinkedList;
import java.util.List;
import java.util.Stack;

import no.donkeylube.donkeyslug.ai.Behavior;
import no.donkeylube.donkeyslug.ai.FieldOfVision;
import no.donkeylube.donkeyslug.ai.PathFinder;
import no.donkeylube.donkeyslug.items.Consumable;
import no.donkeylube.donkeyslug.items.Ingredient;
import no.donkeylube.donkeyslug.items.Item;

public class Creature implements Placeable, Movable {
    private final String name;
    private final CreatureStatistics creatureStats;
    private MovableMover movableMover;
    private List<MoveListener> moveListeners = new LinkedList<MoveListener>();
    private final List<Item> backpack = new LinkedList<Item>();
    private Coordinates coordinates;
    private FieldOfVision fieldOfVision;
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
    
    public void setFieldOfVision(FieldOfVision fieldOfVision) {
	this.fieldOfVision = fieldOfVision;
    }
    
    public List<Attackable> liveAttackablesInFieldOfVision() {
	return fieldOfVision.liveAttackables();
    }

    public void moveTowards(Coordinates targetCoordinates) {
	if (coordinates.equals(targetCoordinates)) {
	    return;
	}
	Stack<Tile> shortestPath = pathFinder.findShortestPathTo(targetCoordinates);
	Tile destinationTile = shortestPath.pop();
	movableMover.move(destinationTile);
	// TODO: no movelistener
    }

    @Override
    public void setPathFinder(PathFinder pathFinder) {
	this.pathFinder = pathFinder;
    }

    public boolean sees(Placeable placeable) {
	return fieldOfVision.contains(placeable);
    }

    public Consumable alchemize(List<Ingredient> ingredientsForHealthPotion, Recipe recipe) {
	for (Ingredient ingredient : ingredientsForHealthPotion) {
	    if (!backpack.contains(ingredient)) {
		throw new IllegalArgumentException("Player does not carry ingredient \"" + ingredient + "\".");
	    }
	    backpack.remove(ingredient);
	}
	Consumable product = new Consumable(recipe.name(), recipe.consumationEffect());
	backpack.add(product);
	return product;
    }

    public void consume(Consumable consumable) {
	consumable.consume(creatureStats);
	backpack.remove(consumable);
    }
}
