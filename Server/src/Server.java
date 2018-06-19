import java.io.*;
import java.net.*;
import java.util.ArrayList;
import java.util.Arrays;

public class Server {
	public static ArrayList<Player> players = new ArrayList<Player>();
	public static void main(String[] args) throws IOException{
    String received;
    ServerSocket socket = new ServerSocket(6489);

    while (true) {
     Socket connectionSocket = socket.accept();
     BufferedReader inFromClient =
      new BufferedReader(new InputStreamReader(connectionSocket.getInputStream()));
     DataOutputStream outToClient = new DataOutputStream(connectionSocket.getOutputStream());
     received = inFromClient.readLine();
     System.out.println(received);
     players.add(new Player(received, connectionSocket.getInetAddress().toString()) );
     String toWrite = "";
     for(int i = 0; i < players.size(); i++) {
    	 toWrite += "@"+players.get(i).id+"["+Arrays.toString(players.get(i).pos)+"]";
     }
     System.out.println(toWrite);
     outToClient.writeBytes(toWrite);
     socket.close();
	}
	}
}
