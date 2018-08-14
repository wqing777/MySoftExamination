/****
插入排序：
	插入排序是一种简单直观的排序算法，它的工作原理是通过构建有序序列，对于未排序数据,在已排序序列中从后面向前面扫描，找到相对应的位置并插入。

算法描述：
	一般来说，插入排序都采用in-place在数组上实现的，
	1.从第一个元素开始，该元素可以认为已经被排序;
	2.取出下一个元素，在已经排好的元素序列中从后向前扫描;
	3.如果该元素（已排序）大于新元素，将该元素移动到下一个位置;
	4.重复步骤3,直到找到已经排序的元素小于或者等于新元素的位置;
	5.将新元素插入到该位置后;
	6.重复步骤2～5.
***/

#include <stdio.h>

int getArrayLen(int* arr)
{
	int i = 0;
	while(arr[i] != '\0')
	{
		i++;
	}
	return i;
}

int* insertionSort(int* arr)
{
	int len = getArrayLen(arr);
	int perIndex, current;
	int i;
	for (i=1; i<len; i++)
	{
		perIndex = i-1;
		current = arr[i];

		while(perIndex>=0 && arr[perIndex]>current)
		{
			arr[perIndex+1] = arr[perIndex];
			perIndex--;
		}
		arr[perIndex+1] = current;
	}
	return arr;
}

void show(int* arr)
{
	int len = getArrayLen(arr);

	int i;

	for (i=0; i<len; i++)
	{
		printf("arr[%d] = %d\n",i,arr[i]);
	}
	
}
int main()
{
	int str[] = {12,1,34,23,111,9,28,33,34,34,6};
	
	int len = sizeof(str)/4;
	int* arr = insertionSort(str);

	show(arr);
	return 0;
}
