package no.donkeylube.donkeyslug;

import no.donkeylube.donkeyslug.ai.PathFinder;

public interface Movable extends Placeable {
    public void move(Direction direction);
    public void setMovableMover(MovableMover movableMover);
    public void setCoordinates(Coordinates newCoordinatesForMovable);
    public void addMoveListener(MoveListener moveListener);
    public void notifyMoveListeners();
    public void setPathFinder(PathFinder pathFinder);
}
