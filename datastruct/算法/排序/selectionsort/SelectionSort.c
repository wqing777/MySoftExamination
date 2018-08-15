/****
选择排序的概念：
	选择排序是一种简单直观的排序算法，它的工作原理是：首先在未排序的序列中找到最大或最小的元素，存放到排序序列的起始位置，然后，再从剩余排序元素中继续寻找最大或最小的元素，然后放到已排序序列的末尾。一次类推，直到所有元素均排序完毕

算法描述：
	1.初始状态：无序区为R[1....n],有序区为空;
	2.第i趟排序(i = 1,2,3,....,n-1)开始时，当前有序区和无序区分别是R[1...i-1]和R[i...n]。
	  该趟排序从无序区中选出关键字最小的记录R[k],将它与无序区的第一个记录R交换，使R[1..i]	   和R[i+1...n]分别变为记录个数增加1个的新有序区和记录个数减少一个的新无序区;
	3.n-1趟结束，数组有序化了。
****/

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


void show(int* arr)
{
	int len = getArrayLen(arr);

	int i;

	for (i=0; i<len; i++)
	{
		printf("arr[%d] = %d\n",i,arr[i]);
	}
	
}

int* selectionSort(int* arr)
{
	int len = getArrayLen(arr);
	int minIndex,temp;

	int i,j;
	
	for (i=0; i<len-1; i++)
	{
		minIndex = i;
		for (j=i+1; j<len; j++)
		{
			if (arr[j] > arr[minIndex])
			{
				minIndex = j;
			}
		}
		
		temp = arr[i];
		arr[i] = arr[minIndex];
		arr[minIndex] = temp;
	}	
	return arr;
}

int main()
{
	int str[] = {12,1,34,23,111,9,28,33,34,34,6};
	
	int* arr = selectionSort(str);

	show(arr);
	return 0;
}
