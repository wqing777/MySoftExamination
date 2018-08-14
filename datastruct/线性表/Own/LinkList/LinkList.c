#include <stdio.h>
#include <malloc.h>


typedef struct _tag_LinkListNode
{
	struct _tag_LinkListNode* next;
	int value;
}LinkListNode;

typedef struct _tag_LinkList
{
	LinkListNode* header;
	int length;
}LinkList;


LinkList* LinkList_Create()
{
	LinkList* list = (LinkList*)malloc(sizeof(LinkList));

	if (NULL != list)
	{
		return list;
	}
	
	return NULL;
}

int LinkList_Length(LinkList* list)
{
	int ret=-1;
	
	if (NULL != list)
	{
		ret = list->length;
	}
	
	return ret;
}

LinkListNode* LinkList_Get(LinkList* list, int pos)
{
	int i = 0;
	LinkListNode* current = (LinkListNode*)list;

	if ( (NULL != list) && (0 <= pos) && ( pos <= LinkList_Length(list)) )
	{
		for (i=0; i<pos; i++)
		{
			current = current->next;
		}

		return current;
	}

	return NULL;
}
int LinkList_Insert(LinkList* list, LinkListNode* node, int pos)
{
	int ret = -1;
	int i = 0;

	LinkListNode* current = (LinkListNode*)list;	
	if ( (NULL != list) && (NULL != node) && (0 <= pos) && ( pos <= LinkList_Length(list)) )
	{
		for (i=0; i < pos; i++)
		{
			current = current->next;
		}
		
		node->next = current->next;
		current->next = node;	
		
		list->length++;
		
		ret = 0;
	}
	
	return ret;
}

int main()
{
	int ret = -1;

	LinkList* list = LinkList_Create();
	LinkListNode* node1 = (LinkListNode*)malloc(sizeof(LinkListNode));	
	LinkListNode* node2 = (LinkListNode*)malloc(sizeof(LinkListNode));	
	
	node1->value = 4;
	node2->value = 5;
	ret = LinkList_Insert(list, node1, 0);
	ret = LinkList_Insert(list, node2, 0);

	ret = LinkList_Length(list);
	
	LinkListNode* node3 = LinkList_Get(list, 2);
	
	printf("node3 -> value = %d\n", node3->value);	
	
	return 0;
}
