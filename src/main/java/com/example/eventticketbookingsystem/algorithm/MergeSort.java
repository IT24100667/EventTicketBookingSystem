package com.example.eventticketbookingsystem.algorithm;

import com.example.eventticketbookingsystem.model.Event;
import com.example.eventticketbookingsystem.model.CustomLinkedList;


public class MergeSort {

    // Sort CustomLinkedList by date using merge sort algorithm
    public static CustomLinkedList sortByDate(CustomLinkedList events){
        // create a copy to avoid making changes to our original list
        CustomLinkedList sortedList = events.copy();

        // if only 1 element or less there is no need to sort
        if (sortedList.size() <= 1) {
            return sortedList;  // Already sorted
        }

        // call merge sort for date - begin the recursive divide and sort
        mergeSortByDate(sortedList, 0, sortedList.size()-1);

        return sortedList;
    }

    // Merge method for CustomLinkedList - combines two sorted halves
    private static void mergeByDate(CustomLinkedList events, int start, int middle, int end){
        // Calculate sizes of left and right subarrays
        int sizeLeft = middle - start + 1;
        int sizeRight = end - middle;

        // Create temporary CustomLinkedLists for left and right halves
        CustomLinkedList leftArray = new CustomLinkedList();
        CustomLinkedList rightArray = new CustomLinkedList();

        // Copy data to temporary left array
        for (int i = 0; i < sizeLeft; i++) {
            leftArray.addLast(events.get(start + i));
        }

        // Copy data to temporary right array
        for (int j = 0; j < sizeRight; j++) {
            rightArray.addLast(events.get(middle + 1 + j));
        }

        // Merge the temporary arrays back into events[start..end]
        int i = 0;  // Initial index of left subarray
        int j = 0;  // Initial index of right subarray
        int k = start;  // Initial index of merged subarray

        // Compare elements from left and right arrays and merge in sorted order
        while (i < sizeLeft && j < sizeRight) {
            Event leftEvent = (Event) leftArray.get(i);
            Event rightEvent = (Event) rightArray.get(j);

            // Compare event dates - put earlier date first (ascending order)
            if (leftEvent.getDate().compareTo(rightEvent.getDate()) <= 0) {
                events.set(k, leftEvent);
                i++;
            } else {
                events.set(k, rightEvent);
                j++;
            }
            k++;
        }

        // Copy remaining elements from leftArray, if any
        while (i < sizeLeft) {
            events.set(k, leftArray.get(i));
            i++;
            k++;
        }

        // Copy remaining elements from rightArray, if any
        while (j < sizeRight) {
            events.set(k, rightArray.get(j));
            j++;
            k++;
        }
    }

    // Recursive merge sort method for CustomLinkedList
    private static void mergeSortByDate(CustomLinkedList events, int start, int end){
        // Base case: if start >= end, the subarray has 0 or 1 element and is already sorted
        if (start < end) {
            // Find the middle point to divide the array into two halves
            int middle = (start + end) / 2;

            // Recursively sort the first half
            mergeSortByDate(events, start, middle);

            // Recursively sort the second half
            mergeSortByDate(events, middle + 1, end);

            // Merge the sorted halves
            mergeByDate(events, start, middle, end);
        }
    }
}