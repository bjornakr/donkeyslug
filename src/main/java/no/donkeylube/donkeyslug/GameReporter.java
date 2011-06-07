package no.donkeylube.donkeyslug;

import java.util.concurrent.LinkedBlockingQueue;

public class GameReporter extends LinkedBlockingQueue<String> {
    private static final long serialVersionUID = 1L;
    private static GameReporter instance;
    
    private GameReporter() {	
    }
    
    public static GameReporter getInstance() {
	if (instance == null) {
	    instance = new GameReporter();
	}
	return instance;
    }
    
    public boolean offer(String message) {
	System.out.println(message);
	return super.offer(message);
    }
}
