
public class Player {
	float[] pos = new float[3];
	String id;
	Player(String p, String id){
		pos[0] = Float.valueOf(p.substring(0, p.indexOf(":")));
		pos[1] = Float.valueOf(p.substring(p.indexOf(":")+1, p.indexOf("-")));
		pos[2] = Float.valueOf(p.substring(p.indexOf("-")+1));
		this.id = id;
	}
}
