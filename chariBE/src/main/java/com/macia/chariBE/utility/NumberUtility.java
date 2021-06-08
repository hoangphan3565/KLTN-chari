package com.macia.chariBE.utility;

import java.util.Random;

public class NumberUtility {
    public static int getRandomNumberInts(int min, int max){
        Random random = new Random();
        return random.ints(min,(max+1)).findFirst().getAsInt();
    }
}
