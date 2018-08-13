// SeqList.cpp : �������̨Ӧ�ó������ڵ㡣

#include <stdio.h>
#include <malloc.h>
#include "SeqList.h"


//ʹ��unsigned int ��Ϊ����ָ���ڼ�����еĴ洢��ʽһ��
typedef unsigned int TSeqListNode;

typedef struct _tag_SeqList
{
	int capacity;//�������
	int length;//��ǰ���Ա���
	TSeqListNode* node;
}TSeqList;

SeqList* Seqlist_Create(int capacity) //O(1) 
{
	TSeqList* ret = NULL;

	if (capacity >= 0)
	{
		ret = (TSeqList*)malloc(sizeof(TSeqList) + sizeof(TSeqListNode)*capacity);
	}

	if (ret != NULL)
	{
		ret->capacity = capacity;
		ret->length = 0;
		ret->node = (TSeqListNode*)(ret + 1);//ָ��ͷ�����λ��
	}
}

void SeqList_Destory(SeqList* list) //O(1)
{
	free(list);
}

void SeqList_Clear(SeqList* list) //O(1)
{
	TSeqList* sList = (TSeqList*)list;
	
	if (sList != NULL)
	{
		sList->length = 0;
	}
}

int SeqList_Length(SeqList* list) //O(1)
{
	TSeqList* sList = (TSeqList*)list;
	int ret = -1;
	
	if (sList != NULL)
	{
		ret = sList->length;
	}
	return ret;
}

int SeqList_Capacity(SeqList* list) //O(1)
{
	TSeqList* sList = (TSeqList*)list;
	int ret = -1;
	
	if (sList != NULL)
	{
		ret = sList->capacity;
	}
	return ret;
}

void SeqList_Insert(SeqList* list, SeqListNode* node, int pos) //O(1) --> O(n) 
{
	TSeqList* sList = (TSeqList*)list;
	int ret = (sList != NULL);
	int i = 0;
	
	ret = ret && (sList->length+1 <= sList->capacity);
	ret = ret && (0 <= pos);
	
	if (ret)
	{
		if( pos >= sList->length)
		{
			pos = sList->length;
		}
		
		//Ԫ�غ��ˣ�Ϊpos��λ 
		for (i=sList->length; i>pos; i--)
		{
			sList->node[i] = sList->node[i-1];
		}
		
		sList->node[i] = (TSeqListNode)node;
		
		sList->length++;
	}	
}

SeqListNode* SeqList_Get(SeqList* list, int pos) //O(1)
{
	TSeqList* sList = (TSeqList*)list;
	SeqListNode* ret = NULL;
	
	if ((sList != NULL) && (0 <= pos) && (pos <= sList->length))
	{
		ret = (SeqListNode*)sList->node[pos];
	}
	
	return ret;
}

SeqListNode* SeqList_Delete(SeqList* list, int pos) //O(1) --> O(n)
{
	TSeqList* sList = (TSeqList*)list;
	SeqListNode* ret = SeqList_Get(sList, pos);
	int i = 0;
	
	if ( ret != NULL )
	{
		for (i=pos+1; i<sList->length; i++)
		{
			sList->node[i-1] = sList->node[i];
		 } 
		 
		 sList->length--;
	} 
	return ret;
}


























