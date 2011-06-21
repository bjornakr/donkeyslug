package no.donkeylube.donkeyslug;

import java.util.Stack;

public interface PathFinder {
    public Stack<Tile> findShortestPathTo(Coordinates targetCoordinates);
}
