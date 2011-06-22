package no.donkeylube.donkeyslug.ai;

import java.util.Collections;
import java.util.LinkedList;
import java.util.Stack;

import no.donkeylube.donkeyslug.Coordinates;
import no.donkeylube.donkeyslug.LevelMap;
import no.donkeylube.donkeyslug.Movable;
import no.donkeylube.donkeyslug.Tile;
import no.donkeylube.donkeyslug.TileUtils;

public class AStarShortestPathFinder implements PathFinder {
    private final LevelMap levelMap;
    private final Movable movable;
    private final TileUtils tileUtils;
    private Tile destinationTile;
    private PathStep currentLowestCostPathStep;
    private LinkedList<PathStep> open;
    private LinkedList<PathStep> closed;

    public AStarShortestPathFinder(LevelMap levelMap, Movable movable) {
	this.levelMap = levelMap;
	this.movable = movable;
	tileUtils = new TileUtils(levelMap.getTiles());
    }

    public Stack<Tile> findShortestPathTo(Coordinates destinationCoordinates) {
	open = new LinkedList<PathStep>();
	closed = new LinkedList<PathStep>();
	closed.clear();
	Tile startTile = levelMap.getTile(movable.getCoordinates());
	destinationTile = levelMap.getTile(destinationCoordinates);
	open.add(new PathStep(startTile, null));
	boolean pathFound = false;
	while (!pathFound) {
	    if (open.size() == 0) {
		throw new IllegalStateException("No possible path to target.");
	    }
	    currentLowestCostPathStep = open.pollFirst();
	    closed.add(currentLowestCostPathStep);
	    for (Tile tile : tileUtils.getAdjacentTiles(currentLowestCostPathStep.tile(), Tile.Type.FLOOR)) {
		treatAdjacentTile(tile);
	    }
	    pathFound = currentLowestCostPathStep.tile().equals(destinationTile);
	}
	return extractShortestPath();
    }

    private void treatAdjacentTile(Tile adjacentTile) {
	PathStep adjacentPathStep = new PathStep(adjacentTile, currentLowestCostPathStep);
	if (closed.contains(adjacentPathStep)) {
	    return;
	}
	if (open.contains(adjacentPathStep)) {
	    decideIfShortestPathShouldBeChanged(adjacentPathStep);
	}
	else {
	    open.add(adjacentPathStep);
	}
    }

    private void decideIfShortestPathShouldBeChanged(PathStep adjacentPathStep) {
	if (adjacentPathStep.getG() < currentLowestCostPathStep.getG()) {
	    adjacentPathStep.changeParentTo(currentLowestCostPathStep);
	    reSortConsideringPathSteps(adjacentPathStep);
	}
    }

    private void reSortConsideringPathSteps(PathStep newPathStep) {
	open.remove(newPathStep);
	open.add(newPathStep);
	Collections.sort(open);
    }

    private Stack<Tile> extractShortestPath() {
	Stack<Tile> shortestPath = new Stack<Tile>();
	PathStep currentPathStep = closed.getLast();
	while (currentPathStep != null) {
	    shortestPath.add(currentPathStep.tile());
	    currentPathStep = currentPathStep.parent;
	}
	shortestPath.pop();
	return shortestPath;
    }

    private class PathStep implements Comparable<PathStep> {
	private final Tile currentTile;
	private PathStep parent;
	private final int H;

	public PathStep(Tile currentTile, PathStep parent) {
	    this.currentTile = currentTile;
	    this.parent = parent;
	    if (parent == null) {
		H = 0;
	    }
	    else {
		H = estimatedDistanceToDestination();
	    }
	}

	private int estimatedDistanceToDestination() {
	    int distanceToDestination = Math.abs(currentTile.coordinates().getX() -
		    destinationTile.coordinates().getX()) +
		    Math.abs(currentTile.coordinates().getY() -
			    destinationTile.coordinates().getY());

	    return distanceToDestination;
	}

	public int getG() {
	    if (parent == null) {
		return 0;
	    }
	    return parent.getG() + 1;
	}

	public int getH() {
	    return H;
	}

	public int getF() {
	    return getG() + H;
	}

	public Tile tile() {
	    return currentTile;
	}

	public void changeParentTo(PathStep newParent) {
	    parent = newParent;
	}

	@Override
	public boolean equals(Object comparison) {
	    if (!(comparison instanceof PathStep)) {
		return false;
	    }
	    else {
		return currentTile.equals(((PathStep) comparison).tile());
	    }
	}

	@Override
	public int hashCode() {
	    return currentTile.hashCode();
	}

	@Override	
	public int compareTo(PathStep comparison) { // NB! INCONSISTENT WITH EQUALS
	    PathStep comparisonPathStep = (PathStep) comparison;
	    return getF() - comparisonPathStep.getF();
	}

	@Override
	public String toString() {
	    return ("c: " + currentTile.coordinates() + ", G: " + getG() + ", H: " + getH() + ", F: " + getF());
	}
    }
}
