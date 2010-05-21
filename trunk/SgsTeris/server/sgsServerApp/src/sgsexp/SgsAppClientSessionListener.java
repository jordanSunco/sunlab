package sgsexp;

import java.io.Serializable;

import org.apache.mina.common.ByteBuffer;

import sgsexp.tetrisprotocol.TetrisProtocol;

import com.sun.sgs.app.AppContext;
import com.sun.sgs.app.ClientSession;
import com.sun.sgs.app.ClientSessionListener;
import com.sun.sgs.app.DataManager;

public class SgsAppClientSessionListener implements ClientSessionListener,
		Serializable {
	private static final long serialVersionUID = 1L;

	private final ClientSession session;
	public SgsAppClientSessionListener(ClientSession ses){
		session = ses;
	}
	public void disconnected(boolean arg0) {
		System.out.println("user "+session.getName()+" loggout..");
		DataManager dm = AppContext.getDataManager();
		GameRoom room = dm.getBinding(SgsApp.ROOM1_NAME, GameRoom.class);
		room.leave(session);

	}

	public void receivedMessage(byte[] arg0) {
//		session.send(arg0);
//		print(arg0);
		//session.
		if(TetrisProtocol.CLIENT_READY==arg0[0]){//如果是client报告ready,则通知room
			System.out.println("client say ready..,client id:"+session.getSessionId());
			DataManager dm = AppContext.getDataManager();
			GameRoom room = dm.getBinding(SgsApp.ROOM1_NAME, GameRoom.class);
			room.clientReady(session.getSessionId());
		}
	}
	private void print(byte[] arg0) {
		long data = ByteBuffer.wrap(arg0).getInt();
		System.out.println("data received from client is:"+data);

	}


}
