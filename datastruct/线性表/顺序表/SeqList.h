#pragma once

#ifndef _SEQLIST_H_
#define _SEQLIST_H_

//使用void类型对方法进行封装 
typedef void SeqList;
typedef void SeqListNode;

SeqList* Seqlist_Create(int capacity);

void SeqList_Destory(SeqList* list);

void SeqList_Clear(SeqList* list);

int SeqList_Length(SeqList* list);

int SeqList_Capacity(SeqList* list);

void SeqList_Insert(SeqList* list, SeqListNode* node, int pos);

SeqListNode* SeqList_Get(SeqList* list, int pos);

SeqListNode* SeqList_Delete(SeqList* list, int pos);

#endif
