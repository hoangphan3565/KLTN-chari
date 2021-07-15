package com.macia.chariBE.utility;

import java.util.List;
import java.util.Random;
import java.util.function.Function;
import java.util.stream.Collectors;

public class NumberUtility {

    public static <T, U> List<U> convertStringListToIntList(List<T> listOfString, Function<T, U> function) {
        return listOfString.stream().map(function).collect(Collectors.toList());
    }
}
