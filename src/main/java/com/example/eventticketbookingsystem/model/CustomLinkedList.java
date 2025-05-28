package com.example.eventticketbookingsystem.model;

 // A simple custom LinkedList implementation for the BookingQueue
 // Uses a more basic approach without advanced Java features

public class CustomLinkedList {

    // Node class - represents each element in the list
    private class Link {
        public Object data;  // The booking object
        public Link next;    // Reference to next link

        // Constructor
        public Link(Object data) {
            this.data = data;
            this.next = null;
        }

        // Display the link (for debugging)
        public void displayLink() {
            System.out.println("Data: " + data);
        }
    }

    private Link first;  // Reference to first link
    private Link last;   // Reference to last link
    private int size;    // Number of items in the list


     // Constructor - create empty list

    public CustomLinkedList() {
        first = null;
        last = null;
        size = 0;
    }


     // Check if list is empty

    public boolean isEmpty() {
        return (first == null);
    }


     // Add item to end of list (like addLast in LinkedList)
     //because we used queue for booking  sor there is using last to insert items
    public void addLast(Object item) {

        Link newLink = new Link(item);

        if (isEmpty()) {
            first = newLink;
            last = newLink;
        } else {
            last.next = newLink;
            last = newLink;
        }

        size++;
    }


     // Add item to beginning of list (like addFirst in LinkedList)
    public void addFirst(Object item) {
        Link newLink = new Link(item);

        if (isEmpty()) {
            first = newLink;
            last = newLink;
        } else {
            newLink.next = first;
            first = newLink;
        }

        size++;
    }


     // Remove and return first item
    public Object removeFirst() {
        if (isEmpty()) {
            return null;
        }

        Object temp = first.data; //first.data= for returning just a value not a node

        if (first == last) {
            // Only one item in the list
            first = null;
            last = null;
        } else {
            first = first.next;
        }

        size--;
        return temp;
    }


     // Get first item without removing
    public Object getFirst() {
        if (isEmpty()) {
            return null;
        }

        return first.data;
    }


     // Get the number of items in the list
    public int size() {
        return size;
    }


     // Remove all items from the list
    public void clear() {
        first = null;
        last = null;
        size = 0;
    }


     // Check if an item is in the list
     public boolean contains(Object item){
        Link current = first;

        while (current != null) {
            if (current.data.equals(item)) {
                return true;
            }
            current = current.next;
        }

        return false;
    }


     // Remove a specific item from the list
    public boolean remove(Object item) {
        if (isEmpty()) {
            return false;
        }

        // If it's the first item
        if (first.data.equals(item)) {
            removeFirst();
            return true;
        }

        // Search for the item
        Link current = first;
        Link previous = null;

        while (current != null && !current.data.equals(item)) {
            previous = current;
            current = current.next;
        }

        // If item not found
        if (current == null) {
            return false;
        }

        // If it's the last item
        if (current == last) {
            last = previous; //after deleting last node last is now the previous node
        }

        // Remove the item
        previous.next = current.next; //previous node.next = null
        size--;

        return true;
    }


     // Create a copy of this list

    public CustomLinkedList copy() {
        CustomLinkedList newList = new CustomLinkedList();

        Link current = first;
        while (current != null) {
            newList.addLast(current.data);
            current = current.next;
        }

        return newList;
    }


     // Display all items in the list (for debugging)
    public void displayList() {
        Link current = first;

        while (current != null) {
            current.displayLink();
            current = current.next;
        }

        System.out.println();
    }

     // Get all items as an array (for iteration)
    public Object[] toArray() {
        Object[] array = new Object[size];
        Link current = first;
        int index = 0;

        while (current != null) {
            array[index++] = current.data;
            current = current.next;
        }

        return array;
    }

    // Get element at specific index (needed for merge sort)
    public Object get(int index) {
        if (index < 0 || index >= size) {
            throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
        }

        Link current = first;
        for (int i = 0; i < index; i++) {
            current = current.next;
        }

        return current.data;
    }

    // Set element at specific index --> needed for merge sort in algo package
    public void set(int index, Object item) {
        if (index < 0 || index >= size) {
            throw new IndexOutOfBoundsException("Index: " + index + ", Size: " + size);
        }

        Link current = first;
        for (int i = 0; i < index; i++) {
            current = current.next;
        }

        current.data = item;
    }

}