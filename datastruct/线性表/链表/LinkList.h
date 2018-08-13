#ifndef _LINKLIST_H_
#define _LINKLIST_H_

//使用void类型对方法进行封装 
typedef void LinkList;
typedef struct _tag_LinkListNode LinkListNode;

struct _tag_LinkListNode
{
	LinkListNode* next;
};

LinkList* LinkList_Create();

void LinkList_Destory(LinkList* list);

void LinkList_Clear(LinkList* list);

int LinkList_Length(LinkList* list);

int LinkList_Insert(LinkList* list, LinkListNode* node, int pos);

LinkListNode* LinkList_Get(LinkList* list, int pos);

LinkListNode* LinkList_Delete(LinkList* list, int pos);

#endif
