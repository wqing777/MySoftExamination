#include <stdio.h>
#include <malloc.h>
#include "LinkList.h"

typedef struct Value
{
	LinkListNode header;
	int v;
}value;

int main(int argc, char** argv) 
{
	int i = 0;
	LinkList* list = LinkList_Create();
	
	value v1,v2,v3,v4,v5;
	
	v1.v = 1;
	v2.v = 2;
	v3.v = 3;
	v4.v = 4;
	v5.v = 5;
	
	LinkList_Insert(list, (LinkListNode*)&v1, LinkList_Length(list));
	LinkList_Insert(list, (LinkListNode*)&v2, LinkList_Length(list));
	LinkList_Insert(list, (LinkListNode*)&v3, LinkList_Length(list));
	LinkList_Insert(list, (LinkListNode*)&v4, LinkList_Length(list));
	LinkList_Insert(list, (LinkListNode*)&v5, LinkList_Length(list));
	
	for (i=0; i<LinkList_Length(list); i++)
	{
		value* pv = (value*)LinkList_Get(list, i);
		
		printf("pv->v = %d\n",pv->v);
	 } 
	 
	 while (LinkList_Length(list) > 0)
	 {
	 	value* pv = (value*)LinkList_Delete(list, 0); 
	 	
	 	printf("pv->v = %d\n",pv->v);
	 }
	 
	 LinkList_Destory(list);
	 
	return 0;
}
