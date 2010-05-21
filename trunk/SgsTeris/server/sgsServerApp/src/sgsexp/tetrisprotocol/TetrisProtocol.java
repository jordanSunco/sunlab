package sgsexp.tetrisprotocol;

import org.apache.mina.common.ByteBuffer;

public class TetrisProtocol {
	public static byte GAME_READY = 1;
	public static byte REMOVE_LINES = 2;
	public  static byte GAME_OVER = 3;
	public static byte CLIENT_READY = 4;
	public static byte[] getGameReady(){
		//ByteBuffer b = ByteBuffer.allocate(1);
		//b.put(GAME_READY);
		//b.flip();
		byte[] re = new byte[1];
		re[0] = GAME_READY ;
		return re;
	}

}
