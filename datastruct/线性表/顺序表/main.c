#include <stdio.h>
#include <stdlib.h>
#include "SeqList.h" 

/* run this program using the console pauser or add your own getch, system("pause") or input loop */

int main(int argc, char *argv[]) {
	
	SeqList* list = Seqlist_Create(5);
	
	int a=0, b=1,c=2,d=3,e=4,f=5;
	int index = 0;
	
	SeqList_Insert(list,&a,0);
	SeqList_Insert(list,&b,0);
	SeqList_Insert(list,&c,0);
	SeqList_Insert(list,&d,0);
	SeqList_Insert(list,&e,0);
	SeqList_Insert(list,&f,0);
	
	for (index=0; index<SeqList_Length(list); index++)
	{
		int* p = (int*)SeqList_Get(list,index);
		printf("%d\n",*p);
	}
	printf("------------------\n");
	while(SeqList_Length(list) > 0)
	{
		int* p = (int*)SeqList_Delete(list,0);
		printf("%d\n",*p);
	}
	SeqList_Destory(list);
	
	return 0;
}
