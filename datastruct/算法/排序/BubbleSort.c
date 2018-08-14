/***
冒泡排序的定义：
	它重复的走访要排序的数列，一次比较两个元素，如果他们顺序错误就把他们交换过来。
	走访数列的工作是重复的进行直到没有再需要交换，也就是排序完成。

算法描述：
	1.比较相邻的元素，如果顺序错误，就交换他们两个;
	2.对每一个相邻元素作同样的工作，从开始第一对到结尾的最后一对，这样在后面的元素顺序应该是正确的;
	3.针对所有的元素重复以上的步骤，除了已经执行过的外;
	4.重复1～3,直到排序完成;

***/

#include<stdio.h>


int getArrayLen(int* arr);

int* bubblesort(int* arr)
{
	int len = getArrayLen(arr);
	printf("len = %d\n",len);

	int i,j;
	int temp;

	for (i=0; i<len-1; i++)
	{
		for (j=i+1; j<len; j++)
		{
			if (arr[i] > arr[j])
			{
				temp = arr[i];
				arr[i] = arr[j];
				arr[j] = temp;
			}
		}
	}
	
	return arr;
}

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
int main()
{
	int str[] = {12,1,34,23,111,9,28,33,34,34,6};
	
	int len = sizeof(str)/4;
	int* arr = bubblesort(str);

	show(arr);
	return 0;
}
