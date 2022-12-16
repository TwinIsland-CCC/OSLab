#include <defs.h>
#include <x86.h>
#include <stdio.h>
#include <string.h>
#include <swap.h>
#include <swap_fifo.h>
#include <list.h>

/* [wikipedia]The simplest Page Replacement Algorithm(PRA) is a FIFO algorithm. The first-in, first-out
 * page replacement algorithm is a low-overhead algorithm that requires little book-keeping on
 * the part of the operating system. The idea is obvious from the name - the operating system
 * keeps track of all the pages in memory in a queue, with the most recent arrival at the back,
 * and the earliest arrival in front. When a page needs to be replaced, the page at the front
 * of the queue (the oldest page) is selected. While FIFO is cheap and intuitive, it performs
 * poorly in practical application. Thus, it is rarely used in its unmodified form. This
 * algorithm experiences Belady's anomaly.
 *
 * Details of FIFO PRA
 * (1) Prepare: In order to implement FIFO PRA, we should manage all swappable pages, so we can
 *              link these pages into pra_list_head according the time order. At first you should
 *              be familiar to the struct list in list.h. struct list is a simple doubly linked list
 *              implementation. You should know howto USE: list_init, list_add(list_add_after),
 *              list_add_before, list_del, list_next, list_prev. Another tricky method is to transform
 *              a general list struct to a special struct (such as struct page). You can find some MACRO:
 *              le2page (in memlayout.h), (in future labs: le2vma (in vmm.h), le2proc (in proc.h),etc.
 */

list_entry_t pra_list_head;
list_entry_t* exclock_list_head;
/*
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     

     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
     exclock_list_head = mm->sm_priv;//exclock init
     log(mm);
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
}
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    list_entry_t *entry=&(page->pra_page_link);
 
    assert(entry != NULL && head != NULL);
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_after(head, entry);
    return 0;
}
/*
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */

static int
_exclock_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
    log(mm);
    list_entry_t *head=(list_entry_t*) exclock_list_head;
    list_entry_t *entry=&(page->pra_page_link);
 
    assert(entry != NULL && head != NULL);
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_before(head, entry);
    exclock_list_head = head->prev;
    return 0;
}

/*
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then assign the value of *ptr_page to the addr of this page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
         assert(head != NULL);
     assert(in_tick==0);
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head queue
     //(2)  assign the value of *ptr_page to the addr of this page
     list_entry_t* temp = head->prev;
     struct Page* page = le2page(temp, pra_page_link);
     list_del(temp);
     assert(page != NULL);
     *ptr_page = page;
     return 0;
}
static int
_exclock_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
        assert(head != NULL);
        assert(in_tick==0);
    /* Select the victim */
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)  unlink the  earliest arrival page in front of pra_list_head queue
    //(2)  assign the value of *ptr_page to the addr of this page


    list_entry_t* temp = exclock_list_head->prev;
    list_entry_t* clock_head = exclock_list_head;

    log(mm);    
    int i=0;
    for(;i<3;i++){
        cprintf("%d\n",i);
        bool flag=0;
        while(temp!=clock_head||flag==0){//A=0 D=0
            if(temp!=head){
                struct Page* page = le2page(temp, pra_page_link);
                pte_t *tmpte = get_pte(mm->pgdir,page->pra_vaddr,0);
                assert(tmpte!=NULL);
                if(!(*tmpte&PTE_A)&&!(*tmpte&PTE_D))
                {
                    list_del(temp);
                    exclock_list_head = temp->next;
                    *ptr_page = page;
                    return 0;
                }else{
                    cprintf("set bit: old pte: %x",*tmpte);
                    if(i==0){*tmpte &= (~PTE_A);}
                    else if(i==1){*tmpte &= (~PTE_D);}
                    cprintf("\tnew pte: %x\n",*tmpte);
                    if(i!=2)tlb_invalidate(mm->pgdir, temp);
                }
            }
            if(temp==clock_head){flag=1;temp = temp->prev;break;}
            temp = temp->prev;
        }
    }


    cprintf("\n\tpage out fail\n");
    return -1;

}

void log(struct mm_struct *mm){
    cprintf("\n\t[log]\n");
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
    cprintf("head = %x\n",head);
    cprintf("clk_head = %x\n",exclock_list_head);
    list_entry_t* le =head->prev;
    while (le!=head){
        struct Page* page = le2page(le, pra_page_link);
        pte_t *tmpte = get_pte(mm->pgdir,page->pra_vaddr,0);
        cprintf("vaddr = %x le = %x pte = %x\n",page->pra_vaddr ,le,*tmpte);
        le=le->prev;
    }
    cprintf("\n");
}

static int
_fifo_check_swap(void) {

    cprintf("write Virt Page c in fifo_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==4);
    cprintf("write Virt Page a in fifo_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==4);
    cprintf("write Virt Page d in fifo_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==4);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==4);
    cprintf("write Virt Page e in fifo_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==5);
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==5);
    cprintf("write Virt Page a in fifo_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==6);//
    cprintf("write Virt Page b in fifo_check_swap\n");
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==7);
    cprintf("write Virt Page c in fifo_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==8);
    cprintf("write Virt Page d in fifo_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==9);
    cprintf("write Virt Page e in fifo_check_swap\n");
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==10);
    cprintf("write Virt Page a in fifo_check_swap\n");
    assert(*(unsigned char *)0x1000 == 0x0a);
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==11);
    return 0;
}

static int
_exclock_check_swap(void) {
 
    cprintf("write Virt Page c in exclock_check_swap\n");
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==4);
    cprintf("write Virt Page a in exclock_check_swap\n");
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==4);
    cprintf("write Virt Page d in exclock_check_swap\n");
    *(unsigned char *)0x4000 = 0x0d;
    assert(pgfault_num==4);
                                                        //             v
    cprintf("write Virt Page b in exclock_check_swap\n");// tail a b c d head
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==4);
                                                        //   v
    cprintf("write Virt Page e in exclock_check_swap\n");// e11 b00 c00 d00
    *(unsigned char *)0x5000 = 0x0e;
    assert(pgfault_num==5);
                                                        //        v
    cprintf("write Virt Page a in exclock_check_swap\n");// e11 a11 c00 d00
    *(unsigned char *)0x1000 = 0x0a;
    assert(pgfault_num==6);
                                                         //     v
    cprintf("write Virt Page c in exclock_check_swap\n");//e11 a11 c11 d00
    *(unsigned char *)0x3000 = 0x0c;
    assert(pgfault_num==6);

                                                        //              v
    cprintf("write Virt Page b in exclock_check_swap\n");//e11 a11 c11 b11
    *(unsigned char *)0x2000 = 0x0b;
    assert(pgfault_num==7);
    //ptr check finish
    return 0;

}


static int
_fifo_init(void)
{
    return 0;
}

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
    return 0;
}

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }


struct swap_manager swap_manager_fifo =
{
     .name            = "fifo swap manager",
     .init            = &_fifo_init,
     .init_mm         = &_fifo_init_mm,
     .tick_event      = &_fifo_tick_event,
     .map_swappable   = &_fifo_map_swappable,
     .set_unswappable = &_fifo_set_unswappable,
     .swap_out_victim = &_fifo_swap_out_victim,
     .check_swap      = &_fifo_check_swap,
};
