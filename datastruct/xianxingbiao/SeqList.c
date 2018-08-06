#include<stdio.h>
#include<stdlib.h>
#include<malloc.h>
#include"SeqList.h"

typedef unsigned int TSeqListNode;

typedef struct _tag_TSeqList
{
	int capacity;
	int length;
	TSeqListNode* node;	//定义指针去动态申请数组的空间 
}TSeqList;

SeqList* list_Create(int capacity)
{
	TSeqList* ret = NULL;
	
	if(capacity >=0)
	{
		ret = (TSeqListNode*)malloc(sizeof(TSeqListNode)+sizeof(TSeqListNode)*capacity);
	}
	
	if (ret != NULL)
	{
		ret->capacity = capacity;
		ret->length = 0;
		ret->node = (TSeqList*)(ret+1);
	}
}

