package sgsexp;

import java.io.Serializable;

import org.apache.mina.common.ByteBuffer;

import sgsexp.tetrisprotocol.TetrisProtocol;

import com.sun.sgs.app.AppContext;
import com.sun.sgs.app.Channel;
import com.sun.sgs.app.ChannelListener;
import com.sun.sgs.app.ClientSession;
import com.sun.sgs.app.DataManager;

public class RoomChannelListener implements ChannelListener, Serializable {
	private static final long serialVersionUID = 1L;
	//private ManagedReference room;
	public RoomChannelListener(){

	}
	public void receivedMessage(Channel arg0, ClientSession arg1, byte[] arg2) {
		System.out.println("channel message..");
		if(TetrisProtocol.GAME_OVER == arg2[0]){//如果是游戏结束,则通知房间游戏结束
			System.out.println("game over message received..");
			DataManager dm = AppContext.getDataManager();
			GameRoom room = dm.getBinding(SgsApp.ROOM1_NAME, GameRoom.class);
			room.gameOver();
		}
		if(TetrisProtocol.REMOVE_LINES == arg2[0]){
			ByteBuffer bf  = ByteBuffer.wrap(arg2, 0, arg2.length);
			bf.position(1);
			int lines = bf.getInt();
			System.out.println("---remove lines channel message:"+lines);

		}

	}

}
