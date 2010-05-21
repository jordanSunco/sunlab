package sgsexp;

import java.io.Serializable;
import java.util.Properties;

import com.sun.sgs.app.AppContext;
import com.sun.sgs.app.AppListener;
import com.sun.sgs.app.Channel;
import com.sun.sgs.app.ChannelListener;
import com.sun.sgs.app.ChannelManager;
import com.sun.sgs.app.ClientSession;
import com.sun.sgs.app.ClientSessionListener;
import com.sun.sgs.app.DataManager;
import com.sun.sgs.app.Delivery;
import com.sun.sgs.app.NameNotBoundException;

public class SgsApp implements AppListener, Serializable {
	private static final long serialVersionUID = 1L;
	public static final String ROOM1_NAME = "ROOM1";
	public static final String CHANNEL_NAME = "CHANNEL1";
	//private  Channel channel = null;
	//private ManagedReference room;
	public void initialize(Properties arg0) {
		System.out.println("sgsApp initialize..");
		ChannelManager cm = AppContext.getChannelManager();
		DataManager dm = AppContext.getDataManager();

		ChannelListener cl = new RoomChannelListener();
		Channel channel = cm.createChannel(CHANNEL_NAME, cl, Delivery.RELIABLE);

		GameRoom rm = new GameRoom(channel);
		dm.setBinding(ROOM1_NAME, rm);
		//room = dm.getBinding(ROOM1_NAME,GameRoom.class);
		//dm.

	}

	public ClientSessionListener loggedIn(ClientSession arg0) {
		String username = arg0.getName();


		DataManager dm = AppContext.getDataManager();
		GameRoom rm = dm.getBinding(ROOM1_NAME, GameRoom.class);
		if(!rm.enter(arg0)){//不能进入房间,说明已经人满
			System.out.println("room is full");
			return null;
		}


		ClientSessionListener userSl ;

		try{
			userSl = dm.getBinding(username, SgsAppClientSessionListener.class);
		}catch(NameNotBoundException ex){
			userSl = new SgsAppClientSessionListener(arg0);
		}
		if(userSl==null){
			userSl = new SgsAppClientSessionListener(arg0);
		}

		System.out.println("user "+arg0.getName()+" is logging in..");
		return userSl;
	}

}
