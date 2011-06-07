package no.donkeylube.donkeyslug;

public interface Movable extends Placeable {
    public void setMoveListener(MoveListener moveListener);
    public void move(Direction direction);
}
