#include <pmm.h>
#include <list.h>
#include <string.h>
#include <stdio.h>
#include <default_pmm.h>

/*  In the First Fit algorithm, the allocator keeps a list of free blocks
 * (known as the free list). Once receiving a allocation request for memory,
 * it scans along the list for the first block that is large enough to satisfy
 * the request. If the chosen block is significantly larger than requested, it
 * is usually splitted, and the remainder will be added into the list as
 * another free block.
 *  Please refer to Page 196~198, Section 8.2 of Yan Wei Min's Chinese book
 * "Data Structure -- C programming language".
*/
// LAB2 EXERCISE 1: YOUR CODE
// you should rewrite functions: `default_init`, `default_init_memmap`,
// `default_alloc_pages`, `default_free_pages`.
/*
 * Details of FFMA
 * (1) Preparation:
 *  In order to implement the First-Fit Memory Allocation (FFMA), we should
 * manage the free memory blocks using a list. The struct `free_area_t` is used
 * for the management of free memory blocks.
 *  First, you should get familiar with the struct `list` in list.h. Struct
 * `list` is a simple doubly linked list implementation. You should know how to
 * USE `list_init`, `list_add`(`list_add_after`), `list_add_before`, `list_del`,
 * `list_next`, `list_prev`.
 *  There's a tricky method that is to transform a general `list` struct to a
 * special struct (such as struct `page`), using the following MACROs: `le2page`
 * (in memlayout.h), (and in future labs: `le2vma` (in vmm.h), `le2proc` (in
 * proc.h), etc).
 * (2) `default_init`:
 *  You can reuse the demo `default_init` function to initialize the `free_list`
 * and set `nr_free` to 0. `free_list` is used to record the free memory blocks.
 * `nr_free` is the total number of the free memory blocks.
 * (3) `default_init_memmap`:
 *  CALL GRAPH: `kern_init` --> `pmm_init` --> `page_init` --> `init_memmap` -->
 * `pmm_manager` --> `init_memmap`.
 *  This function is used to initialize a free block (with parameter `addr_base`,
 * `page_number`). In order to initialize a free block, firstly, you should
 * initialize each page (defined in memlayout.h) in this free block. This
 * procedure includes:
 *  - Setting the bit `PG_property` of `p->flags`, which means this page is
 * valid. P.S. In function `pmm_init` (in pmm.c), the bit `PG_reserved` of
 * `p->flags` is already set.
 *  - If this page is free and is not the first page of a free block,
 * `p->property` should be set to 0.
 *  - If this page is free and is the first page of a free block, `p->property`
 * should be set to be the total number of pages in the block.
 *  - `p->ref` should be 0, because now `p` is free and has no reference.
 *  After that, We can use `p->page_link` to link this page into `free_list`.
 * (e.g.: `list_add_before(&free_list, &(p->page_link));` )
 *  Finally, we should update the sum of the free memory blocks: `nr_free += n`.
 * (4) `default_alloc_pages`:
 *  Search for the first free block (block size >= n) in the free list and reszie
 * the block found, returning the address of this block as the address required by
 * `malloc`.
 *  (4.1)
 *      So you should search the free list like this:
 *          list_entry_t le = &free_list;
 *          while((le=list_next(le)) != &free_list) {
 *          ...
 *      (4.1.1)
 *          In the while loop, get the struct `page` and check if `p->property`
 *      (recording the num of free pages in this block) >= n.
 *              struct Page *p = le2page(le, page_link);
 *              if(p->property >= n){ ...
 *      (4.1.2)
 *          If we find this `p`, it means we've found a free block with its size
 *      >= n, whose first `n` pages can be malloced. Some flag bits of this page
 *      should be set as the following: `PG_reserved = 1`, `PG_property = 0`.
 *      Then, unlink the pages from `free_list`.
 *          (4.1.2.1)
 *              If `p->property > n`, we should re-calculate number of the rest
 *          pages of this free block. (e.g.: `le2page(le,page_link))->property
 *          = p->property - n;`)
 *          (4.1.3)
 *              Re-caluclate `nr_free` (number of the the rest of all free block).
 *          (4.1.4)
 *              return `p`.
 *      (4.2)
 *          If we can not find a free block with its size >=n, then return NULL.
 * (5) `default_free_pages`:
 *  re-link the pages into the free list, and may merge small free blocks into
 * the big ones.
 *  (5.1)
 *      According to the base address of the withdrawed blocks, search the free
 *  list for its correct position (with address from low to high), and insert
 *  the pages. (May use `list_next`, `le2page`, `list_add_before`)
 *  (5.2)
 *      Reset the fields of the pages, such as `p->ref` and `p->flags` (PageProperty)
 *  (5.3)
 *      Try to merge blocks at lower or higher addresses. Notice: This should
 *  change some pages' `p->property` correctly.
 */
//free_area_t free_area;
free_buddy_t free_buddy;

//#define free_list (free_area.free_list)  // list itself
//#define nr_free (free_area.nr_free)  // remaining capacity

#define free_array (free_buddy.free_array)  // buddy array
#define buddy_tag (free_buddy.buddy_tag)  // buddy tag
#define buddy_flag (free_buddy.buddy_flag)  // buddy tag
#define max_order (free_buddy.max_order)  // buddy array
#define nrfree_buddy (free_buddy.nr_free_buddy)  // remaining capacity
#define buddy_start (free_buddy.start)  // remaining capacity

#define IS_POWER_OF_2(x) (!((x)&((x)-1)))

//--------------------------------Buddy System----------------------------------
typedef unsigned int u32;

static int buddy_size = 0;

/* n2pow2: convert n to the nearest integet power of 2, round down
*/
static u32 n2pow2rd(u32 n){
    u32 ret = 1;
    for (ret; ret <= n; ret <<= 1);
    return ret >> 1;
}
/* n2pow2: convert n to the nearest integet power of 2, round up
*/
static u32 n2pow2ru(u32 n){
    u32 ret = 1;
    for (ret; ret < n; ret <<= 1);
    return ret;
}

static u32 log2(u32 n) {
    u32 order = 0;
    while (n >>= 1) order ++;
    return order;
}

static int page2index(struct Page* n) {
    cprintf("[buddy] page2index, page = %p\n", n);
    int k = 0;  // k is the real index
    for(k; k < buddy_size; k = lchild(k)){
        //cprintf("[buddy] alloc memmap k computing, k = %d, buddy_tag[k] = %d\n", k, buddy_tag[k]);
        //cprintf("[buddy] page2index, n->property = %u, buddy_tag[k] = %d\n", n->property, buddy_tag[k]);
        if (n->property == buddy_tag[k]) break;  // find level first
    }
    return k + (n - buddy_start) / n->property;
}

static void
buddy_init(void) {
    cprintf("[buddy] init\n");
    free_array == NULL;
    buddy_tag == NULL;  // temp
    buddy_flag == NULL;  // temp
    nrfree_buddy = 0;
}


static void
buddy_init_memmap(struct Page *base, size_t n) {
    cprintf("[buddy] init memmap\n");
    assert(n > 0);  // make sure n > 0

    struct Page *p = base;  // create a backup of base pointer
    for (; p != base + n; p ++) {  // allocate new physical page
        assert(PageReserved(p));  // make sure this page is not a reserved page
        p->flags = p->property = 0;  // clear the flags
        set_page_ref(p, 0);  // clear the number of this page's reference
    }
    base->property = n;  // set the property
    nrfree_buddy += n;  // calculate the total nr_free

    int upper_n = n2pow2ru(n);
    buddy_size = 2 * upper_n - 1;  // ?
    buddy_start = base;  // set start bit, it will be used after
    cprintf("[buddy] initing memmap, max buddy_size = %d, buddy_size = %d, n = %u \n", MAX_BUDDY_SIZE, buddy_size, (u32)n);
    assert(buddy_size < MAX_BUDDY_SIZE);


    // free_array = (struct Page*)malloc((buddy_size + 1) * sizeof(struct Page*));
    // buddy_tag  = (int)malloc((buddy_size + 1) * sizeof(int));
    // buddy_flag = (int)malloc((buddy_size + 1) * sizeof(int));

    max_order = log2(n);
    struct Page * start = base;
    struct Page * end = base + n;
    int i = 0, prev_i = 0;

    int j = 0;
    
    u32 temp;
    for (j; j < buddy_size; j++) {  // tag init
        temp = n2pow2rd(j + 1);
        if(j + 1 == temp){
            cprintf("[buddy] initing memmap, j = %d, temp = %d, tag = %d \n", \
        j, temp, upper_n / temp);
            buddy_tag[j] = upper_n / temp;
        }
    }

    if(IS_POWER_OF_2(n)){  // only have one big block
        free_array[0] = start;
        buddy_flag[0] = 1;
        start->property = n;
        SetPageProperty(start);
        cprintf("[buddy] initing memmap FINISH n = %u \n",(u32)n);
        return;
    }

    
    while(start != end)  // many blocks
    {
        u32 curr_n = n2pow2rd(n);
        // 设置free pages的数量
        start->property = curr_n;
        // 设置当前页为可用
        SetPageProperty(start);

        int k = 0;  // k is the real index
        for(k; k < buddy_size; k = lchild(k)){
            //cprintf("[buddy] alloc memmap k computing, k = %d, buddy_tag[k] = %d\n", k, buddy_tag[k]);
            if (curr_n == buddy_tag[k]) break;  // find level first
        }
        int index = k + (start - buddy_start) / curr_n;
        cprintf("[buddy] initing memmap, start =%p, end = %p, index = %d, buddy_size = %d, n = %u \n", start, end, index, buddy_size, (u32)n);
        free_array[index] = start;
        buddy_flag[index] = 1;

        start += curr_n;
        n -= curr_n;
    }
    cprintf("[buddy] init memmap over\n");
}

static struct Page *
buddy_split_pages(struct Page *p0, size_t n, int index) {  // split p0 to n size block, return leftside block
    //cprintf("[buddy] split memmap start, page = %p, property = %u\n", p0, p0->property);
    assert(IS_POWER_OF_2(n));
    int s = p0->property;
    assert(IS_POWER_OF_2(s));
    //cprintf("[buddy] split memmap start, s = %d, n = %u\n", s, (u32)n);
    assert(s >= n);
    while(s != n){
        s /= 2;
        struct Page *p = p0 + s;
        SetPageProperty(p0);
        SetPageProperty(p );
        p0->property = s;
        p ->property = s;
        free_array[index] = NULL, buddy_flag[index] = 0;
        assert(free_array[lchild(index)] == NULL);
        free_array[lchild(index)] = p0, buddy_flag[lchild(index)] = 1;
        assert(free_array[rchild(index)] == NULL);
        free_array[rchild(index)] = p , buddy_flag[rchild(index)] = 1;
        index = lchild(index);
    }
    free_array[index] = NULL;
    buddy_flag[index] = 0;
    //cprintf("[buddy] split memmap COMPLETE, page = %p, property = %u\n", p0, p0->property);
    //cprintf("[buddy] split memmap COMPLETE, page's sib = %p, property = %u\n", free_array[index + 1], free_array[index + 1]->property);
    cprintf("[buddy] split over and alloc memmap COMPLETE, index = %d, page = %p, property = %u\n", index, p0, p0->property);
    return p0;
}

static struct Page *
buddy_alloc_pages(size_t n) {
    cprintf("[buddy] alloc memmap, size = %u\n", (u32)n);
    assert(n > 0);
    // 向上取2的幂次方，如果当前数为2的幂次方则不变
    int upper_n = n2pow2ru(n);
    int order = max_order - log2(upper_n);
    int layer_bound = 1 << order;
    // 如果待分配的空闲页面数量小于所需的内存数量
    if (n > nrfree_buddy) {
        return NULL;
    }

    // 查找符合要求的连续页
    struct Page *page = NULL;

    int k = 0;  // k is the real index
    for(k; k < buddy_size; k = lchild(k)){
        //cprintf("[buddy] alloc memmap k computing, k = %d, buddy_tag[k] = %d\n", k, buddy_tag[k]);
        if (upper_n == buddy_tag[k]) break;  // find level first
    }
    //cprintf("[buddy] alloc memmap k COMPUTED, k = %d, buddy_tag[k] = %d\n", k, buddy_tag[k]);
    if(upper_n != buddy_tag[k]) return NULL;

    int shift = 0;  // shift in layer
    
    for(shift; shift < layer_bound; shift++){
        //cprintf("[buddy] alloc memmap in for, k + shift = %d\n", k + shift);
        if(free_array[k + shift] != NULL && buddy_flag[k + shift]){
            //cprintf("[buddy] alloc memmap in for, k + shift = %d\n", k + shift);
            assert(free_array[k + shift] != NULL);
            page = free_array[k + shift];  // TODO should split it if n isn't power of 2
            ClearPageProperty(page);
            page->property = 0;
            free_array[k + shift] = NULL;
            buddy_flag[k + shift] = 0;
            nrfree_buddy -= upper_n;
            cprintf("[buddy] alloc memmap COMPLETE, index = %d, page = %p, property = %u\n", k + shift, page, page->property);
            return page;
        }
    }
    //cprintf("[buddy] alloc memmap NOT FOUND\n");
    // not found
    int j = parent(k);  // go back to get a big page
    layer_bound >>= 1;
    for(; j >= 0; j = parent(j), layer_bound >>= 1){
        //cprintf("[buddy] alloc memmap, outer for, j = %d, layer_bound = %d\n", j, layer_bound);
        int shift = 0;
        for(shift; shift < layer_bound; shift++){
            //cprintf("[buddy] alloc memmap, not found, j = %d, shift = %d, layer_bound = %d, free_array[j + shift] = %p\n", j, shift, layer_bound, free_array[j + shift]);
            if(free_array[j + shift] != NULL && buddy_flag[j + shift]){
                //cprintf("[buddy] alloc memmap, not found, free_array[j + shift] != NULL && buddy_flag[j + shift]\n");
                page = buddy_split_pages(free_array[j + shift], upper_n, j + shift);
                nrfree_buddy -= upper_n;
                page->property = 0;
                ClearPageProperty(page);
                //cprintf("[buddy] alloc memmap COMPLETE, index = %d, page = %p, property = %u\n", j + shift, page, page->property);
                return page;
            }
            //cprintf("[buddy] alloc memmap, not found, cycle2, shift = %d\n", shift);
        }
    }
    return page;
}


static void
buddy_merge_pages(struct Page *base, size_t n) {
    assert(n > 0);
    cprintf("[buddy] merge memmap start\n");
    int upper_n = n2pow2ru(n);

    int order = max_order - log2(upper_n);
    int layer_bound = 1 << order;

    struct Page *page = base;


    int index = page2index(page);

    int prev_index = index;


    if(prev_index == 0) return;

    assert(free_array[prev_index] != NULL);
    assert(free_array[parent(prev_index)] == NULL);
    if(islchild(prev_index)){
        if(buddy_flag[prev_index + 1] == 1) {
            SetPageProperty(page);
            page->property = 2 * upper_n;
            cprintf("[buddy] free memmap merge to the right, page->property = %u\n", page->property);
            free_array[prev_index]         = NULL, buddy_flag[prev_index]         = 0;
            free_array[prev_index + 1]     = NULL, buddy_flag[prev_index + 1]     = 0;
            free_array[parent(prev_index)] = page, buddy_flag[parent(prev_index)] = 1;
            buddy_merge_pages(page, 2 * upper_n);
        }
        else{
            cprintf("[buddy] can't memmap merge, islchild\n");
            SetPageProperty(page);
            page->property = upper_n;
            free_array[prev_index]         = page, buddy_flag[prev_index]         = 1;
        }
    }
    else if(isrchild(prev_index)){
        if(buddy_flag[prev_index - 1] == 1) {
            cprintf("[buddy] free memmap merge to the left\n");
            page -= upper_n;
            SetPageProperty(page);
            page->property = 2 * upper_n;
            free_array[prev_index]         = NULL, buddy_flag[prev_index]         = 0;
            free_array[prev_index - 1]     = NULL, buddy_flag[prev_index - 1]     = 0;
            free_array[parent(prev_index)] = page, buddy_flag[parent(prev_index)] = 1;
            buddy_merge_pages(page, 2 * upper_n);
        }
        else{
            cprintf("[buddy] can't memmap merge, isrchild\n");
            SetPageProperty(page);
            page->property = upper_n;
            free_array[prev_index]         = page, buddy_flag[prev_index]         = 1;
        }
    }
}

static void
buddy_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    cprintf("[buddy] free memmap start\n");
    int upper_n = n2pow2ru(n);
    cprintf("[buddy] free memmap, upper_n = %d\n", upper_n);
    int order = max_order - log2(upper_n);
    int layer_bound = 1 << order;

    struct Page *p = base;
    for (; p != base + upper_n; p ++) {
        //cprintf("[buddy] free memmap, reseting base, p = %p, n = %u, reserved = %d, property = %d, num = %d\n", p, (u32)n, PageReserved(p), PageProperty(p), p - base);
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    nrfree_buddy += upper_n;
    base->property = upper_n;
    cprintf("[buddy] free memmap, clear over\n");
    // 查找符合要求的连续页
    struct Page *page = base;

    int index = page2index(page);

    int prev_index = index;

    cprintf("[buddy] free memmap, index = %d, prev_index = %d, free_array[prev_index] = %p\n", index, prev_index, free_array[prev_index]);

    if(prev_index == 0) return;

    assert(free_array[prev_index] == NULL);
    assert(free_array[parent(prev_index)] == NULL);
    if(islchild(prev_index)){
        if(buddy_flag[prev_index + 1] == 1) {
            SetPageProperty(page);
            page->property = 2 * upper_n;
            cprintf("[buddy] free memmap merge to the right, page->property = %u\n", page->property);
            free_array[prev_index]         = NULL, buddy_flag[prev_index]         = 0;
            free_array[prev_index + 1]     = NULL, buddy_flag[prev_index + 1]     = 0;
            free_array[parent(prev_index)] = page, buddy_flag[parent(prev_index)] = 1;
            buddy_merge_pages(page, 2 * upper_n);
        }
        else{
            cprintf("[buddy] can't memmap merge, islchild\n");
            SetPageProperty(page);
            page->property = upper_n;
            free_array[prev_index]         = page, buddy_flag[prev_index]         = 1;
        }
    }
    else if(isrchild(prev_index)){
        if(buddy_flag[prev_index - 1] == 1) {
            cprintf("[buddy] free memmap merge to the left\n");
            page -= upper_n;
            SetPageProperty(page);
            page->property = 2 * upper_n;
            free_array[prev_index]         = NULL, buddy_flag[prev_index]         = 0;
            free_array[prev_index - 1]     = NULL, buddy_flag[prev_index - 1]     = 0;
            free_array[parent(prev_index)] = page, buddy_flag[parent(prev_index)] = 1;
            buddy_merge_pages(page, 2 * upper_n);
        }
        else{
            cprintf("[buddy] can't memmap merge, isrchild\n");
            SetPageProperty(page);
            page->property = upper_n;
            free_array[prev_index]         = page, buddy_flag[prev_index]         = 1;
        }
    }
}


static size_t
buddy_nr_free_pages(void) {
    return nrfree_buddy;
}

//--------------------------------Buddy System----------------------------------

static void
basic_check(void) {
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
    assert((p0 = alloc_page()) != NULL);
    assert((p1 = alloc_page()) != NULL);
    assert((p2 = alloc_page()) != NULL);

    assert(p0 != p1 && p0 != p2 && p1 != p2);
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);

    assert(page2pa(p0) < npage * PGSIZE);
    assert(page2pa(p1) < npage * PGSIZE);
    assert(page2pa(p2) < npage * PGSIZE);

    struct Page** buddy_store = free_array;

    unsigned int nr_free_store = nrfree_buddy;
    nrfree_buddy = 0;

    assert(alloc_page() == NULL);

    free_page(p0);
    free_page(p1);
    free_page(p2);
    assert(nrfree_buddy == 3);

    assert((p0 = alloc_page()) != NULL);
    assert((p1 = alloc_page()) != NULL);
    assert((p2 = alloc_page()) != NULL);

    assert(alloc_page() == NULL);

    free_page(p0);

    struct Page *p;
    assert((p = alloc_page()) == p0);
    assert(alloc_page() == NULL);

    assert(nrfree_buddy == 0);
    //free_array = buddy_store;
    nrfree_buddy = nr_free_store;

    free_page(p);
    free_page(p1);
    free_page(p2);
}

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
buddy_check(void) {
    //basic_check();
    struct Page *p0, *A, *B, *C, *D;
    p0 = A = B = C = D = NULL;

    // assert((p0 = alloc_page()) != NULL);
    // assert((A = alloc_page()) != NULL);
    // assert((B = alloc_page()) != NULL);

    // assert(p0 != A && p0 != B && A != B);
    // assert(page_ref(p0) == 0 && page_ref(A) == 0 && page_ref(B) == 0);

    // free_page(p0);
    // free_page(A);
    // free_page(B);
    // cprintf("[test ] alloc A\n");
    // A = alloc_pages(500);
    // cprintf("[test ] alloc B\n");
    // B = alloc_pages(500);
    // cprintf("[test ] A %p\n", A);
    // cprintf("[test ] B %p\n", B);
    // free_pages(A, 250);
    // free_pages(B, 500);
    // free_pages(A + 250, 250);

    // follow the sample in coolshell
    A = alloc_pages(70);
    B = alloc_pages(35);
    cprintf("[test ] A %p\n", A);
    cprintf("[test ] B %p\n", B);
    assert(A + 128 == B);  
    C = alloc_pages(80);
    assert(A + 256 == C);  
    cprintf("[test ] C %p\n", C);
    free_pages(A, 70);  
    D = alloc_pages(60);
    cprintf("[test ] D %p\n", D);
    assert(B + 64 == D);  
    free_pages(B, 35);
    cprintf("[test ] D %p\n", D);
    free_pages(D, 60);
    cprintf("[test ] C %p\n", C);
    free_pages(C, 80);

    cprintf("\n[test ] ONCE COMPELETED, sizeofpage* = %d\n\n", sizeof(struct Page));

    A = alloc_pages(70);
    B = alloc_pages(35);
    cprintf("[test ] A %p\n", A);
    cprintf("[test ] B %p\n", B);
    assert(A + 128 == B);  
    C = alloc_pages(80);
    assert(A + 256 == C);  
    cprintf("[test ] C %p\n", C);
    free_pages(A, 70);  
    D = alloc_pages(60);
    cprintf("[test ] D %p\n", D);
    assert(B + 64 == D);  
    free_pages(B, 35);
    cprintf("[test ] D %p\n", D);
    free_pages(D, 60);
    cprintf("[test ] C %p\n", C);
    free_pages(C, 80);
}

const struct pmm_manager default_pmm_manager = {
    .name = "default_pmm_manager",
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};

