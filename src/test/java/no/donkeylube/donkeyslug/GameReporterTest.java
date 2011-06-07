package no.donkeylube.donkeyslug;

import org.junit.Before;
import org.junit.Test;

import static org.hamcrest.Matchers.*;
import static org.hamcrest.MatcherAssert.*;

public class GameReporterTest {
    private GameReporter gameReporter;
    
    @Before
    public void initializeGameReporter() {
	gameReporter = GameReporter.getInstance();
	gameReporter.clear();
    }
    
    @Test
    public void testAddMessage() {
	gameReporter.offer("Test");
	assertThat(gameReporter, hasItem("Test"));
    }
    
    @Test
    public void testThatPollingRemovesElement() {
	gameReporter.offer("Soon to be polled");
	System.out.println(gameReporter.poll());
	assertThat(gameReporter, not(hasItem("Soon to be polled")));
    }
}
