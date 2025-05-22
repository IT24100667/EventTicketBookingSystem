package com.example.eventticketbookingsystem.algorithm;

import com.example.eventticketbookingsystem.model.Event;

import java.util.ArrayList;
import java.util.List;

public class MergeSort {


    private static void mergeByDate(List<Event> events, int start, int middle, int end){
        // first calculate for n1 and n2
        // n1 = q - p + 1
        // n2 = r - q
        // basically these are sizes of first and second halves of the list so lets use new variable names

        int sizeLeft = middle - start + 1;
        int sizeRight = end - middle;

        // create the left and right arrays
        List<Event> leftArray = new ArrayList<>(sizeLeft);
        List<Event> rightArray = new ArrayList<>(sizeRight);


        for (int i = 0; i < sizeLeft; i++) {
            leftArray.add(events.get(start + i));
        }
        for (int j = 0; j < sizeRight; j++) {
            rightArray.add(events.get(middle + 1 + j));
        }

//        Merge the arrays

        int i = 0;  // index for left
        int j = 0;  // index for right
        int k = start;  // index for merged final array

        while (i < sizeLeft && j < sizeRight) {
            // Compare event dates - put earlier date first (ascending order)
//            leftArray.get(i).getDate() <= rightArray.get(j).getDate() this does not work so used compare()
            if (leftArray.get(i).getDate().compareTo(rightArray.get(j).getDate()) <= 0) {
                events.set(k, leftArray.get(i));
                i++;
            } else {
                events.set(k, rightArray.get(j));
                j++;
            }
            k++;

        }

        // for remaining elements...add to left and right

//       Copy remaining elements from leftArray
        while (i < sizeLeft) {
            events.set(k, leftArray.get(i));
            i++;
            k++;
        }

        // Copy remaining elements from rightArray
        while (j < sizeRight) {
            events.set(k, rightArray.get(j));
            j++;
            k++;
        }
    }


}
