package no.donkeylube.donkeyslug.helpers;

public class RandomDistributor {
    public static int walk(int base, double cutoff) {
	if (cutoff >= 1 || cutoff < 0) {
	    throw new IllegalArgumentException("Cutoff must be between 0-1, 1 exclusive.");
	}
	double random = Math.random();
	if (random < cutoff) {
	    return walk(base+1, cutoff);
	}
	else return base;
    }
    
    public static void main(String[] args) {
	for (int i=0; i < 10; i++) {
	    System.out.println(walk(0, 0.9));
	}
    }
    
}
