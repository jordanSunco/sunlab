/*
 * Copyright 
 */

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Stack;


/**
 * 模拟实现斗地主发牌过程
 * 
 * @author Sun
 * @version FightLandlord.java 2011-10-14 17:00:47
 */
public class FightLandlord {
    public static void main(String[] args) {
        // 构造一副新牌
        Stack<Integer> newPoker = new Stack<Integer>();
        for (int i = 1; i <= 54; i++) {
            newPoker.add(i);
        }
        // 洗牌
        Collections.shuffle(newPoker);

        // 玩家闪亮登场
        Map<Integer, List<Integer>> players = new HashMap<Integer, List<Integer>>();
        List<Integer> jobs = new ArrayList<Integer>();
        List<Integer> gates = new ArrayList<Integer>();
        List<Integer> page = new ArrayList<Integer>();
        players.put(0, jobs);
        players.put(1, gates);
        players.put(2, page);

        // 猥琐的地主
        int whoIsTheLord = (int) (Math.random() * 3);
        // 发牌, 每轮发3张
        for (int i = 0, length = newPoker.size() - 3; i < length; i+=3) {
            // 地主先抓牌
            for (int j = whoIsTheLord, count = 0; count < 3; count++) {
                players.get(j).add(newPoker.pop());

                // 谁下一个抓牌(保持抓牌顺序始终从地主开始)
                // 例如2是地主, 那么以后的抓牌顺序都是2, 0, 1
                j++;
                if (j > 2) {
                    // 确保抓了一圈牌
                    j = 0;
                }
            }
        }
        // 底牌给地主
        players.get(whoIsTheLord).add(newPoker.pop());
        players.get(whoIsTheLord).add(newPoker.pop());
        players.get(whoIsTheLord).add(newPoker.pop());

        // 测试
        System.out.println("哪个是地主?\n" + whoIsTheLord + "\n");
        for (Integer p : jobs) {
            System.out.println(p);
        }
        System.out.println("=> 0, jobs: " + jobs.size() + "\n");

        for (Integer p : gates) {
            System.out.println(p);
        }
        System.out.println("=> 1, gates: " + gates.size() + "\n");

        for (Integer p : page) {
            System.out.println(p);
        }
        System.out.println("=> 2, page: " + page.size());
    }
}
