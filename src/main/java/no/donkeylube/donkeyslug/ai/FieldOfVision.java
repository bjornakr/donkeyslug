package no.donkeylube.donkeyslug.ai;

import java.util.LinkedList;
import java.util.List;

import no.donkeylube.donkeyslug.Attackable;
import no.donkeylube.donkeyslug.Coordinates;
import no.donkeylube.donkeyslug.Creature;
import no.donkeylube.donkeyslug.LevelMap;
import no.donkeylube.donkeyslug.Placeable;
import no.donkeylube.donkeyslug.Tile;
import no.donkeylube.donkeyslug.TileUtils;

public class FieldOfVision {
    private final LevelMap levelMap;
    private final Creature creature;
    private final TileUtils tileUtils;

    public FieldOfVision(LevelMap levelMap, Creature creature) {
	this.levelMap = levelMap;
	this.creature = creature;
	tileUtils = new TileUtils(levelMap.getTiles());
    }

    public List<Placeable> placeables() {
	List<Placeable> placeablesInView = new LinkedList<Placeable>();
	for (Tile tile : tilesInView()) {
	    placeablesInView.addAll(tile.getPlaceables());
	}
	return placeablesInView;
    }

    public List<Attackable> liveAttackables() {
	List<Attackable> attackablesInView = new LinkedList<Attackable>();
	for (Tile tile : tilesInView()) {
	    addLiveAttackables(attackablesInView, tile);
	}
	return attackablesInView;
    }

    private void addLiveAttackables(List<Attackable> attackablesInView, Tile tile) {
	Attackable attackable = tile.getAttackable();
	if (attackable != null && attackable != creature && !attackable.isDead()) {
	    attackablesInView.add(tile.getAttackable());
	}
    }

    private List<Tile> tilesInView() {
	int sightRange = creature.getStatistics().getSightRange();
	Coordinates coordinatesForCreature = creature.getCoordinates();
	Coordinates upperLeftCoordinates = adjustCoordinatesWithRangeAndCutoff(coordinatesForCreature, -sightRange);
	Coordinates lowerRightCoordinates = adjustCoordinatesWithRangeAndCutoff(coordinatesForCreature, sightRange);
	return tileUtils.intersectRectange(upperLeftCoordinates, lowerRightCoordinates);

    }

    private Coordinates adjustCoordinatesWithRangeAndCutoff(Coordinates initialCoordinates, int range) {
	return Coordinates.getInstanceWithCutoffs(initialCoordinates.getX() + range, initialCoordinates.getY() + range,
		levelMap.getHeight(), levelMap.getWidth());
    }

    public boolean contains(Placeable placeable) {
	return placeables().contains(placeable);
    }

}
