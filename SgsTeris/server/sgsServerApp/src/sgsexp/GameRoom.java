package sgsexp;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.mina.common.ByteBuffer;

import sgsexp.tetrisprotocol.TetrisProtocol;

import com.sun.sgs.app.Channel;
import com.sun.sgs.app.ClientSession;
import com.sun.sgs.app.ClientSessionId;
import com.sun.sgs.app.ManagedObject;

public class GameRoom implements ManagedObject, Serializable {
	private static final long serialVersionUID = 1L;
	private Channel channel;
	private Map<ClientSessionId,Boolean> clientStatus;
	public GameRoom(Channel ch){
		channel = ch;
		clientStatus = new HashMap<ClientSessionId,Boolean>();
	}
	/**
	 * 进入房间. 添加到channel 并设置状态
	 * @param client
	 * @return
	 */
	public boolean enter(ClientSession client){
		if(channel.getSessions().size()<2){
			channel.join(client, null);

			clientStatus.put(client.getSessionId(), new Boolean(false));
			return true;
		}
		return false;
	}
	/**
	 * 游戏结束,重置所有状态
	 *
	 */
	public void gameOver(){
		for(Iterator i=clientStatus.keySet().iterator();i.hasNext();){
			clientStatus.put((ClientSessionId)i.next(),false);
		}
	}
	/**
	 * 某个客户端已经就绪.
	 * @param clientId
	 */
	public void clientReady(ClientSessionId clientId){
		clientStatus.put(clientId, true);

		if(channel.getSessions().size()>=2){
			boolean gameReady = true;
			System.out.println("GameRoom.clientReady, check clients status:");
			for(Iterator i=clientStatus.keySet().iterator();i.hasNext();){
				Boolean st = clientStatus.get(i.next());

				System.out.print(st); System.out.print(" | ");
				gameReady = st && gameReady;
			}
			if(gameReady){//游戏ready,发送消息给房间中的所有客户端
				System.out.println("game ready, send game ready message");
				//ByteBuffer buf = TetrisProtocol.getGameReady();
				byte[] buf = TetrisProtocol.getGameReady();
				//channel.send(buf);
				for(Iterator i=channel.getSessions().iterator();i.hasNext();){
					ClientSession client =(ClientSession)i.next();
					client.send(buf);
				}
			}
		}



	}
	/**
	 * 离开房间.清除状态.
	 * @param client
	 */
	public void leave(ClientSession client){
		System.out.println("GameRoom.leave, clear status");
		channel.leave(client);
		clientStatus.remove(client.getSessionId());
	}
}
