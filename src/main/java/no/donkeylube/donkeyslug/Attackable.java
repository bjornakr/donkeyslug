package no.donkeylube.donkeyslug;

public interface Attackable {
    public void takeDamage(int damage);
    public String getName();
    public boolean isDead();
    public CreatureStatistics getStatistics();
    public int getAccumulatedDefensiveValueOfArmor();
    public Coordinates getCoordinates();
}
