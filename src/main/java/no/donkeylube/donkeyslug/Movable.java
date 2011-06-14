package no.donkeylube.donkeyslug;

public interface Movable extends Placeable {
    public void move(Direction direction);
    public void createMovableMover(LevelMap levelMap);
    public void setCoordinates(Coordinates newCoordinatesForMovable);
}
