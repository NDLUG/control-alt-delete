// C# Code for Minimum number of moves to reach end
using System;

class Solution {

  // Part A
  static int minDrinks(int[] arr){
    int n = arr.Length;
    int[] moves = new int[n];

    // Populate array
    for(int i = 0; i < n; i++){
      moves[i] = int.MaxValue;
    }

    // First drink counts
    moves[0] = 1;

    // DP
    for(int i = 0; i < n; i++) {
      for(int j = 1; j <= arr[i]; j++) {
        if(i + j >= n) continue;
        moves[i + j] = Math.Min(moves[i + j], moves[i] + 1);
      }
    }

    return moves[n - 1];
  }

  // Part B
  static int minDrinksRearrange(int[] arr){
    // First drink counts
    int drinks = 1;
    int arrLen = arr.Length;

    foreach(int i in arr){
      arrLen = arrLen - i;
      drinks++;
      if(arrLen <= 0) return drinks;
    }

    return -1;
  }

  public static void Main(){

    // Read input
    string[] input = Console.ReadLine().Split(' ');
    int[] arr = Array.ConvertAll(input, int.Parse);

    // Part A
    Console.WriteLine("Part A: " + minDrinks(arr));

    // Part B: Sort in descending order
    Array.Sort(arr, delegate(int m, int n) { return n - m; });
    Console.WriteLine("Part B: " + minDrinksRearrange(arr));
  }
}
