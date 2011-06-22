package no.donkeylube.donkeyslug.ai;

import java.util.Stack;

import no.donkeylube.donkeyslug.Coordinates;
import no.donkeylube.donkeyslug.Tile;

public interface PathFinder {
    public Stack<Tile> findShortestPathTo(Coordinates targetCoordinates);
}
