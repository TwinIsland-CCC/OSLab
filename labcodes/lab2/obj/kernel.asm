
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 80 11 00       	mov    $0x118000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 80 11 c0       	mov    %eax,0xc0118000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba e4 af 11 c0       	mov    $0xc011afe4,%edx
c0100041:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 a0 11 c0 	movl   $0xc011a000,(%esp)
c010005d:	e8 29 5f 00 00       	call   c0105f8b <memset>

    cons_init();                // init the console
c0100062:	e8 a3 15 00 00       	call   c010160a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 20 61 10 c0 	movl   $0xc0106120,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 3c 61 10 c0 	movl   $0xc010613c,(%esp)
c010007c:	e8 c7 02 00 00       	call   c0100348 <cprintf>

    print_kerninfo();
c0100081:	e8 f6 07 00 00       	call   c010087c <print_kerninfo>

    grade_backtrace();
c0100086:	e8 86 00 00 00       	call   c0100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 f5 45 00 00       	call   c0104685 <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 de 16 00 00       	call   c0101773 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 30 18 00 00       	call   c01018ca <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 21 0d 00 00       	call   c0100dc0 <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 3d 16 00 00       	call   c01016e1 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a4:	eb fe                	jmp    c01000a4 <kern_init+0x6e>

c01000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a6:	55                   	push   %ebp
c01000a7:	89 e5                	mov    %esp,%ebp
c01000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b3:	00 
c01000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000bb:	00 
c01000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c3:	e8 19 0c 00 00       	call   c0100ce1 <mon_backtrace>
}
c01000c8:	c9                   	leave  
c01000c9:	c3                   	ret    

c01000ca <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000ca:	55                   	push   %ebp
c01000cb:	89 e5                	mov    %esp,%ebp
c01000cd:	53                   	push   %ebx
c01000ce:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d1:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000d7:	8d 55 08             	lea    0x8(%ebp),%edx
c01000da:	8b 45 08             	mov    0x8(%ebp),%eax
c01000dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000e5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000e9:	89 04 24             	mov    %eax,(%esp)
c01000ec:	e8 b5 ff ff ff       	call   c01000a6 <grade_backtrace2>
}
c01000f1:	83 c4 14             	add    $0x14,%esp
c01000f4:	5b                   	pop    %ebx
c01000f5:	5d                   	pop    %ebp
c01000f6:	c3                   	ret    

c01000f7 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000f7:	55                   	push   %ebp
c01000f8:	89 e5                	mov    %esp,%ebp
c01000fa:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0100100:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100104:	8b 45 08             	mov    0x8(%ebp),%eax
c0100107:	89 04 24             	mov    %eax,(%esp)
c010010a:	e8 bb ff ff ff       	call   c01000ca <grade_backtrace1>
}
c010010f:	c9                   	leave  
c0100110:	c3                   	ret    

c0100111 <grade_backtrace>:

void
grade_backtrace(void) {
c0100111:	55                   	push   %ebp
c0100112:	89 e5                	mov    %esp,%ebp
c0100114:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100117:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010011c:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100123:	ff 
c0100124:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010012f:	e8 c3 ff ff ff       	call   c01000f7 <grade_backtrace0>
}
c0100134:	c9                   	leave  
c0100135:	c3                   	ret    

c0100136 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100136:	55                   	push   %ebp
c0100137:	89 e5                	mov    %esp,%ebp
c0100139:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014c:	0f b7 c0             	movzwl %ax,%eax
c010014f:	83 e0 03             	and    $0x3,%eax
c0100152:	89 c2                	mov    %eax,%edx
c0100154:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100159:	89 54 24 08          	mov    %edx,0x8(%esp)
c010015d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100161:	c7 04 24 41 61 10 c0 	movl   $0xc0106141,(%esp)
c0100168:	e8 db 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010016d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100171:	0f b7 d0             	movzwl %ax,%edx
c0100174:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100179:	89 54 24 08          	mov    %edx,0x8(%esp)
c010017d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100181:	c7 04 24 4f 61 10 c0 	movl   $0xc010614f,(%esp)
c0100188:	e8 bb 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100191:	0f b7 d0             	movzwl %ax,%edx
c0100194:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100199:	89 54 24 08          	mov    %edx,0x8(%esp)
c010019d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a1:	c7 04 24 5d 61 10 c0 	movl   $0xc010615d,(%esp)
c01001a8:	e8 9b 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001ad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b1:	0f b7 d0             	movzwl %ax,%edx
c01001b4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c1:	c7 04 24 6b 61 10 c0 	movl   $0xc010616b,(%esp)
c01001c8:	e8 7b 01 00 00       	call   c0100348 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d1:	0f b7 d0             	movzwl %ax,%edx
c01001d4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001d9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e1:	c7 04 24 79 61 10 c0 	movl   $0xc0106179,(%esp)
c01001e8:	e8 5b 01 00 00       	call   c0100348 <cprintf>
    round ++;
c01001ed:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001f2:	83 c0 01             	add    $0x1,%eax
c01001f5:	a3 00 a0 11 c0       	mov    %eax,0xc011a000
}
c01001fa:	c9                   	leave  
c01001fb:	c3                   	ret    

c01001fc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001fc:	55                   	push   %ebp
c01001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001ff:	5d                   	pop    %ebp
c0100200:	c3                   	ret    

c0100201 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100201:	55                   	push   %ebp
c0100202:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100204:	5d                   	pop    %ebp
c0100205:	c3                   	ret    

c0100206 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100206:	55                   	push   %ebp
c0100207:	89 e5                	mov    %esp,%ebp
c0100209:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020c:	e8 25 ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100211:	c7 04 24 88 61 10 c0 	movl   $0xc0106188,(%esp)
c0100218:	e8 2b 01 00 00       	call   c0100348 <cprintf>
    lab1_switch_to_user();
c010021d:	e8 da ff ff ff       	call   c01001fc <lab1_switch_to_user>
    lab1_print_cur_status();
c0100222:	e8 0f ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100227:	c7 04 24 a8 61 10 c0 	movl   $0xc01061a8,(%esp)
c010022e:	e8 15 01 00 00       	call   c0100348 <cprintf>
    lab1_switch_to_kernel();
c0100233:	e8 c9 ff ff ff       	call   c0100201 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100238:	e8 f9 fe ff ff       	call   c0100136 <lab1_print_cur_status>
}
c010023d:	c9                   	leave  
c010023e:	c3                   	ret    

c010023f <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010023f:	55                   	push   %ebp
c0100240:	89 e5                	mov    %esp,%ebp
c0100242:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100245:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100249:	74 13                	je     c010025e <readline+0x1f>
        cprintf("%s", prompt);
c010024b:	8b 45 08             	mov    0x8(%ebp),%eax
c010024e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100252:	c7 04 24 c7 61 10 c0 	movl   $0xc01061c7,(%esp)
c0100259:	e8 ea 00 00 00       	call   c0100348 <cprintf>
    }
    int i = 0, c;
c010025e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100265:	e8 66 01 00 00       	call   c01003d0 <getchar>
c010026a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010026d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100271:	79 07                	jns    c010027a <readline+0x3b>
            return NULL;
c0100273:	b8 00 00 00 00       	mov    $0x0,%eax
c0100278:	eb 79                	jmp    c01002f3 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010027a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010027e:	7e 28                	jle    c01002a8 <readline+0x69>
c0100280:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100287:	7f 1f                	jg     c01002a8 <readline+0x69>
            cputchar(c);
c0100289:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028c:	89 04 24             	mov    %eax,(%esp)
c010028f:	e8 da 00 00 00       	call   c010036e <cputchar>
            buf[i ++] = c;
c0100294:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100297:	8d 50 01             	lea    0x1(%eax),%edx
c010029a:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010029d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a0:	88 90 20 a0 11 c0    	mov    %dl,-0x3fee5fe0(%eax)
c01002a6:	eb 46                	jmp    c01002ee <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002a8:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002ac:	75 17                	jne    c01002c5 <readline+0x86>
c01002ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b2:	7e 11                	jle    c01002c5 <readline+0x86>
            cputchar(c);
c01002b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b7:	89 04 24             	mov    %eax,(%esp)
c01002ba:	e8 af 00 00 00       	call   c010036e <cputchar>
            i --;
c01002bf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c3:	eb 29                	jmp    c01002ee <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002c9:	74 06                	je     c01002d1 <readline+0x92>
c01002cb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002cf:	75 1d                	jne    c01002ee <readline+0xaf>
            cputchar(c);
c01002d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d4:	89 04 24             	mov    %eax,(%esp)
c01002d7:	e8 92 00 00 00       	call   c010036e <cputchar>
            buf[i] = '\0';
c01002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002df:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c01002e4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002e7:	b8 20 a0 11 c0       	mov    $0xc011a020,%eax
c01002ec:	eb 05                	jmp    c01002f3 <readline+0xb4>
        }
    }
c01002ee:	e9 72 ff ff ff       	jmp    c0100265 <readline+0x26>
}
c01002f3:	c9                   	leave  
c01002f4:	c3                   	ret    

c01002f5 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f5:	55                   	push   %ebp
c01002f6:	89 e5                	mov    %esp,%ebp
c01002f8:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01002fe:	89 04 24             	mov    %eax,(%esp)
c0100301:	e8 30 13 00 00       	call   c0101636 <cons_putc>
    (*cnt) ++;
c0100306:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100309:	8b 00                	mov    (%eax),%eax
c010030b:	8d 50 01             	lea    0x1(%eax),%edx
c010030e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100311:	89 10                	mov    %edx,(%eax)
}
c0100313:	c9                   	leave  
c0100314:	c3                   	ret    

c0100315 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100315:	55                   	push   %ebp
c0100316:	89 e5                	mov    %esp,%ebp
c0100318:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100322:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100325:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100329:	8b 45 08             	mov    0x8(%ebp),%eax
c010032c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100330:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100333:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100337:	c7 04 24 f5 02 10 c0 	movl   $0xc01002f5,(%esp)
c010033e:	e8 61 54 00 00       	call   c01057a4 <vprintfmt>
    return cnt;
c0100343:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100346:	c9                   	leave  
c0100347:	c3                   	ret    

c0100348 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100348:	55                   	push   %ebp
c0100349:	89 e5                	mov    %esp,%ebp
c010034b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010034e:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100351:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100354:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100357:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035b:	8b 45 08             	mov    0x8(%ebp),%eax
c010035e:	89 04 24             	mov    %eax,(%esp)
c0100361:	e8 af ff ff ff       	call   c0100315 <vcprintf>
c0100366:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100369:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036c:	c9                   	leave  
c010036d:	c3                   	ret    

c010036e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010036e:	55                   	push   %ebp
c010036f:	89 e5                	mov    %esp,%ebp
c0100371:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100374:	8b 45 08             	mov    0x8(%ebp),%eax
c0100377:	89 04 24             	mov    %eax,(%esp)
c010037a:	e8 b7 12 00 00       	call   c0101636 <cons_putc>
}
c010037f:	c9                   	leave  
c0100380:	c3                   	ret    

c0100381 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100381:	55                   	push   %ebp
c0100382:	89 e5                	mov    %esp,%ebp
c0100384:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100387:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010038e:	eb 13                	jmp    c01003a3 <cputs+0x22>
        cputch(c, &cnt);
c0100390:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100394:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100397:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039b:	89 04 24             	mov    %eax,(%esp)
c010039e:	e8 52 ff ff ff       	call   c01002f5 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a6:	8d 50 01             	lea    0x1(%eax),%edx
c01003a9:	89 55 08             	mov    %edx,0x8(%ebp)
c01003ac:	0f b6 00             	movzbl (%eax),%eax
c01003af:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b6:	75 d8                	jne    c0100390 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003bf:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c6:	e8 2a ff ff ff       	call   c01002f5 <cputch>
    return cnt;
c01003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003ce:	c9                   	leave  
c01003cf:	c3                   	ret    

c01003d0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d0:	55                   	push   %ebp
c01003d1:	89 e5                	mov    %esp,%ebp
c01003d3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d6:	e8 97 12 00 00       	call   c0101672 <cons_getc>
c01003db:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e2:	74 f2                	je     c01003d6 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003e7:	c9                   	leave  
c01003e8:	c3                   	ret    

c01003e9 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003e9:	55                   	push   %ebp
c01003ea:	89 e5                	mov    %esp,%ebp
c01003ec:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f2:	8b 00                	mov    (%eax),%eax
c01003f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fa:	8b 00                	mov    (%eax),%eax
c01003fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100406:	e9 d2 00 00 00       	jmp    c01004dd <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010040e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100411:	01 d0                	add    %edx,%eax
c0100413:	89 c2                	mov    %eax,%edx
c0100415:	c1 ea 1f             	shr    $0x1f,%edx
c0100418:	01 d0                	add    %edx,%eax
c010041a:	d1 f8                	sar    %eax
c010041c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100422:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100425:	eb 04                	jmp    c010042b <stab_binsearch+0x42>
            m --;
c0100427:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010042e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100431:	7c 1f                	jl     c0100452 <stab_binsearch+0x69>
c0100433:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100436:	89 d0                	mov    %edx,%eax
c0100438:	01 c0                	add    %eax,%eax
c010043a:	01 d0                	add    %edx,%eax
c010043c:	c1 e0 02             	shl    $0x2,%eax
c010043f:	89 c2                	mov    %eax,%edx
c0100441:	8b 45 08             	mov    0x8(%ebp),%eax
c0100444:	01 d0                	add    %edx,%eax
c0100446:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044a:	0f b6 c0             	movzbl %al,%eax
c010044d:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100450:	75 d5                	jne    c0100427 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100452:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100455:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100458:	7d 0b                	jge    c0100465 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010045d:	83 c0 01             	add    $0x1,%eax
c0100460:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100463:	eb 78                	jmp    c01004dd <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100465:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010046f:	89 d0                	mov    %edx,%eax
c0100471:	01 c0                	add    %eax,%eax
c0100473:	01 d0                	add    %edx,%eax
c0100475:	c1 e0 02             	shl    $0x2,%eax
c0100478:	89 c2                	mov    %eax,%edx
c010047a:	8b 45 08             	mov    0x8(%ebp),%eax
c010047d:	01 d0                	add    %edx,%eax
c010047f:	8b 40 08             	mov    0x8(%eax),%eax
c0100482:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100485:	73 13                	jae    c010049a <stab_binsearch+0xb1>
            *region_left = m;
c0100487:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010048d:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010048f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100492:	83 c0 01             	add    $0x1,%eax
c0100495:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100498:	eb 43                	jmp    c01004dd <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010049d:	89 d0                	mov    %edx,%eax
c010049f:	01 c0                	add    %eax,%eax
c01004a1:	01 d0                	add    %edx,%eax
c01004a3:	c1 e0 02             	shl    $0x2,%eax
c01004a6:	89 c2                	mov    %eax,%edx
c01004a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ab:	01 d0                	add    %edx,%eax
c01004ad:	8b 40 08             	mov    0x8(%eax),%eax
c01004b0:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b3:	76 16                	jbe    c01004cb <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004be:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c3:	83 e8 01             	sub    $0x1,%eax
c01004c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004c9:	eb 12                	jmp    c01004dd <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d1:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004d9:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e3:	0f 8e 22 ff ff ff    	jle    c010040b <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004ed:	75 0f                	jne    c01004fe <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f2:	8b 00                	mov    (%eax),%eax
c01004f4:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fa:	89 10                	mov    %edx,(%eax)
c01004fc:	eb 3f                	jmp    c010053d <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004fe:	8b 45 10             	mov    0x10(%ebp),%eax
c0100501:	8b 00                	mov    (%eax),%eax
c0100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100506:	eb 04                	jmp    c010050c <stab_binsearch+0x123>
c0100508:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010050f:	8b 00                	mov    (%eax),%eax
c0100511:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100514:	7d 1f                	jge    c0100535 <stab_binsearch+0x14c>
c0100516:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100519:	89 d0                	mov    %edx,%eax
c010051b:	01 c0                	add    %eax,%eax
c010051d:	01 d0                	add    %edx,%eax
c010051f:	c1 e0 02             	shl    $0x2,%eax
c0100522:	89 c2                	mov    %eax,%edx
c0100524:	8b 45 08             	mov    0x8(%ebp),%eax
c0100527:	01 d0                	add    %edx,%eax
c0100529:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010052d:	0f b6 c0             	movzbl %al,%eax
c0100530:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100533:	75 d3                	jne    c0100508 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100535:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100538:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053b:	89 10                	mov    %edx,(%eax)
    }
}
c010053d:	c9                   	leave  
c010053e:	c3                   	ret    

c010053f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010053f:	55                   	push   %ebp
c0100540:	89 e5                	mov    %esp,%ebp
c0100542:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100545:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100548:	c7 00 cc 61 10 c0    	movl   $0xc01061cc,(%eax)
    info->eip_line = 0;
c010054e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100558:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055b:	c7 40 08 cc 61 10 c0 	movl   $0xc01061cc,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100562:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100565:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100572:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100575:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100578:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010057f:	c7 45 f4 d0 74 10 c0 	movl   $0xc01074d0,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100586:	c7 45 f0 c0 20 11 c0 	movl   $0xc01120c0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010058d:	c7 45 ec c1 20 11 c0 	movl   $0xc01120c1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100594:	c7 45 e8 1d 4b 11 c0 	movl   $0xc0114b1d,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a1:	76 0d                	jbe    c01005b0 <debuginfo_eip+0x71>
c01005a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a6:	83 e8 01             	sub    $0x1,%eax
c01005a9:	0f b6 00             	movzbl (%eax),%eax
c01005ac:	84 c0                	test   %al,%al
c01005ae:	74 0a                	je     c01005ba <debuginfo_eip+0x7b>
        return -1;
c01005b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b5:	e9 c0 02 00 00       	jmp    c010087a <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005c7:	29 c2                	sub    %eax,%edx
c01005c9:	89 d0                	mov    %edx,%eax
c01005cb:	c1 f8 02             	sar    $0x2,%eax
c01005ce:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d4:	83 e8 01             	sub    $0x1,%eax
c01005d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005da:	8b 45 08             	mov    0x8(%ebp),%eax
c01005dd:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e1:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005e8:	00 
c01005e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005ec:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fa:	89 04 24             	mov    %eax,(%esp)
c01005fd:	e8 e7 fd ff ff       	call   c01003e9 <stab_binsearch>
    if (lfile == 0)
c0100602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100605:	85 c0                	test   %eax,%eax
c0100607:	75 0a                	jne    c0100613 <debuginfo_eip+0xd4>
        return -1;
c0100609:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010060e:	e9 67 02 00 00       	jmp    c010087a <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100616:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100619:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010061f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100622:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100626:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010062d:	00 
c010062e:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100631:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100635:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100638:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063f:	89 04 24             	mov    %eax,(%esp)
c0100642:	e8 a2 fd ff ff       	call   c01003e9 <stab_binsearch>

    if (lfun <= rfun) {
c0100647:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010064d:	39 c2                	cmp    %eax,%edx
c010064f:	7f 7c                	jg     c01006cd <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100651:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100654:	89 c2                	mov    %eax,%edx
c0100656:	89 d0                	mov    %edx,%eax
c0100658:	01 c0                	add    %eax,%eax
c010065a:	01 d0                	add    %edx,%eax
c010065c:	c1 e0 02             	shl    $0x2,%eax
c010065f:	89 c2                	mov    %eax,%edx
c0100661:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100664:	01 d0                	add    %edx,%eax
c0100666:	8b 10                	mov    (%eax),%edx
c0100668:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010066e:	29 c1                	sub    %eax,%ecx
c0100670:	89 c8                	mov    %ecx,%eax
c0100672:	39 c2                	cmp    %eax,%edx
c0100674:	73 22                	jae    c0100698 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100676:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100679:	89 c2                	mov    %eax,%edx
c010067b:	89 d0                	mov    %edx,%eax
c010067d:	01 c0                	add    %eax,%eax
c010067f:	01 d0                	add    %edx,%eax
c0100681:	c1 e0 02             	shl    $0x2,%eax
c0100684:	89 c2                	mov    %eax,%edx
c0100686:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100689:	01 d0                	add    %edx,%eax
c010068b:	8b 10                	mov    (%eax),%edx
c010068d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100690:	01 c2                	add    %eax,%edx
c0100692:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100695:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100698:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069b:	89 c2                	mov    %eax,%edx
c010069d:	89 d0                	mov    %edx,%eax
c010069f:	01 c0                	add    %eax,%eax
c01006a1:	01 d0                	add    %edx,%eax
c01006a3:	c1 e0 02             	shl    $0x2,%eax
c01006a6:	89 c2                	mov    %eax,%edx
c01006a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ab:	01 d0                	add    %edx,%eax
c01006ad:	8b 50 08             	mov    0x8(%eax),%edx
c01006b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b3:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b9:	8b 40 10             	mov    0x10(%eax),%eax
c01006bc:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006cb:	eb 15                	jmp    c01006e2 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d0:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006df:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e5:	8b 40 08             	mov    0x8(%eax),%eax
c01006e8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006ef:	00 
c01006f0:	89 04 24             	mov    %eax,(%esp)
c01006f3:	e8 07 57 00 00       	call   c0105dff <strfind>
c01006f8:	89 c2                	mov    %eax,%edx
c01006fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006fd:	8b 40 08             	mov    0x8(%eax),%eax
c0100700:	29 c2                	sub    %eax,%edx
c0100702:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100705:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100708:	8b 45 08             	mov    0x8(%ebp),%eax
c010070b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010070f:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100716:	00 
c0100717:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010071e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100721:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100728:	89 04 24             	mov    %eax,(%esp)
c010072b:	e8 b9 fc ff ff       	call   c01003e9 <stab_binsearch>
    if (lline <= rline) {
c0100730:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100733:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100736:	39 c2                	cmp    %eax,%edx
c0100738:	7f 24                	jg     c010075e <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010073d:	89 c2                	mov    %eax,%edx
c010073f:	89 d0                	mov    %edx,%eax
c0100741:	01 c0                	add    %eax,%eax
c0100743:	01 d0                	add    %edx,%eax
c0100745:	c1 e0 02             	shl    $0x2,%eax
c0100748:	89 c2                	mov    %eax,%edx
c010074a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010074d:	01 d0                	add    %edx,%eax
c010074f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100753:	0f b7 d0             	movzwl %ax,%edx
c0100756:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100759:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075c:	eb 13                	jmp    c0100771 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c010075e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100763:	e9 12 01 00 00       	jmp    c010087a <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076b:	83 e8 01             	sub    $0x1,%eax
c010076e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100771:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100777:	39 c2                	cmp    %eax,%edx
c0100779:	7c 56                	jl     c01007d1 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077e:	89 c2                	mov    %eax,%edx
c0100780:	89 d0                	mov    %edx,%eax
c0100782:	01 c0                	add    %eax,%eax
c0100784:	01 d0                	add    %edx,%eax
c0100786:	c1 e0 02             	shl    $0x2,%eax
c0100789:	89 c2                	mov    %eax,%edx
c010078b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010078e:	01 d0                	add    %edx,%eax
c0100790:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100794:	3c 84                	cmp    $0x84,%al
c0100796:	74 39                	je     c01007d1 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079b:	89 c2                	mov    %eax,%edx
c010079d:	89 d0                	mov    %edx,%eax
c010079f:	01 c0                	add    %eax,%eax
c01007a1:	01 d0                	add    %edx,%eax
c01007a3:	c1 e0 02             	shl    $0x2,%eax
c01007a6:	89 c2                	mov    %eax,%edx
c01007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ab:	01 d0                	add    %edx,%eax
c01007ad:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b1:	3c 64                	cmp    $0x64,%al
c01007b3:	75 b3                	jne    c0100768 <debuginfo_eip+0x229>
c01007b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007b8:	89 c2                	mov    %eax,%edx
c01007ba:	89 d0                	mov    %edx,%eax
c01007bc:	01 c0                	add    %eax,%eax
c01007be:	01 d0                	add    %edx,%eax
c01007c0:	c1 e0 02             	shl    $0x2,%eax
c01007c3:	89 c2                	mov    %eax,%edx
c01007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007c8:	01 d0                	add    %edx,%eax
c01007ca:	8b 40 08             	mov    0x8(%eax),%eax
c01007cd:	85 c0                	test   %eax,%eax
c01007cf:	74 97                	je     c0100768 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007d7:	39 c2                	cmp    %eax,%edx
c01007d9:	7c 46                	jl     c0100821 <debuginfo_eip+0x2e2>
c01007db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007de:	89 c2                	mov    %eax,%edx
c01007e0:	89 d0                	mov    %edx,%eax
c01007e2:	01 c0                	add    %eax,%eax
c01007e4:	01 d0                	add    %edx,%eax
c01007e6:	c1 e0 02             	shl    $0x2,%eax
c01007e9:	89 c2                	mov    %eax,%edx
c01007eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ee:	01 d0                	add    %edx,%eax
c01007f0:	8b 10                	mov    (%eax),%edx
c01007f2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007f8:	29 c1                	sub    %eax,%ecx
c01007fa:	89 c8                	mov    %ecx,%eax
c01007fc:	39 c2                	cmp    %eax,%edx
c01007fe:	73 21                	jae    c0100821 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100803:	89 c2                	mov    %eax,%edx
c0100805:	89 d0                	mov    %edx,%eax
c0100807:	01 c0                	add    %eax,%eax
c0100809:	01 d0                	add    %edx,%eax
c010080b:	c1 e0 02             	shl    $0x2,%eax
c010080e:	89 c2                	mov    %eax,%edx
c0100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100813:	01 d0                	add    %edx,%eax
c0100815:	8b 10                	mov    (%eax),%edx
c0100817:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081a:	01 c2                	add    %eax,%edx
c010081c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100821:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100824:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100827:	39 c2                	cmp    %eax,%edx
c0100829:	7d 4a                	jge    c0100875 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010082e:	83 c0 01             	add    $0x1,%eax
c0100831:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100834:	eb 18                	jmp    c010084e <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100836:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100839:	8b 40 14             	mov    0x14(%eax),%eax
c010083c:	8d 50 01             	lea    0x1(%eax),%edx
c010083f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100842:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100845:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100848:	83 c0 01             	add    $0x1,%eax
c010084b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100851:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100854:	39 c2                	cmp    %eax,%edx
c0100856:	7d 1d                	jge    c0100875 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085b:	89 c2                	mov    %eax,%edx
c010085d:	89 d0                	mov    %edx,%eax
c010085f:	01 c0                	add    %eax,%eax
c0100861:	01 d0                	add    %edx,%eax
c0100863:	c1 e0 02             	shl    $0x2,%eax
c0100866:	89 c2                	mov    %eax,%edx
c0100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086b:	01 d0                	add    %edx,%eax
c010086d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100871:	3c a0                	cmp    $0xa0,%al
c0100873:	74 c1                	je     c0100836 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100875:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087a:	c9                   	leave  
c010087b:	c3                   	ret    

c010087c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087c:	55                   	push   %ebp
c010087d:	89 e5                	mov    %esp,%ebp
c010087f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100882:	c7 04 24 d6 61 10 c0 	movl   $0xc01061d6,(%esp)
c0100889:	e8 ba fa ff ff       	call   c0100348 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010088e:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100895:	c0 
c0100896:	c7 04 24 ef 61 10 c0 	movl   $0xc01061ef,(%esp)
c010089d:	e8 a6 fa ff ff       	call   c0100348 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a2:	c7 44 24 04 14 61 10 	movl   $0xc0106114,0x4(%esp)
c01008a9:	c0 
c01008aa:	c7 04 24 07 62 10 c0 	movl   $0xc0106207,(%esp)
c01008b1:	e8 92 fa ff ff       	call   c0100348 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b6:	c7 44 24 04 00 a0 11 	movl   $0xc011a000,0x4(%esp)
c01008bd:	c0 
c01008be:	c7 04 24 1f 62 10 c0 	movl   $0xc010621f,(%esp)
c01008c5:	e8 7e fa ff ff       	call   c0100348 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008ca:	c7 44 24 04 e4 af 11 	movl   $0xc011afe4,0x4(%esp)
c01008d1:	c0 
c01008d2:	c7 04 24 37 62 10 c0 	movl   $0xc0106237,(%esp)
c01008d9:	e8 6a fa ff ff       	call   c0100348 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008de:	b8 e4 af 11 c0       	mov    $0xc011afe4,%eax
c01008e3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008e9:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01008ee:	29 c2                	sub    %eax,%edx
c01008f0:	89 d0                	mov    %edx,%eax
c01008f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f8:	85 c0                	test   %eax,%eax
c01008fa:	0f 48 c2             	cmovs  %edx,%eax
c01008fd:	c1 f8 0a             	sar    $0xa,%eax
c0100900:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100904:	c7 04 24 50 62 10 c0 	movl   $0xc0106250,(%esp)
c010090b:	e8 38 fa ff ff       	call   c0100348 <cprintf>
}
c0100910:	c9                   	leave  
c0100911:	c3                   	ret    

c0100912 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100912:	55                   	push   %ebp
c0100913:	89 e5                	mov    %esp,%ebp
c0100915:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091b:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010091e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100922:	8b 45 08             	mov    0x8(%ebp),%eax
c0100925:	89 04 24             	mov    %eax,(%esp)
c0100928:	e8 12 fc ff ff       	call   c010053f <debuginfo_eip>
c010092d:	85 c0                	test   %eax,%eax
c010092f:	74 15                	je     c0100946 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100931:	8b 45 08             	mov    0x8(%ebp),%eax
c0100934:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100938:	c7 04 24 7a 62 10 c0 	movl   $0xc010627a,(%esp)
c010093f:	e8 04 fa ff ff       	call   c0100348 <cprintf>
c0100944:	eb 6d                	jmp    c01009b3 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100946:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010094d:	eb 1c                	jmp    c010096b <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010094f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100952:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100955:	01 d0                	add    %edx,%eax
c0100957:	0f b6 00             	movzbl (%eax),%eax
c010095a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100960:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100963:	01 ca                	add    %ecx,%edx
c0100965:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100967:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010096e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100971:	7f dc                	jg     c010094f <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100973:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100979:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097c:	01 d0                	add    %edx,%eax
c010097e:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100981:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100984:	8b 55 08             	mov    0x8(%ebp),%edx
c0100987:	89 d1                	mov    %edx,%ecx
c0100989:	29 c1                	sub    %eax,%ecx
c010098b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010098e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100991:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100995:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010099f:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009a7:	c7 04 24 96 62 10 c0 	movl   $0xc0106296,(%esp)
c01009ae:	e8 95 f9 ff ff       	call   c0100348 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b3:	c9                   	leave  
c01009b4:	c3                   	ret    

c01009b5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b5:	55                   	push   %ebp
c01009b6:	89 e5                	mov    %esp,%ebp
c01009b8:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009bb:	8b 45 04             	mov    0x4(%ebp),%eax
c01009be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c4:	c9                   	leave  
c01009c5:	c3                   	ret    

c01009c6 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c6:	55                   	push   %ebp
c01009c7:	89 e5                	mov    %esp,%ebp
c01009c9:	53                   	push   %ebx
c01009ca:	83 ec 54             	sub    $0x54,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cd:	89 e8                	mov    %ebp,%eax
c01009cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
c01009d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

    uint32_t ebp_val = read_ebp();
c01009d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip_val = read_eip();
c01009d8:	e8 d8 ff ff ff       	call   c01009b5 <read_eip>
c01009dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i = 0;
c01009e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for(i = 0; i < STACKFRAME_DEPTH && ebp_val != 0; i++){
c01009e7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009ee:	e9 9d 00 00 00       	jmp    c0100a90 <print_stackframe+0xca>
        cprintf("ebp:0x%08x, eip:0x%08x", ebp_val, eip_val);  // 输出八位十六进制（即32位寄存器值）
c01009f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a01:	c7 04 24 a8 62 10 c0 	movl   $0xc01062a8,(%esp)
c0100a08:	e8 3b f9 ff ff       	call   c0100348 <cprintf>
        uint32_t* ebp_ptr = (uint32_t*)ebp_val;
c0100a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a10:	89 45 e8             	mov    %eax,-0x18(%ebp)
        uint32_t args[] = {*(ebp_ptr+2), *(ebp_ptr+3), *(ebp_ptr+4), *(ebp_ptr+5)};
c0100a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a16:	8b 40 08             	mov    0x8(%eax),%eax
c0100a19:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100a1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a1f:	8b 40 0c             	mov    0xc(%eax),%eax
c0100a22:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0100a25:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a28:	8b 40 10             	mov    0x10(%eax),%eax
c0100a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100a2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a31:	8b 40 14             	mov    0x14(%eax),%eax
c0100a34:	89 45 e0             	mov    %eax,-0x20(%ebp)
        cprintf(" args:0x%08x 0x%08x 0x%08x 0x%08x", args[0], args[1], args[2], args[3]);
c0100a37:	8b 5d e0             	mov    -0x20(%ebp),%ebx
c0100a3a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0100a3d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0100a40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100a43:	89 5c 24 10          	mov    %ebx,0x10(%esp)
c0100a47:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a4b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a53:	c7 04 24 c0 62 10 c0 	movl   $0xc01062c0,(%esp)
c0100a5a:	e8 e9 f8 ff ff       	call   c0100348 <cprintf>
        cprintf("\n");
c0100a5f:	c7 04 24 e2 62 10 c0 	movl   $0xc01062e2,(%esp)
c0100a66:	e8 dd f8 ff ff       	call   c0100348 <cprintf>
        print_debuginfo(eip_val - 1);
c0100a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a6e:	83 e8 01             	sub    $0x1,%eax
c0100a71:	89 04 24             	mov    %eax,(%esp)
c0100a74:	e8 99 fe ff ff       	call   c0100912 <print_debuginfo>
        eip_val = *(uint32_t*)(ebp_val + 4);
c0100a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a7c:	83 c0 04             	add    $0x4,%eax
c0100a7f:	8b 00                	mov    (%eax),%eax
c0100a81:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp_val = *(uint32_t*)ebp_val;
c0100a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a87:	8b 00                	mov    (%eax),%eax
c0100a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
      */

    uint32_t ebp_val = read_ebp();
    uint32_t eip_val = read_eip();
    int i = 0;
    for(i = 0; i < STACKFRAME_DEPTH && ebp_val != 0; i++){
c0100a8c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a90:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a94:	7f 0a                	jg     c0100aa0 <print_stackframe+0xda>
c0100a96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a9a:	0f 85 53 ff ff ff    	jne    c01009f3 <print_stackframe+0x2d>
        cprintf("\n");
        print_debuginfo(eip_val - 1);
        eip_val = *(uint32_t*)(ebp_val + 4);
        ebp_val = *(uint32_t*)ebp_val;
    }
}
c0100aa0:	83 c4 54             	add    $0x54,%esp
c0100aa3:	5b                   	pop    %ebx
c0100aa4:	5d                   	pop    %ebp
c0100aa5:	c3                   	ret    

c0100aa6 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100aa6:	55                   	push   %ebp
c0100aa7:	89 e5                	mov    %esp,%ebp
c0100aa9:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100aac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ab3:	eb 0c                	jmp    c0100ac1 <parse+0x1b>
            *buf ++ = '\0';
c0100ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab8:	8d 50 01             	lea    0x1(%eax),%edx
c0100abb:	89 55 08             	mov    %edx,0x8(%ebp)
c0100abe:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100ac1:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac4:	0f b6 00             	movzbl (%eax),%eax
c0100ac7:	84 c0                	test   %al,%al
c0100ac9:	74 1d                	je     c0100ae8 <parse+0x42>
c0100acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ace:	0f b6 00             	movzbl (%eax),%eax
c0100ad1:	0f be c0             	movsbl %al,%eax
c0100ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ad8:	c7 04 24 64 63 10 c0 	movl   $0xc0106364,(%esp)
c0100adf:	e8 e8 52 00 00       	call   c0105dcc <strchr>
c0100ae4:	85 c0                	test   %eax,%eax
c0100ae6:	75 cd                	jne    c0100ab5 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ae8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aeb:	0f b6 00             	movzbl (%eax),%eax
c0100aee:	84 c0                	test   %al,%al
c0100af0:	75 02                	jne    c0100af4 <parse+0x4e>
            break;
c0100af2:	eb 67                	jmp    c0100b5b <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100af4:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100af8:	75 14                	jne    c0100b0e <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100afa:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100b01:	00 
c0100b02:	c7 04 24 69 63 10 c0 	movl   $0xc0106369,(%esp)
c0100b09:	e8 3a f8 ff ff       	call   c0100348 <cprintf>
        }
        argv[argc ++] = buf;
c0100b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b11:	8d 50 01             	lea    0x1(%eax),%edx
c0100b14:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b17:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b21:	01 c2                	add    %eax,%edx
c0100b23:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b26:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b28:	eb 04                	jmp    c0100b2e <parse+0x88>
            buf ++;
c0100b2a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b31:	0f b6 00             	movzbl (%eax),%eax
c0100b34:	84 c0                	test   %al,%al
c0100b36:	74 1d                	je     c0100b55 <parse+0xaf>
c0100b38:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b3b:	0f b6 00             	movzbl (%eax),%eax
c0100b3e:	0f be c0             	movsbl %al,%eax
c0100b41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b45:	c7 04 24 64 63 10 c0 	movl   $0xc0106364,(%esp)
c0100b4c:	e8 7b 52 00 00       	call   c0105dcc <strchr>
c0100b51:	85 c0                	test   %eax,%eax
c0100b53:	74 d5                	je     c0100b2a <parse+0x84>
            buf ++;
        }
    }
c0100b55:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b56:	e9 66 ff ff ff       	jmp    c0100ac1 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b5e:	c9                   	leave  
c0100b5f:	c3                   	ret    

c0100b60 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b60:	55                   	push   %ebp
c0100b61:	89 e5                	mov    %esp,%ebp
c0100b63:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b66:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b70:	89 04 24             	mov    %eax,(%esp)
c0100b73:	e8 2e ff ff ff       	call   c0100aa6 <parse>
c0100b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b7f:	75 0a                	jne    c0100b8b <runcmd+0x2b>
        return 0;
c0100b81:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b86:	e9 85 00 00 00       	jmp    c0100c10 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b92:	eb 5c                	jmp    c0100bf0 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b94:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b97:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b9a:	89 d0                	mov    %edx,%eax
c0100b9c:	01 c0                	add    %eax,%eax
c0100b9e:	01 d0                	add    %edx,%eax
c0100ba0:	c1 e0 02             	shl    $0x2,%eax
c0100ba3:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100ba8:	8b 00                	mov    (%eax),%eax
c0100baa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100bae:	89 04 24             	mov    %eax,(%esp)
c0100bb1:	e8 77 51 00 00       	call   c0105d2d <strcmp>
c0100bb6:	85 c0                	test   %eax,%eax
c0100bb8:	75 32                	jne    c0100bec <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bbd:	89 d0                	mov    %edx,%eax
c0100bbf:	01 c0                	add    %eax,%eax
c0100bc1:	01 d0                	add    %edx,%eax
c0100bc3:	c1 e0 02             	shl    $0x2,%eax
c0100bc6:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100bcb:	8b 40 08             	mov    0x8(%eax),%eax
c0100bce:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bd1:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bd7:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bdb:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bde:	83 c2 04             	add    $0x4,%edx
c0100be1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100be5:	89 0c 24             	mov    %ecx,(%esp)
c0100be8:	ff d0                	call   *%eax
c0100bea:	eb 24                	jmp    c0100c10 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bf3:	83 f8 02             	cmp    $0x2,%eax
c0100bf6:	76 9c                	jbe    c0100b94 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bf8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bff:	c7 04 24 87 63 10 c0 	movl   $0xc0106387,(%esp)
c0100c06:	e8 3d f7 ff ff       	call   c0100348 <cprintf>
    return 0;
c0100c0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c10:	c9                   	leave  
c0100c11:	c3                   	ret    

c0100c12 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c12:	55                   	push   %ebp
c0100c13:	89 e5                	mov    %esp,%ebp
c0100c15:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c18:	c7 04 24 a0 63 10 c0 	movl   $0xc01063a0,(%esp)
c0100c1f:	e8 24 f7 ff ff       	call   c0100348 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c24:	c7 04 24 c8 63 10 c0 	movl   $0xc01063c8,(%esp)
c0100c2b:	e8 18 f7 ff ff       	call   c0100348 <cprintf>

    if (tf != NULL) {
c0100c30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c34:	74 0b                	je     c0100c41 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c36:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c39:	89 04 24             	mov    %eax,(%esp)
c0100c3c:	e8 c6 0e 00 00       	call   c0101b07 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c41:	c7 04 24 ed 63 10 c0 	movl   $0xc01063ed,(%esp)
c0100c48:	e8 f2 f5 ff ff       	call   c010023f <readline>
c0100c4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c54:	74 18                	je     c0100c6e <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c56:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c60:	89 04 24             	mov    %eax,(%esp)
c0100c63:	e8 f8 fe ff ff       	call   c0100b60 <runcmd>
c0100c68:	85 c0                	test   %eax,%eax
c0100c6a:	79 02                	jns    c0100c6e <kmonitor+0x5c>
                break;
c0100c6c:	eb 02                	jmp    c0100c70 <kmonitor+0x5e>
            }
        }
    }
c0100c6e:	eb d1                	jmp    c0100c41 <kmonitor+0x2f>
}
c0100c70:	c9                   	leave  
c0100c71:	c3                   	ret    

c0100c72 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c72:	55                   	push   %ebp
c0100c73:	89 e5                	mov    %esp,%ebp
c0100c75:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c7f:	eb 3f                	jmp    c0100cc0 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c81:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c84:	89 d0                	mov    %edx,%eax
c0100c86:	01 c0                	add    %eax,%eax
c0100c88:	01 d0                	add    %edx,%eax
c0100c8a:	c1 e0 02             	shl    $0x2,%eax
c0100c8d:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c92:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c95:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c98:	89 d0                	mov    %edx,%eax
c0100c9a:	01 c0                	add    %eax,%eax
c0100c9c:	01 d0                	add    %edx,%eax
c0100c9e:	c1 e0 02             	shl    $0x2,%eax
c0100ca1:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100ca6:	8b 00                	mov    (%eax),%eax
c0100ca8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100cac:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cb0:	c7 04 24 f1 63 10 c0 	movl   $0xc01063f1,(%esp)
c0100cb7:	e8 8c f6 ff ff       	call   c0100348 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cbc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cc3:	83 f8 02             	cmp    $0x2,%eax
c0100cc6:	76 b9                	jbe    c0100c81 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccd:	c9                   	leave  
c0100cce:	c3                   	ret    

c0100ccf <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ccf:	55                   	push   %ebp
c0100cd0:	89 e5                	mov    %esp,%ebp
c0100cd2:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cd5:	e8 a2 fb ff ff       	call   c010087c <print_kerninfo>
    return 0;
c0100cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cdf:	c9                   	leave  
c0100ce0:	c3                   	ret    

c0100ce1 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100ce1:	55                   	push   %ebp
c0100ce2:	89 e5                	mov    %esp,%ebp
c0100ce4:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100ce7:	e8 da fc ff ff       	call   c01009c6 <print_stackframe>
    return 0;
c0100cec:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cf1:	c9                   	leave  
c0100cf2:	c3                   	ret    

c0100cf3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cf3:	55                   	push   %ebp
c0100cf4:	89 e5                	mov    %esp,%ebp
c0100cf6:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cf9:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
c0100cfe:	85 c0                	test   %eax,%eax
c0100d00:	74 02                	je     c0100d04 <__panic+0x11>
        goto panic_dead;
c0100d02:	eb 59                	jmp    c0100d5d <__panic+0x6a>
    }
    is_panic = 1;
c0100d04:	c7 05 20 a4 11 c0 01 	movl   $0x1,0xc011a420
c0100d0b:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100d0e:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100d14:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d17:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d22:	c7 04 24 fa 63 10 c0 	movl   $0xc01063fa,(%esp)
c0100d29:	e8 1a f6 ff ff       	call   c0100348 <cprintf>
    vcprintf(fmt, ap);
c0100d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d31:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d35:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d38:	89 04 24             	mov    %eax,(%esp)
c0100d3b:	e8 d5 f5 ff ff       	call   c0100315 <vcprintf>
    cprintf("\n");
c0100d40:	c7 04 24 16 64 10 c0 	movl   $0xc0106416,(%esp)
c0100d47:	e8 fc f5 ff ff       	call   c0100348 <cprintf>
    
    cprintf("stack trackback:\n");
c0100d4c:	c7 04 24 18 64 10 c0 	movl   $0xc0106418,(%esp)
c0100d53:	e8 f0 f5 ff ff       	call   c0100348 <cprintf>
    print_stackframe();
c0100d58:	e8 69 fc ff ff       	call   c01009c6 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100d5d:	e8 85 09 00 00       	call   c01016e7 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d69:	e8 a4 fe ff ff       	call   c0100c12 <kmonitor>
    }
c0100d6e:	eb f2                	jmp    c0100d62 <__panic+0x6f>

c0100d70 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d70:	55                   	push   %ebp
c0100d71:	89 e5                	mov    %esp,%ebp
c0100d73:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d76:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d7f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d83:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d86:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d8a:	c7 04 24 2a 64 10 c0 	movl   $0xc010642a,(%esp)
c0100d91:	e8 b2 f5 ff ff       	call   c0100348 <cprintf>
    vcprintf(fmt, ap);
c0100d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d99:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d9d:	8b 45 10             	mov    0x10(%ebp),%eax
c0100da0:	89 04 24             	mov    %eax,(%esp)
c0100da3:	e8 6d f5 ff ff       	call   c0100315 <vcprintf>
    cprintf("\n");
c0100da8:	c7 04 24 16 64 10 c0 	movl   $0xc0106416,(%esp)
c0100daf:	e8 94 f5 ff ff       	call   c0100348 <cprintf>
    va_end(ap);
}
c0100db4:	c9                   	leave  
c0100db5:	c3                   	ret    

c0100db6 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100db6:	55                   	push   %ebp
c0100db7:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100db9:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
}
c0100dbe:	5d                   	pop    %ebp
c0100dbf:	c3                   	ret    

c0100dc0 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100dc0:	55                   	push   %ebp
c0100dc1:	89 e5                	mov    %esp,%ebp
c0100dc3:	83 ec 28             	sub    $0x28,%esp
c0100dc6:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100dcc:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dd0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dd4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dd8:	ee                   	out    %al,(%dx)
c0100dd9:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100ddf:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100de3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100de7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100deb:	ee                   	out    %al,(%dx)
c0100dec:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100df2:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100df6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dfa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dfe:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dff:	c7 05 0c af 11 c0 00 	movl   $0x0,0xc011af0c
c0100e06:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100e09:	c7 04 24 48 64 10 c0 	movl   $0xc0106448,(%esp)
c0100e10:	e8 33 f5 ff ff       	call   c0100348 <cprintf>
    pic_enable(IRQ_TIMER);
c0100e15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e1c:	e8 24 09 00 00       	call   c0101745 <pic_enable>
}
c0100e21:	c9                   	leave  
c0100e22:	c3                   	ret    

c0100e23 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e23:	55                   	push   %ebp
c0100e24:	89 e5                	mov    %esp,%ebp
c0100e26:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e29:	9c                   	pushf  
c0100e2a:	58                   	pop    %eax
c0100e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e31:	25 00 02 00 00       	and    $0x200,%eax
c0100e36:	85 c0                	test   %eax,%eax
c0100e38:	74 0c                	je     c0100e46 <__intr_save+0x23>
        intr_disable();
c0100e3a:	e8 a8 08 00 00       	call   c01016e7 <intr_disable>
        return 1;
c0100e3f:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e44:	eb 05                	jmp    c0100e4b <__intr_save+0x28>
    }
    return 0;
c0100e46:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e4b:	c9                   	leave  
c0100e4c:	c3                   	ret    

c0100e4d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e4d:	55                   	push   %ebp
c0100e4e:	89 e5                	mov    %esp,%ebp
c0100e50:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e57:	74 05                	je     c0100e5e <__intr_restore+0x11>
        intr_enable();
c0100e59:	e8 83 08 00 00       	call   c01016e1 <intr_enable>
    }
}
c0100e5e:	c9                   	leave  
c0100e5f:	c3                   	ret    

c0100e60 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e60:	55                   	push   %ebp
c0100e61:	89 e5                	mov    %esp,%ebp
c0100e63:	83 ec 10             	sub    $0x10,%esp
c0100e66:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e6c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e70:	89 c2                	mov    %eax,%edx
c0100e72:	ec                   	in     (%dx),%al
c0100e73:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e76:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e7c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e80:	89 c2                	mov    %eax,%edx
c0100e82:	ec                   	in     (%dx),%al
c0100e83:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e86:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e8c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e90:	89 c2                	mov    %eax,%edx
c0100e92:	ec                   	in     (%dx),%al
c0100e93:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e96:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e9c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ea0:	89 c2                	mov    %eax,%edx
c0100ea2:	ec                   	in     (%dx),%al
c0100ea3:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100ea6:	c9                   	leave  
c0100ea7:	c3                   	ret    

c0100ea8 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100ea8:	55                   	push   %ebp
c0100ea9:	89 e5                	mov    %esp,%ebp
c0100eab:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100eae:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb8:	0f b7 00             	movzwl (%eax),%eax
c0100ebb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100ebf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec2:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ec7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eca:	0f b7 00             	movzwl (%eax),%eax
c0100ecd:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ed1:	74 12                	je     c0100ee5 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ed3:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eda:	66 c7 05 46 a4 11 c0 	movw   $0x3b4,0xc011a446
c0100ee1:	b4 03 
c0100ee3:	eb 13                	jmp    c0100ef8 <cga_init+0x50>
    } else {
        *cp = was;
c0100ee5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ee8:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eec:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eef:	66 c7 05 46 a4 11 c0 	movw   $0x3d4,0xc011a446
c0100ef6:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ef8:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100eff:	0f b7 c0             	movzwl %ax,%eax
c0100f02:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100f06:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f0a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f0e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f12:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100f13:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f1a:	83 c0 01             	add    $0x1,%eax
c0100f1d:	0f b7 c0             	movzwl %ax,%eax
c0100f20:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f24:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f28:	89 c2                	mov    %eax,%edx
c0100f2a:	ec                   	in     (%dx),%al
c0100f2b:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f2e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f32:	0f b6 c0             	movzbl %al,%eax
c0100f35:	c1 e0 08             	shl    $0x8,%eax
c0100f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f3b:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f42:	0f b7 c0             	movzwl %ax,%eax
c0100f45:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f49:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f4d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f51:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f55:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f56:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f5d:	83 c0 01             	add    $0x1,%eax
c0100f60:	0f b7 c0             	movzwl %ax,%eax
c0100f63:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f67:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f6b:	89 c2                	mov    %eax,%edx
c0100f6d:	ec                   	in     (%dx),%al
c0100f6e:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f71:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f75:	0f b6 c0             	movzbl %al,%eax
c0100f78:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f7e:	a3 40 a4 11 c0       	mov    %eax,0xc011a440
    crt_pos = pos;
c0100f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f86:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
}
c0100f8c:	c9                   	leave  
c0100f8d:	c3                   	ret    

c0100f8e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f8e:	55                   	push   %ebp
c0100f8f:	89 e5                	mov    %esp,%ebp
c0100f91:	83 ec 48             	sub    $0x48,%esp
c0100f94:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f9a:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f9e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100fa2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100fa6:	ee                   	out    %al,(%dx)
c0100fa7:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100fad:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100fb1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fb5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fb9:	ee                   	out    %al,(%dx)
c0100fba:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100fc0:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100fc4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fc8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fcc:	ee                   	out    %al,(%dx)
c0100fcd:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fd3:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fd7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fdb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fdf:	ee                   	out    %al,(%dx)
c0100fe0:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fe6:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fea:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fee:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100ff2:	ee                   	out    %al,(%dx)
c0100ff3:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100ff9:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100ffd:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101001:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101005:	ee                   	out    %al,(%dx)
c0101006:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c010100c:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0101010:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101014:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101018:	ee                   	out    %al,(%dx)
c0101019:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010101f:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101023:	89 c2                	mov    %eax,%edx
c0101025:	ec                   	in     (%dx),%al
c0101026:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101029:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010102d:	3c ff                	cmp    $0xff,%al
c010102f:	0f 95 c0             	setne  %al
c0101032:	0f b6 c0             	movzbl %al,%eax
c0101035:	a3 48 a4 11 c0       	mov    %eax,0xc011a448
c010103a:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101040:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101044:	89 c2                	mov    %eax,%edx
c0101046:	ec                   	in     (%dx),%al
c0101047:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010104a:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101050:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101054:	89 c2                	mov    %eax,%edx
c0101056:	ec                   	in     (%dx),%al
c0101057:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010105a:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c010105f:	85 c0                	test   %eax,%eax
c0101061:	74 0c                	je     c010106f <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101063:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010106a:	e8 d6 06 00 00       	call   c0101745 <pic_enable>
    }
}
c010106f:	c9                   	leave  
c0101070:	c3                   	ret    

c0101071 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101071:	55                   	push   %ebp
c0101072:	89 e5                	mov    %esp,%ebp
c0101074:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101077:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010107e:	eb 09                	jmp    c0101089 <lpt_putc_sub+0x18>
        delay();
c0101080:	e8 db fd ff ff       	call   c0100e60 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101085:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101089:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c010108f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101093:	89 c2                	mov    %eax,%edx
c0101095:	ec                   	in     (%dx),%al
c0101096:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101099:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010109d:	84 c0                	test   %al,%al
c010109f:	78 09                	js     c01010aa <lpt_putc_sub+0x39>
c01010a1:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01010a8:	7e d6                	jle    c0101080 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c01010aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ad:	0f b6 c0             	movzbl %al,%eax
c01010b0:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c01010b6:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010b9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010bd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010c1:	ee                   	out    %al,(%dx)
c01010c2:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010c8:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010cc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010d0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010d4:	ee                   	out    %al,(%dx)
c01010d5:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010db:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010df:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010e3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010e7:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010e8:	c9                   	leave  
c01010e9:	c3                   	ret    

c01010ea <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010ea:	55                   	push   %ebp
c01010eb:	89 e5                	mov    %esp,%ebp
c01010ed:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010f0:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010f4:	74 0d                	je     c0101103 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f9:	89 04 24             	mov    %eax,(%esp)
c01010fc:	e8 70 ff ff ff       	call   c0101071 <lpt_putc_sub>
c0101101:	eb 24                	jmp    c0101127 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c0101103:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010110a:	e8 62 ff ff ff       	call   c0101071 <lpt_putc_sub>
        lpt_putc_sub(' ');
c010110f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101116:	e8 56 ff ff ff       	call   c0101071 <lpt_putc_sub>
        lpt_putc_sub('\b');
c010111b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101122:	e8 4a ff ff ff       	call   c0101071 <lpt_putc_sub>
    }
}
c0101127:	c9                   	leave  
c0101128:	c3                   	ret    

c0101129 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101129:	55                   	push   %ebp
c010112a:	89 e5                	mov    %esp,%ebp
c010112c:	53                   	push   %ebx
c010112d:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101130:	8b 45 08             	mov    0x8(%ebp),%eax
c0101133:	b0 00                	mov    $0x0,%al
c0101135:	85 c0                	test   %eax,%eax
c0101137:	75 07                	jne    c0101140 <cga_putc+0x17>
        c |= 0x0700;
c0101139:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101140:	8b 45 08             	mov    0x8(%ebp),%eax
c0101143:	0f b6 c0             	movzbl %al,%eax
c0101146:	83 f8 0a             	cmp    $0xa,%eax
c0101149:	74 4c                	je     c0101197 <cga_putc+0x6e>
c010114b:	83 f8 0d             	cmp    $0xd,%eax
c010114e:	74 57                	je     c01011a7 <cga_putc+0x7e>
c0101150:	83 f8 08             	cmp    $0x8,%eax
c0101153:	0f 85 88 00 00 00    	jne    c01011e1 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101159:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101160:	66 85 c0             	test   %ax,%ax
c0101163:	74 30                	je     c0101195 <cga_putc+0x6c>
            crt_pos --;
c0101165:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010116c:	83 e8 01             	sub    $0x1,%eax
c010116f:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101175:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c010117a:	0f b7 15 44 a4 11 c0 	movzwl 0xc011a444,%edx
c0101181:	0f b7 d2             	movzwl %dx,%edx
c0101184:	01 d2                	add    %edx,%edx
c0101186:	01 c2                	add    %eax,%edx
c0101188:	8b 45 08             	mov    0x8(%ebp),%eax
c010118b:	b0 00                	mov    $0x0,%al
c010118d:	83 c8 20             	or     $0x20,%eax
c0101190:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101193:	eb 72                	jmp    c0101207 <cga_putc+0xde>
c0101195:	eb 70                	jmp    c0101207 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101197:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010119e:	83 c0 50             	add    $0x50,%eax
c01011a1:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011a7:	0f b7 1d 44 a4 11 c0 	movzwl 0xc011a444,%ebx
c01011ae:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
c01011b5:	0f b7 c1             	movzwl %cx,%eax
c01011b8:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01011be:	c1 e8 10             	shr    $0x10,%eax
c01011c1:	89 c2                	mov    %eax,%edx
c01011c3:	66 c1 ea 06          	shr    $0x6,%dx
c01011c7:	89 d0                	mov    %edx,%eax
c01011c9:	c1 e0 02             	shl    $0x2,%eax
c01011cc:	01 d0                	add    %edx,%eax
c01011ce:	c1 e0 04             	shl    $0x4,%eax
c01011d1:	29 c1                	sub    %eax,%ecx
c01011d3:	89 ca                	mov    %ecx,%edx
c01011d5:	89 d8                	mov    %ebx,%eax
c01011d7:	29 d0                	sub    %edx,%eax
c01011d9:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
        break;
c01011df:	eb 26                	jmp    c0101207 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011e1:	8b 0d 40 a4 11 c0    	mov    0xc011a440,%ecx
c01011e7:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011ee:	8d 50 01             	lea    0x1(%eax),%edx
c01011f1:	66 89 15 44 a4 11 c0 	mov    %dx,0xc011a444
c01011f8:	0f b7 c0             	movzwl %ax,%eax
c01011fb:	01 c0                	add    %eax,%eax
c01011fd:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101200:	8b 45 08             	mov    0x8(%ebp),%eax
c0101203:	66 89 02             	mov    %ax,(%edx)
        break;
c0101206:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101207:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010120e:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101212:	76 5b                	jbe    c010126f <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101214:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101219:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010121f:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101224:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c010122b:	00 
c010122c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101230:	89 04 24             	mov    %eax,(%esp)
c0101233:	e8 92 4d 00 00       	call   c0105fca <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101238:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010123f:	eb 15                	jmp    c0101256 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101241:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101246:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101249:	01 d2                	add    %edx,%edx
c010124b:	01 d0                	add    %edx,%eax
c010124d:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101252:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101256:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010125d:	7e e2                	jle    c0101241 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010125f:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101266:	83 e8 50             	sub    $0x50,%eax
c0101269:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010126f:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0101276:	0f b7 c0             	movzwl %ax,%eax
c0101279:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010127d:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101281:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101285:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101289:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010128a:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101291:	66 c1 e8 08          	shr    $0x8,%ax
c0101295:	0f b6 c0             	movzbl %al,%eax
c0101298:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c010129f:	83 c2 01             	add    $0x1,%edx
c01012a2:	0f b7 d2             	movzwl %dx,%edx
c01012a5:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c01012a9:	88 45 ed             	mov    %al,-0x13(%ebp)
c01012ac:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01012b0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012b4:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01012b5:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c01012bc:	0f b7 c0             	movzwl %ax,%eax
c01012bf:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012c3:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012c7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012cb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012cf:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012d0:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01012d7:	0f b6 c0             	movzbl %al,%eax
c01012da:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c01012e1:	83 c2 01             	add    $0x1,%edx
c01012e4:	0f b7 d2             	movzwl %dx,%edx
c01012e7:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012eb:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012ee:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012f2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012f6:	ee                   	out    %al,(%dx)
}
c01012f7:	83 c4 34             	add    $0x34,%esp
c01012fa:	5b                   	pop    %ebx
c01012fb:	5d                   	pop    %ebp
c01012fc:	c3                   	ret    

c01012fd <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012fd:	55                   	push   %ebp
c01012fe:	89 e5                	mov    %esp,%ebp
c0101300:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101303:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010130a:	eb 09                	jmp    c0101315 <serial_putc_sub+0x18>
        delay();
c010130c:	e8 4f fb ff ff       	call   c0100e60 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101311:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101315:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010131b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010131f:	89 c2                	mov    %eax,%edx
c0101321:	ec                   	in     (%dx),%al
c0101322:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101325:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101329:	0f b6 c0             	movzbl %al,%eax
c010132c:	83 e0 20             	and    $0x20,%eax
c010132f:	85 c0                	test   %eax,%eax
c0101331:	75 09                	jne    c010133c <serial_putc_sub+0x3f>
c0101333:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010133a:	7e d0                	jle    c010130c <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c010133c:	8b 45 08             	mov    0x8(%ebp),%eax
c010133f:	0f b6 c0             	movzbl %al,%eax
c0101342:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101348:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010134b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010134f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101353:	ee                   	out    %al,(%dx)
}
c0101354:	c9                   	leave  
c0101355:	c3                   	ret    

c0101356 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101356:	55                   	push   %ebp
c0101357:	89 e5                	mov    %esp,%ebp
c0101359:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010135c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101360:	74 0d                	je     c010136f <serial_putc+0x19>
        serial_putc_sub(c);
c0101362:	8b 45 08             	mov    0x8(%ebp),%eax
c0101365:	89 04 24             	mov    %eax,(%esp)
c0101368:	e8 90 ff ff ff       	call   c01012fd <serial_putc_sub>
c010136d:	eb 24                	jmp    c0101393 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c010136f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101376:	e8 82 ff ff ff       	call   c01012fd <serial_putc_sub>
        serial_putc_sub(' ');
c010137b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101382:	e8 76 ff ff ff       	call   c01012fd <serial_putc_sub>
        serial_putc_sub('\b');
c0101387:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010138e:	e8 6a ff ff ff       	call   c01012fd <serial_putc_sub>
    }
}
c0101393:	c9                   	leave  
c0101394:	c3                   	ret    

c0101395 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101395:	55                   	push   %ebp
c0101396:	89 e5                	mov    %esp,%ebp
c0101398:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010139b:	eb 33                	jmp    c01013d0 <cons_intr+0x3b>
        if (c != 0) {
c010139d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013a1:	74 2d                	je     c01013d0 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c01013a3:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c01013a8:	8d 50 01             	lea    0x1(%eax),%edx
c01013ab:	89 15 64 a6 11 c0    	mov    %edx,0xc011a664
c01013b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013b4:	88 90 60 a4 11 c0    	mov    %dl,-0x3fee5ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013ba:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c01013bf:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013c4:	75 0a                	jne    c01013d0 <cons_intr+0x3b>
                cons.wpos = 0;
c01013c6:	c7 05 64 a6 11 c0 00 	movl   $0x0,0xc011a664
c01013cd:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01013d3:	ff d0                	call   *%eax
c01013d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013d8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013dc:	75 bf                	jne    c010139d <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013de:	c9                   	leave  
c01013df:	c3                   	ret    

c01013e0 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013e0:	55                   	push   %ebp
c01013e1:	89 e5                	mov    %esp,%ebp
c01013e3:	83 ec 10             	sub    $0x10,%esp
c01013e6:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ec:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013f0:	89 c2                	mov    %eax,%edx
c01013f2:	ec                   	in     (%dx),%al
c01013f3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013f6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013fa:	0f b6 c0             	movzbl %al,%eax
c01013fd:	83 e0 01             	and    $0x1,%eax
c0101400:	85 c0                	test   %eax,%eax
c0101402:	75 07                	jne    c010140b <serial_proc_data+0x2b>
        return -1;
c0101404:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101409:	eb 2a                	jmp    c0101435 <serial_proc_data+0x55>
c010140b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101411:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101415:	89 c2                	mov    %eax,%edx
c0101417:	ec                   	in     (%dx),%al
c0101418:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c010141b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c010141f:	0f b6 c0             	movzbl %al,%eax
c0101422:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c0101425:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101429:	75 07                	jne    c0101432 <serial_proc_data+0x52>
        c = '\b';
c010142b:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101432:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101435:	c9                   	leave  
c0101436:	c3                   	ret    

c0101437 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101437:	55                   	push   %ebp
c0101438:	89 e5                	mov    %esp,%ebp
c010143a:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010143d:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101442:	85 c0                	test   %eax,%eax
c0101444:	74 0c                	je     c0101452 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101446:	c7 04 24 e0 13 10 c0 	movl   $0xc01013e0,(%esp)
c010144d:	e8 43 ff ff ff       	call   c0101395 <cons_intr>
    }
}
c0101452:	c9                   	leave  
c0101453:	c3                   	ret    

c0101454 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101454:	55                   	push   %ebp
c0101455:	89 e5                	mov    %esp,%ebp
c0101457:	83 ec 38             	sub    $0x38,%esp
c010145a:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101460:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101464:	89 c2                	mov    %eax,%edx
c0101466:	ec                   	in     (%dx),%al
c0101467:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010146a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010146e:	0f b6 c0             	movzbl %al,%eax
c0101471:	83 e0 01             	and    $0x1,%eax
c0101474:	85 c0                	test   %eax,%eax
c0101476:	75 0a                	jne    c0101482 <kbd_proc_data+0x2e>
        return -1;
c0101478:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010147d:	e9 59 01 00 00       	jmp    c01015db <kbd_proc_data+0x187>
c0101482:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101488:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010148c:	89 c2                	mov    %eax,%edx
c010148e:	ec                   	in     (%dx),%al
c010148f:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101492:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101496:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101499:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010149d:	75 17                	jne    c01014b6 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c010149f:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014a4:	83 c8 40             	or     $0x40,%eax
c01014a7:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c01014ac:	b8 00 00 00 00       	mov    $0x0,%eax
c01014b1:	e9 25 01 00 00       	jmp    c01015db <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c01014b6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ba:	84 c0                	test   %al,%al
c01014bc:	79 47                	jns    c0101505 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01014be:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014c3:	83 e0 40             	and    $0x40,%eax
c01014c6:	85 c0                	test   %eax,%eax
c01014c8:	75 09                	jne    c01014d3 <kbd_proc_data+0x7f>
c01014ca:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ce:	83 e0 7f             	and    $0x7f,%eax
c01014d1:	eb 04                	jmp    c01014d7 <kbd_proc_data+0x83>
c01014d3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014d7:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014da:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014de:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c01014e5:	83 c8 40             	or     $0x40,%eax
c01014e8:	0f b6 c0             	movzbl %al,%eax
c01014eb:	f7 d0                	not    %eax
c01014ed:	89 c2                	mov    %eax,%edx
c01014ef:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014f4:	21 d0                	and    %edx,%eax
c01014f6:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c01014fb:	b8 00 00 00 00       	mov    $0x0,%eax
c0101500:	e9 d6 00 00 00       	jmp    c01015db <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c0101505:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010150a:	83 e0 40             	and    $0x40,%eax
c010150d:	85 c0                	test   %eax,%eax
c010150f:	74 11                	je     c0101522 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101511:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101515:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010151a:	83 e0 bf             	and    $0xffffffbf,%eax
c010151d:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    }

    shift |= shiftcode[data];
c0101522:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101526:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c010152d:	0f b6 d0             	movzbl %al,%edx
c0101530:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101535:	09 d0                	or     %edx,%eax
c0101537:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    shift ^= togglecode[data];
c010153c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101540:	0f b6 80 40 71 11 c0 	movzbl -0x3fee8ec0(%eax),%eax
c0101547:	0f b6 d0             	movzbl %al,%edx
c010154a:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010154f:	31 d0                	xor    %edx,%eax
c0101551:	a3 68 a6 11 c0       	mov    %eax,0xc011a668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101556:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010155b:	83 e0 03             	and    $0x3,%eax
c010155e:	8b 14 85 40 75 11 c0 	mov    -0x3fee8ac0(,%eax,4),%edx
c0101565:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101569:	01 d0                	add    %edx,%eax
c010156b:	0f b6 00             	movzbl (%eax),%eax
c010156e:	0f b6 c0             	movzbl %al,%eax
c0101571:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101574:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101579:	83 e0 08             	and    $0x8,%eax
c010157c:	85 c0                	test   %eax,%eax
c010157e:	74 22                	je     c01015a2 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101580:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101584:	7e 0c                	jle    c0101592 <kbd_proc_data+0x13e>
c0101586:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010158a:	7f 06                	jg     c0101592 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010158c:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101590:	eb 10                	jmp    c01015a2 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101592:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101596:	7e 0a                	jle    c01015a2 <kbd_proc_data+0x14e>
c0101598:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010159c:	7f 04                	jg     c01015a2 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010159e:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c01015a2:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01015a7:	f7 d0                	not    %eax
c01015a9:	83 e0 06             	and    $0x6,%eax
c01015ac:	85 c0                	test   %eax,%eax
c01015ae:	75 28                	jne    c01015d8 <kbd_proc_data+0x184>
c01015b0:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01015b7:	75 1f                	jne    c01015d8 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c01015b9:	c7 04 24 63 64 10 c0 	movl   $0xc0106463,(%esp)
c01015c0:	e8 83 ed ff ff       	call   c0100348 <cprintf>
c01015c5:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015cb:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015cf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015d3:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015d7:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015db:	c9                   	leave  
c01015dc:	c3                   	ret    

c01015dd <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015dd:	55                   	push   %ebp
c01015de:	89 e5                	mov    %esp,%ebp
c01015e0:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015e3:	c7 04 24 54 14 10 c0 	movl   $0xc0101454,(%esp)
c01015ea:	e8 a6 fd ff ff       	call   c0101395 <cons_intr>
}
c01015ef:	c9                   	leave  
c01015f0:	c3                   	ret    

c01015f1 <kbd_init>:

static void
kbd_init(void) {
c01015f1:	55                   	push   %ebp
c01015f2:	89 e5                	mov    %esp,%ebp
c01015f4:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015f7:	e8 e1 ff ff ff       	call   c01015dd <kbd_intr>
    pic_enable(IRQ_KBD);
c01015fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101603:	e8 3d 01 00 00       	call   c0101745 <pic_enable>
}
c0101608:	c9                   	leave  
c0101609:	c3                   	ret    

c010160a <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c010160a:	55                   	push   %ebp
c010160b:	89 e5                	mov    %esp,%ebp
c010160d:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101610:	e8 93 f8 ff ff       	call   c0100ea8 <cga_init>
    serial_init();
c0101615:	e8 74 f9 ff ff       	call   c0100f8e <serial_init>
    kbd_init();
c010161a:	e8 d2 ff ff ff       	call   c01015f1 <kbd_init>
    if (!serial_exists) {
c010161f:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101624:	85 c0                	test   %eax,%eax
c0101626:	75 0c                	jne    c0101634 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101628:	c7 04 24 6f 64 10 c0 	movl   $0xc010646f,(%esp)
c010162f:	e8 14 ed ff ff       	call   c0100348 <cprintf>
    }
}
c0101634:	c9                   	leave  
c0101635:	c3                   	ret    

c0101636 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101636:	55                   	push   %ebp
c0101637:	89 e5                	mov    %esp,%ebp
c0101639:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010163c:	e8 e2 f7 ff ff       	call   c0100e23 <__intr_save>
c0101641:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101644:	8b 45 08             	mov    0x8(%ebp),%eax
c0101647:	89 04 24             	mov    %eax,(%esp)
c010164a:	e8 9b fa ff ff       	call   c01010ea <lpt_putc>
        cga_putc(c);
c010164f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101652:	89 04 24             	mov    %eax,(%esp)
c0101655:	e8 cf fa ff ff       	call   c0101129 <cga_putc>
        serial_putc(c);
c010165a:	8b 45 08             	mov    0x8(%ebp),%eax
c010165d:	89 04 24             	mov    %eax,(%esp)
c0101660:	e8 f1 fc ff ff       	call   c0101356 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101665:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101668:	89 04 24             	mov    %eax,(%esp)
c010166b:	e8 dd f7 ff ff       	call   c0100e4d <__intr_restore>
}
c0101670:	c9                   	leave  
c0101671:	c3                   	ret    

c0101672 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101672:	55                   	push   %ebp
c0101673:	89 e5                	mov    %esp,%ebp
c0101675:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101678:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c010167f:	e8 9f f7 ff ff       	call   c0100e23 <__intr_save>
c0101684:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101687:	e8 ab fd ff ff       	call   c0101437 <serial_intr>
        kbd_intr();
c010168c:	e8 4c ff ff ff       	call   c01015dd <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101691:	8b 15 60 a6 11 c0    	mov    0xc011a660,%edx
c0101697:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c010169c:	39 c2                	cmp    %eax,%edx
c010169e:	74 31                	je     c01016d1 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c01016a0:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c01016a5:	8d 50 01             	lea    0x1(%eax),%edx
c01016a8:	89 15 60 a6 11 c0    	mov    %edx,0xc011a660
c01016ae:	0f b6 80 60 a4 11 c0 	movzbl -0x3fee5ba0(%eax),%eax
c01016b5:	0f b6 c0             	movzbl %al,%eax
c01016b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01016bb:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c01016c0:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016c5:	75 0a                	jne    c01016d1 <cons_getc+0x5f>
                cons.rpos = 0;
c01016c7:	c7 05 60 a6 11 c0 00 	movl   $0x0,0xc011a660
c01016ce:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016d4:	89 04 24             	mov    %eax,(%esp)
c01016d7:	e8 71 f7 ff ff       	call   c0100e4d <__intr_restore>
    return c;
c01016dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016df:	c9                   	leave  
c01016e0:	c3                   	ret    

c01016e1 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016e1:	55                   	push   %ebp
c01016e2:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016e4:	fb                   	sti    
    sti();
}
c01016e5:	5d                   	pop    %ebp
c01016e6:	c3                   	ret    

c01016e7 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016e7:	55                   	push   %ebp
c01016e8:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016ea:	fa                   	cli    
    cli();
}
c01016eb:	5d                   	pop    %ebp
c01016ec:	c3                   	ret    

c01016ed <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016ed:	55                   	push   %ebp
c01016ee:	89 e5                	mov    %esp,%ebp
c01016f0:	83 ec 14             	sub    $0x14,%esp
c01016f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01016f6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016fa:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016fe:	66 a3 50 75 11 c0    	mov    %ax,0xc0117550
    if (did_init) {
c0101704:	a1 6c a6 11 c0       	mov    0xc011a66c,%eax
c0101709:	85 c0                	test   %eax,%eax
c010170b:	74 36                	je     c0101743 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c010170d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101711:	0f b6 c0             	movzbl %al,%eax
c0101714:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010171a:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010171d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101721:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101725:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101726:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010172a:	66 c1 e8 08          	shr    $0x8,%ax
c010172e:	0f b6 c0             	movzbl %al,%eax
c0101731:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101737:	88 45 f9             	mov    %al,-0x7(%ebp)
c010173a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010173e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101742:	ee                   	out    %al,(%dx)
    }
}
c0101743:	c9                   	leave  
c0101744:	c3                   	ret    

c0101745 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101745:	55                   	push   %ebp
c0101746:	89 e5                	mov    %esp,%ebp
c0101748:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010174b:	8b 45 08             	mov    0x8(%ebp),%eax
c010174e:	ba 01 00 00 00       	mov    $0x1,%edx
c0101753:	89 c1                	mov    %eax,%ecx
c0101755:	d3 e2                	shl    %cl,%edx
c0101757:	89 d0                	mov    %edx,%eax
c0101759:	f7 d0                	not    %eax
c010175b:	89 c2                	mov    %eax,%edx
c010175d:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101764:	21 d0                	and    %edx,%eax
c0101766:	0f b7 c0             	movzwl %ax,%eax
c0101769:	89 04 24             	mov    %eax,(%esp)
c010176c:	e8 7c ff ff ff       	call   c01016ed <pic_setmask>
}
c0101771:	c9                   	leave  
c0101772:	c3                   	ret    

c0101773 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101773:	55                   	push   %ebp
c0101774:	89 e5                	mov    %esp,%ebp
c0101776:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101779:	c7 05 6c a6 11 c0 01 	movl   $0x1,0xc011a66c
c0101780:	00 00 00 
c0101783:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101789:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010178d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101791:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101795:	ee                   	out    %al,(%dx)
c0101796:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010179c:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c01017a0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017a4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01017a8:	ee                   	out    %al,(%dx)
c01017a9:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01017af:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c01017b3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01017b7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01017bb:	ee                   	out    %al,(%dx)
c01017bc:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c01017c2:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c01017c6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01017ca:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017ce:	ee                   	out    %al,(%dx)
c01017cf:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01017d5:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017d9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017dd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017e1:	ee                   	out    %al,(%dx)
c01017e2:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017e8:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017ec:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017f0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017f4:	ee                   	out    %al,(%dx)
c01017f5:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017fb:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017ff:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101803:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101807:	ee                   	out    %al,(%dx)
c0101808:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c010180e:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0101812:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101816:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010181a:	ee                   	out    %al,(%dx)
c010181b:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0101821:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0101825:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101829:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010182d:	ee                   	out    %al,(%dx)
c010182e:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0101834:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101838:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010183c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101840:	ee                   	out    %al,(%dx)
c0101841:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101847:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c010184b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010184f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101853:	ee                   	out    %al,(%dx)
c0101854:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010185a:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c010185e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101862:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101866:	ee                   	out    %al,(%dx)
c0101867:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010186d:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101871:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101875:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101879:	ee                   	out    %al,(%dx)
c010187a:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101880:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101884:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101888:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010188c:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010188d:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101894:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101898:	74 12                	je     c01018ac <pic_init+0x139>
        pic_setmask(irq_mask);
c010189a:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c01018a1:	0f b7 c0             	movzwl %ax,%eax
c01018a4:	89 04 24             	mov    %eax,(%esp)
c01018a7:	e8 41 fe ff ff       	call   c01016ed <pic_setmask>
    }
}
c01018ac:	c9                   	leave  
c01018ad:	c3                   	ret    

c01018ae <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01018ae:	55                   	push   %ebp
c01018af:	89 e5                	mov    %esp,%ebp
c01018b1:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01018b4:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01018bb:	00 
c01018bc:	c7 04 24 a0 64 10 c0 	movl   $0xc01064a0,(%esp)
c01018c3:	e8 80 ea ff ff       	call   c0100348 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01018c8:	c9                   	leave  
c01018c9:	c3                   	ret    

c01018ca <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018ca:	55                   	push   %ebp
c01018cb:	89 e5                	mov    %esp,%ebp
c01018cd:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i = 0;
c01018d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    for(i = 0; i < 256; i++) SETGATE(idt[i], 0, GD_KTEXT , __vectors[i], DPL_KERNEL);
c01018d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018de:	e9 c3 00 00 00       	jmp    c01019a6 <idt_init+0xdc>
c01018e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e6:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c01018ed:	89 c2                	mov    %eax,%edx
c01018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f2:	66 89 14 c5 80 a6 11 	mov    %dx,-0x3fee5980(,%eax,8)
c01018f9:	c0 
c01018fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fd:	66 c7 04 c5 82 a6 11 	movw   $0x8,-0x3fee597e(,%eax,8)
c0101904:	c0 08 00 
c0101907:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010190a:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101911:	c0 
c0101912:	83 e2 e0             	and    $0xffffffe0,%edx
c0101915:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c010191c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191f:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c0101926:	c0 
c0101927:	83 e2 1f             	and    $0x1f,%edx
c010192a:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c0101931:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101934:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010193b:	c0 
c010193c:	83 e2 f0             	and    $0xfffffff0,%edx
c010193f:	83 ca 0e             	or     $0xe,%edx
c0101942:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101949:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194c:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101953:	c0 
c0101954:	83 e2 ef             	and    $0xffffffef,%edx
c0101957:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010195e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101961:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101968:	c0 
c0101969:	83 e2 9f             	and    $0xffffff9f,%edx
c010196c:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101973:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101976:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010197d:	c0 
c010197e:	83 ca 80             	or     $0xffffff80,%edx
c0101981:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101988:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010198b:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c0101992:	c1 e8 10             	shr    $0x10,%eax
c0101995:	89 c2                	mov    %eax,%edx
c0101997:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010199a:	66 89 14 c5 86 a6 11 	mov    %dx,-0x3fee597a(,%eax,8)
c01019a1:	c0 
c01019a2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01019a6:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01019ad:	0f 8e 30 ff ff ff    	jle    c01018e3 <idt_init+0x19>
    SETGATE(idt[T_SYSCALL], 0, GD_KTEXT , __vectors[T_SYSCALL], DPL_USER);
c01019b3:	a1 e0 77 11 c0       	mov    0xc01177e0,%eax
c01019b8:	66 a3 80 aa 11 c0    	mov    %ax,0xc011aa80
c01019be:	66 c7 05 82 aa 11 c0 	movw   $0x8,0xc011aa82
c01019c5:	08 00 
c01019c7:	0f b6 05 84 aa 11 c0 	movzbl 0xc011aa84,%eax
c01019ce:	83 e0 e0             	and    $0xffffffe0,%eax
c01019d1:	a2 84 aa 11 c0       	mov    %al,0xc011aa84
c01019d6:	0f b6 05 84 aa 11 c0 	movzbl 0xc011aa84,%eax
c01019dd:	83 e0 1f             	and    $0x1f,%eax
c01019e0:	a2 84 aa 11 c0       	mov    %al,0xc011aa84
c01019e5:	0f b6 05 85 aa 11 c0 	movzbl 0xc011aa85,%eax
c01019ec:	83 e0 f0             	and    $0xfffffff0,%eax
c01019ef:	83 c8 0e             	or     $0xe,%eax
c01019f2:	a2 85 aa 11 c0       	mov    %al,0xc011aa85
c01019f7:	0f b6 05 85 aa 11 c0 	movzbl 0xc011aa85,%eax
c01019fe:	83 e0 ef             	and    $0xffffffef,%eax
c0101a01:	a2 85 aa 11 c0       	mov    %al,0xc011aa85
c0101a06:	0f b6 05 85 aa 11 c0 	movzbl 0xc011aa85,%eax
c0101a0d:	83 c8 60             	or     $0x60,%eax
c0101a10:	a2 85 aa 11 c0       	mov    %al,0xc011aa85
c0101a15:	0f b6 05 85 aa 11 c0 	movzbl 0xc011aa85,%eax
c0101a1c:	83 c8 80             	or     $0xffffff80,%eax
c0101a1f:	a2 85 aa 11 c0       	mov    %al,0xc011aa85
c0101a24:	a1 e0 77 11 c0       	mov    0xc01177e0,%eax
c0101a29:	c1 e8 10             	shr    $0x10,%eax
c0101a2c:	66 a3 86 aa 11 c0    	mov    %ax,0xc011aa86
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0101a32:	a1 c4 77 11 c0       	mov    0xc01177c4,%eax
c0101a37:	66 a3 48 aa 11 c0    	mov    %ax,0xc011aa48
c0101a3d:	66 c7 05 4a aa 11 c0 	movw   $0x8,0xc011aa4a
c0101a44:	08 00 
c0101a46:	0f b6 05 4c aa 11 c0 	movzbl 0xc011aa4c,%eax
c0101a4d:	83 e0 e0             	and    $0xffffffe0,%eax
c0101a50:	a2 4c aa 11 c0       	mov    %al,0xc011aa4c
c0101a55:	0f b6 05 4c aa 11 c0 	movzbl 0xc011aa4c,%eax
c0101a5c:	83 e0 1f             	and    $0x1f,%eax
c0101a5f:	a2 4c aa 11 c0       	mov    %al,0xc011aa4c
c0101a64:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c0101a6b:	83 e0 f0             	and    $0xfffffff0,%eax
c0101a6e:	83 c8 0e             	or     $0xe,%eax
c0101a71:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a76:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c0101a7d:	83 e0 ef             	and    $0xffffffef,%eax
c0101a80:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a85:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c0101a8c:	83 c8 60             	or     $0x60,%eax
c0101a8f:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a94:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c0101a9b:	83 c8 80             	or     $0xffffff80,%eax
c0101a9e:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101aa3:	a1 c4 77 11 c0       	mov    0xc01177c4,%eax
c0101aa8:	c1 e8 10             	shr    $0x10,%eax
c0101aab:	66 a3 4e aa 11 c0    	mov    %ax,0xc011aa4e
c0101ab1:	c7 45 f8 60 75 11 c0 	movl   $0xc0117560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101ab8:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101abb:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd);
}
c0101abe:	c9                   	leave  
c0101abf:	c3                   	ret    

c0101ac0 <trapname>:

static const char *
trapname(int trapno) {
c0101ac0:	55                   	push   %ebp
c0101ac1:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101ac3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac6:	83 f8 13             	cmp    $0x13,%eax
c0101ac9:	77 0c                	ja     c0101ad7 <trapname+0x17>
        return excnames[trapno];
c0101acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ace:	8b 04 85 40 68 10 c0 	mov    -0x3fef97c0(,%eax,4),%eax
c0101ad5:	eb 18                	jmp    c0101aef <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101ad7:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101adb:	7e 0d                	jle    c0101aea <trapname+0x2a>
c0101add:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101ae1:	7f 07                	jg     c0101aea <trapname+0x2a>
        return "Hardware Interrupt";
c0101ae3:	b8 aa 64 10 c0       	mov    $0xc01064aa,%eax
c0101ae8:	eb 05                	jmp    c0101aef <trapname+0x2f>
    }
    return "(unknown trap)";
c0101aea:	b8 bd 64 10 c0       	mov    $0xc01064bd,%eax
}
c0101aef:	5d                   	pop    %ebp
c0101af0:	c3                   	ret    

c0101af1 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101af1:	55                   	push   %ebp
c0101af2:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101af4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101afb:	66 83 f8 08          	cmp    $0x8,%ax
c0101aff:	0f 94 c0             	sete   %al
c0101b02:	0f b6 c0             	movzbl %al,%eax
}
c0101b05:	5d                   	pop    %ebp
c0101b06:	c3                   	ret    

c0101b07 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101b07:	55                   	push   %ebp
c0101b08:	89 e5                	mov    %esp,%ebp
c0101b0a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101b0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b14:	c7 04 24 fe 64 10 c0 	movl   $0xc01064fe,(%esp)
c0101b1b:	e8 28 e8 ff ff       	call   c0100348 <cprintf>
    print_regs(&tf->tf_regs);
c0101b20:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b23:	89 04 24             	mov    %eax,(%esp)
c0101b26:	e8 a1 01 00 00       	call   c0101ccc <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b32:	0f b7 c0             	movzwl %ax,%eax
c0101b35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b39:	c7 04 24 0f 65 10 c0 	movl   $0xc010650f,(%esp)
c0101b40:	e8 03 e8 ff ff       	call   c0100348 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b45:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b48:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b4c:	0f b7 c0             	movzwl %ax,%eax
c0101b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b53:	c7 04 24 22 65 10 c0 	movl   $0xc0106522,(%esp)
c0101b5a:	e8 e9 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b62:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b66:	0f b7 c0             	movzwl %ax,%eax
c0101b69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b6d:	c7 04 24 35 65 10 c0 	movl   $0xc0106535,(%esp)
c0101b74:	e8 cf e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b79:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b7c:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b80:	0f b7 c0             	movzwl %ax,%eax
c0101b83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b87:	c7 04 24 48 65 10 c0 	movl   $0xc0106548,(%esp)
c0101b8e:	e8 b5 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b96:	8b 40 30             	mov    0x30(%eax),%eax
c0101b99:	89 04 24             	mov    %eax,(%esp)
c0101b9c:	e8 1f ff ff ff       	call   c0101ac0 <trapname>
c0101ba1:	8b 55 08             	mov    0x8(%ebp),%edx
c0101ba4:	8b 52 30             	mov    0x30(%edx),%edx
c0101ba7:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101bab:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101baf:	c7 04 24 5b 65 10 c0 	movl   $0xc010655b,(%esp)
c0101bb6:	e8 8d e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbe:	8b 40 34             	mov    0x34(%eax),%eax
c0101bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bc5:	c7 04 24 6d 65 10 c0 	movl   $0xc010656d,(%esp)
c0101bcc:	e8 77 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd4:	8b 40 38             	mov    0x38(%eax),%eax
c0101bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bdb:	c7 04 24 7c 65 10 c0 	movl   $0xc010657c,(%esp)
c0101be2:	e8 61 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101be7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bea:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bee:	0f b7 c0             	movzwl %ax,%eax
c0101bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf5:	c7 04 24 8b 65 10 c0 	movl   $0xc010658b,(%esp)
c0101bfc:	e8 47 e7 ff ff       	call   c0100348 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101c01:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c04:	8b 40 40             	mov    0x40(%eax),%eax
c0101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c0b:	c7 04 24 9e 65 10 c0 	movl   $0xc010659e,(%esp)
c0101c12:	e8 31 e7 ff ff       	call   c0100348 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101c1e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101c25:	eb 3e                	jmp    c0101c65 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101c27:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c2a:	8b 50 40             	mov    0x40(%eax),%edx
c0101c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c30:	21 d0                	and    %edx,%eax
c0101c32:	85 c0                	test   %eax,%eax
c0101c34:	74 28                	je     c0101c5e <print_trapframe+0x157>
c0101c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c39:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101c40:	85 c0                	test   %eax,%eax
c0101c42:	74 1a                	je     c0101c5e <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c47:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c52:	c7 04 24 ad 65 10 c0 	movl   $0xc01065ad,(%esp)
c0101c59:	e8 ea e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c5e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101c62:	d1 65 f0             	shll   -0x10(%ebp)
c0101c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c68:	83 f8 17             	cmp    $0x17,%eax
c0101c6b:	76 ba                	jbe    c0101c27 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c70:	8b 40 40             	mov    0x40(%eax),%eax
c0101c73:	25 00 30 00 00       	and    $0x3000,%eax
c0101c78:	c1 e8 0c             	shr    $0xc,%eax
c0101c7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c7f:	c7 04 24 b1 65 10 c0 	movl   $0xc01065b1,(%esp)
c0101c86:	e8 bd e6 ff ff       	call   c0100348 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8e:	89 04 24             	mov    %eax,(%esp)
c0101c91:	e8 5b fe ff ff       	call   c0101af1 <trap_in_kernel>
c0101c96:	85 c0                	test   %eax,%eax
c0101c98:	75 30                	jne    c0101cca <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c9d:	8b 40 44             	mov    0x44(%eax),%eax
c0101ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca4:	c7 04 24 ba 65 10 c0 	movl   $0xc01065ba,(%esp)
c0101cab:	e8 98 e6 ff ff       	call   c0100348 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101cb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb3:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101cb7:	0f b7 c0             	movzwl %ax,%eax
c0101cba:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cbe:	c7 04 24 c9 65 10 c0 	movl   $0xc01065c9,(%esp)
c0101cc5:	e8 7e e6 ff ff       	call   c0100348 <cprintf>
    }
}
c0101cca:	c9                   	leave  
c0101ccb:	c3                   	ret    

c0101ccc <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101ccc:	55                   	push   %ebp
c0101ccd:	89 e5                	mov    %esp,%ebp
c0101ccf:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101cd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd5:	8b 00                	mov    (%eax),%eax
c0101cd7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cdb:	c7 04 24 dc 65 10 c0 	movl   $0xc01065dc,(%esp)
c0101ce2:	e8 61 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101ce7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cea:	8b 40 04             	mov    0x4(%eax),%eax
c0101ced:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf1:	c7 04 24 eb 65 10 c0 	movl   $0xc01065eb,(%esp)
c0101cf8:	e8 4b e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101cfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d00:	8b 40 08             	mov    0x8(%eax),%eax
c0101d03:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d07:	c7 04 24 fa 65 10 c0 	movl   $0xc01065fa,(%esp)
c0101d0e:	e8 35 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101d13:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d16:	8b 40 0c             	mov    0xc(%eax),%eax
c0101d19:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d1d:	c7 04 24 09 66 10 c0 	movl   $0xc0106609,(%esp)
c0101d24:	e8 1f e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101d29:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d2c:	8b 40 10             	mov    0x10(%eax),%eax
c0101d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d33:	c7 04 24 18 66 10 c0 	movl   $0xc0106618,(%esp)
c0101d3a:	e8 09 e6 ff ff       	call   c0100348 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d42:	8b 40 14             	mov    0x14(%eax),%eax
c0101d45:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d49:	c7 04 24 27 66 10 c0 	movl   $0xc0106627,(%esp)
c0101d50:	e8 f3 e5 ff ff       	call   c0100348 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d58:	8b 40 18             	mov    0x18(%eax),%eax
c0101d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d5f:	c7 04 24 36 66 10 c0 	movl   $0xc0106636,(%esp)
c0101d66:	e8 dd e5 ff ff       	call   c0100348 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d6e:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d75:	c7 04 24 45 66 10 c0 	movl   $0xc0106645,(%esp)
c0101d7c:	e8 c7 e5 ff ff       	call   c0100348 <cprintf>
}
c0101d81:	c9                   	leave  
c0101d82:	c3                   	ret    

c0101d83 <trap_dispatch>:

struct trapframe k2u, u2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d83:	55                   	push   %ebp
c0101d84:	89 e5                	mov    %esp,%ebp
c0101d86:	57                   	push   %edi
c0101d87:	56                   	push   %esi
c0101d88:	53                   	push   %ebx
c0101d89:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d8f:	8b 40 30             	mov    0x30(%eax),%eax
c0101d92:	83 f8 24             	cmp    $0x24,%eax
c0101d95:	74 6a                	je     c0101e01 <trap_dispatch+0x7e>
c0101d97:	83 f8 24             	cmp    $0x24,%eax
c0101d9a:	77 13                	ja     c0101daf <trap_dispatch+0x2c>
c0101d9c:	83 f8 20             	cmp    $0x20,%eax
c0101d9f:	74 25                	je     c0101dc6 <trap_dispatch+0x43>
c0101da1:	83 f8 21             	cmp    $0x21,%eax
c0101da4:	0f 84 80 00 00 00    	je     c0101e2a <trap_dispatch+0xa7>
c0101daa:	e9 9c 02 00 00       	jmp    c010204b <trap_dispatch+0x2c8>
c0101daf:	83 f8 78             	cmp    $0x78,%eax
c0101db2:	0f 84 ab 01 00 00    	je     c0101f63 <trap_dispatch+0x1e0>
c0101db8:	83 f8 79             	cmp    $0x79,%eax
c0101dbb:	0f 84 19 02 00 00    	je     c0101fda <trap_dispatch+0x257>
c0101dc1:	e9 85 02 00 00       	jmp    c010204b <trap_dispatch+0x2c8>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++ != 0 ? ticks % TICK_NUM == 0 ? print_ticks() : NULL : NULL;
c0101dc6:	a1 0c af 11 c0       	mov    0xc011af0c,%eax
c0101dcb:	8d 50 01             	lea    0x1(%eax),%edx
c0101dce:	89 15 0c af 11 c0    	mov    %edx,0xc011af0c
c0101dd4:	85 c0                	test   %eax,%eax
c0101dd6:	74 24                	je     c0101dfc <trap_dispatch+0x79>
c0101dd8:	8b 0d 0c af 11 c0    	mov    0xc011af0c,%ecx
c0101dde:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101de3:	89 c8                	mov    %ecx,%eax
c0101de5:	f7 e2                	mul    %edx
c0101de7:	89 d0                	mov    %edx,%eax
c0101de9:	c1 e8 05             	shr    $0x5,%eax
c0101dec:	6b c0 64             	imul   $0x64,%eax,%eax
c0101def:	29 c1                	sub    %eax,%ecx
c0101df1:	89 c8                	mov    %ecx,%eax
c0101df3:	85 c0                	test   %eax,%eax
c0101df5:	75 05                	jne    c0101dfc <trap_dispatch+0x79>
c0101df7:	e8 b2 fa ff ff       	call   c01018ae <print_ticks>
        break;
c0101dfc:	e9 82 02 00 00       	jmp    c0102083 <trap_dispatch+0x300>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101e01:	e8 6c f8 ff ff       	call   c0101672 <cons_getc>
c0101e06:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101e09:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101e0d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101e11:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e15:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e19:	c7 04 24 54 66 10 c0 	movl   $0xc0106654,(%esp)
c0101e20:	e8 23 e5 ff ff       	call   c0100348 <cprintf>
        break;
c0101e25:	e9 59 02 00 00       	jmp    c0102083 <trap_dispatch+0x300>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101e2a:	e8 43 f8 ff ff       	call   c0101672 <cons_getc>
c0101e2f:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101e32:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101e36:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101e3a:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e3e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e42:	c7 04 24 66 66 10 c0 	movl   $0xc0106666,(%esp)
c0101e49:	e8 fa e4 ff ff       	call   c0100348 <cprintf>
        if(c == '0'){
c0101e4e:	80 7d e7 30          	cmpb   $0x30,-0x19(%ebp)
c0101e52:	0f 85 82 00 00 00    	jne    c0101eda <trap_dispatch+0x157>
            if (tf->tf_cs != KERNEL_CS) {
c0101e58:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e5b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e5f:	66 83 f8 08          	cmp    $0x8,%ax
c0101e63:	0f 84 f5 00 00 00    	je     c0101f5e <trap_dispatch+0x1db>
                cprintf("+++ switch to  kernel  mode +++\n");
c0101e69:	c7 04 24 78 66 10 c0 	movl   $0xc0106678,(%esp)
c0101e70:	e8 d3 e4 ff ff       	call   c0100348 <cprintf>
                u2k = *tf;
c0101e75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e78:	ba 80 af 11 c0       	mov    $0xc011af80,%edx
c0101e7d:	89 c3                	mov    %eax,%ebx
c0101e7f:	b8 13 00 00 00       	mov    $0x13,%eax
c0101e84:	89 d7                	mov    %edx,%edi
c0101e86:	89 de                	mov    %ebx,%esi
c0101e88:	89 c1                	mov    %eax,%ecx
c0101e8a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
                u2k.tf_cs = KERNEL_CS;
c0101e8c:	66 c7 05 bc af 11 c0 	movw   $0x8,0xc011afbc
c0101e93:	08 00 
                u2k.tf_ds = KERNEL_DS;
c0101e95:	66 c7 05 ac af 11 c0 	movw   $0x10,0xc011afac
c0101e9c:	10 00 
                u2k.tf_es = KERNEL_DS;
c0101e9e:	66 c7 05 a8 af 11 c0 	movw   $0x10,0xc011afa8
c0101ea5:	10 00 
                u2k.tf_ss = KERNEL_DS;
c0101ea7:	66 c7 05 c8 af 11 c0 	movw   $0x10,0xc011afc8
c0101eae:	10 00 
                u2k.tf_esp = tf->tf_esp;
c0101eb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101eb3:	8b 40 44             	mov    0x44(%eax),%eax
c0101eb6:	a3 c4 af 11 c0       	mov    %eax,0xc011afc4
                u2k.tf_eflags &= ~FL_IOPL_MASK;  // 保证printf正常
c0101ebb:	a1 c0 af 11 c0       	mov    0xc011afc0,%eax
c0101ec0:	80 e4 cf             	and    $0xcf,%ah
c0101ec3:	a3 c0 af 11 c0       	mov    %eax,0xc011afc0
                
                *((uint32_t *)tf - 1) = (uint32_t)&u2k;
c0101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ecb:	8d 50 fc             	lea    -0x4(%eax),%edx
c0101ece:	b8 80 af 11 c0       	mov    $0xc011af80,%eax
c0101ed3:	89 02                	mov    %eax,(%edx)
                k2u.tf_esp = tf->tf_esp;
                k2u.tf_eflags |= FL_IOPL_MASK;  // 保证printf正常
                *((uint32_t *)tf - 1) = (uint32_t)&k2u;
            }
        }
        break;
c0101ed5:	e9 a9 01 00 00       	jmp    c0102083 <trap_dispatch+0x300>
                u2k.tf_eflags &= ~FL_IOPL_MASK;  // 保证printf正常
                
                *((uint32_t *)tf - 1) = (uint32_t)&u2k;
            }
        }
        else if(c == '3')
c0101eda:	80 7d e7 33          	cmpb   $0x33,-0x19(%ebp)
c0101ede:	75 7e                	jne    c0101f5e <trap_dispatch+0x1db>
        {
            if (tf->tf_cs != USER_CS) {
c0101ee0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ee7:	66 83 f8 1b          	cmp    $0x1b,%ax
c0101eeb:	74 71                	je     c0101f5e <trap_dispatch+0x1db>
                cprintf("+++ switch to  user  mode +++\n");
c0101eed:	c7 04 24 9c 66 10 c0 	movl   $0xc010669c,(%esp)
c0101ef4:	e8 4f e4 ff ff       	call   c0100348 <cprintf>
                k2u = *tf;
c0101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101efc:	ba 20 af 11 c0       	mov    $0xc011af20,%edx
c0101f01:	89 c3                	mov    %eax,%ebx
c0101f03:	b8 13 00 00 00       	mov    $0x13,%eax
c0101f08:	89 d7                	mov    %edx,%edi
c0101f0a:	89 de                	mov    %ebx,%esi
c0101f0c:	89 c1                	mov    %eax,%ecx
c0101f0e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
                k2u.tf_cs = USER_CS;
c0101f10:	66 c7 05 5c af 11 c0 	movw   $0x1b,0xc011af5c
c0101f17:	1b 00 
                k2u.tf_ds = USER_DS;
c0101f19:	66 c7 05 4c af 11 c0 	movw   $0x23,0xc011af4c
c0101f20:	23 00 
                k2u.tf_es = USER_DS;
c0101f22:	66 c7 05 48 af 11 c0 	movw   $0x23,0xc011af48
c0101f29:	23 00 
                k2u.tf_ss = USER_DS;
c0101f2b:	66 c7 05 68 af 11 c0 	movw   $0x23,0xc011af68
c0101f32:	23 00 
                k2u.tf_esp = tf->tf_esp;
c0101f34:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f37:	8b 40 44             	mov    0x44(%eax),%eax
c0101f3a:	a3 64 af 11 c0       	mov    %eax,0xc011af64
                k2u.tf_eflags |= FL_IOPL_MASK;  // 保证printf正常
c0101f3f:	a1 60 af 11 c0       	mov    0xc011af60,%eax
c0101f44:	80 cc 30             	or     $0x30,%ah
c0101f47:	a3 60 af 11 c0       	mov    %eax,0xc011af60
                *((uint32_t *)tf - 1) = (uint32_t)&k2u;
c0101f4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f4f:	8d 50 fc             	lea    -0x4(%eax),%edx
c0101f52:	b8 20 af 11 c0       	mov    $0xc011af20,%eax
c0101f57:	89 02                	mov    %eax,(%edx)
            }
        }
        break;
c0101f59:	e9 25 01 00 00       	jmp    c0102083 <trap_dispatch+0x300>
c0101f5e:	e9 20 01 00 00       	jmp    c0102083 <trap_dispatch+0x300>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if(tf->tf_cs != USER_CS){  // 不等则切换
c0101f63:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f66:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101f6a:	66 83 f8 1b          	cmp    $0x1b,%ax
c0101f6e:	74 65                	je     c0101fd5 <trap_dispatch+0x252>
            k2u = *tf;
c0101f70:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f73:	ba 20 af 11 c0       	mov    $0xc011af20,%edx
c0101f78:	89 c3                	mov    %eax,%ebx
c0101f7a:	b8 13 00 00 00       	mov    $0x13,%eax
c0101f7f:	89 d7                	mov    %edx,%edi
c0101f81:	89 de                	mov    %ebx,%esi
c0101f83:	89 c1                	mov    %eax,%ecx
c0101f85:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            k2u.tf_cs = USER_CS;
c0101f87:	66 c7 05 5c af 11 c0 	movw   $0x1b,0xc011af5c
c0101f8e:	1b 00 
            k2u.tf_ds = USER_DS;
c0101f90:	66 c7 05 4c af 11 c0 	movw   $0x23,0xc011af4c
c0101f97:	23 00 
            k2u.tf_es = USER_DS;
c0101f99:	66 c7 05 48 af 11 c0 	movw   $0x23,0xc011af48
c0101fa0:	23 00 
            k2u.tf_ss = USER_DS;
c0101fa2:	66 c7 05 68 af 11 c0 	movw   $0x23,0xc011af68
c0101fa9:	23 00 
            k2u.tf_esp = tf->tf_esp;
c0101fab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fae:	8b 40 44             	mov    0x44(%eax),%eax
c0101fb1:	a3 64 af 11 c0       	mov    %eax,0xc011af64
            k2u.tf_eflags |= FL_IOPL_MASK;  // 保证printf正常
c0101fb6:	a1 60 af 11 c0       	mov    0xc011af60,%eax
c0101fbb:	80 cc 30             	or     $0x30,%ah
c0101fbe:	a3 60 af 11 c0       	mov    %eax,0xc011af60
            
            *((uint32_t *)tf - 1) = (uint32_t)&k2u;
c0101fc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fc6:	8d 50 fc             	lea    -0x4(%eax),%edx
c0101fc9:	b8 20 af 11 c0       	mov    $0xc011af20,%eax
c0101fce:	89 02                	mov    %eax,(%edx)
        }

        break;
c0101fd0:	e9 ae 00 00 00       	jmp    c0102083 <trap_dispatch+0x300>
c0101fd5:	e9 a9 00 00 00       	jmp    c0102083 <trap_dispatch+0x300>
    case T_SWITCH_TOK:
        if(tf->tf_cs != KERNEL_CS){  // 不等则切换
c0101fda:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fdd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101fe1:	66 83 f8 08          	cmp    $0x8,%ax
c0101fe5:	74 62                	je     c0102049 <trap_dispatch+0x2c6>
            u2k = *tf;
c0101fe7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101fea:	ba 80 af 11 c0       	mov    $0xc011af80,%edx
c0101fef:	89 c3                	mov    %eax,%ebx
c0101ff1:	b8 13 00 00 00       	mov    $0x13,%eax
c0101ff6:	89 d7                	mov    %edx,%edi
c0101ff8:	89 de                	mov    %ebx,%esi
c0101ffa:	89 c1                	mov    %eax,%ecx
c0101ffc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            u2k.tf_cs = KERNEL_CS;
c0101ffe:	66 c7 05 bc af 11 c0 	movw   $0x8,0xc011afbc
c0102005:	08 00 
            u2k.tf_ds = KERNEL_DS;
c0102007:	66 c7 05 ac af 11 c0 	movw   $0x10,0xc011afac
c010200e:	10 00 
            u2k.tf_es = KERNEL_DS;
c0102010:	66 c7 05 a8 af 11 c0 	movw   $0x10,0xc011afa8
c0102017:	10 00 
            u2k.tf_ss = KERNEL_DS;
c0102019:	66 c7 05 c8 af 11 c0 	movw   $0x10,0xc011afc8
c0102020:	10 00 
            u2k.tf_esp = tf->tf_esp;
c0102022:	8b 45 08             	mov    0x8(%ebp),%eax
c0102025:	8b 40 44             	mov    0x44(%eax),%eax
c0102028:	a3 c4 af 11 c0       	mov    %eax,0xc011afc4
            u2k.tf_eflags &= ~FL_IOPL_MASK;  // 保证printf正常
c010202d:	a1 c0 af 11 c0       	mov    0xc011afc0,%eax
c0102032:	80 e4 cf             	and    $0xcf,%ah
c0102035:	a3 c0 af 11 c0       	mov    %eax,0xc011afc0
            
            *((uint32_t *)tf - 1) = (uint32_t)&u2k;
c010203a:	8b 45 08             	mov    0x8(%ebp),%eax
c010203d:	8d 50 fc             	lea    -0x4(%eax),%edx
c0102040:	b8 80 af 11 c0       	mov    $0xc011af80,%eax
c0102045:	89 02                	mov    %eax,(%edx)

        }
        //panic("T_SWITCH_** ??\n");
        break;
c0102047:	eb 3a                	jmp    c0102083 <trap_dispatch+0x300>
c0102049:	eb 38                	jmp    c0102083 <trap_dispatch+0x300>
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c010204b:	8b 45 08             	mov    0x8(%ebp),%eax
c010204e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102052:	0f b7 c0             	movzwl %ax,%eax
c0102055:	83 e0 03             	and    $0x3,%eax
c0102058:	85 c0                	test   %eax,%eax
c010205a:	75 27                	jne    c0102083 <trap_dispatch+0x300>
            print_trapframe(tf);
c010205c:	8b 45 08             	mov    0x8(%ebp),%eax
c010205f:	89 04 24             	mov    %eax,(%esp)
c0102062:	e8 a0 fa ff ff       	call   c0101b07 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0102067:	c7 44 24 08 bb 66 10 	movl   $0xc01066bb,0x8(%esp)
c010206e:	c0 
c010206f:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0102076:	00 
c0102077:	c7 04 24 d7 66 10 c0 	movl   $0xc01066d7,(%esp)
c010207e:	e8 70 ec ff ff       	call   c0100cf3 <__panic>
        }
    }
}
c0102083:	83 c4 2c             	add    $0x2c,%esp
c0102086:	5b                   	pop    %ebx
c0102087:	5e                   	pop    %esi
c0102088:	5f                   	pop    %edi
c0102089:	5d                   	pop    %ebp
c010208a:	c3                   	ret    

c010208b <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010208b:	55                   	push   %ebp
c010208c:	89 e5                	mov    %esp,%ebp
c010208e:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102091:	8b 45 08             	mov    0x8(%ebp),%eax
c0102094:	89 04 24             	mov    %eax,(%esp)
c0102097:	e8 e7 fc ff ff       	call   c0101d83 <trap_dispatch>
}
c010209c:	c9                   	leave  
c010209d:	c3                   	ret    

c010209e <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010209e:	1e                   	push   %ds
    pushl %es
c010209f:	06                   	push   %es
    pushl %fs
c01020a0:	0f a0                	push   %fs
    pushl %gs
c01020a2:	0f a8                	push   %gs
    pushal
c01020a4:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01020a5:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01020aa:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01020ac:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01020ae:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01020af:	e8 d7 ff ff ff       	call   c010208b <trap>

    # pop the pushed stack pointer
    popl %esp
c01020b4:	5c                   	pop    %esp

c01020b5 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01020b5:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01020b6:	0f a9                	pop    %gs
    popl %fs
c01020b8:	0f a1                	pop    %fs
    popl %es
c01020ba:	07                   	pop    %es
    popl %ds
c01020bb:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01020bc:	83 c4 08             	add    $0x8,%esp
    iret
c01020bf:	cf                   	iret   

c01020c0 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c01020c0:	6a 00                	push   $0x0
  pushl $0
c01020c2:	6a 00                	push   $0x0
  jmp __alltraps
c01020c4:	e9 d5 ff ff ff       	jmp    c010209e <__alltraps>

c01020c9 <vector1>:
.globl vector1
vector1:
  pushl $0
c01020c9:	6a 00                	push   $0x0
  pushl $1
c01020cb:	6a 01                	push   $0x1
  jmp __alltraps
c01020cd:	e9 cc ff ff ff       	jmp    c010209e <__alltraps>

c01020d2 <vector2>:
.globl vector2
vector2:
  pushl $0
c01020d2:	6a 00                	push   $0x0
  pushl $2
c01020d4:	6a 02                	push   $0x2
  jmp __alltraps
c01020d6:	e9 c3 ff ff ff       	jmp    c010209e <__alltraps>

c01020db <vector3>:
.globl vector3
vector3:
  pushl $0
c01020db:	6a 00                	push   $0x0
  pushl $3
c01020dd:	6a 03                	push   $0x3
  jmp __alltraps
c01020df:	e9 ba ff ff ff       	jmp    c010209e <__alltraps>

c01020e4 <vector4>:
.globl vector4
vector4:
  pushl $0
c01020e4:	6a 00                	push   $0x0
  pushl $4
c01020e6:	6a 04                	push   $0x4
  jmp __alltraps
c01020e8:	e9 b1 ff ff ff       	jmp    c010209e <__alltraps>

c01020ed <vector5>:
.globl vector5
vector5:
  pushl $0
c01020ed:	6a 00                	push   $0x0
  pushl $5
c01020ef:	6a 05                	push   $0x5
  jmp __alltraps
c01020f1:	e9 a8 ff ff ff       	jmp    c010209e <__alltraps>

c01020f6 <vector6>:
.globl vector6
vector6:
  pushl $0
c01020f6:	6a 00                	push   $0x0
  pushl $6
c01020f8:	6a 06                	push   $0x6
  jmp __alltraps
c01020fa:	e9 9f ff ff ff       	jmp    c010209e <__alltraps>

c01020ff <vector7>:
.globl vector7
vector7:
  pushl $0
c01020ff:	6a 00                	push   $0x0
  pushl $7
c0102101:	6a 07                	push   $0x7
  jmp __alltraps
c0102103:	e9 96 ff ff ff       	jmp    c010209e <__alltraps>

c0102108 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102108:	6a 08                	push   $0x8
  jmp __alltraps
c010210a:	e9 8f ff ff ff       	jmp    c010209e <__alltraps>

c010210f <vector9>:
.globl vector9
vector9:
  pushl $0
c010210f:	6a 00                	push   $0x0
  pushl $9
c0102111:	6a 09                	push   $0x9
  jmp __alltraps
c0102113:	e9 86 ff ff ff       	jmp    c010209e <__alltraps>

c0102118 <vector10>:
.globl vector10
vector10:
  pushl $10
c0102118:	6a 0a                	push   $0xa
  jmp __alltraps
c010211a:	e9 7f ff ff ff       	jmp    c010209e <__alltraps>

c010211f <vector11>:
.globl vector11
vector11:
  pushl $11
c010211f:	6a 0b                	push   $0xb
  jmp __alltraps
c0102121:	e9 78 ff ff ff       	jmp    c010209e <__alltraps>

c0102126 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102126:	6a 0c                	push   $0xc
  jmp __alltraps
c0102128:	e9 71 ff ff ff       	jmp    c010209e <__alltraps>

c010212d <vector13>:
.globl vector13
vector13:
  pushl $13
c010212d:	6a 0d                	push   $0xd
  jmp __alltraps
c010212f:	e9 6a ff ff ff       	jmp    c010209e <__alltraps>

c0102134 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102134:	6a 0e                	push   $0xe
  jmp __alltraps
c0102136:	e9 63 ff ff ff       	jmp    c010209e <__alltraps>

c010213b <vector15>:
.globl vector15
vector15:
  pushl $0
c010213b:	6a 00                	push   $0x0
  pushl $15
c010213d:	6a 0f                	push   $0xf
  jmp __alltraps
c010213f:	e9 5a ff ff ff       	jmp    c010209e <__alltraps>

c0102144 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102144:	6a 00                	push   $0x0
  pushl $16
c0102146:	6a 10                	push   $0x10
  jmp __alltraps
c0102148:	e9 51 ff ff ff       	jmp    c010209e <__alltraps>

c010214d <vector17>:
.globl vector17
vector17:
  pushl $17
c010214d:	6a 11                	push   $0x11
  jmp __alltraps
c010214f:	e9 4a ff ff ff       	jmp    c010209e <__alltraps>

c0102154 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102154:	6a 00                	push   $0x0
  pushl $18
c0102156:	6a 12                	push   $0x12
  jmp __alltraps
c0102158:	e9 41 ff ff ff       	jmp    c010209e <__alltraps>

c010215d <vector19>:
.globl vector19
vector19:
  pushl $0
c010215d:	6a 00                	push   $0x0
  pushl $19
c010215f:	6a 13                	push   $0x13
  jmp __alltraps
c0102161:	e9 38 ff ff ff       	jmp    c010209e <__alltraps>

c0102166 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102166:	6a 00                	push   $0x0
  pushl $20
c0102168:	6a 14                	push   $0x14
  jmp __alltraps
c010216a:	e9 2f ff ff ff       	jmp    c010209e <__alltraps>

c010216f <vector21>:
.globl vector21
vector21:
  pushl $0
c010216f:	6a 00                	push   $0x0
  pushl $21
c0102171:	6a 15                	push   $0x15
  jmp __alltraps
c0102173:	e9 26 ff ff ff       	jmp    c010209e <__alltraps>

c0102178 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102178:	6a 00                	push   $0x0
  pushl $22
c010217a:	6a 16                	push   $0x16
  jmp __alltraps
c010217c:	e9 1d ff ff ff       	jmp    c010209e <__alltraps>

c0102181 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102181:	6a 00                	push   $0x0
  pushl $23
c0102183:	6a 17                	push   $0x17
  jmp __alltraps
c0102185:	e9 14 ff ff ff       	jmp    c010209e <__alltraps>

c010218a <vector24>:
.globl vector24
vector24:
  pushl $0
c010218a:	6a 00                	push   $0x0
  pushl $24
c010218c:	6a 18                	push   $0x18
  jmp __alltraps
c010218e:	e9 0b ff ff ff       	jmp    c010209e <__alltraps>

c0102193 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102193:	6a 00                	push   $0x0
  pushl $25
c0102195:	6a 19                	push   $0x19
  jmp __alltraps
c0102197:	e9 02 ff ff ff       	jmp    c010209e <__alltraps>

c010219c <vector26>:
.globl vector26
vector26:
  pushl $0
c010219c:	6a 00                	push   $0x0
  pushl $26
c010219e:	6a 1a                	push   $0x1a
  jmp __alltraps
c01021a0:	e9 f9 fe ff ff       	jmp    c010209e <__alltraps>

c01021a5 <vector27>:
.globl vector27
vector27:
  pushl $0
c01021a5:	6a 00                	push   $0x0
  pushl $27
c01021a7:	6a 1b                	push   $0x1b
  jmp __alltraps
c01021a9:	e9 f0 fe ff ff       	jmp    c010209e <__alltraps>

c01021ae <vector28>:
.globl vector28
vector28:
  pushl $0
c01021ae:	6a 00                	push   $0x0
  pushl $28
c01021b0:	6a 1c                	push   $0x1c
  jmp __alltraps
c01021b2:	e9 e7 fe ff ff       	jmp    c010209e <__alltraps>

c01021b7 <vector29>:
.globl vector29
vector29:
  pushl $0
c01021b7:	6a 00                	push   $0x0
  pushl $29
c01021b9:	6a 1d                	push   $0x1d
  jmp __alltraps
c01021bb:	e9 de fe ff ff       	jmp    c010209e <__alltraps>

c01021c0 <vector30>:
.globl vector30
vector30:
  pushl $0
c01021c0:	6a 00                	push   $0x0
  pushl $30
c01021c2:	6a 1e                	push   $0x1e
  jmp __alltraps
c01021c4:	e9 d5 fe ff ff       	jmp    c010209e <__alltraps>

c01021c9 <vector31>:
.globl vector31
vector31:
  pushl $0
c01021c9:	6a 00                	push   $0x0
  pushl $31
c01021cb:	6a 1f                	push   $0x1f
  jmp __alltraps
c01021cd:	e9 cc fe ff ff       	jmp    c010209e <__alltraps>

c01021d2 <vector32>:
.globl vector32
vector32:
  pushl $0
c01021d2:	6a 00                	push   $0x0
  pushl $32
c01021d4:	6a 20                	push   $0x20
  jmp __alltraps
c01021d6:	e9 c3 fe ff ff       	jmp    c010209e <__alltraps>

c01021db <vector33>:
.globl vector33
vector33:
  pushl $0
c01021db:	6a 00                	push   $0x0
  pushl $33
c01021dd:	6a 21                	push   $0x21
  jmp __alltraps
c01021df:	e9 ba fe ff ff       	jmp    c010209e <__alltraps>

c01021e4 <vector34>:
.globl vector34
vector34:
  pushl $0
c01021e4:	6a 00                	push   $0x0
  pushl $34
c01021e6:	6a 22                	push   $0x22
  jmp __alltraps
c01021e8:	e9 b1 fe ff ff       	jmp    c010209e <__alltraps>

c01021ed <vector35>:
.globl vector35
vector35:
  pushl $0
c01021ed:	6a 00                	push   $0x0
  pushl $35
c01021ef:	6a 23                	push   $0x23
  jmp __alltraps
c01021f1:	e9 a8 fe ff ff       	jmp    c010209e <__alltraps>

c01021f6 <vector36>:
.globl vector36
vector36:
  pushl $0
c01021f6:	6a 00                	push   $0x0
  pushl $36
c01021f8:	6a 24                	push   $0x24
  jmp __alltraps
c01021fa:	e9 9f fe ff ff       	jmp    c010209e <__alltraps>

c01021ff <vector37>:
.globl vector37
vector37:
  pushl $0
c01021ff:	6a 00                	push   $0x0
  pushl $37
c0102201:	6a 25                	push   $0x25
  jmp __alltraps
c0102203:	e9 96 fe ff ff       	jmp    c010209e <__alltraps>

c0102208 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102208:	6a 00                	push   $0x0
  pushl $38
c010220a:	6a 26                	push   $0x26
  jmp __alltraps
c010220c:	e9 8d fe ff ff       	jmp    c010209e <__alltraps>

c0102211 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102211:	6a 00                	push   $0x0
  pushl $39
c0102213:	6a 27                	push   $0x27
  jmp __alltraps
c0102215:	e9 84 fe ff ff       	jmp    c010209e <__alltraps>

c010221a <vector40>:
.globl vector40
vector40:
  pushl $0
c010221a:	6a 00                	push   $0x0
  pushl $40
c010221c:	6a 28                	push   $0x28
  jmp __alltraps
c010221e:	e9 7b fe ff ff       	jmp    c010209e <__alltraps>

c0102223 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102223:	6a 00                	push   $0x0
  pushl $41
c0102225:	6a 29                	push   $0x29
  jmp __alltraps
c0102227:	e9 72 fe ff ff       	jmp    c010209e <__alltraps>

c010222c <vector42>:
.globl vector42
vector42:
  pushl $0
c010222c:	6a 00                	push   $0x0
  pushl $42
c010222e:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102230:	e9 69 fe ff ff       	jmp    c010209e <__alltraps>

c0102235 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102235:	6a 00                	push   $0x0
  pushl $43
c0102237:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102239:	e9 60 fe ff ff       	jmp    c010209e <__alltraps>

c010223e <vector44>:
.globl vector44
vector44:
  pushl $0
c010223e:	6a 00                	push   $0x0
  pushl $44
c0102240:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102242:	e9 57 fe ff ff       	jmp    c010209e <__alltraps>

c0102247 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102247:	6a 00                	push   $0x0
  pushl $45
c0102249:	6a 2d                	push   $0x2d
  jmp __alltraps
c010224b:	e9 4e fe ff ff       	jmp    c010209e <__alltraps>

c0102250 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102250:	6a 00                	push   $0x0
  pushl $46
c0102252:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102254:	e9 45 fe ff ff       	jmp    c010209e <__alltraps>

c0102259 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102259:	6a 00                	push   $0x0
  pushl $47
c010225b:	6a 2f                	push   $0x2f
  jmp __alltraps
c010225d:	e9 3c fe ff ff       	jmp    c010209e <__alltraps>

c0102262 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102262:	6a 00                	push   $0x0
  pushl $48
c0102264:	6a 30                	push   $0x30
  jmp __alltraps
c0102266:	e9 33 fe ff ff       	jmp    c010209e <__alltraps>

c010226b <vector49>:
.globl vector49
vector49:
  pushl $0
c010226b:	6a 00                	push   $0x0
  pushl $49
c010226d:	6a 31                	push   $0x31
  jmp __alltraps
c010226f:	e9 2a fe ff ff       	jmp    c010209e <__alltraps>

c0102274 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102274:	6a 00                	push   $0x0
  pushl $50
c0102276:	6a 32                	push   $0x32
  jmp __alltraps
c0102278:	e9 21 fe ff ff       	jmp    c010209e <__alltraps>

c010227d <vector51>:
.globl vector51
vector51:
  pushl $0
c010227d:	6a 00                	push   $0x0
  pushl $51
c010227f:	6a 33                	push   $0x33
  jmp __alltraps
c0102281:	e9 18 fe ff ff       	jmp    c010209e <__alltraps>

c0102286 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102286:	6a 00                	push   $0x0
  pushl $52
c0102288:	6a 34                	push   $0x34
  jmp __alltraps
c010228a:	e9 0f fe ff ff       	jmp    c010209e <__alltraps>

c010228f <vector53>:
.globl vector53
vector53:
  pushl $0
c010228f:	6a 00                	push   $0x0
  pushl $53
c0102291:	6a 35                	push   $0x35
  jmp __alltraps
c0102293:	e9 06 fe ff ff       	jmp    c010209e <__alltraps>

c0102298 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102298:	6a 00                	push   $0x0
  pushl $54
c010229a:	6a 36                	push   $0x36
  jmp __alltraps
c010229c:	e9 fd fd ff ff       	jmp    c010209e <__alltraps>

c01022a1 <vector55>:
.globl vector55
vector55:
  pushl $0
c01022a1:	6a 00                	push   $0x0
  pushl $55
c01022a3:	6a 37                	push   $0x37
  jmp __alltraps
c01022a5:	e9 f4 fd ff ff       	jmp    c010209e <__alltraps>

c01022aa <vector56>:
.globl vector56
vector56:
  pushl $0
c01022aa:	6a 00                	push   $0x0
  pushl $56
c01022ac:	6a 38                	push   $0x38
  jmp __alltraps
c01022ae:	e9 eb fd ff ff       	jmp    c010209e <__alltraps>

c01022b3 <vector57>:
.globl vector57
vector57:
  pushl $0
c01022b3:	6a 00                	push   $0x0
  pushl $57
c01022b5:	6a 39                	push   $0x39
  jmp __alltraps
c01022b7:	e9 e2 fd ff ff       	jmp    c010209e <__alltraps>

c01022bc <vector58>:
.globl vector58
vector58:
  pushl $0
c01022bc:	6a 00                	push   $0x0
  pushl $58
c01022be:	6a 3a                	push   $0x3a
  jmp __alltraps
c01022c0:	e9 d9 fd ff ff       	jmp    c010209e <__alltraps>

c01022c5 <vector59>:
.globl vector59
vector59:
  pushl $0
c01022c5:	6a 00                	push   $0x0
  pushl $59
c01022c7:	6a 3b                	push   $0x3b
  jmp __alltraps
c01022c9:	e9 d0 fd ff ff       	jmp    c010209e <__alltraps>

c01022ce <vector60>:
.globl vector60
vector60:
  pushl $0
c01022ce:	6a 00                	push   $0x0
  pushl $60
c01022d0:	6a 3c                	push   $0x3c
  jmp __alltraps
c01022d2:	e9 c7 fd ff ff       	jmp    c010209e <__alltraps>

c01022d7 <vector61>:
.globl vector61
vector61:
  pushl $0
c01022d7:	6a 00                	push   $0x0
  pushl $61
c01022d9:	6a 3d                	push   $0x3d
  jmp __alltraps
c01022db:	e9 be fd ff ff       	jmp    c010209e <__alltraps>

c01022e0 <vector62>:
.globl vector62
vector62:
  pushl $0
c01022e0:	6a 00                	push   $0x0
  pushl $62
c01022e2:	6a 3e                	push   $0x3e
  jmp __alltraps
c01022e4:	e9 b5 fd ff ff       	jmp    c010209e <__alltraps>

c01022e9 <vector63>:
.globl vector63
vector63:
  pushl $0
c01022e9:	6a 00                	push   $0x0
  pushl $63
c01022eb:	6a 3f                	push   $0x3f
  jmp __alltraps
c01022ed:	e9 ac fd ff ff       	jmp    c010209e <__alltraps>

c01022f2 <vector64>:
.globl vector64
vector64:
  pushl $0
c01022f2:	6a 00                	push   $0x0
  pushl $64
c01022f4:	6a 40                	push   $0x40
  jmp __alltraps
c01022f6:	e9 a3 fd ff ff       	jmp    c010209e <__alltraps>

c01022fb <vector65>:
.globl vector65
vector65:
  pushl $0
c01022fb:	6a 00                	push   $0x0
  pushl $65
c01022fd:	6a 41                	push   $0x41
  jmp __alltraps
c01022ff:	e9 9a fd ff ff       	jmp    c010209e <__alltraps>

c0102304 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102304:	6a 00                	push   $0x0
  pushl $66
c0102306:	6a 42                	push   $0x42
  jmp __alltraps
c0102308:	e9 91 fd ff ff       	jmp    c010209e <__alltraps>

c010230d <vector67>:
.globl vector67
vector67:
  pushl $0
c010230d:	6a 00                	push   $0x0
  pushl $67
c010230f:	6a 43                	push   $0x43
  jmp __alltraps
c0102311:	e9 88 fd ff ff       	jmp    c010209e <__alltraps>

c0102316 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102316:	6a 00                	push   $0x0
  pushl $68
c0102318:	6a 44                	push   $0x44
  jmp __alltraps
c010231a:	e9 7f fd ff ff       	jmp    c010209e <__alltraps>

c010231f <vector69>:
.globl vector69
vector69:
  pushl $0
c010231f:	6a 00                	push   $0x0
  pushl $69
c0102321:	6a 45                	push   $0x45
  jmp __alltraps
c0102323:	e9 76 fd ff ff       	jmp    c010209e <__alltraps>

c0102328 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102328:	6a 00                	push   $0x0
  pushl $70
c010232a:	6a 46                	push   $0x46
  jmp __alltraps
c010232c:	e9 6d fd ff ff       	jmp    c010209e <__alltraps>

c0102331 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102331:	6a 00                	push   $0x0
  pushl $71
c0102333:	6a 47                	push   $0x47
  jmp __alltraps
c0102335:	e9 64 fd ff ff       	jmp    c010209e <__alltraps>

c010233a <vector72>:
.globl vector72
vector72:
  pushl $0
c010233a:	6a 00                	push   $0x0
  pushl $72
c010233c:	6a 48                	push   $0x48
  jmp __alltraps
c010233e:	e9 5b fd ff ff       	jmp    c010209e <__alltraps>

c0102343 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102343:	6a 00                	push   $0x0
  pushl $73
c0102345:	6a 49                	push   $0x49
  jmp __alltraps
c0102347:	e9 52 fd ff ff       	jmp    c010209e <__alltraps>

c010234c <vector74>:
.globl vector74
vector74:
  pushl $0
c010234c:	6a 00                	push   $0x0
  pushl $74
c010234e:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102350:	e9 49 fd ff ff       	jmp    c010209e <__alltraps>

c0102355 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102355:	6a 00                	push   $0x0
  pushl $75
c0102357:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102359:	e9 40 fd ff ff       	jmp    c010209e <__alltraps>

c010235e <vector76>:
.globl vector76
vector76:
  pushl $0
c010235e:	6a 00                	push   $0x0
  pushl $76
c0102360:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102362:	e9 37 fd ff ff       	jmp    c010209e <__alltraps>

c0102367 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102367:	6a 00                	push   $0x0
  pushl $77
c0102369:	6a 4d                	push   $0x4d
  jmp __alltraps
c010236b:	e9 2e fd ff ff       	jmp    c010209e <__alltraps>

c0102370 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102370:	6a 00                	push   $0x0
  pushl $78
c0102372:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102374:	e9 25 fd ff ff       	jmp    c010209e <__alltraps>

c0102379 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102379:	6a 00                	push   $0x0
  pushl $79
c010237b:	6a 4f                	push   $0x4f
  jmp __alltraps
c010237d:	e9 1c fd ff ff       	jmp    c010209e <__alltraps>

c0102382 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102382:	6a 00                	push   $0x0
  pushl $80
c0102384:	6a 50                	push   $0x50
  jmp __alltraps
c0102386:	e9 13 fd ff ff       	jmp    c010209e <__alltraps>

c010238b <vector81>:
.globl vector81
vector81:
  pushl $0
c010238b:	6a 00                	push   $0x0
  pushl $81
c010238d:	6a 51                	push   $0x51
  jmp __alltraps
c010238f:	e9 0a fd ff ff       	jmp    c010209e <__alltraps>

c0102394 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102394:	6a 00                	push   $0x0
  pushl $82
c0102396:	6a 52                	push   $0x52
  jmp __alltraps
c0102398:	e9 01 fd ff ff       	jmp    c010209e <__alltraps>

c010239d <vector83>:
.globl vector83
vector83:
  pushl $0
c010239d:	6a 00                	push   $0x0
  pushl $83
c010239f:	6a 53                	push   $0x53
  jmp __alltraps
c01023a1:	e9 f8 fc ff ff       	jmp    c010209e <__alltraps>

c01023a6 <vector84>:
.globl vector84
vector84:
  pushl $0
c01023a6:	6a 00                	push   $0x0
  pushl $84
c01023a8:	6a 54                	push   $0x54
  jmp __alltraps
c01023aa:	e9 ef fc ff ff       	jmp    c010209e <__alltraps>

c01023af <vector85>:
.globl vector85
vector85:
  pushl $0
c01023af:	6a 00                	push   $0x0
  pushl $85
c01023b1:	6a 55                	push   $0x55
  jmp __alltraps
c01023b3:	e9 e6 fc ff ff       	jmp    c010209e <__alltraps>

c01023b8 <vector86>:
.globl vector86
vector86:
  pushl $0
c01023b8:	6a 00                	push   $0x0
  pushl $86
c01023ba:	6a 56                	push   $0x56
  jmp __alltraps
c01023bc:	e9 dd fc ff ff       	jmp    c010209e <__alltraps>

c01023c1 <vector87>:
.globl vector87
vector87:
  pushl $0
c01023c1:	6a 00                	push   $0x0
  pushl $87
c01023c3:	6a 57                	push   $0x57
  jmp __alltraps
c01023c5:	e9 d4 fc ff ff       	jmp    c010209e <__alltraps>

c01023ca <vector88>:
.globl vector88
vector88:
  pushl $0
c01023ca:	6a 00                	push   $0x0
  pushl $88
c01023cc:	6a 58                	push   $0x58
  jmp __alltraps
c01023ce:	e9 cb fc ff ff       	jmp    c010209e <__alltraps>

c01023d3 <vector89>:
.globl vector89
vector89:
  pushl $0
c01023d3:	6a 00                	push   $0x0
  pushl $89
c01023d5:	6a 59                	push   $0x59
  jmp __alltraps
c01023d7:	e9 c2 fc ff ff       	jmp    c010209e <__alltraps>

c01023dc <vector90>:
.globl vector90
vector90:
  pushl $0
c01023dc:	6a 00                	push   $0x0
  pushl $90
c01023de:	6a 5a                	push   $0x5a
  jmp __alltraps
c01023e0:	e9 b9 fc ff ff       	jmp    c010209e <__alltraps>

c01023e5 <vector91>:
.globl vector91
vector91:
  pushl $0
c01023e5:	6a 00                	push   $0x0
  pushl $91
c01023e7:	6a 5b                	push   $0x5b
  jmp __alltraps
c01023e9:	e9 b0 fc ff ff       	jmp    c010209e <__alltraps>

c01023ee <vector92>:
.globl vector92
vector92:
  pushl $0
c01023ee:	6a 00                	push   $0x0
  pushl $92
c01023f0:	6a 5c                	push   $0x5c
  jmp __alltraps
c01023f2:	e9 a7 fc ff ff       	jmp    c010209e <__alltraps>

c01023f7 <vector93>:
.globl vector93
vector93:
  pushl $0
c01023f7:	6a 00                	push   $0x0
  pushl $93
c01023f9:	6a 5d                	push   $0x5d
  jmp __alltraps
c01023fb:	e9 9e fc ff ff       	jmp    c010209e <__alltraps>

c0102400 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102400:	6a 00                	push   $0x0
  pushl $94
c0102402:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102404:	e9 95 fc ff ff       	jmp    c010209e <__alltraps>

c0102409 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102409:	6a 00                	push   $0x0
  pushl $95
c010240b:	6a 5f                	push   $0x5f
  jmp __alltraps
c010240d:	e9 8c fc ff ff       	jmp    c010209e <__alltraps>

c0102412 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102412:	6a 00                	push   $0x0
  pushl $96
c0102414:	6a 60                	push   $0x60
  jmp __alltraps
c0102416:	e9 83 fc ff ff       	jmp    c010209e <__alltraps>

c010241b <vector97>:
.globl vector97
vector97:
  pushl $0
c010241b:	6a 00                	push   $0x0
  pushl $97
c010241d:	6a 61                	push   $0x61
  jmp __alltraps
c010241f:	e9 7a fc ff ff       	jmp    c010209e <__alltraps>

c0102424 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102424:	6a 00                	push   $0x0
  pushl $98
c0102426:	6a 62                	push   $0x62
  jmp __alltraps
c0102428:	e9 71 fc ff ff       	jmp    c010209e <__alltraps>

c010242d <vector99>:
.globl vector99
vector99:
  pushl $0
c010242d:	6a 00                	push   $0x0
  pushl $99
c010242f:	6a 63                	push   $0x63
  jmp __alltraps
c0102431:	e9 68 fc ff ff       	jmp    c010209e <__alltraps>

c0102436 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102436:	6a 00                	push   $0x0
  pushl $100
c0102438:	6a 64                	push   $0x64
  jmp __alltraps
c010243a:	e9 5f fc ff ff       	jmp    c010209e <__alltraps>

c010243f <vector101>:
.globl vector101
vector101:
  pushl $0
c010243f:	6a 00                	push   $0x0
  pushl $101
c0102441:	6a 65                	push   $0x65
  jmp __alltraps
c0102443:	e9 56 fc ff ff       	jmp    c010209e <__alltraps>

c0102448 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102448:	6a 00                	push   $0x0
  pushl $102
c010244a:	6a 66                	push   $0x66
  jmp __alltraps
c010244c:	e9 4d fc ff ff       	jmp    c010209e <__alltraps>

c0102451 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102451:	6a 00                	push   $0x0
  pushl $103
c0102453:	6a 67                	push   $0x67
  jmp __alltraps
c0102455:	e9 44 fc ff ff       	jmp    c010209e <__alltraps>

c010245a <vector104>:
.globl vector104
vector104:
  pushl $0
c010245a:	6a 00                	push   $0x0
  pushl $104
c010245c:	6a 68                	push   $0x68
  jmp __alltraps
c010245e:	e9 3b fc ff ff       	jmp    c010209e <__alltraps>

c0102463 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102463:	6a 00                	push   $0x0
  pushl $105
c0102465:	6a 69                	push   $0x69
  jmp __alltraps
c0102467:	e9 32 fc ff ff       	jmp    c010209e <__alltraps>

c010246c <vector106>:
.globl vector106
vector106:
  pushl $0
c010246c:	6a 00                	push   $0x0
  pushl $106
c010246e:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102470:	e9 29 fc ff ff       	jmp    c010209e <__alltraps>

c0102475 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102475:	6a 00                	push   $0x0
  pushl $107
c0102477:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102479:	e9 20 fc ff ff       	jmp    c010209e <__alltraps>

c010247e <vector108>:
.globl vector108
vector108:
  pushl $0
c010247e:	6a 00                	push   $0x0
  pushl $108
c0102480:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102482:	e9 17 fc ff ff       	jmp    c010209e <__alltraps>

c0102487 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102487:	6a 00                	push   $0x0
  pushl $109
c0102489:	6a 6d                	push   $0x6d
  jmp __alltraps
c010248b:	e9 0e fc ff ff       	jmp    c010209e <__alltraps>

c0102490 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102490:	6a 00                	push   $0x0
  pushl $110
c0102492:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102494:	e9 05 fc ff ff       	jmp    c010209e <__alltraps>

c0102499 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102499:	6a 00                	push   $0x0
  pushl $111
c010249b:	6a 6f                	push   $0x6f
  jmp __alltraps
c010249d:	e9 fc fb ff ff       	jmp    c010209e <__alltraps>

c01024a2 <vector112>:
.globl vector112
vector112:
  pushl $0
c01024a2:	6a 00                	push   $0x0
  pushl $112
c01024a4:	6a 70                	push   $0x70
  jmp __alltraps
c01024a6:	e9 f3 fb ff ff       	jmp    c010209e <__alltraps>

c01024ab <vector113>:
.globl vector113
vector113:
  pushl $0
c01024ab:	6a 00                	push   $0x0
  pushl $113
c01024ad:	6a 71                	push   $0x71
  jmp __alltraps
c01024af:	e9 ea fb ff ff       	jmp    c010209e <__alltraps>

c01024b4 <vector114>:
.globl vector114
vector114:
  pushl $0
c01024b4:	6a 00                	push   $0x0
  pushl $114
c01024b6:	6a 72                	push   $0x72
  jmp __alltraps
c01024b8:	e9 e1 fb ff ff       	jmp    c010209e <__alltraps>

c01024bd <vector115>:
.globl vector115
vector115:
  pushl $0
c01024bd:	6a 00                	push   $0x0
  pushl $115
c01024bf:	6a 73                	push   $0x73
  jmp __alltraps
c01024c1:	e9 d8 fb ff ff       	jmp    c010209e <__alltraps>

c01024c6 <vector116>:
.globl vector116
vector116:
  pushl $0
c01024c6:	6a 00                	push   $0x0
  pushl $116
c01024c8:	6a 74                	push   $0x74
  jmp __alltraps
c01024ca:	e9 cf fb ff ff       	jmp    c010209e <__alltraps>

c01024cf <vector117>:
.globl vector117
vector117:
  pushl $0
c01024cf:	6a 00                	push   $0x0
  pushl $117
c01024d1:	6a 75                	push   $0x75
  jmp __alltraps
c01024d3:	e9 c6 fb ff ff       	jmp    c010209e <__alltraps>

c01024d8 <vector118>:
.globl vector118
vector118:
  pushl $0
c01024d8:	6a 00                	push   $0x0
  pushl $118
c01024da:	6a 76                	push   $0x76
  jmp __alltraps
c01024dc:	e9 bd fb ff ff       	jmp    c010209e <__alltraps>

c01024e1 <vector119>:
.globl vector119
vector119:
  pushl $0
c01024e1:	6a 00                	push   $0x0
  pushl $119
c01024e3:	6a 77                	push   $0x77
  jmp __alltraps
c01024e5:	e9 b4 fb ff ff       	jmp    c010209e <__alltraps>

c01024ea <vector120>:
.globl vector120
vector120:
  pushl $0
c01024ea:	6a 00                	push   $0x0
  pushl $120
c01024ec:	6a 78                	push   $0x78
  jmp __alltraps
c01024ee:	e9 ab fb ff ff       	jmp    c010209e <__alltraps>

c01024f3 <vector121>:
.globl vector121
vector121:
  pushl $0
c01024f3:	6a 00                	push   $0x0
  pushl $121
c01024f5:	6a 79                	push   $0x79
  jmp __alltraps
c01024f7:	e9 a2 fb ff ff       	jmp    c010209e <__alltraps>

c01024fc <vector122>:
.globl vector122
vector122:
  pushl $0
c01024fc:	6a 00                	push   $0x0
  pushl $122
c01024fe:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102500:	e9 99 fb ff ff       	jmp    c010209e <__alltraps>

c0102505 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102505:	6a 00                	push   $0x0
  pushl $123
c0102507:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102509:	e9 90 fb ff ff       	jmp    c010209e <__alltraps>

c010250e <vector124>:
.globl vector124
vector124:
  pushl $0
c010250e:	6a 00                	push   $0x0
  pushl $124
c0102510:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102512:	e9 87 fb ff ff       	jmp    c010209e <__alltraps>

c0102517 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102517:	6a 00                	push   $0x0
  pushl $125
c0102519:	6a 7d                	push   $0x7d
  jmp __alltraps
c010251b:	e9 7e fb ff ff       	jmp    c010209e <__alltraps>

c0102520 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102520:	6a 00                	push   $0x0
  pushl $126
c0102522:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102524:	e9 75 fb ff ff       	jmp    c010209e <__alltraps>

c0102529 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102529:	6a 00                	push   $0x0
  pushl $127
c010252b:	6a 7f                	push   $0x7f
  jmp __alltraps
c010252d:	e9 6c fb ff ff       	jmp    c010209e <__alltraps>

c0102532 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102532:	6a 00                	push   $0x0
  pushl $128
c0102534:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102539:	e9 60 fb ff ff       	jmp    c010209e <__alltraps>

c010253e <vector129>:
.globl vector129
vector129:
  pushl $0
c010253e:	6a 00                	push   $0x0
  pushl $129
c0102540:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102545:	e9 54 fb ff ff       	jmp    c010209e <__alltraps>

c010254a <vector130>:
.globl vector130
vector130:
  pushl $0
c010254a:	6a 00                	push   $0x0
  pushl $130
c010254c:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102551:	e9 48 fb ff ff       	jmp    c010209e <__alltraps>

c0102556 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102556:	6a 00                	push   $0x0
  pushl $131
c0102558:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010255d:	e9 3c fb ff ff       	jmp    c010209e <__alltraps>

c0102562 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102562:	6a 00                	push   $0x0
  pushl $132
c0102564:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102569:	e9 30 fb ff ff       	jmp    c010209e <__alltraps>

c010256e <vector133>:
.globl vector133
vector133:
  pushl $0
c010256e:	6a 00                	push   $0x0
  pushl $133
c0102570:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102575:	e9 24 fb ff ff       	jmp    c010209e <__alltraps>

c010257a <vector134>:
.globl vector134
vector134:
  pushl $0
c010257a:	6a 00                	push   $0x0
  pushl $134
c010257c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102581:	e9 18 fb ff ff       	jmp    c010209e <__alltraps>

c0102586 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102586:	6a 00                	push   $0x0
  pushl $135
c0102588:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010258d:	e9 0c fb ff ff       	jmp    c010209e <__alltraps>

c0102592 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102592:	6a 00                	push   $0x0
  pushl $136
c0102594:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102599:	e9 00 fb ff ff       	jmp    c010209e <__alltraps>

c010259e <vector137>:
.globl vector137
vector137:
  pushl $0
c010259e:	6a 00                	push   $0x0
  pushl $137
c01025a0:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01025a5:	e9 f4 fa ff ff       	jmp    c010209e <__alltraps>

c01025aa <vector138>:
.globl vector138
vector138:
  pushl $0
c01025aa:	6a 00                	push   $0x0
  pushl $138
c01025ac:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01025b1:	e9 e8 fa ff ff       	jmp    c010209e <__alltraps>

c01025b6 <vector139>:
.globl vector139
vector139:
  pushl $0
c01025b6:	6a 00                	push   $0x0
  pushl $139
c01025b8:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01025bd:	e9 dc fa ff ff       	jmp    c010209e <__alltraps>

c01025c2 <vector140>:
.globl vector140
vector140:
  pushl $0
c01025c2:	6a 00                	push   $0x0
  pushl $140
c01025c4:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01025c9:	e9 d0 fa ff ff       	jmp    c010209e <__alltraps>

c01025ce <vector141>:
.globl vector141
vector141:
  pushl $0
c01025ce:	6a 00                	push   $0x0
  pushl $141
c01025d0:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01025d5:	e9 c4 fa ff ff       	jmp    c010209e <__alltraps>

c01025da <vector142>:
.globl vector142
vector142:
  pushl $0
c01025da:	6a 00                	push   $0x0
  pushl $142
c01025dc:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01025e1:	e9 b8 fa ff ff       	jmp    c010209e <__alltraps>

c01025e6 <vector143>:
.globl vector143
vector143:
  pushl $0
c01025e6:	6a 00                	push   $0x0
  pushl $143
c01025e8:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01025ed:	e9 ac fa ff ff       	jmp    c010209e <__alltraps>

c01025f2 <vector144>:
.globl vector144
vector144:
  pushl $0
c01025f2:	6a 00                	push   $0x0
  pushl $144
c01025f4:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01025f9:	e9 a0 fa ff ff       	jmp    c010209e <__alltraps>

c01025fe <vector145>:
.globl vector145
vector145:
  pushl $0
c01025fe:	6a 00                	push   $0x0
  pushl $145
c0102600:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102605:	e9 94 fa ff ff       	jmp    c010209e <__alltraps>

c010260a <vector146>:
.globl vector146
vector146:
  pushl $0
c010260a:	6a 00                	push   $0x0
  pushl $146
c010260c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102611:	e9 88 fa ff ff       	jmp    c010209e <__alltraps>

c0102616 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102616:	6a 00                	push   $0x0
  pushl $147
c0102618:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010261d:	e9 7c fa ff ff       	jmp    c010209e <__alltraps>

c0102622 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102622:	6a 00                	push   $0x0
  pushl $148
c0102624:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102629:	e9 70 fa ff ff       	jmp    c010209e <__alltraps>

c010262e <vector149>:
.globl vector149
vector149:
  pushl $0
c010262e:	6a 00                	push   $0x0
  pushl $149
c0102630:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102635:	e9 64 fa ff ff       	jmp    c010209e <__alltraps>

c010263a <vector150>:
.globl vector150
vector150:
  pushl $0
c010263a:	6a 00                	push   $0x0
  pushl $150
c010263c:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102641:	e9 58 fa ff ff       	jmp    c010209e <__alltraps>

c0102646 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102646:	6a 00                	push   $0x0
  pushl $151
c0102648:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010264d:	e9 4c fa ff ff       	jmp    c010209e <__alltraps>

c0102652 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102652:	6a 00                	push   $0x0
  pushl $152
c0102654:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102659:	e9 40 fa ff ff       	jmp    c010209e <__alltraps>

c010265e <vector153>:
.globl vector153
vector153:
  pushl $0
c010265e:	6a 00                	push   $0x0
  pushl $153
c0102660:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102665:	e9 34 fa ff ff       	jmp    c010209e <__alltraps>

c010266a <vector154>:
.globl vector154
vector154:
  pushl $0
c010266a:	6a 00                	push   $0x0
  pushl $154
c010266c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102671:	e9 28 fa ff ff       	jmp    c010209e <__alltraps>

c0102676 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102676:	6a 00                	push   $0x0
  pushl $155
c0102678:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010267d:	e9 1c fa ff ff       	jmp    c010209e <__alltraps>

c0102682 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102682:	6a 00                	push   $0x0
  pushl $156
c0102684:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102689:	e9 10 fa ff ff       	jmp    c010209e <__alltraps>

c010268e <vector157>:
.globl vector157
vector157:
  pushl $0
c010268e:	6a 00                	push   $0x0
  pushl $157
c0102690:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102695:	e9 04 fa ff ff       	jmp    c010209e <__alltraps>

c010269a <vector158>:
.globl vector158
vector158:
  pushl $0
c010269a:	6a 00                	push   $0x0
  pushl $158
c010269c:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c01026a1:	e9 f8 f9 ff ff       	jmp    c010209e <__alltraps>

c01026a6 <vector159>:
.globl vector159
vector159:
  pushl $0
c01026a6:	6a 00                	push   $0x0
  pushl $159
c01026a8:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01026ad:	e9 ec f9 ff ff       	jmp    c010209e <__alltraps>

c01026b2 <vector160>:
.globl vector160
vector160:
  pushl $0
c01026b2:	6a 00                	push   $0x0
  pushl $160
c01026b4:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01026b9:	e9 e0 f9 ff ff       	jmp    c010209e <__alltraps>

c01026be <vector161>:
.globl vector161
vector161:
  pushl $0
c01026be:	6a 00                	push   $0x0
  pushl $161
c01026c0:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01026c5:	e9 d4 f9 ff ff       	jmp    c010209e <__alltraps>

c01026ca <vector162>:
.globl vector162
vector162:
  pushl $0
c01026ca:	6a 00                	push   $0x0
  pushl $162
c01026cc:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01026d1:	e9 c8 f9 ff ff       	jmp    c010209e <__alltraps>

c01026d6 <vector163>:
.globl vector163
vector163:
  pushl $0
c01026d6:	6a 00                	push   $0x0
  pushl $163
c01026d8:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01026dd:	e9 bc f9 ff ff       	jmp    c010209e <__alltraps>

c01026e2 <vector164>:
.globl vector164
vector164:
  pushl $0
c01026e2:	6a 00                	push   $0x0
  pushl $164
c01026e4:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01026e9:	e9 b0 f9 ff ff       	jmp    c010209e <__alltraps>

c01026ee <vector165>:
.globl vector165
vector165:
  pushl $0
c01026ee:	6a 00                	push   $0x0
  pushl $165
c01026f0:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01026f5:	e9 a4 f9 ff ff       	jmp    c010209e <__alltraps>

c01026fa <vector166>:
.globl vector166
vector166:
  pushl $0
c01026fa:	6a 00                	push   $0x0
  pushl $166
c01026fc:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102701:	e9 98 f9 ff ff       	jmp    c010209e <__alltraps>

c0102706 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102706:	6a 00                	push   $0x0
  pushl $167
c0102708:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010270d:	e9 8c f9 ff ff       	jmp    c010209e <__alltraps>

c0102712 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102712:	6a 00                	push   $0x0
  pushl $168
c0102714:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102719:	e9 80 f9 ff ff       	jmp    c010209e <__alltraps>

c010271e <vector169>:
.globl vector169
vector169:
  pushl $0
c010271e:	6a 00                	push   $0x0
  pushl $169
c0102720:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102725:	e9 74 f9 ff ff       	jmp    c010209e <__alltraps>

c010272a <vector170>:
.globl vector170
vector170:
  pushl $0
c010272a:	6a 00                	push   $0x0
  pushl $170
c010272c:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102731:	e9 68 f9 ff ff       	jmp    c010209e <__alltraps>

c0102736 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102736:	6a 00                	push   $0x0
  pushl $171
c0102738:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010273d:	e9 5c f9 ff ff       	jmp    c010209e <__alltraps>

c0102742 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102742:	6a 00                	push   $0x0
  pushl $172
c0102744:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102749:	e9 50 f9 ff ff       	jmp    c010209e <__alltraps>

c010274e <vector173>:
.globl vector173
vector173:
  pushl $0
c010274e:	6a 00                	push   $0x0
  pushl $173
c0102750:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102755:	e9 44 f9 ff ff       	jmp    c010209e <__alltraps>

c010275a <vector174>:
.globl vector174
vector174:
  pushl $0
c010275a:	6a 00                	push   $0x0
  pushl $174
c010275c:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102761:	e9 38 f9 ff ff       	jmp    c010209e <__alltraps>

c0102766 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102766:	6a 00                	push   $0x0
  pushl $175
c0102768:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010276d:	e9 2c f9 ff ff       	jmp    c010209e <__alltraps>

c0102772 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102772:	6a 00                	push   $0x0
  pushl $176
c0102774:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102779:	e9 20 f9 ff ff       	jmp    c010209e <__alltraps>

c010277e <vector177>:
.globl vector177
vector177:
  pushl $0
c010277e:	6a 00                	push   $0x0
  pushl $177
c0102780:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102785:	e9 14 f9 ff ff       	jmp    c010209e <__alltraps>

c010278a <vector178>:
.globl vector178
vector178:
  pushl $0
c010278a:	6a 00                	push   $0x0
  pushl $178
c010278c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102791:	e9 08 f9 ff ff       	jmp    c010209e <__alltraps>

c0102796 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102796:	6a 00                	push   $0x0
  pushl $179
c0102798:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010279d:	e9 fc f8 ff ff       	jmp    c010209e <__alltraps>

c01027a2 <vector180>:
.globl vector180
vector180:
  pushl $0
c01027a2:	6a 00                	push   $0x0
  pushl $180
c01027a4:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01027a9:	e9 f0 f8 ff ff       	jmp    c010209e <__alltraps>

c01027ae <vector181>:
.globl vector181
vector181:
  pushl $0
c01027ae:	6a 00                	push   $0x0
  pushl $181
c01027b0:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01027b5:	e9 e4 f8 ff ff       	jmp    c010209e <__alltraps>

c01027ba <vector182>:
.globl vector182
vector182:
  pushl $0
c01027ba:	6a 00                	push   $0x0
  pushl $182
c01027bc:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01027c1:	e9 d8 f8 ff ff       	jmp    c010209e <__alltraps>

c01027c6 <vector183>:
.globl vector183
vector183:
  pushl $0
c01027c6:	6a 00                	push   $0x0
  pushl $183
c01027c8:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01027cd:	e9 cc f8 ff ff       	jmp    c010209e <__alltraps>

c01027d2 <vector184>:
.globl vector184
vector184:
  pushl $0
c01027d2:	6a 00                	push   $0x0
  pushl $184
c01027d4:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01027d9:	e9 c0 f8 ff ff       	jmp    c010209e <__alltraps>

c01027de <vector185>:
.globl vector185
vector185:
  pushl $0
c01027de:	6a 00                	push   $0x0
  pushl $185
c01027e0:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01027e5:	e9 b4 f8 ff ff       	jmp    c010209e <__alltraps>

c01027ea <vector186>:
.globl vector186
vector186:
  pushl $0
c01027ea:	6a 00                	push   $0x0
  pushl $186
c01027ec:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01027f1:	e9 a8 f8 ff ff       	jmp    c010209e <__alltraps>

c01027f6 <vector187>:
.globl vector187
vector187:
  pushl $0
c01027f6:	6a 00                	push   $0x0
  pushl $187
c01027f8:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01027fd:	e9 9c f8 ff ff       	jmp    c010209e <__alltraps>

c0102802 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102802:	6a 00                	push   $0x0
  pushl $188
c0102804:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102809:	e9 90 f8 ff ff       	jmp    c010209e <__alltraps>

c010280e <vector189>:
.globl vector189
vector189:
  pushl $0
c010280e:	6a 00                	push   $0x0
  pushl $189
c0102810:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102815:	e9 84 f8 ff ff       	jmp    c010209e <__alltraps>

c010281a <vector190>:
.globl vector190
vector190:
  pushl $0
c010281a:	6a 00                	push   $0x0
  pushl $190
c010281c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102821:	e9 78 f8 ff ff       	jmp    c010209e <__alltraps>

c0102826 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102826:	6a 00                	push   $0x0
  pushl $191
c0102828:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010282d:	e9 6c f8 ff ff       	jmp    c010209e <__alltraps>

c0102832 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102832:	6a 00                	push   $0x0
  pushl $192
c0102834:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102839:	e9 60 f8 ff ff       	jmp    c010209e <__alltraps>

c010283e <vector193>:
.globl vector193
vector193:
  pushl $0
c010283e:	6a 00                	push   $0x0
  pushl $193
c0102840:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102845:	e9 54 f8 ff ff       	jmp    c010209e <__alltraps>

c010284a <vector194>:
.globl vector194
vector194:
  pushl $0
c010284a:	6a 00                	push   $0x0
  pushl $194
c010284c:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102851:	e9 48 f8 ff ff       	jmp    c010209e <__alltraps>

c0102856 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102856:	6a 00                	push   $0x0
  pushl $195
c0102858:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010285d:	e9 3c f8 ff ff       	jmp    c010209e <__alltraps>

c0102862 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102862:	6a 00                	push   $0x0
  pushl $196
c0102864:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102869:	e9 30 f8 ff ff       	jmp    c010209e <__alltraps>

c010286e <vector197>:
.globl vector197
vector197:
  pushl $0
c010286e:	6a 00                	push   $0x0
  pushl $197
c0102870:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102875:	e9 24 f8 ff ff       	jmp    c010209e <__alltraps>

c010287a <vector198>:
.globl vector198
vector198:
  pushl $0
c010287a:	6a 00                	push   $0x0
  pushl $198
c010287c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102881:	e9 18 f8 ff ff       	jmp    c010209e <__alltraps>

c0102886 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102886:	6a 00                	push   $0x0
  pushl $199
c0102888:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010288d:	e9 0c f8 ff ff       	jmp    c010209e <__alltraps>

c0102892 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102892:	6a 00                	push   $0x0
  pushl $200
c0102894:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102899:	e9 00 f8 ff ff       	jmp    c010209e <__alltraps>

c010289e <vector201>:
.globl vector201
vector201:
  pushl $0
c010289e:	6a 00                	push   $0x0
  pushl $201
c01028a0:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01028a5:	e9 f4 f7 ff ff       	jmp    c010209e <__alltraps>

c01028aa <vector202>:
.globl vector202
vector202:
  pushl $0
c01028aa:	6a 00                	push   $0x0
  pushl $202
c01028ac:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01028b1:	e9 e8 f7 ff ff       	jmp    c010209e <__alltraps>

c01028b6 <vector203>:
.globl vector203
vector203:
  pushl $0
c01028b6:	6a 00                	push   $0x0
  pushl $203
c01028b8:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01028bd:	e9 dc f7 ff ff       	jmp    c010209e <__alltraps>

c01028c2 <vector204>:
.globl vector204
vector204:
  pushl $0
c01028c2:	6a 00                	push   $0x0
  pushl $204
c01028c4:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01028c9:	e9 d0 f7 ff ff       	jmp    c010209e <__alltraps>

c01028ce <vector205>:
.globl vector205
vector205:
  pushl $0
c01028ce:	6a 00                	push   $0x0
  pushl $205
c01028d0:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01028d5:	e9 c4 f7 ff ff       	jmp    c010209e <__alltraps>

c01028da <vector206>:
.globl vector206
vector206:
  pushl $0
c01028da:	6a 00                	push   $0x0
  pushl $206
c01028dc:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01028e1:	e9 b8 f7 ff ff       	jmp    c010209e <__alltraps>

c01028e6 <vector207>:
.globl vector207
vector207:
  pushl $0
c01028e6:	6a 00                	push   $0x0
  pushl $207
c01028e8:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01028ed:	e9 ac f7 ff ff       	jmp    c010209e <__alltraps>

c01028f2 <vector208>:
.globl vector208
vector208:
  pushl $0
c01028f2:	6a 00                	push   $0x0
  pushl $208
c01028f4:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01028f9:	e9 a0 f7 ff ff       	jmp    c010209e <__alltraps>

c01028fe <vector209>:
.globl vector209
vector209:
  pushl $0
c01028fe:	6a 00                	push   $0x0
  pushl $209
c0102900:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102905:	e9 94 f7 ff ff       	jmp    c010209e <__alltraps>

c010290a <vector210>:
.globl vector210
vector210:
  pushl $0
c010290a:	6a 00                	push   $0x0
  pushl $210
c010290c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102911:	e9 88 f7 ff ff       	jmp    c010209e <__alltraps>

c0102916 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102916:	6a 00                	push   $0x0
  pushl $211
c0102918:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010291d:	e9 7c f7 ff ff       	jmp    c010209e <__alltraps>

c0102922 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102922:	6a 00                	push   $0x0
  pushl $212
c0102924:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102929:	e9 70 f7 ff ff       	jmp    c010209e <__alltraps>

c010292e <vector213>:
.globl vector213
vector213:
  pushl $0
c010292e:	6a 00                	push   $0x0
  pushl $213
c0102930:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102935:	e9 64 f7 ff ff       	jmp    c010209e <__alltraps>

c010293a <vector214>:
.globl vector214
vector214:
  pushl $0
c010293a:	6a 00                	push   $0x0
  pushl $214
c010293c:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102941:	e9 58 f7 ff ff       	jmp    c010209e <__alltraps>

c0102946 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102946:	6a 00                	push   $0x0
  pushl $215
c0102948:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010294d:	e9 4c f7 ff ff       	jmp    c010209e <__alltraps>

c0102952 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102952:	6a 00                	push   $0x0
  pushl $216
c0102954:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102959:	e9 40 f7 ff ff       	jmp    c010209e <__alltraps>

c010295e <vector217>:
.globl vector217
vector217:
  pushl $0
c010295e:	6a 00                	push   $0x0
  pushl $217
c0102960:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102965:	e9 34 f7 ff ff       	jmp    c010209e <__alltraps>

c010296a <vector218>:
.globl vector218
vector218:
  pushl $0
c010296a:	6a 00                	push   $0x0
  pushl $218
c010296c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102971:	e9 28 f7 ff ff       	jmp    c010209e <__alltraps>

c0102976 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102976:	6a 00                	push   $0x0
  pushl $219
c0102978:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010297d:	e9 1c f7 ff ff       	jmp    c010209e <__alltraps>

c0102982 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102982:	6a 00                	push   $0x0
  pushl $220
c0102984:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102989:	e9 10 f7 ff ff       	jmp    c010209e <__alltraps>

c010298e <vector221>:
.globl vector221
vector221:
  pushl $0
c010298e:	6a 00                	push   $0x0
  pushl $221
c0102990:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102995:	e9 04 f7 ff ff       	jmp    c010209e <__alltraps>

c010299a <vector222>:
.globl vector222
vector222:
  pushl $0
c010299a:	6a 00                	push   $0x0
  pushl $222
c010299c:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01029a1:	e9 f8 f6 ff ff       	jmp    c010209e <__alltraps>

c01029a6 <vector223>:
.globl vector223
vector223:
  pushl $0
c01029a6:	6a 00                	push   $0x0
  pushl $223
c01029a8:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01029ad:	e9 ec f6 ff ff       	jmp    c010209e <__alltraps>

c01029b2 <vector224>:
.globl vector224
vector224:
  pushl $0
c01029b2:	6a 00                	push   $0x0
  pushl $224
c01029b4:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01029b9:	e9 e0 f6 ff ff       	jmp    c010209e <__alltraps>

c01029be <vector225>:
.globl vector225
vector225:
  pushl $0
c01029be:	6a 00                	push   $0x0
  pushl $225
c01029c0:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01029c5:	e9 d4 f6 ff ff       	jmp    c010209e <__alltraps>

c01029ca <vector226>:
.globl vector226
vector226:
  pushl $0
c01029ca:	6a 00                	push   $0x0
  pushl $226
c01029cc:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01029d1:	e9 c8 f6 ff ff       	jmp    c010209e <__alltraps>

c01029d6 <vector227>:
.globl vector227
vector227:
  pushl $0
c01029d6:	6a 00                	push   $0x0
  pushl $227
c01029d8:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01029dd:	e9 bc f6 ff ff       	jmp    c010209e <__alltraps>

c01029e2 <vector228>:
.globl vector228
vector228:
  pushl $0
c01029e2:	6a 00                	push   $0x0
  pushl $228
c01029e4:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01029e9:	e9 b0 f6 ff ff       	jmp    c010209e <__alltraps>

c01029ee <vector229>:
.globl vector229
vector229:
  pushl $0
c01029ee:	6a 00                	push   $0x0
  pushl $229
c01029f0:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01029f5:	e9 a4 f6 ff ff       	jmp    c010209e <__alltraps>

c01029fa <vector230>:
.globl vector230
vector230:
  pushl $0
c01029fa:	6a 00                	push   $0x0
  pushl $230
c01029fc:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102a01:	e9 98 f6 ff ff       	jmp    c010209e <__alltraps>

c0102a06 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102a06:	6a 00                	push   $0x0
  pushl $231
c0102a08:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102a0d:	e9 8c f6 ff ff       	jmp    c010209e <__alltraps>

c0102a12 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102a12:	6a 00                	push   $0x0
  pushl $232
c0102a14:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102a19:	e9 80 f6 ff ff       	jmp    c010209e <__alltraps>

c0102a1e <vector233>:
.globl vector233
vector233:
  pushl $0
c0102a1e:	6a 00                	push   $0x0
  pushl $233
c0102a20:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102a25:	e9 74 f6 ff ff       	jmp    c010209e <__alltraps>

c0102a2a <vector234>:
.globl vector234
vector234:
  pushl $0
c0102a2a:	6a 00                	push   $0x0
  pushl $234
c0102a2c:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102a31:	e9 68 f6 ff ff       	jmp    c010209e <__alltraps>

c0102a36 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102a36:	6a 00                	push   $0x0
  pushl $235
c0102a38:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102a3d:	e9 5c f6 ff ff       	jmp    c010209e <__alltraps>

c0102a42 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102a42:	6a 00                	push   $0x0
  pushl $236
c0102a44:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102a49:	e9 50 f6 ff ff       	jmp    c010209e <__alltraps>

c0102a4e <vector237>:
.globl vector237
vector237:
  pushl $0
c0102a4e:	6a 00                	push   $0x0
  pushl $237
c0102a50:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102a55:	e9 44 f6 ff ff       	jmp    c010209e <__alltraps>

c0102a5a <vector238>:
.globl vector238
vector238:
  pushl $0
c0102a5a:	6a 00                	push   $0x0
  pushl $238
c0102a5c:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102a61:	e9 38 f6 ff ff       	jmp    c010209e <__alltraps>

c0102a66 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102a66:	6a 00                	push   $0x0
  pushl $239
c0102a68:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102a6d:	e9 2c f6 ff ff       	jmp    c010209e <__alltraps>

c0102a72 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102a72:	6a 00                	push   $0x0
  pushl $240
c0102a74:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102a79:	e9 20 f6 ff ff       	jmp    c010209e <__alltraps>

c0102a7e <vector241>:
.globl vector241
vector241:
  pushl $0
c0102a7e:	6a 00                	push   $0x0
  pushl $241
c0102a80:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102a85:	e9 14 f6 ff ff       	jmp    c010209e <__alltraps>

c0102a8a <vector242>:
.globl vector242
vector242:
  pushl $0
c0102a8a:	6a 00                	push   $0x0
  pushl $242
c0102a8c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102a91:	e9 08 f6 ff ff       	jmp    c010209e <__alltraps>

c0102a96 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102a96:	6a 00                	push   $0x0
  pushl $243
c0102a98:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102a9d:	e9 fc f5 ff ff       	jmp    c010209e <__alltraps>

c0102aa2 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102aa2:	6a 00                	push   $0x0
  pushl $244
c0102aa4:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102aa9:	e9 f0 f5 ff ff       	jmp    c010209e <__alltraps>

c0102aae <vector245>:
.globl vector245
vector245:
  pushl $0
c0102aae:	6a 00                	push   $0x0
  pushl $245
c0102ab0:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102ab5:	e9 e4 f5 ff ff       	jmp    c010209e <__alltraps>

c0102aba <vector246>:
.globl vector246
vector246:
  pushl $0
c0102aba:	6a 00                	push   $0x0
  pushl $246
c0102abc:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102ac1:	e9 d8 f5 ff ff       	jmp    c010209e <__alltraps>

c0102ac6 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102ac6:	6a 00                	push   $0x0
  pushl $247
c0102ac8:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102acd:	e9 cc f5 ff ff       	jmp    c010209e <__alltraps>

c0102ad2 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102ad2:	6a 00                	push   $0x0
  pushl $248
c0102ad4:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102ad9:	e9 c0 f5 ff ff       	jmp    c010209e <__alltraps>

c0102ade <vector249>:
.globl vector249
vector249:
  pushl $0
c0102ade:	6a 00                	push   $0x0
  pushl $249
c0102ae0:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102ae5:	e9 b4 f5 ff ff       	jmp    c010209e <__alltraps>

c0102aea <vector250>:
.globl vector250
vector250:
  pushl $0
c0102aea:	6a 00                	push   $0x0
  pushl $250
c0102aec:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102af1:	e9 a8 f5 ff ff       	jmp    c010209e <__alltraps>

c0102af6 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102af6:	6a 00                	push   $0x0
  pushl $251
c0102af8:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0102afd:	e9 9c f5 ff ff       	jmp    c010209e <__alltraps>

c0102b02 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102b02:	6a 00                	push   $0x0
  pushl $252
c0102b04:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102b09:	e9 90 f5 ff ff       	jmp    c010209e <__alltraps>

c0102b0e <vector253>:
.globl vector253
vector253:
  pushl $0
c0102b0e:	6a 00                	push   $0x0
  pushl $253
c0102b10:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102b15:	e9 84 f5 ff ff       	jmp    c010209e <__alltraps>

c0102b1a <vector254>:
.globl vector254
vector254:
  pushl $0
c0102b1a:	6a 00                	push   $0x0
  pushl $254
c0102b1c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102b21:	e9 78 f5 ff ff       	jmp    c010209e <__alltraps>

c0102b26 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102b26:	6a 00                	push   $0x0
  pushl $255
c0102b28:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102b2d:	e9 6c f5 ff ff       	jmp    c010209e <__alltraps>

c0102b32 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102b32:	55                   	push   %ebp
c0102b33:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102b35:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b38:	a1 e0 af 11 c0       	mov    0xc011afe0,%eax
c0102b3d:	29 c2                	sub    %eax,%edx
c0102b3f:	89 d0                	mov    %edx,%eax
c0102b41:	c1 f8 02             	sar    $0x2,%eax
c0102b44:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102b4a:	5d                   	pop    %ebp
c0102b4b:	c3                   	ret    

c0102b4c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102b4c:	55                   	push   %ebp
c0102b4d:	89 e5                	mov    %esp,%ebp
c0102b4f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102b52:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b55:	89 04 24             	mov    %eax,(%esp)
c0102b58:	e8 d5 ff ff ff       	call   c0102b32 <page2ppn>
c0102b5d:	c1 e0 0c             	shl    $0xc,%eax
}
c0102b60:	c9                   	leave  
c0102b61:	c3                   	ret    

c0102b62 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102b62:	55                   	push   %ebp
c0102b63:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102b65:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b68:	8b 00                	mov    (%eax),%eax
}
c0102b6a:	5d                   	pop    %ebp
c0102b6b:	c3                   	ret    

c0102b6c <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102b6c:	55                   	push   %ebp
c0102b6d:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102b6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b72:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b75:	89 10                	mov    %edx,(%eax)
}
c0102b77:	5d                   	pop    %ebp
c0102b78:	c3                   	ret    

c0102b79 <default_init>:

#define free_list (free_area.free_list)  // list itself
#define nr_free (free_area.nr_free)  // remaining capacity

static void
default_init(void) {
c0102b79:	55                   	push   %ebp
c0102b7a:	89 e5                	mov    %esp,%ebp
c0102b7c:	83 ec 10             	sub    $0x10,%esp
c0102b7f:	c7 45 fc cc af 11 c0 	movl   $0xc011afcc,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102b86:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b89:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102b8c:	89 50 04             	mov    %edx,0x4(%eax)
c0102b8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b92:	8b 50 04             	mov    0x4(%eax),%edx
c0102b95:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102b98:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0102b9a:	c7 05 d4 af 11 c0 00 	movl   $0x0,0xc011afd4
c0102ba1:	00 00 00 
}
c0102ba4:	c9                   	leave  
c0102ba5:	c3                   	ret    

c0102ba6 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102ba6:	55                   	push   %ebp
c0102ba7:	89 e5                	mov    %esp,%ebp
c0102ba9:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);  // make sure n > 0
c0102bac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102bb0:	75 24                	jne    c0102bd6 <default_init_memmap+0x30>
c0102bb2:	c7 44 24 0c 90 68 10 	movl   $0xc0106890,0xc(%esp)
c0102bb9:	c0 
c0102bba:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0102bc1:	c0 
c0102bc2:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0102bc9:	00 
c0102bca:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0102bd1:	e8 1d e1 ff ff       	call   c0100cf3 <__panic>
    struct Page *p = base;  // create a backup of base pointer
c0102bd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {  // allocate new physical page
c0102bdc:	eb 7d                	jmp    c0102c5b <default_init_memmap+0xb5>
        assert(PageReserved(p));  // make sure this page is not a reserved page
c0102bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102be1:	83 c0 04             	add    $0x4,%eax
c0102be4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102beb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102bee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102bf1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102bf4:	0f a3 10             	bt     %edx,(%eax)
c0102bf7:	19 c0                	sbb    %eax,%eax
c0102bf9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102bfc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102c00:	0f 95 c0             	setne  %al
c0102c03:	0f b6 c0             	movzbl %al,%eax
c0102c06:	85 c0                	test   %eax,%eax
c0102c08:	75 24                	jne    c0102c2e <default_init_memmap+0x88>
c0102c0a:	c7 44 24 0c c1 68 10 	movl   $0xc01068c1,0xc(%esp)
c0102c11:	c0 
c0102c12:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0102c19:	c0 
c0102c1a:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0102c21:	00 
c0102c22:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0102c29:	e8 c5 e0 ff ff       	call   c0100cf3 <__panic>
        p->flags = p->property = 0;  // clear the flags
c0102c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c3b:	8b 50 08             	mov    0x8(%eax),%edx
c0102c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c41:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);  // clear the number of this page's reference
c0102c44:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102c4b:	00 
c0102c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c4f:	89 04 24             	mov    %eax,(%esp)
c0102c52:	e8 15 ff ff ff       	call   c0102b6c <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);  // make sure n > 0
    struct Page *p = base;  // create a backup of base pointer
    for (; p != base + n; p ++) {  // allocate new physical page
c0102c57:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c5e:	89 d0                	mov    %edx,%eax
c0102c60:	c1 e0 02             	shl    $0x2,%eax
c0102c63:	01 d0                	add    %edx,%eax
c0102c65:	c1 e0 02             	shl    $0x2,%eax
c0102c68:	89 c2                	mov    %eax,%edx
c0102c6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c6d:	01 d0                	add    %edx,%eax
c0102c6f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102c72:	0f 85 66 ff ff ff    	jne    c0102bde <default_init_memmap+0x38>
        assert(PageReserved(p));  // make sure this page is not a reserved page
        p->flags = p->property = 0;  // clear the flags
        set_page_ref(p, 0);  // clear the number of this page's reference
    }
    base->property = n;  // set the property
c0102c78:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c7e:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);  // let it can be used
c0102c81:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c84:	83 c0 04             	add    $0x4,%eax
c0102c87:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102c8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c91:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102c94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102c97:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;  // calculate the total nr_free
c0102c9a:	8b 15 d4 af 11 c0    	mov    0xc011afd4,%edx
c0102ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102ca3:	01 d0                	add    %edx,%eax
c0102ca5:	a3 d4 af 11 c0       	mov    %eax,0xc011afd4
    list_add_before(&free_list, &(base->page_link));  // follow the FF
c0102caa:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cad:	83 c0 0c             	add    $0xc,%eax
c0102cb0:	c7 45 dc cc af 11 c0 	movl   $0xc011afcc,-0x24(%ebp)
c0102cb7:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102cba:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102cbd:	8b 00                	mov    (%eax),%eax
c0102cbf:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102cc2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102cc5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102cc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102ccb:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102cce:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cd1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102cd4:	89 10                	mov    %edx,(%eax)
c0102cd6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102cd9:	8b 10                	mov    (%eax),%edx
c0102cdb:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102cde:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102ce1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102ce4:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102ce7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102cea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102ced:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102cf0:	89 10                	mov    %edx,(%eax)
}
c0102cf2:	c9                   	leave  
c0102cf3:	c3                   	ret    

c0102cf4 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102cf4:	55                   	push   %ebp
c0102cf5:	89 e5                	mov    %esp,%ebp
c0102cf7:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);  // make sure n > 0
c0102cfa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102cfe:	75 24                	jne    c0102d24 <default_alloc_pages+0x30>
c0102d00:	c7 44 24 0c 90 68 10 	movl   $0xc0106890,0xc(%esp)
c0102d07:	c0 
c0102d08:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0102d0f:	c0 
c0102d10:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c0102d17:	00 
c0102d18:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0102d1f:	e8 cf df ff ff       	call   c0100cf3 <__panic>
    if (n > nr_free) {  // full
c0102d24:	a1 d4 af 11 c0       	mov    0xc011afd4,%eax
c0102d29:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102d2c:	73 0a                	jae    c0102d38 <default_alloc_pages+0x44>
        return NULL;
c0102d2e:	b8 00 00 00 00       	mov    $0x0,%eax
c0102d33:	e9 49 01 00 00       	jmp    c0102e81 <default_alloc_pages+0x18d>
    }
    struct Page *page = NULL;
c0102d38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102d3f:	c7 45 f0 cc af 11 c0 	movl   $0xc011afcc,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {  // double cycled list
c0102d46:	eb 1c                	jmp    c0102d64 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d4b:	83 e8 0c             	sub    $0xc,%eax
c0102d4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {  // divide this page to two parts
c0102d51:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d54:	8b 40 08             	mov    0x8(%eax),%eax
c0102d57:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102d5a:	72 08                	jb     c0102d64 <default_alloc_pages+0x70>
            page = p;
c0102d5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102d62:	eb 18                	jmp    c0102d7c <default_alloc_pages+0x88>
c0102d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102d6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102d6d:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {  // full
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {  // double cycled list
c0102d70:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102d73:	81 7d f0 cc af 11 c0 	cmpl   $0xc011afcc,-0x10(%ebp)
c0102d7a:	75 cc                	jne    c0102d48 <default_alloc_pages+0x54>
        if (p->property >= n) {  // divide this page to two parts
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0102d7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102d80:	0f 84 f8 00 00 00    	je     c0102e7e <default_alloc_pages+0x18a>
        if (page->property > n) {
c0102d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d89:	8b 40 08             	mov    0x8(%eax),%eax
c0102d8c:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102d8f:	0f 86 98 00 00 00    	jbe    c0102e2d <default_alloc_pages+0x139>
            struct Page *p = page + n;
c0102d95:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d98:	89 d0                	mov    %edx,%eax
c0102d9a:	c1 e0 02             	shl    $0x2,%eax
c0102d9d:	01 d0                	add    %edx,%eax
c0102d9f:	c1 e0 02             	shl    $0x2,%eax
c0102da2:	89 c2                	mov    %eax,%edx
c0102da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102da7:	01 d0                	add    %edx,%eax
c0102da9:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c0102dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102daf:	8b 40 08             	mov    0x8(%eax),%eax
c0102db2:	2b 45 08             	sub    0x8(%ebp),%eax
c0102db5:	89 c2                	mov    %eax,%edx
c0102db7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102dba:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c0102dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102dc0:	83 c0 04             	add    $0x4,%eax
c0102dc3:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102dca:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102dcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102dd0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102dd3:	0f ab 10             	bts    %edx,(%eax)
            list_add(&(page->page_link), &(p->page_link));
c0102dd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102dd9:	83 c0 0c             	add    $0xc,%eax
c0102ddc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102ddf:	83 c2 0c             	add    $0xc,%edx
c0102de2:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0102de5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102de8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102deb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102dee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102df1:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102df4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102df7:	8b 40 04             	mov    0x4(%eax),%eax
c0102dfa:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102dfd:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102e00:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102e03:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102e06:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102e09:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102e0c:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102e0f:	89 10                	mov    %edx,(%eax)
c0102e11:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102e14:	8b 10                	mov    (%eax),%edx
c0102e16:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102e19:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102e1c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102e1f:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102e22:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102e25:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102e28:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102e2b:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
c0102e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e30:	83 c0 0c             	add    $0xc,%eax
c0102e33:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102e36:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102e39:	8b 40 04             	mov    0x4(%eax),%eax
c0102e3c:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102e3f:	8b 12                	mov    (%edx),%edx
c0102e41:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102e44:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102e47:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102e4a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102e4d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102e50:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102e53:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102e56:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
c0102e58:	a1 d4 af 11 c0       	mov    0xc011afd4,%eax
c0102e5d:	2b 45 08             	sub    0x8(%ebp),%eax
c0102e60:	a3 d4 af 11 c0       	mov    %eax,0xc011afd4
        ClearPageProperty(page);
c0102e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e68:	83 c0 04             	add    $0x4,%eax
c0102e6b:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0102e72:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102e75:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102e78:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102e7b:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0102e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102e81:	c9                   	leave  
c0102e82:	c3                   	ret    

c0102e83 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102e83:	55                   	push   %ebp
c0102e84:	89 e5                	mov    %esp,%ebp
c0102e86:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102e8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102e90:	75 24                	jne    c0102eb6 <default_free_pages+0x33>
c0102e92:	c7 44 24 0c 90 68 10 	movl   $0xc0106890,0xc(%esp)
c0102e99:	c0 
c0102e9a:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0102ea1:	c0 
c0102ea2:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c0102ea9:	00 
c0102eaa:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0102eb1:	e8 3d de ff ff       	call   c0100cf3 <__panic>
    struct Page *p = base;
c0102eb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102eb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102ebc:	e9 9d 00 00 00       	jmp    c0102f5e <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0102ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ec4:	83 c0 04             	add    $0x4,%eax
c0102ec7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102ece:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102ed1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102ed4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102ed7:	0f a3 10             	bt     %edx,(%eax)
c0102eda:	19 c0                	sbb    %eax,%eax
c0102edc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102edf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102ee3:	0f 95 c0             	setne  %al
c0102ee6:	0f b6 c0             	movzbl %al,%eax
c0102ee9:	85 c0                	test   %eax,%eax
c0102eeb:	75 2c                	jne    c0102f19 <default_free_pages+0x96>
c0102eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ef0:	83 c0 04             	add    $0x4,%eax
c0102ef3:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102efa:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102efd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102f00:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102f03:	0f a3 10             	bt     %edx,(%eax)
c0102f06:	19 c0                	sbb    %eax,%eax
c0102f08:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c0102f0b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102f0f:	0f 95 c0             	setne  %al
c0102f12:	0f b6 c0             	movzbl %al,%eax
c0102f15:	85 c0                	test   %eax,%eax
c0102f17:	74 24                	je     c0102f3d <default_free_pages+0xba>
c0102f19:	c7 44 24 0c d4 68 10 	movl   $0xc01068d4,0xc(%esp)
c0102f20:	c0 
c0102f21:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0102f28:	c0 
c0102f29:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0102f30:	00 
c0102f31:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0102f38:	e8 b6 dd ff ff       	call   c0100cf3 <__panic>
        p->flags = 0;
c0102f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102f47:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102f4e:	00 
c0102f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f52:	89 04 24             	mov    %eax,(%esp)
c0102f55:	e8 12 fc ff ff       	call   c0102b6c <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102f5a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102f5e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102f61:	89 d0                	mov    %edx,%eax
c0102f63:	c1 e0 02             	shl    $0x2,%eax
c0102f66:	01 d0                	add    %edx,%eax
c0102f68:	c1 e0 02             	shl    $0x2,%eax
c0102f6b:	89 c2                	mov    %eax,%edx
c0102f6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f70:	01 d0                	add    %edx,%eax
c0102f72:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f75:	0f 85 46 ff ff ff    	jne    c0102ec1 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102f7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f7e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102f81:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102f84:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f87:	83 c0 04             	add    $0x4,%eax
c0102f8a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102f91:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102f94:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f97:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f9a:	0f ab 10             	bts    %edx,(%eax)
c0102f9d:	c7 45 cc cc af 11 c0 	movl   $0xc011afcc,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102fa4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102fa7:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102faa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102fad:	e9 08 01 00 00       	jmp    c01030ba <default_free_pages+0x237>
        p = le2page(le, page_link);
c0102fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fb5:	83 e8 0c             	sub    $0xc,%eax
c0102fb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fbe:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102fc1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102fc4:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102fc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0102fca:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fcd:	8b 50 08             	mov    0x8(%eax),%edx
c0102fd0:	89 d0                	mov    %edx,%eax
c0102fd2:	c1 e0 02             	shl    $0x2,%eax
c0102fd5:	01 d0                	add    %edx,%eax
c0102fd7:	c1 e0 02             	shl    $0x2,%eax
c0102fda:	89 c2                	mov    %eax,%edx
c0102fdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fdf:	01 d0                	add    %edx,%eax
c0102fe1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102fe4:	75 5a                	jne    c0103040 <default_free_pages+0x1bd>
            base->property += p->property;
c0102fe6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fe9:	8b 50 08             	mov    0x8(%eax),%edx
c0102fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fef:	8b 40 08             	mov    0x8(%eax),%eax
c0102ff2:	01 c2                	add    %eax,%edx
c0102ff4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ff7:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ffd:	83 c0 04             	add    $0x4,%eax
c0103000:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0103007:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010300a:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010300d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103010:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0103013:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103016:	83 c0 0c             	add    $0xc,%eax
c0103019:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010301c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010301f:	8b 40 04             	mov    0x4(%eax),%eax
c0103022:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103025:	8b 12                	mov    (%edx),%edx
c0103027:	89 55 b8             	mov    %edx,-0x48(%ebp)
c010302a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010302d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103030:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103033:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103036:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103039:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010303c:	89 10                	mov    %edx,(%eax)
c010303e:	eb 7a                	jmp    c01030ba <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c0103040:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103043:	8b 50 08             	mov    0x8(%eax),%edx
c0103046:	89 d0                	mov    %edx,%eax
c0103048:	c1 e0 02             	shl    $0x2,%eax
c010304b:	01 d0                	add    %edx,%eax
c010304d:	c1 e0 02             	shl    $0x2,%eax
c0103050:	89 c2                	mov    %eax,%edx
c0103052:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103055:	01 d0                	add    %edx,%eax
c0103057:	3b 45 08             	cmp    0x8(%ebp),%eax
c010305a:	75 5e                	jne    c01030ba <default_free_pages+0x237>
            p->property += base->property;
c010305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010305f:	8b 50 08             	mov    0x8(%eax),%edx
c0103062:	8b 45 08             	mov    0x8(%ebp),%eax
c0103065:	8b 40 08             	mov    0x8(%eax),%eax
c0103068:	01 c2                	add    %eax,%edx
c010306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010306d:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0103070:	8b 45 08             	mov    0x8(%ebp),%eax
c0103073:	83 c0 04             	add    $0x4,%eax
c0103076:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c010307d:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0103080:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103083:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0103086:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0103089:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010308c:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c010308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103092:	83 c0 0c             	add    $0xc,%eax
c0103095:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103098:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010309b:	8b 40 04             	mov    0x4(%eax),%eax
c010309e:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01030a1:	8b 12                	mov    (%edx),%edx
c01030a3:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c01030a6:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01030a9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01030ac:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01030af:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01030b2:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01030b5:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c01030b8:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c01030ba:	81 7d f0 cc af 11 c0 	cmpl   $0xc011afcc,-0x10(%ebp)
c01030c1:	0f 85 eb fe ff ff    	jne    c0102fb2 <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c01030c7:	8b 15 d4 af 11 c0    	mov    0xc011afd4,%edx
c01030cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01030d0:	01 d0                	add    %edx,%eax
c01030d2:	a3 d4 af 11 c0       	mov    %eax,0xc011afd4
c01030d7:	c7 45 9c cc af 11 c0 	movl   $0xc011afcc,-0x64(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01030de:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01030e1:	8b 40 04             	mov    0x4(%eax),%eax
    //list_add(&free_list, &(base->page_link));
    // 将空闲页面按地址大小插入至链表中
    for(le = list_next(&free_list); le != &free_list; le = list_next(le))
c01030e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01030e7:	eb 76                	jmp    c010315f <default_free_pages+0x2dc>
    {
        p = le2page(le, page_link);
c01030e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030ec:	83 e8 0c             	sub    $0xc,%eax
c01030ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
c01030f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01030f5:	8b 50 08             	mov    0x8(%eax),%edx
c01030f8:	89 d0                	mov    %edx,%eax
c01030fa:	c1 e0 02             	shl    $0x2,%eax
c01030fd:	01 d0                	add    %edx,%eax
c01030ff:	c1 e0 02             	shl    $0x2,%eax
c0103102:	89 c2                	mov    %eax,%edx
c0103104:	8b 45 08             	mov    0x8(%ebp),%eax
c0103107:	01 d0                	add    %edx,%eax
c0103109:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010310c:	77 42                	ja     c0103150 <default_free_pages+0x2cd>
            assert(base + base->property != p);
c010310e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103111:	8b 50 08             	mov    0x8(%eax),%edx
c0103114:	89 d0                	mov    %edx,%eax
c0103116:	c1 e0 02             	shl    $0x2,%eax
c0103119:	01 d0                	add    %edx,%eax
c010311b:	c1 e0 02             	shl    $0x2,%eax
c010311e:	89 c2                	mov    %eax,%edx
c0103120:	8b 45 08             	mov    0x8(%ebp),%eax
c0103123:	01 d0                	add    %edx,%eax
c0103125:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103128:	75 24                	jne    c010314e <default_free_pages+0x2cb>
c010312a:	c7 44 24 0c f9 68 10 	movl   $0xc01068f9,0xc(%esp)
c0103131:	c0 
c0103132:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103139:	c0 
c010313a:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0103141:	00 
c0103142:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103149:	e8 a5 db ff ff       	call   c0100cf3 <__panic>
            break;
c010314e:	eb 18                	jmp    c0103168 <default_free_pages+0x2e5>
c0103150:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103153:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103156:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103159:	8b 40 04             	mov    0x4(%eax),%eax
        }
    }
    nr_free += n;
    //list_add(&free_list, &(base->page_link));
    // 将空闲页面按地址大小插入至链表中
    for(le = list_next(&free_list); le != &free_list; le = list_next(le))
c010315c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010315f:	81 7d f0 cc af 11 c0 	cmpl   $0xc011afcc,-0x10(%ebp)
c0103166:	75 81                	jne    c01030e9 <default_free_pages+0x266>
        if (base + base->property <= p) {
            assert(base + base->property != p);
            break;
        }
    }
    list_add_before(le, &(base->page_link));
c0103168:	8b 45 08             	mov    0x8(%ebp),%eax
c010316b:	8d 50 0c             	lea    0xc(%eax),%edx
c010316e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103171:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0103174:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103177:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010317a:	8b 00                	mov    (%eax),%eax
c010317c:	8b 55 90             	mov    -0x70(%ebp),%edx
c010317f:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0103182:	89 45 88             	mov    %eax,-0x78(%ebp)
c0103185:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103188:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010318b:	8b 45 84             	mov    -0x7c(%ebp),%eax
c010318e:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0103191:	89 10                	mov    %edx,(%eax)
c0103193:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0103196:	8b 10                	mov    (%eax),%edx
c0103198:	8b 45 88             	mov    -0x78(%ebp),%eax
c010319b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010319e:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01031a1:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01031a4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01031a7:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01031aa:	8b 55 88             	mov    -0x78(%ebp),%edx
c01031ad:	89 10                	mov    %edx,(%eax)
}
c01031af:	c9                   	leave  
c01031b0:	c3                   	ret    

c01031b1 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01031b1:	55                   	push   %ebp
c01031b2:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01031b4:	a1 d4 af 11 c0       	mov    0xc011afd4,%eax
}
c01031b9:	5d                   	pop    %ebp
c01031ba:	c3                   	ret    

c01031bb <basic_check>:

static void
basic_check(void) {
c01031bb:	55                   	push   %ebp
c01031bc:	89 e5                	mov    %esp,%ebp
c01031be:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01031c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01031d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031db:	e8 ce 0e 00 00       	call   c01040ae <alloc_pages>
c01031e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01031e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01031e7:	75 24                	jne    c010320d <basic_check+0x52>
c01031e9:	c7 44 24 0c 14 69 10 	movl   $0xc0106914,0xc(%esp)
c01031f0:	c0 
c01031f1:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c01031f8:	c0 
c01031f9:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103200:	00 
c0103201:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103208:	e8 e6 da ff ff       	call   c0100cf3 <__panic>
    assert((p1 = alloc_page()) != NULL);
c010320d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103214:	e8 95 0e 00 00       	call   c01040ae <alloc_pages>
c0103219:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010321c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103220:	75 24                	jne    c0103246 <basic_check+0x8b>
c0103222:	c7 44 24 0c 30 69 10 	movl   $0xc0106930,0xc(%esp)
c0103229:	c0 
c010322a:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103231:	c0 
c0103232:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0103239:	00 
c010323a:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103241:	e8 ad da ff ff       	call   c0100cf3 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103246:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010324d:	e8 5c 0e 00 00       	call   c01040ae <alloc_pages>
c0103252:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103255:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103259:	75 24                	jne    c010327f <basic_check+0xc4>
c010325b:	c7 44 24 0c 4c 69 10 	movl   $0xc010694c,0xc(%esp)
c0103262:	c0 
c0103263:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c010326a:	c0 
c010326b:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0103272:	00 
c0103273:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c010327a:	e8 74 da ff ff       	call   c0100cf3 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010327f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103282:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103285:	74 10                	je     c0103297 <basic_check+0xdc>
c0103287:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010328a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010328d:	74 08                	je     c0103297 <basic_check+0xdc>
c010328f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103292:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103295:	75 24                	jne    c01032bb <basic_check+0x100>
c0103297:	c7 44 24 0c 68 69 10 	movl   $0xc0106968,0xc(%esp)
c010329e:	c0 
c010329f:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c01032a6:	c0 
c01032a7:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c01032ae:	00 
c01032af:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c01032b6:	e8 38 da ff ff       	call   c0100cf3 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01032bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032be:	89 04 24             	mov    %eax,(%esp)
c01032c1:	e8 9c f8 ff ff       	call   c0102b62 <page_ref>
c01032c6:	85 c0                	test   %eax,%eax
c01032c8:	75 1e                	jne    c01032e8 <basic_check+0x12d>
c01032ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01032cd:	89 04 24             	mov    %eax,(%esp)
c01032d0:	e8 8d f8 ff ff       	call   c0102b62 <page_ref>
c01032d5:	85 c0                	test   %eax,%eax
c01032d7:	75 0f                	jne    c01032e8 <basic_check+0x12d>
c01032d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032dc:	89 04 24             	mov    %eax,(%esp)
c01032df:	e8 7e f8 ff ff       	call   c0102b62 <page_ref>
c01032e4:	85 c0                	test   %eax,%eax
c01032e6:	74 24                	je     c010330c <basic_check+0x151>
c01032e8:	c7 44 24 0c 8c 69 10 	movl   $0xc010698c,0xc(%esp)
c01032ef:	c0 
c01032f0:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c01032f7:	c0 
c01032f8:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c01032ff:	00 
c0103300:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103307:	e8 e7 d9 ff ff       	call   c0100cf3 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c010330c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010330f:	89 04 24             	mov    %eax,(%esp)
c0103312:	e8 35 f8 ff ff       	call   c0102b4c <page2pa>
c0103317:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c010331d:	c1 e2 0c             	shl    $0xc,%edx
c0103320:	39 d0                	cmp    %edx,%eax
c0103322:	72 24                	jb     c0103348 <basic_check+0x18d>
c0103324:	c7 44 24 0c c8 69 10 	movl   $0xc01069c8,0xc(%esp)
c010332b:	c0 
c010332c:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103333:	c0 
c0103334:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c010333b:	00 
c010333c:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103343:	e8 ab d9 ff ff       	call   c0100cf3 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010334b:	89 04 24             	mov    %eax,(%esp)
c010334e:	e8 f9 f7 ff ff       	call   c0102b4c <page2pa>
c0103353:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0103359:	c1 e2 0c             	shl    $0xc,%edx
c010335c:	39 d0                	cmp    %edx,%eax
c010335e:	72 24                	jb     c0103384 <basic_check+0x1c9>
c0103360:	c7 44 24 0c e5 69 10 	movl   $0xc01069e5,0xc(%esp)
c0103367:	c0 
c0103368:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c010336f:	c0 
c0103370:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103377:	00 
c0103378:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c010337f:	e8 6f d9 ff ff       	call   c0100cf3 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103384:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103387:	89 04 24             	mov    %eax,(%esp)
c010338a:	e8 bd f7 ff ff       	call   c0102b4c <page2pa>
c010338f:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0103395:	c1 e2 0c             	shl    $0xc,%edx
c0103398:	39 d0                	cmp    %edx,%eax
c010339a:	72 24                	jb     c01033c0 <basic_check+0x205>
c010339c:	c7 44 24 0c 02 6a 10 	movl   $0xc0106a02,0xc(%esp)
c01033a3:	c0 
c01033a4:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c01033ab:	c0 
c01033ac:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c01033b3:	00 
c01033b4:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c01033bb:	e8 33 d9 ff ff       	call   c0100cf3 <__panic>

    list_entry_t free_list_store = free_list;
c01033c0:	a1 cc af 11 c0       	mov    0xc011afcc,%eax
c01033c5:	8b 15 d0 af 11 c0    	mov    0xc011afd0,%edx
c01033cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01033ce:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01033d1:	c7 45 e0 cc af 11 c0 	movl   $0xc011afcc,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01033d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033db:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01033de:	89 50 04             	mov    %edx,0x4(%eax)
c01033e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033e4:	8b 50 04             	mov    0x4(%eax),%edx
c01033e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033ea:	89 10                	mov    %edx,(%eax)
c01033ec:	c7 45 dc cc af 11 c0 	movl   $0xc011afcc,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01033f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01033f6:	8b 40 04             	mov    0x4(%eax),%eax
c01033f9:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01033fc:	0f 94 c0             	sete   %al
c01033ff:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103402:	85 c0                	test   %eax,%eax
c0103404:	75 24                	jne    c010342a <basic_check+0x26f>
c0103406:	c7 44 24 0c 1f 6a 10 	movl   $0xc0106a1f,0xc(%esp)
c010340d:	c0 
c010340e:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103415:	c0 
c0103416:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c010341d:	00 
c010341e:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103425:	e8 c9 d8 ff ff       	call   c0100cf3 <__panic>

    unsigned int nr_free_store = nr_free;
c010342a:	a1 d4 af 11 c0       	mov    0xc011afd4,%eax
c010342f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103432:	c7 05 d4 af 11 c0 00 	movl   $0x0,0xc011afd4
c0103439:	00 00 00 

    assert(alloc_page() == NULL);
c010343c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103443:	e8 66 0c 00 00       	call   c01040ae <alloc_pages>
c0103448:	85 c0                	test   %eax,%eax
c010344a:	74 24                	je     c0103470 <basic_check+0x2b5>
c010344c:	c7 44 24 0c 36 6a 10 	movl   $0xc0106a36,0xc(%esp)
c0103453:	c0 
c0103454:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c010345b:	c0 
c010345c:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103463:	00 
c0103464:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c010346b:	e8 83 d8 ff ff       	call   c0100cf3 <__panic>

    free_page(p0);
c0103470:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103477:	00 
c0103478:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010347b:	89 04 24             	mov    %eax,(%esp)
c010347e:	e8 63 0c 00 00       	call   c01040e6 <free_pages>
    free_page(p1);
c0103483:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010348a:	00 
c010348b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010348e:	89 04 24             	mov    %eax,(%esp)
c0103491:	e8 50 0c 00 00       	call   c01040e6 <free_pages>
    free_page(p2);
c0103496:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010349d:	00 
c010349e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034a1:	89 04 24             	mov    %eax,(%esp)
c01034a4:	e8 3d 0c 00 00       	call   c01040e6 <free_pages>
    assert(nr_free == 3);
c01034a9:	a1 d4 af 11 c0       	mov    0xc011afd4,%eax
c01034ae:	83 f8 03             	cmp    $0x3,%eax
c01034b1:	74 24                	je     c01034d7 <basic_check+0x31c>
c01034b3:	c7 44 24 0c 4b 6a 10 	movl   $0xc0106a4b,0xc(%esp)
c01034ba:	c0 
c01034bb:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c01034c2:	c0 
c01034c3:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c01034ca:	00 
c01034cb:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c01034d2:	e8 1c d8 ff ff       	call   c0100cf3 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01034d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034de:	e8 cb 0b 00 00       	call   c01040ae <alloc_pages>
c01034e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01034e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01034ea:	75 24                	jne    c0103510 <basic_check+0x355>
c01034ec:	c7 44 24 0c 14 69 10 	movl   $0xc0106914,0xc(%esp)
c01034f3:	c0 
c01034f4:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c01034fb:	c0 
c01034fc:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103503:	00 
c0103504:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c010350b:	e8 e3 d7 ff ff       	call   c0100cf3 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103510:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103517:	e8 92 0b 00 00       	call   c01040ae <alloc_pages>
c010351c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010351f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103523:	75 24                	jne    c0103549 <basic_check+0x38e>
c0103525:	c7 44 24 0c 30 69 10 	movl   $0xc0106930,0xc(%esp)
c010352c:	c0 
c010352d:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103534:	c0 
c0103535:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c010353c:	00 
c010353d:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103544:	e8 aa d7 ff ff       	call   c0100cf3 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103549:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103550:	e8 59 0b 00 00       	call   c01040ae <alloc_pages>
c0103555:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103558:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010355c:	75 24                	jne    c0103582 <basic_check+0x3c7>
c010355e:	c7 44 24 0c 4c 69 10 	movl   $0xc010694c,0xc(%esp)
c0103565:	c0 
c0103566:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c010356d:	c0 
c010356e:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103575:	00 
c0103576:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c010357d:	e8 71 d7 ff ff       	call   c0100cf3 <__panic>

    assert(alloc_page() == NULL);
c0103582:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103589:	e8 20 0b 00 00       	call   c01040ae <alloc_pages>
c010358e:	85 c0                	test   %eax,%eax
c0103590:	74 24                	je     c01035b6 <basic_check+0x3fb>
c0103592:	c7 44 24 0c 36 6a 10 	movl   $0xc0106a36,0xc(%esp)
c0103599:	c0 
c010359a:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c01035a1:	c0 
c01035a2:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c01035a9:	00 
c01035aa:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c01035b1:	e8 3d d7 ff ff       	call   c0100cf3 <__panic>

    free_page(p0);
c01035b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01035bd:	00 
c01035be:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035c1:	89 04 24             	mov    %eax,(%esp)
c01035c4:	e8 1d 0b 00 00       	call   c01040e6 <free_pages>
c01035c9:	c7 45 d8 cc af 11 c0 	movl   $0xc011afcc,-0x28(%ebp)
c01035d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01035d3:	8b 40 04             	mov    0x4(%eax),%eax
c01035d6:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01035d9:	0f 94 c0             	sete   %al
c01035dc:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01035df:	85 c0                	test   %eax,%eax
c01035e1:	74 24                	je     c0103607 <basic_check+0x44c>
c01035e3:	c7 44 24 0c 58 6a 10 	movl   $0xc0106a58,0xc(%esp)
c01035ea:	c0 
c01035eb:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c01035f2:	c0 
c01035f3:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c01035fa:	00 
c01035fb:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103602:	e8 ec d6 ff ff       	call   c0100cf3 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103607:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010360e:	e8 9b 0a 00 00       	call   c01040ae <alloc_pages>
c0103613:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103619:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010361c:	74 24                	je     c0103642 <basic_check+0x487>
c010361e:	c7 44 24 0c 70 6a 10 	movl   $0xc0106a70,0xc(%esp)
c0103625:	c0 
c0103626:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c010362d:	c0 
c010362e:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0103635:	00 
c0103636:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c010363d:	e8 b1 d6 ff ff       	call   c0100cf3 <__panic>
    assert(alloc_page() == NULL);
c0103642:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103649:	e8 60 0a 00 00       	call   c01040ae <alloc_pages>
c010364e:	85 c0                	test   %eax,%eax
c0103650:	74 24                	je     c0103676 <basic_check+0x4bb>
c0103652:	c7 44 24 0c 36 6a 10 	movl   $0xc0106a36,0xc(%esp)
c0103659:	c0 
c010365a:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103661:	c0 
c0103662:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0103669:	00 
c010366a:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103671:	e8 7d d6 ff ff       	call   c0100cf3 <__panic>

    assert(nr_free == 0);
c0103676:	a1 d4 af 11 c0       	mov    0xc011afd4,%eax
c010367b:	85 c0                	test   %eax,%eax
c010367d:	74 24                	je     c01036a3 <basic_check+0x4e8>
c010367f:	c7 44 24 0c 89 6a 10 	movl   $0xc0106a89,0xc(%esp)
c0103686:	c0 
c0103687:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c010368e:	c0 
c010368f:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0103696:	00 
c0103697:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c010369e:	e8 50 d6 ff ff       	call   c0100cf3 <__panic>
    free_list = free_list_store;
c01036a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01036a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01036a9:	a3 cc af 11 c0       	mov    %eax,0xc011afcc
c01036ae:	89 15 d0 af 11 c0    	mov    %edx,0xc011afd0
    nr_free = nr_free_store;
c01036b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01036b7:	a3 d4 af 11 c0       	mov    %eax,0xc011afd4

    free_page(p);
c01036bc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01036c3:	00 
c01036c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036c7:	89 04 24             	mov    %eax,(%esp)
c01036ca:	e8 17 0a 00 00       	call   c01040e6 <free_pages>
    free_page(p1);
c01036cf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01036d6:	00 
c01036d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036da:	89 04 24             	mov    %eax,(%esp)
c01036dd:	e8 04 0a 00 00       	call   c01040e6 <free_pages>
    free_page(p2);
c01036e2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01036e9:	00 
c01036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ed:	89 04 24             	mov    %eax,(%esp)
c01036f0:	e8 f1 09 00 00       	call   c01040e6 <free_pages>
}
c01036f5:	c9                   	leave  
c01036f6:	c3                   	ret    

c01036f7 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01036f7:	55                   	push   %ebp
c01036f8:	89 e5                	mov    %esp,%ebp
c01036fa:	53                   	push   %ebx
c01036fb:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103701:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103708:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010370f:	c7 45 ec cc af 11 c0 	movl   $0xc011afcc,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103716:	eb 6b                	jmp    c0103783 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103718:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010371b:	83 e8 0c             	sub    $0xc,%eax
c010371e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103721:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103724:	83 c0 04             	add    $0x4,%eax
c0103727:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010372e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103731:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103734:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103737:	0f a3 10             	bt     %edx,(%eax)
c010373a:	19 c0                	sbb    %eax,%eax
c010373c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c010373f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103743:	0f 95 c0             	setne  %al
c0103746:	0f b6 c0             	movzbl %al,%eax
c0103749:	85 c0                	test   %eax,%eax
c010374b:	75 24                	jne    c0103771 <default_check+0x7a>
c010374d:	c7 44 24 0c 96 6a 10 	movl   $0xc0106a96,0xc(%esp)
c0103754:	c0 
c0103755:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c010375c:	c0 
c010375d:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0103764:	00 
c0103765:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c010376c:	e8 82 d5 ff ff       	call   c0100cf3 <__panic>
        count ++, total += p->property;
c0103771:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103775:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103778:	8b 50 08             	mov    0x8(%eax),%edx
c010377b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010377e:	01 d0                	add    %edx,%eax
c0103780:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103783:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103786:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103789:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010378c:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010378f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103792:	81 7d ec cc af 11 c0 	cmpl   $0xc011afcc,-0x14(%ebp)
c0103799:	0f 85 79 ff ff ff    	jne    c0103718 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010379f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01037a2:	e8 71 09 00 00       	call   c0104118 <nr_free_pages>
c01037a7:	39 c3                	cmp    %eax,%ebx
c01037a9:	74 24                	je     c01037cf <default_check+0xd8>
c01037ab:	c7 44 24 0c a6 6a 10 	movl   $0xc0106aa6,0xc(%esp)
c01037b2:	c0 
c01037b3:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c01037ba:	c0 
c01037bb:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c01037c2:	00 
c01037c3:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c01037ca:	e8 24 d5 ff ff       	call   c0100cf3 <__panic>

    basic_check();
c01037cf:	e8 e7 f9 ff ff       	call   c01031bb <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01037d4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01037db:	e8 ce 08 00 00       	call   c01040ae <alloc_pages>
c01037e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01037e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01037e7:	75 24                	jne    c010380d <default_check+0x116>
c01037e9:	c7 44 24 0c bf 6a 10 	movl   $0xc0106abf,0xc(%esp)
c01037f0:	c0 
c01037f1:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c01037f8:	c0 
c01037f9:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0103800:	00 
c0103801:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103808:	e8 e6 d4 ff ff       	call   c0100cf3 <__panic>
    assert(!PageProperty(p0));
c010380d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103810:	83 c0 04             	add    $0x4,%eax
c0103813:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010381a:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010381d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103820:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103823:	0f a3 10             	bt     %edx,(%eax)
c0103826:	19 c0                	sbb    %eax,%eax
c0103828:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010382b:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010382f:	0f 95 c0             	setne  %al
c0103832:	0f b6 c0             	movzbl %al,%eax
c0103835:	85 c0                	test   %eax,%eax
c0103837:	74 24                	je     c010385d <default_check+0x166>
c0103839:	c7 44 24 0c ca 6a 10 	movl   $0xc0106aca,0xc(%esp)
c0103840:	c0 
c0103841:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103848:	c0 
c0103849:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0103850:	00 
c0103851:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103858:	e8 96 d4 ff ff       	call   c0100cf3 <__panic>

    list_entry_t free_list_store = free_list;
c010385d:	a1 cc af 11 c0       	mov    0xc011afcc,%eax
c0103862:	8b 15 d0 af 11 c0    	mov    0xc011afd0,%edx
c0103868:	89 45 80             	mov    %eax,-0x80(%ebp)
c010386b:	89 55 84             	mov    %edx,-0x7c(%ebp)
c010386e:	c7 45 b4 cc af 11 c0 	movl   $0xc011afcc,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103875:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103878:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010387b:	89 50 04             	mov    %edx,0x4(%eax)
c010387e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103881:	8b 50 04             	mov    0x4(%eax),%edx
c0103884:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103887:	89 10                	mov    %edx,(%eax)
c0103889:	c7 45 b0 cc af 11 c0 	movl   $0xc011afcc,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103890:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103893:	8b 40 04             	mov    0x4(%eax),%eax
c0103896:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103899:	0f 94 c0             	sete   %al
c010389c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010389f:	85 c0                	test   %eax,%eax
c01038a1:	75 24                	jne    c01038c7 <default_check+0x1d0>
c01038a3:	c7 44 24 0c 1f 6a 10 	movl   $0xc0106a1f,0xc(%esp)
c01038aa:	c0 
c01038ab:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c01038b2:	c0 
c01038b3:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c01038ba:	00 
c01038bb:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c01038c2:	e8 2c d4 ff ff       	call   c0100cf3 <__panic>
    assert(alloc_page() == NULL);
c01038c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038ce:	e8 db 07 00 00       	call   c01040ae <alloc_pages>
c01038d3:	85 c0                	test   %eax,%eax
c01038d5:	74 24                	je     c01038fb <default_check+0x204>
c01038d7:	c7 44 24 0c 36 6a 10 	movl   $0xc0106a36,0xc(%esp)
c01038de:	c0 
c01038df:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c01038e6:	c0 
c01038e7:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c01038ee:	00 
c01038ef:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c01038f6:	e8 f8 d3 ff ff       	call   c0100cf3 <__panic>

    unsigned int nr_free_store = nr_free;
c01038fb:	a1 d4 af 11 c0       	mov    0xc011afd4,%eax
c0103900:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103903:	c7 05 d4 af 11 c0 00 	movl   $0x0,0xc011afd4
c010390a:	00 00 00 

    free_pages(p0 + 2, 3);
c010390d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103910:	83 c0 28             	add    $0x28,%eax
c0103913:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010391a:	00 
c010391b:	89 04 24             	mov    %eax,(%esp)
c010391e:	e8 c3 07 00 00       	call   c01040e6 <free_pages>
    assert(alloc_pages(4) == NULL);
c0103923:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010392a:	e8 7f 07 00 00       	call   c01040ae <alloc_pages>
c010392f:	85 c0                	test   %eax,%eax
c0103931:	74 24                	je     c0103957 <default_check+0x260>
c0103933:	c7 44 24 0c dc 6a 10 	movl   $0xc0106adc,0xc(%esp)
c010393a:	c0 
c010393b:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103942:	c0 
c0103943:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c010394a:	00 
c010394b:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103952:	e8 9c d3 ff ff       	call   c0100cf3 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010395a:	83 c0 28             	add    $0x28,%eax
c010395d:	83 c0 04             	add    $0x4,%eax
c0103960:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103967:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010396a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010396d:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103970:	0f a3 10             	bt     %edx,(%eax)
c0103973:	19 c0                	sbb    %eax,%eax
c0103975:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103978:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010397c:	0f 95 c0             	setne  %al
c010397f:	0f b6 c0             	movzbl %al,%eax
c0103982:	85 c0                	test   %eax,%eax
c0103984:	74 0e                	je     c0103994 <default_check+0x29d>
c0103986:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103989:	83 c0 28             	add    $0x28,%eax
c010398c:	8b 40 08             	mov    0x8(%eax),%eax
c010398f:	83 f8 03             	cmp    $0x3,%eax
c0103992:	74 24                	je     c01039b8 <default_check+0x2c1>
c0103994:	c7 44 24 0c f4 6a 10 	movl   $0xc0106af4,0xc(%esp)
c010399b:	c0 
c010399c:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c01039a3:	c0 
c01039a4:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01039ab:	00 
c01039ac:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c01039b3:	e8 3b d3 ff ff       	call   c0100cf3 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01039b8:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01039bf:	e8 ea 06 00 00       	call   c01040ae <alloc_pages>
c01039c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01039c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01039cb:	75 24                	jne    c01039f1 <default_check+0x2fa>
c01039cd:	c7 44 24 0c 20 6b 10 	movl   $0xc0106b20,0xc(%esp)
c01039d4:	c0 
c01039d5:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c01039dc:	c0 
c01039dd:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01039e4:	00 
c01039e5:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c01039ec:	e8 02 d3 ff ff       	call   c0100cf3 <__panic>
    assert(alloc_page() == NULL);
c01039f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039f8:	e8 b1 06 00 00       	call   c01040ae <alloc_pages>
c01039fd:	85 c0                	test   %eax,%eax
c01039ff:	74 24                	je     c0103a25 <default_check+0x32e>
c0103a01:	c7 44 24 0c 36 6a 10 	movl   $0xc0106a36,0xc(%esp)
c0103a08:	c0 
c0103a09:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103a10:	c0 
c0103a11:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0103a18:	00 
c0103a19:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103a20:	e8 ce d2 ff ff       	call   c0100cf3 <__panic>
    assert(p0 + 2 == p1);
c0103a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a28:	83 c0 28             	add    $0x28,%eax
c0103a2b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103a2e:	74 24                	je     c0103a54 <default_check+0x35d>
c0103a30:	c7 44 24 0c 3e 6b 10 	movl   $0xc0106b3e,0xc(%esp)
c0103a37:	c0 
c0103a38:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103a3f:	c0 
c0103a40:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0103a47:	00 
c0103a48:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103a4f:	e8 9f d2 ff ff       	call   c0100cf3 <__panic>

    p2 = p0 + 1;
c0103a54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a57:	83 c0 14             	add    $0x14,%eax
c0103a5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103a5d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a64:	00 
c0103a65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a68:	89 04 24             	mov    %eax,(%esp)
c0103a6b:	e8 76 06 00 00       	call   c01040e6 <free_pages>
    free_pages(p1, 3);
c0103a70:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103a77:	00 
c0103a78:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103a7b:	89 04 24             	mov    %eax,(%esp)
c0103a7e:	e8 63 06 00 00       	call   c01040e6 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103a83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a86:	83 c0 04             	add    $0x4,%eax
c0103a89:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103a90:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103a93:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103a96:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103a99:	0f a3 10             	bt     %edx,(%eax)
c0103a9c:	19 c0                	sbb    %eax,%eax
c0103a9e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103aa1:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103aa5:	0f 95 c0             	setne  %al
c0103aa8:	0f b6 c0             	movzbl %al,%eax
c0103aab:	85 c0                	test   %eax,%eax
c0103aad:	74 0b                	je     c0103aba <default_check+0x3c3>
c0103aaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ab2:	8b 40 08             	mov    0x8(%eax),%eax
c0103ab5:	83 f8 01             	cmp    $0x1,%eax
c0103ab8:	74 24                	je     c0103ade <default_check+0x3e7>
c0103aba:	c7 44 24 0c 4c 6b 10 	movl   $0xc0106b4c,0xc(%esp)
c0103ac1:	c0 
c0103ac2:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103ac9:	c0 
c0103aca:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c0103ad1:	00 
c0103ad2:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103ad9:	e8 15 d2 ff ff       	call   c0100cf3 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103ade:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ae1:	83 c0 04             	add    $0x4,%eax
c0103ae4:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103aeb:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103aee:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103af1:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0103af4:	0f a3 10             	bt     %edx,(%eax)
c0103af7:	19 c0                	sbb    %eax,%eax
c0103af9:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103afc:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103b00:	0f 95 c0             	setne  %al
c0103b03:	0f b6 c0             	movzbl %al,%eax
c0103b06:	85 c0                	test   %eax,%eax
c0103b08:	74 0b                	je     c0103b15 <default_check+0x41e>
c0103b0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103b0d:	8b 40 08             	mov    0x8(%eax),%eax
c0103b10:	83 f8 03             	cmp    $0x3,%eax
c0103b13:	74 24                	je     c0103b39 <default_check+0x442>
c0103b15:	c7 44 24 0c 74 6b 10 	movl   $0xc0106b74,0xc(%esp)
c0103b1c:	c0 
c0103b1d:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103b24:	c0 
c0103b25:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
c0103b2c:	00 
c0103b2d:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103b34:	e8 ba d1 ff ff       	call   c0100cf3 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103b39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b40:	e8 69 05 00 00       	call   c01040ae <alloc_pages>
c0103b45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103b48:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103b4b:	83 e8 14             	sub    $0x14,%eax
c0103b4e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103b51:	74 24                	je     c0103b77 <default_check+0x480>
c0103b53:	c7 44 24 0c 9a 6b 10 	movl   $0xc0106b9a,0xc(%esp)
c0103b5a:	c0 
c0103b5b:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103b62:	c0 
c0103b63:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c0103b6a:	00 
c0103b6b:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103b72:	e8 7c d1 ff ff       	call   c0100cf3 <__panic>
    free_page(p0);
c0103b77:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b7e:	00 
c0103b7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b82:	89 04 24             	mov    %eax,(%esp)
c0103b85:	e8 5c 05 00 00       	call   c01040e6 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103b8a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103b91:	e8 18 05 00 00       	call   c01040ae <alloc_pages>
c0103b96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103b99:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103b9c:	83 c0 14             	add    $0x14,%eax
c0103b9f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103ba2:	74 24                	je     c0103bc8 <default_check+0x4d1>
c0103ba4:	c7 44 24 0c b8 6b 10 	movl   $0xc0106bb8,0xc(%esp)
c0103bab:	c0 
c0103bac:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103bb3:	c0 
c0103bb4:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c0103bbb:	00 
c0103bbc:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103bc3:	e8 2b d1 ff ff       	call   c0100cf3 <__panic>

    free_pages(p0, 2);
c0103bc8:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103bcf:	00 
c0103bd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bd3:	89 04 24             	mov    %eax,(%esp)
c0103bd6:	e8 0b 05 00 00       	call   c01040e6 <free_pages>
    free_page(p2);
c0103bdb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103be2:	00 
c0103be3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103be6:	89 04 24             	mov    %eax,(%esp)
c0103be9:	e8 f8 04 00 00       	call   c01040e6 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103bee:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103bf5:	e8 b4 04 00 00       	call   c01040ae <alloc_pages>
c0103bfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103bfd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103c01:	75 24                	jne    c0103c27 <default_check+0x530>
c0103c03:	c7 44 24 0c d8 6b 10 	movl   $0xc0106bd8,0xc(%esp)
c0103c0a:	c0 
c0103c0b:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103c12:	c0 
c0103c13:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c0103c1a:	00 
c0103c1b:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103c22:	e8 cc d0 ff ff       	call   c0100cf3 <__panic>
    assert(alloc_page() == NULL);
c0103c27:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c2e:	e8 7b 04 00 00       	call   c01040ae <alloc_pages>
c0103c33:	85 c0                	test   %eax,%eax
c0103c35:	74 24                	je     c0103c5b <default_check+0x564>
c0103c37:	c7 44 24 0c 36 6a 10 	movl   $0xc0106a36,0xc(%esp)
c0103c3e:	c0 
c0103c3f:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103c46:	c0 
c0103c47:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c0103c4e:	00 
c0103c4f:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103c56:	e8 98 d0 ff ff       	call   c0100cf3 <__panic>

    assert(nr_free == 0);
c0103c5b:	a1 d4 af 11 c0       	mov    0xc011afd4,%eax
c0103c60:	85 c0                	test   %eax,%eax
c0103c62:	74 24                	je     c0103c88 <default_check+0x591>
c0103c64:	c7 44 24 0c 89 6a 10 	movl   $0xc0106a89,0xc(%esp)
c0103c6b:	c0 
c0103c6c:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103c73:	c0 
c0103c74:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c0103c7b:	00 
c0103c7c:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103c83:	e8 6b d0 ff ff       	call   c0100cf3 <__panic>
    nr_free = nr_free_store;
c0103c88:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c8b:	a3 d4 af 11 c0       	mov    %eax,0xc011afd4

    free_list = free_list_store;
c0103c90:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103c93:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103c96:	a3 cc af 11 c0       	mov    %eax,0xc011afcc
c0103c9b:	89 15 d0 af 11 c0    	mov    %edx,0xc011afd0
    free_pages(p0, 5);
c0103ca1:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103ca8:	00 
c0103ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103cac:	89 04 24             	mov    %eax,(%esp)
c0103caf:	e8 32 04 00 00       	call   c01040e6 <free_pages>

    le = &free_list;
c0103cb4:	c7 45 ec cc af 11 c0 	movl   $0xc011afcc,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103cbb:	eb 5b                	jmp    c0103d18 <default_check+0x621>
        assert(le->next->prev == le && le->prev->next == le);
c0103cbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cc0:	8b 40 04             	mov    0x4(%eax),%eax
c0103cc3:	8b 00                	mov    (%eax),%eax
c0103cc5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103cc8:	75 0d                	jne    c0103cd7 <default_check+0x5e0>
c0103cca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ccd:	8b 00                	mov    (%eax),%eax
c0103ccf:	8b 40 04             	mov    0x4(%eax),%eax
c0103cd2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103cd5:	74 24                	je     c0103cfb <default_check+0x604>
c0103cd7:	c7 44 24 0c f8 6b 10 	movl   $0xc0106bf8,0xc(%esp)
c0103cde:	c0 
c0103cdf:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103ce6:	c0 
c0103ce7:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c0103cee:	00 
c0103cef:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103cf6:	e8 f8 cf ff ff       	call   c0100cf3 <__panic>
        struct Page *p = le2page(le, page_link);
c0103cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cfe:	83 e8 0c             	sub    $0xc,%eax
c0103d01:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103d04:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103d08:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103d0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103d0e:	8b 40 08             	mov    0x8(%eax),%eax
c0103d11:	29 c2                	sub    %eax,%edx
c0103d13:	89 d0                	mov    %edx,%eax
c0103d15:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d1b:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103d1e:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103d21:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103d24:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103d27:	81 7d ec cc af 11 c0 	cmpl   $0xc011afcc,-0x14(%ebp)
c0103d2e:	75 8d                	jne    c0103cbd <default_check+0x5c6>
        assert(le->next->prev == le && le->prev->next == le);
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103d30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103d34:	74 24                	je     c0103d5a <default_check+0x663>
c0103d36:	c7 44 24 0c 25 6c 10 	movl   $0xc0106c25,0xc(%esp)
c0103d3d:	c0 
c0103d3e:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103d45:	c0 
c0103d46:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c0103d4d:	00 
c0103d4e:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103d55:	e8 99 cf ff ff       	call   c0100cf3 <__panic>
    assert(total == 0);
c0103d5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103d5e:	74 24                	je     c0103d84 <default_check+0x68d>
c0103d60:	c7 44 24 0c 30 6c 10 	movl   $0xc0106c30,0xc(%esp)
c0103d67:	c0 
c0103d68:	c7 44 24 08 96 68 10 	movl   $0xc0106896,0x8(%esp)
c0103d6f:	c0 
c0103d70:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
c0103d77:	00 
c0103d78:	c7 04 24 ab 68 10 c0 	movl   $0xc01068ab,(%esp)
c0103d7f:	e8 6f cf ff ff       	call   c0100cf3 <__panic>
}
c0103d84:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103d8a:	5b                   	pop    %ebx
c0103d8b:	5d                   	pop    %ebp
c0103d8c:	c3                   	ret    

c0103d8d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103d8d:	55                   	push   %ebp
c0103d8e:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103d90:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d93:	a1 e0 af 11 c0       	mov    0xc011afe0,%eax
c0103d98:	29 c2                	sub    %eax,%edx
c0103d9a:	89 d0                	mov    %edx,%eax
c0103d9c:	c1 f8 02             	sar    $0x2,%eax
c0103d9f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103da5:	5d                   	pop    %ebp
c0103da6:	c3                   	ret    

c0103da7 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103da7:	55                   	push   %ebp
c0103da8:	89 e5                	mov    %esp,%ebp
c0103daa:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103dad:	8b 45 08             	mov    0x8(%ebp),%eax
c0103db0:	89 04 24             	mov    %eax,(%esp)
c0103db3:	e8 d5 ff ff ff       	call   c0103d8d <page2ppn>
c0103db8:	c1 e0 0c             	shl    $0xc,%eax
}
c0103dbb:	c9                   	leave  
c0103dbc:	c3                   	ret    

c0103dbd <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103dbd:	55                   	push   %ebp
c0103dbe:	89 e5                	mov    %esp,%ebp
c0103dc0:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103dc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103dc6:	c1 e8 0c             	shr    $0xc,%eax
c0103dc9:	89 c2                	mov    %eax,%edx
c0103dcb:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103dd0:	39 c2                	cmp    %eax,%edx
c0103dd2:	72 1c                	jb     c0103df0 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103dd4:	c7 44 24 08 6c 6c 10 	movl   $0xc0106c6c,0x8(%esp)
c0103ddb:	c0 
c0103ddc:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103de3:	00 
c0103de4:	c7 04 24 8b 6c 10 c0 	movl   $0xc0106c8b,(%esp)
c0103deb:	e8 03 cf ff ff       	call   c0100cf3 <__panic>
    }
    return &pages[PPN(pa)];
c0103df0:	8b 0d e0 af 11 c0    	mov    0xc011afe0,%ecx
c0103df6:	8b 45 08             	mov    0x8(%ebp),%eax
c0103df9:	c1 e8 0c             	shr    $0xc,%eax
c0103dfc:	89 c2                	mov    %eax,%edx
c0103dfe:	89 d0                	mov    %edx,%eax
c0103e00:	c1 e0 02             	shl    $0x2,%eax
c0103e03:	01 d0                	add    %edx,%eax
c0103e05:	c1 e0 02             	shl    $0x2,%eax
c0103e08:	01 c8                	add    %ecx,%eax
}
c0103e0a:	c9                   	leave  
c0103e0b:	c3                   	ret    

c0103e0c <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103e0c:	55                   	push   %ebp
c0103e0d:	89 e5                	mov    %esp,%ebp
c0103e0f:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103e12:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e15:	89 04 24             	mov    %eax,(%esp)
c0103e18:	e8 8a ff ff ff       	call   c0103da7 <page2pa>
c0103e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e23:	c1 e8 0c             	shr    $0xc,%eax
c0103e26:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103e29:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103e2e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103e31:	72 23                	jb     c0103e56 <page2kva+0x4a>
c0103e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e36:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e3a:	c7 44 24 08 9c 6c 10 	movl   $0xc0106c9c,0x8(%esp)
c0103e41:	c0 
c0103e42:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103e49:	00 
c0103e4a:	c7 04 24 8b 6c 10 c0 	movl   $0xc0106c8b,(%esp)
c0103e51:	e8 9d ce ff ff       	call   c0100cf3 <__panic>
c0103e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e59:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103e5e:	c9                   	leave  
c0103e5f:	c3                   	ret    

c0103e60 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103e60:	55                   	push   %ebp
c0103e61:	89 e5                	mov    %esp,%ebp
c0103e63:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103e66:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e69:	83 e0 01             	and    $0x1,%eax
c0103e6c:	85 c0                	test   %eax,%eax
c0103e6e:	75 1c                	jne    c0103e8c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103e70:	c7 44 24 08 c0 6c 10 	movl   $0xc0106cc0,0x8(%esp)
c0103e77:	c0 
c0103e78:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103e7f:	00 
c0103e80:	c7 04 24 8b 6c 10 c0 	movl   $0xc0106c8b,(%esp)
c0103e87:	e8 67 ce ff ff       	call   c0100cf3 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103e8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103e94:	89 04 24             	mov    %eax,(%esp)
c0103e97:	e8 21 ff ff ff       	call   c0103dbd <pa2page>
}
c0103e9c:	c9                   	leave  
c0103e9d:	c3                   	ret    

c0103e9e <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0103e9e:	55                   	push   %ebp
c0103e9f:	89 e5                	mov    %esp,%ebp
c0103ea1:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103ea4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ea7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103eac:	89 04 24             	mov    %eax,(%esp)
c0103eaf:	e8 09 ff ff ff       	call   c0103dbd <pa2page>
}
c0103eb4:	c9                   	leave  
c0103eb5:	c3                   	ret    

c0103eb6 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0103eb6:	55                   	push   %ebp
c0103eb7:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103eb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ebc:	8b 00                	mov    (%eax),%eax
}
c0103ebe:	5d                   	pop    %ebp
c0103ebf:	c3                   	ret    

c0103ec0 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c0103ec0:	55                   	push   %ebp
c0103ec1:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103ec3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ec6:	8b 00                	mov    (%eax),%eax
c0103ec8:	8d 50 01             	lea    0x1(%eax),%edx
c0103ecb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ece:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103ed0:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ed3:	8b 00                	mov    (%eax),%eax
}
c0103ed5:	5d                   	pop    %ebp
c0103ed6:	c3                   	ret    

c0103ed7 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103ed7:	55                   	push   %ebp
c0103ed8:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103eda:	8b 45 08             	mov    0x8(%ebp),%eax
c0103edd:	8b 00                	mov    (%eax),%eax
c0103edf:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103ee2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ee5:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103ee7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103eea:	8b 00                	mov    (%eax),%eax
}
c0103eec:	5d                   	pop    %ebp
c0103eed:	c3                   	ret    

c0103eee <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103eee:	55                   	push   %ebp
c0103eef:	89 e5                	mov    %esp,%ebp
c0103ef1:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103ef4:	9c                   	pushf  
c0103ef5:	58                   	pop    %eax
c0103ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103efc:	25 00 02 00 00       	and    $0x200,%eax
c0103f01:	85 c0                	test   %eax,%eax
c0103f03:	74 0c                	je     c0103f11 <__intr_save+0x23>
        intr_disable();
c0103f05:	e8 dd d7 ff ff       	call   c01016e7 <intr_disable>
        return 1;
c0103f0a:	b8 01 00 00 00       	mov    $0x1,%eax
c0103f0f:	eb 05                	jmp    c0103f16 <__intr_save+0x28>
    }
    return 0;
c0103f11:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103f16:	c9                   	leave  
c0103f17:	c3                   	ret    

c0103f18 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103f18:	55                   	push   %ebp
c0103f19:	89 e5                	mov    %esp,%ebp
c0103f1b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103f1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103f22:	74 05                	je     c0103f29 <__intr_restore+0x11>
        intr_enable();
c0103f24:	e8 b8 d7 ff ff       	call   c01016e1 <intr_enable>
    }
}
c0103f29:	c9                   	leave  
c0103f2a:	c3                   	ret    

c0103f2b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103f2b:	55                   	push   %ebp
c0103f2c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103f2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f31:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103f34:	b8 23 00 00 00       	mov    $0x23,%eax
c0103f39:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103f3b:	b8 23 00 00 00       	mov    $0x23,%eax
c0103f40:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103f42:	b8 10 00 00 00       	mov    $0x10,%eax
c0103f47:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103f49:	b8 10 00 00 00       	mov    $0x10,%eax
c0103f4e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103f50:	b8 10 00 00 00       	mov    $0x10,%eax
c0103f55:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103f57:	ea 5e 3f 10 c0 08 00 	ljmp   $0x8,$0xc0103f5e
}
c0103f5e:	5d                   	pop    %ebp
c0103f5f:	c3                   	ret    

c0103f60 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103f60:	55                   	push   %ebp
c0103f61:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103f63:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f66:	a3 a4 ae 11 c0       	mov    %eax,0xc011aea4
}
c0103f6b:	5d                   	pop    %ebp
c0103f6c:	c3                   	ret    

c0103f6d <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103f6d:	55                   	push   %ebp
c0103f6e:	89 e5                	mov    %esp,%ebp
c0103f70:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103f73:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103f78:	89 04 24             	mov    %eax,(%esp)
c0103f7b:	e8 e0 ff ff ff       	call   c0103f60 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103f80:	66 c7 05 a8 ae 11 c0 	movw   $0x10,0xc011aea8
c0103f87:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103f89:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103f90:	68 00 
c0103f92:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103f97:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103f9d:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0103fa2:	c1 e8 10             	shr    $0x10,%eax
c0103fa5:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103faa:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103fb1:	83 e0 f0             	and    $0xfffffff0,%eax
c0103fb4:	83 c8 09             	or     $0x9,%eax
c0103fb7:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103fbc:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103fc3:	83 e0 ef             	and    $0xffffffef,%eax
c0103fc6:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103fcb:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103fd2:	83 e0 9f             	and    $0xffffff9f,%eax
c0103fd5:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103fda:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103fe1:	83 c8 80             	or     $0xffffff80,%eax
c0103fe4:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103fe9:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103ff0:	83 e0 f0             	and    $0xfffffff0,%eax
c0103ff3:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103ff8:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103fff:	83 e0 ef             	and    $0xffffffef,%eax
c0104002:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0104007:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c010400e:	83 e0 df             	and    $0xffffffdf,%eax
c0104011:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0104016:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c010401d:	83 c8 40             	or     $0x40,%eax
c0104020:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0104025:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c010402c:	83 e0 7f             	and    $0x7f,%eax
c010402f:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0104034:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0104039:	c1 e8 18             	shr    $0x18,%eax
c010403c:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104041:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0104048:	e8 de fe ff ff       	call   c0103f2b <lgdt>
c010404d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104053:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104057:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c010405a:	c9                   	leave  
c010405b:	c3                   	ret    

c010405c <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c010405c:	55                   	push   %ebp
c010405d:	89 e5                	mov    %esp,%ebp
c010405f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104062:	c7 05 d8 af 11 c0 50 	movl   $0xc0106c50,0xc011afd8
c0104069:	6c 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c010406c:	a1 d8 af 11 c0       	mov    0xc011afd8,%eax
c0104071:	8b 00                	mov    (%eax),%eax
c0104073:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104077:	c7 04 24 ec 6c 10 c0 	movl   $0xc0106cec,(%esp)
c010407e:	e8 c5 c2 ff ff       	call   c0100348 <cprintf>
    pmm_manager->init();
c0104083:	a1 d8 af 11 c0       	mov    0xc011afd8,%eax
c0104088:	8b 40 04             	mov    0x4(%eax),%eax
c010408b:	ff d0                	call   *%eax
}
c010408d:	c9                   	leave  
c010408e:	c3                   	ret    

c010408f <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c010408f:	55                   	push   %ebp
c0104090:	89 e5                	mov    %esp,%ebp
c0104092:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104095:	a1 d8 af 11 c0       	mov    0xc011afd8,%eax
c010409a:	8b 40 08             	mov    0x8(%eax),%eax
c010409d:	8b 55 0c             	mov    0xc(%ebp),%edx
c01040a0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01040a4:	8b 55 08             	mov    0x8(%ebp),%edx
c01040a7:	89 14 24             	mov    %edx,(%esp)
c01040aa:	ff d0                	call   *%eax
}
c01040ac:	c9                   	leave  
c01040ad:	c3                   	ret    

c01040ae <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c01040ae:	55                   	push   %ebp
c01040af:	89 e5                	mov    %esp,%ebp
c01040b1:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c01040b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01040bb:	e8 2e fe ff ff       	call   c0103eee <__intr_save>
c01040c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c01040c3:	a1 d8 af 11 c0       	mov    0xc011afd8,%eax
c01040c8:	8b 40 0c             	mov    0xc(%eax),%eax
c01040cb:	8b 55 08             	mov    0x8(%ebp),%edx
c01040ce:	89 14 24             	mov    %edx,(%esp)
c01040d1:	ff d0                	call   *%eax
c01040d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c01040d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040d9:	89 04 24             	mov    %eax,(%esp)
c01040dc:	e8 37 fe ff ff       	call   c0103f18 <__intr_restore>
    return page;
c01040e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01040e4:	c9                   	leave  
c01040e5:	c3                   	ret    

c01040e6 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c01040e6:	55                   	push   %ebp
c01040e7:	89 e5                	mov    %esp,%ebp
c01040e9:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01040ec:	e8 fd fd ff ff       	call   c0103eee <__intr_save>
c01040f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c01040f4:	a1 d8 af 11 c0       	mov    0xc011afd8,%eax
c01040f9:	8b 40 10             	mov    0x10(%eax),%eax
c01040fc:	8b 55 0c             	mov    0xc(%ebp),%edx
c01040ff:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104103:	8b 55 08             	mov    0x8(%ebp),%edx
c0104106:	89 14 24             	mov    %edx,(%esp)
c0104109:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c010410b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010410e:	89 04 24             	mov    %eax,(%esp)
c0104111:	e8 02 fe ff ff       	call   c0103f18 <__intr_restore>
}
c0104116:	c9                   	leave  
c0104117:	c3                   	ret    

c0104118 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0104118:	55                   	push   %ebp
c0104119:	89 e5                	mov    %esp,%ebp
c010411b:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c010411e:	e8 cb fd ff ff       	call   c0103eee <__intr_save>
c0104123:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104126:	a1 d8 af 11 c0       	mov    0xc011afd8,%eax
c010412b:	8b 40 14             	mov    0x14(%eax),%eax
c010412e:	ff d0                	call   *%eax
c0104130:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104133:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104136:	89 04 24             	mov    %eax,(%esp)
c0104139:	e8 da fd ff ff       	call   c0103f18 <__intr_restore>
    return ret;
c010413e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104141:	c9                   	leave  
c0104142:	c3                   	ret    

c0104143 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104143:	55                   	push   %ebp
c0104144:	89 e5                	mov    %esp,%ebp
c0104146:	57                   	push   %edi
c0104147:	56                   	push   %esi
c0104148:	53                   	push   %ebx
c0104149:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c010414f:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104156:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c010415d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104164:	c7 04 24 03 6d 10 c0 	movl   $0xc0106d03,(%esp)
c010416b:	e8 d8 c1 ff ff       	call   c0100348 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104170:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104177:	e9 15 01 00 00       	jmp    c0104291 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010417c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010417f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104182:	89 d0                	mov    %edx,%eax
c0104184:	c1 e0 02             	shl    $0x2,%eax
c0104187:	01 d0                	add    %edx,%eax
c0104189:	c1 e0 02             	shl    $0x2,%eax
c010418c:	01 c8                	add    %ecx,%eax
c010418e:	8b 50 08             	mov    0x8(%eax),%edx
c0104191:	8b 40 04             	mov    0x4(%eax),%eax
c0104194:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104197:	89 55 bc             	mov    %edx,-0x44(%ebp)
c010419a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010419d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041a0:	89 d0                	mov    %edx,%eax
c01041a2:	c1 e0 02             	shl    $0x2,%eax
c01041a5:	01 d0                	add    %edx,%eax
c01041a7:	c1 e0 02             	shl    $0x2,%eax
c01041aa:	01 c8                	add    %ecx,%eax
c01041ac:	8b 48 0c             	mov    0xc(%eax),%ecx
c01041af:	8b 58 10             	mov    0x10(%eax),%ebx
c01041b2:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01041b5:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01041b8:	01 c8                	add    %ecx,%eax
c01041ba:	11 da                	adc    %ebx,%edx
c01041bc:	89 45 b0             	mov    %eax,-0x50(%ebp)
c01041bf:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c01041c2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01041c5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041c8:	89 d0                	mov    %edx,%eax
c01041ca:	c1 e0 02             	shl    $0x2,%eax
c01041cd:	01 d0                	add    %edx,%eax
c01041cf:	c1 e0 02             	shl    $0x2,%eax
c01041d2:	01 c8                	add    %ecx,%eax
c01041d4:	83 c0 14             	add    $0x14,%eax
c01041d7:	8b 00                	mov    (%eax),%eax
c01041d9:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c01041df:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01041e2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01041e5:	83 c0 ff             	add    $0xffffffff,%eax
c01041e8:	83 d2 ff             	adc    $0xffffffff,%edx
c01041eb:	89 c6                	mov    %eax,%esi
c01041ed:	89 d7                	mov    %edx,%edi
c01041ef:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01041f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041f5:	89 d0                	mov    %edx,%eax
c01041f7:	c1 e0 02             	shl    $0x2,%eax
c01041fa:	01 d0                	add    %edx,%eax
c01041fc:	c1 e0 02             	shl    $0x2,%eax
c01041ff:	01 c8                	add    %ecx,%eax
c0104201:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104204:	8b 58 10             	mov    0x10(%eax),%ebx
c0104207:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c010420d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104211:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104215:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0104219:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010421c:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010421f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104223:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104227:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010422b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c010422f:	c7 04 24 10 6d 10 c0 	movl   $0xc0106d10,(%esp)
c0104236:	e8 0d c1 ff ff       	call   c0100348 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c010423b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010423e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104241:	89 d0                	mov    %edx,%eax
c0104243:	c1 e0 02             	shl    $0x2,%eax
c0104246:	01 d0                	add    %edx,%eax
c0104248:	c1 e0 02             	shl    $0x2,%eax
c010424b:	01 c8                	add    %ecx,%eax
c010424d:	83 c0 14             	add    $0x14,%eax
c0104250:	8b 00                	mov    (%eax),%eax
c0104252:	83 f8 01             	cmp    $0x1,%eax
c0104255:	75 36                	jne    c010428d <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0104257:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010425a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010425d:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104260:	77 2b                	ja     c010428d <page_init+0x14a>
c0104262:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104265:	72 05                	jb     c010426c <page_init+0x129>
c0104267:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c010426a:	73 21                	jae    c010428d <page_init+0x14a>
c010426c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104270:	77 1b                	ja     c010428d <page_init+0x14a>
c0104272:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104276:	72 09                	jb     c0104281 <page_init+0x13e>
c0104278:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c010427f:	77 0c                	ja     c010428d <page_init+0x14a>
                maxpa = end;
c0104281:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104284:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104287:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010428a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010428d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104291:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104294:	8b 00                	mov    (%eax),%eax
c0104296:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104299:	0f 8f dd fe ff ff    	jg     c010417c <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c010429f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01042a3:	72 1d                	jb     c01042c2 <page_init+0x17f>
c01042a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01042a9:	77 09                	ja     c01042b4 <page_init+0x171>
c01042ab:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c01042b2:	76 0e                	jbe    c01042c2 <page_init+0x17f>
        maxpa = KMEMSIZE;
c01042b4:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c01042bb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c01042c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01042c8:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01042cc:	c1 ea 0c             	shr    $0xc,%edx
c01042cf:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01042d4:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c01042db:	b8 e4 af 11 c0       	mov    $0xc011afe4,%eax
c01042e0:	8d 50 ff             	lea    -0x1(%eax),%edx
c01042e3:	8b 45 ac             	mov    -0x54(%ebp),%eax
c01042e6:	01 d0                	add    %edx,%eax
c01042e8:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01042eb:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01042ee:	ba 00 00 00 00       	mov    $0x0,%edx
c01042f3:	f7 75 ac             	divl   -0x54(%ebp)
c01042f6:	89 d0                	mov    %edx,%eax
c01042f8:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01042fb:	29 c2                	sub    %eax,%edx
c01042fd:	89 d0                	mov    %edx,%eax
c01042ff:	a3 e0 af 11 c0       	mov    %eax,0xc011afe0

    for (i = 0; i < npage; i ++) {
c0104304:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010430b:	eb 2f                	jmp    c010433c <page_init+0x1f9>
        SetPageReserved(pages + i);
c010430d:	8b 0d e0 af 11 c0    	mov    0xc011afe0,%ecx
c0104313:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104316:	89 d0                	mov    %edx,%eax
c0104318:	c1 e0 02             	shl    $0x2,%eax
c010431b:	01 d0                	add    %edx,%eax
c010431d:	c1 e0 02             	shl    $0x2,%eax
c0104320:	01 c8                	add    %ecx,%eax
c0104322:	83 c0 04             	add    $0x4,%eax
c0104325:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c010432c:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010432f:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104332:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104335:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0104338:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010433c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010433f:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104344:	39 c2                	cmp    %eax,%edx
c0104346:	72 c5                	jb     c010430d <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104348:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c010434e:	89 d0                	mov    %edx,%eax
c0104350:	c1 e0 02             	shl    $0x2,%eax
c0104353:	01 d0                	add    %edx,%eax
c0104355:	c1 e0 02             	shl    $0x2,%eax
c0104358:	89 c2                	mov    %eax,%edx
c010435a:	a1 e0 af 11 c0       	mov    0xc011afe0,%eax
c010435f:	01 d0                	add    %edx,%eax
c0104361:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104364:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c010436b:	77 23                	ja     c0104390 <page_init+0x24d>
c010436d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104370:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104374:	c7 44 24 08 40 6d 10 	movl   $0xc0106d40,0x8(%esp)
c010437b:	c0 
c010437c:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0104383:	00 
c0104384:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c010438b:	e8 63 c9 ff ff       	call   c0100cf3 <__panic>
c0104390:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104393:	05 00 00 00 40       	add    $0x40000000,%eax
c0104398:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c010439b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01043a2:	e9 74 01 00 00       	jmp    c010451b <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01043a7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01043aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01043ad:	89 d0                	mov    %edx,%eax
c01043af:	c1 e0 02             	shl    $0x2,%eax
c01043b2:	01 d0                	add    %edx,%eax
c01043b4:	c1 e0 02             	shl    $0x2,%eax
c01043b7:	01 c8                	add    %ecx,%eax
c01043b9:	8b 50 08             	mov    0x8(%eax),%edx
c01043bc:	8b 40 04             	mov    0x4(%eax),%eax
c01043bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01043c2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01043c5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01043c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01043cb:	89 d0                	mov    %edx,%eax
c01043cd:	c1 e0 02             	shl    $0x2,%eax
c01043d0:	01 d0                	add    %edx,%eax
c01043d2:	c1 e0 02             	shl    $0x2,%eax
c01043d5:	01 c8                	add    %ecx,%eax
c01043d7:	8b 48 0c             	mov    0xc(%eax),%ecx
c01043da:	8b 58 10             	mov    0x10(%eax),%ebx
c01043dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01043e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01043e3:	01 c8                	add    %ecx,%eax
c01043e5:	11 da                	adc    %ebx,%edx
c01043e7:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01043ea:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01043ed:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01043f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01043f3:	89 d0                	mov    %edx,%eax
c01043f5:	c1 e0 02             	shl    $0x2,%eax
c01043f8:	01 d0                	add    %edx,%eax
c01043fa:	c1 e0 02             	shl    $0x2,%eax
c01043fd:	01 c8                	add    %ecx,%eax
c01043ff:	83 c0 14             	add    $0x14,%eax
c0104402:	8b 00                	mov    (%eax),%eax
c0104404:	83 f8 01             	cmp    $0x1,%eax
c0104407:	0f 85 0a 01 00 00    	jne    c0104517 <page_init+0x3d4>
            if (begin < freemem) {
c010440d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104410:	ba 00 00 00 00       	mov    $0x0,%edx
c0104415:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104418:	72 17                	jb     c0104431 <page_init+0x2ee>
c010441a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010441d:	77 05                	ja     c0104424 <page_init+0x2e1>
c010441f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104422:	76 0d                	jbe    c0104431 <page_init+0x2ee>
                begin = freemem;
c0104424:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104427:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010442a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104431:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104435:	72 1d                	jb     c0104454 <page_init+0x311>
c0104437:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010443b:	77 09                	ja     c0104446 <page_init+0x303>
c010443d:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104444:	76 0e                	jbe    c0104454 <page_init+0x311>
                end = KMEMSIZE;
c0104446:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c010444d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104454:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104457:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010445a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010445d:	0f 87 b4 00 00 00    	ja     c0104517 <page_init+0x3d4>
c0104463:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104466:	72 09                	jb     c0104471 <page_init+0x32e>
c0104468:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010446b:	0f 83 a6 00 00 00    	jae    c0104517 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104471:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104478:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010447b:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010447e:	01 d0                	add    %edx,%eax
c0104480:	83 e8 01             	sub    $0x1,%eax
c0104483:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104486:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104489:	ba 00 00 00 00       	mov    $0x0,%edx
c010448e:	f7 75 9c             	divl   -0x64(%ebp)
c0104491:	89 d0                	mov    %edx,%eax
c0104493:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104496:	29 c2                	sub    %eax,%edx
c0104498:	89 d0                	mov    %edx,%eax
c010449a:	ba 00 00 00 00       	mov    $0x0,%edx
c010449f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01044a2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01044a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01044a8:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01044ab:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01044ae:	ba 00 00 00 00       	mov    $0x0,%edx
c01044b3:	89 c7                	mov    %eax,%edi
c01044b5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01044bb:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01044be:	89 d0                	mov    %edx,%eax
c01044c0:	83 e0 00             	and    $0x0,%eax
c01044c3:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01044c6:	8b 45 80             	mov    -0x80(%ebp),%eax
c01044c9:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01044cc:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01044cf:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01044d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01044d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01044d8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01044db:	77 3a                	ja     c0104517 <page_init+0x3d4>
c01044dd:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01044e0:	72 05                	jb     c01044e7 <page_init+0x3a4>
c01044e2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01044e5:	73 30                	jae    c0104517 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01044e7:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01044ea:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01044ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01044f0:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01044f3:	29 c8                	sub    %ecx,%eax
c01044f5:	19 da                	sbb    %ebx,%edx
c01044f7:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01044fb:	c1 ea 0c             	shr    $0xc,%edx
c01044fe:	89 c3                	mov    %eax,%ebx
c0104500:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104503:	89 04 24             	mov    %eax,(%esp)
c0104506:	e8 b2 f8 ff ff       	call   c0103dbd <pa2page>
c010450b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010450f:	89 04 24             	mov    %eax,(%esp)
c0104512:	e8 78 fb ff ff       	call   c010408f <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104517:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010451b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010451e:	8b 00                	mov    (%eax),%eax
c0104520:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104523:	0f 8f 7e fe ff ff    	jg     c01043a7 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104529:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c010452f:	5b                   	pop    %ebx
c0104530:	5e                   	pop    %esi
c0104531:	5f                   	pop    %edi
c0104532:	5d                   	pop    %ebp
c0104533:	c3                   	ret    

c0104534 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104534:	55                   	push   %ebp
c0104535:	89 e5                	mov    %esp,%ebp
c0104537:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010453a:	8b 45 14             	mov    0x14(%ebp),%eax
c010453d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104540:	31 d0                	xor    %edx,%eax
c0104542:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104547:	85 c0                	test   %eax,%eax
c0104549:	74 24                	je     c010456f <boot_map_segment+0x3b>
c010454b:	c7 44 24 0c 72 6d 10 	movl   $0xc0106d72,0xc(%esp)
c0104552:	c0 
c0104553:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c010455a:	c0 
c010455b:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0104562:	00 
c0104563:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c010456a:	e8 84 c7 ff ff       	call   c0100cf3 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010456f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104576:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104579:	25 ff 0f 00 00       	and    $0xfff,%eax
c010457e:	89 c2                	mov    %eax,%edx
c0104580:	8b 45 10             	mov    0x10(%ebp),%eax
c0104583:	01 c2                	add    %eax,%edx
c0104585:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104588:	01 d0                	add    %edx,%eax
c010458a:	83 e8 01             	sub    $0x1,%eax
c010458d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104590:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104593:	ba 00 00 00 00       	mov    $0x0,%edx
c0104598:	f7 75 f0             	divl   -0x10(%ebp)
c010459b:	89 d0                	mov    %edx,%eax
c010459d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01045a0:	29 c2                	sub    %eax,%edx
c01045a2:	89 d0                	mov    %edx,%eax
c01045a4:	c1 e8 0c             	shr    $0xc,%eax
c01045a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01045aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01045b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01045b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01045b8:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01045bb:	8b 45 14             	mov    0x14(%ebp),%eax
c01045be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01045c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01045c9:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01045cc:	eb 6b                	jmp    c0104639 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01045ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01045d5:	00 
c01045d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01045e0:	89 04 24             	mov    %eax,(%esp)
c01045e3:	e8 82 01 00 00       	call   c010476a <get_pte>
c01045e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01045eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01045ef:	75 24                	jne    c0104615 <boot_map_segment+0xe1>
c01045f1:	c7 44 24 0c 9e 6d 10 	movl   $0xc0106d9e,0xc(%esp)
c01045f8:	c0 
c01045f9:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104600:	c0 
c0104601:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0104608:	00 
c0104609:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104610:	e8 de c6 ff ff       	call   c0100cf3 <__panic>
        *ptep = pa | PTE_P | perm;
c0104615:	8b 45 18             	mov    0x18(%ebp),%eax
c0104618:	8b 55 14             	mov    0x14(%ebp),%edx
c010461b:	09 d0                	or     %edx,%eax
c010461d:	83 c8 01             	or     $0x1,%eax
c0104620:	89 c2                	mov    %eax,%edx
c0104622:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104625:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104627:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010462b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104632:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010463d:	75 8f                	jne    c01045ce <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010463f:	c9                   	leave  
c0104640:	c3                   	ret    

c0104641 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104641:	55                   	push   %ebp
c0104642:	89 e5                	mov    %esp,%ebp
c0104644:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104647:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010464e:	e8 5b fa ff ff       	call   c01040ae <alloc_pages>
c0104653:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104656:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010465a:	75 1c                	jne    c0104678 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010465c:	c7 44 24 08 ab 6d 10 	movl   $0xc0106dab,0x8(%esp)
c0104663:	c0 
c0104664:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c010466b:	00 
c010466c:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104673:	e8 7b c6 ff ff       	call   c0100cf3 <__panic>
    }
    return page2kva(p);
c0104678:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010467b:	89 04 24             	mov    %eax,(%esp)
c010467e:	e8 89 f7 ff ff       	call   c0103e0c <page2kva>
}
c0104683:	c9                   	leave  
c0104684:	c3                   	ret    

c0104685 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104685:	55                   	push   %ebp
c0104686:	89 e5                	mov    %esp,%ebp
c0104688:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c010468b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104690:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104693:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010469a:	77 23                	ja     c01046bf <pmm_init+0x3a>
c010469c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010469f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01046a3:	c7 44 24 08 40 6d 10 	movl   $0xc0106d40,0x8(%esp)
c01046aa:	c0 
c01046ab:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01046b2:	00 
c01046b3:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c01046ba:	e8 34 c6 ff ff       	call   c0100cf3 <__panic>
c01046bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c2:	05 00 00 00 40       	add    $0x40000000,%eax
c01046c7:	a3 dc af 11 c0       	mov    %eax,0xc011afdc
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01046cc:	e8 8b f9 ff ff       	call   c010405c <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01046d1:	e8 6d fa ff ff       	call   c0104143 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01046d6:	e8 4c 02 00 00       	call   c0104927 <check_alloc_page>

    check_pgdir();
c01046db:	e8 65 02 00 00       	call   c0104945 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01046e0:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01046e5:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01046eb:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01046f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01046f3:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01046fa:	77 23                	ja     c010471f <pmm_init+0x9a>
c01046fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104703:	c7 44 24 08 40 6d 10 	movl   $0xc0106d40,0x8(%esp)
c010470a:	c0 
c010470b:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0104712:	00 
c0104713:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c010471a:	e8 d4 c5 ff ff       	call   c0100cf3 <__panic>
c010471f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104722:	05 00 00 00 40       	add    $0x40000000,%eax
c0104727:	83 c8 03             	or     $0x3,%eax
c010472a:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010472c:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104731:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104738:	00 
c0104739:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104740:	00 
c0104741:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104748:	38 
c0104749:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104750:	c0 
c0104751:	89 04 24             	mov    %eax,(%esp)
c0104754:	e8 db fd ff ff       	call   c0104534 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104759:	e8 0f f8 ff ff       	call   c0103f6d <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010475e:	e8 7d 08 00 00       	call   c0104fe0 <check_boot_pgdir>

    print_pgdir();
c0104763:	e8 05 0d 00 00       	call   c010546d <print_pgdir>

}
c0104768:	c9                   	leave  
c0104769:	c3                   	ret    

c010476a <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010476a:	55                   	push   %ebp
c010476b:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c010476d:	5d                   	pop    %ebp
c010476e:	c3                   	ret    

c010476f <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010476f:	55                   	push   %ebp
c0104770:	89 e5                	mov    %esp,%ebp
c0104772:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104775:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010477c:	00 
c010477d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104780:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104784:	8b 45 08             	mov    0x8(%ebp),%eax
c0104787:	89 04 24             	mov    %eax,(%esp)
c010478a:	e8 db ff ff ff       	call   c010476a <get_pte>
c010478f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104792:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104796:	74 08                	je     c01047a0 <get_page+0x31>
        *ptep_store = ptep;
c0104798:	8b 45 10             	mov    0x10(%ebp),%eax
c010479b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010479e:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01047a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047a4:	74 1b                	je     c01047c1 <get_page+0x52>
c01047a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047a9:	8b 00                	mov    (%eax),%eax
c01047ab:	83 e0 01             	and    $0x1,%eax
c01047ae:	85 c0                	test   %eax,%eax
c01047b0:	74 0f                	je     c01047c1 <get_page+0x52>
        return pte2page(*ptep);
c01047b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047b5:	8b 00                	mov    (%eax),%eax
c01047b7:	89 04 24             	mov    %eax,(%esp)
c01047ba:	e8 a1 f6 ff ff       	call   c0103e60 <pte2page>
c01047bf:	eb 05                	jmp    c01047c6 <get_page+0x57>
    }
    return NULL;
c01047c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01047c6:	c9                   	leave  
c01047c7:	c3                   	ret    

c01047c8 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01047c8:	55                   	push   %ebp
c01047c9:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c01047cb:	5d                   	pop    %ebp
c01047cc:	c3                   	ret    

c01047cd <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01047cd:	55                   	push   %ebp
c01047ce:	89 e5                	mov    %esp,%ebp
c01047d0:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01047d3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047da:	00 
c01047db:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047de:	89 44 24 04          	mov    %eax,0x4(%esp)
c01047e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01047e5:	89 04 24             	mov    %eax,(%esp)
c01047e8:	e8 7d ff ff ff       	call   c010476a <get_pte>
c01047ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c01047f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01047f4:	74 19                	je     c010480f <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01047f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01047f9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01047fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104800:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104804:	8b 45 08             	mov    0x8(%ebp),%eax
c0104807:	89 04 24             	mov    %eax,(%esp)
c010480a:	e8 b9 ff ff ff       	call   c01047c8 <page_remove_pte>
    }
}
c010480f:	c9                   	leave  
c0104810:	c3                   	ret    

c0104811 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104811:	55                   	push   %ebp
c0104812:	89 e5                	mov    %esp,%ebp
c0104814:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104817:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010481e:	00 
c010481f:	8b 45 10             	mov    0x10(%ebp),%eax
c0104822:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104826:	8b 45 08             	mov    0x8(%ebp),%eax
c0104829:	89 04 24             	mov    %eax,(%esp)
c010482c:	e8 39 ff ff ff       	call   c010476a <get_pte>
c0104831:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104834:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104838:	75 0a                	jne    c0104844 <page_insert+0x33>
        return -E_NO_MEM;
c010483a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010483f:	e9 84 00 00 00       	jmp    c01048c8 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104844:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104847:	89 04 24             	mov    %eax,(%esp)
c010484a:	e8 71 f6 ff ff       	call   c0103ec0 <page_ref_inc>
    if (*ptep & PTE_P) {
c010484f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104852:	8b 00                	mov    (%eax),%eax
c0104854:	83 e0 01             	and    $0x1,%eax
c0104857:	85 c0                	test   %eax,%eax
c0104859:	74 3e                	je     c0104899 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010485b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010485e:	8b 00                	mov    (%eax),%eax
c0104860:	89 04 24             	mov    %eax,(%esp)
c0104863:	e8 f8 f5 ff ff       	call   c0103e60 <pte2page>
c0104868:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010486b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010486e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104871:	75 0d                	jne    c0104880 <page_insert+0x6f>
            page_ref_dec(page);
c0104873:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104876:	89 04 24             	mov    %eax,(%esp)
c0104879:	e8 59 f6 ff ff       	call   c0103ed7 <page_ref_dec>
c010487e:	eb 19                	jmp    c0104899 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104880:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104883:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104887:	8b 45 10             	mov    0x10(%ebp),%eax
c010488a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010488e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104891:	89 04 24             	mov    %eax,(%esp)
c0104894:	e8 2f ff ff ff       	call   c01047c8 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104899:	8b 45 0c             	mov    0xc(%ebp),%eax
c010489c:	89 04 24             	mov    %eax,(%esp)
c010489f:	e8 03 f5 ff ff       	call   c0103da7 <page2pa>
c01048a4:	0b 45 14             	or     0x14(%ebp),%eax
c01048a7:	83 c8 01             	or     $0x1,%eax
c01048aa:	89 c2                	mov    %eax,%edx
c01048ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048af:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01048b1:	8b 45 10             	mov    0x10(%ebp),%eax
c01048b4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01048bb:	89 04 24             	mov    %eax,(%esp)
c01048be:	e8 07 00 00 00       	call   c01048ca <tlb_invalidate>
    return 0;
c01048c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01048c8:	c9                   	leave  
c01048c9:	c3                   	ret    

c01048ca <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01048ca:	55                   	push   %ebp
c01048cb:	89 e5                	mov    %esp,%ebp
c01048cd:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01048d0:	0f 20 d8             	mov    %cr3,%eax
c01048d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01048d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01048d9:	89 c2                	mov    %eax,%edx
c01048db:	8b 45 08             	mov    0x8(%ebp),%eax
c01048de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048e1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01048e8:	77 23                	ja     c010490d <tlb_invalidate+0x43>
c01048ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01048f1:	c7 44 24 08 40 6d 10 	movl   $0xc0106d40,0x8(%esp)
c01048f8:	c0 
c01048f9:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
c0104900:	00 
c0104901:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104908:	e8 e6 c3 ff ff       	call   c0100cf3 <__panic>
c010490d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104910:	05 00 00 00 40       	add    $0x40000000,%eax
c0104915:	39 c2                	cmp    %eax,%edx
c0104917:	75 0c                	jne    c0104925 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104919:	8b 45 0c             	mov    0xc(%ebp),%eax
c010491c:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010491f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104922:	0f 01 38             	invlpg (%eax)
    }
}
c0104925:	c9                   	leave  
c0104926:	c3                   	ret    

c0104927 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104927:	55                   	push   %ebp
c0104928:	89 e5                	mov    %esp,%ebp
c010492a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010492d:	a1 d8 af 11 c0       	mov    0xc011afd8,%eax
c0104932:	8b 40 18             	mov    0x18(%eax),%eax
c0104935:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104937:	c7 04 24 c4 6d 10 c0 	movl   $0xc0106dc4,(%esp)
c010493e:	e8 05 ba ff ff       	call   c0100348 <cprintf>
}
c0104943:	c9                   	leave  
c0104944:	c3                   	ret    

c0104945 <check_pgdir>:

static void
check_pgdir(void) {
c0104945:	55                   	push   %ebp
c0104946:	89 e5                	mov    %esp,%ebp
c0104948:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010494b:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104950:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104955:	76 24                	jbe    c010497b <check_pgdir+0x36>
c0104957:	c7 44 24 0c e3 6d 10 	movl   $0xc0106de3,0xc(%esp)
c010495e:	c0 
c010495f:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104966:	c0 
c0104967:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
c010496e:	00 
c010496f:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104976:	e8 78 c3 ff ff       	call   c0100cf3 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010497b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104980:	85 c0                	test   %eax,%eax
c0104982:	74 0e                	je     c0104992 <check_pgdir+0x4d>
c0104984:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104989:	25 ff 0f 00 00       	and    $0xfff,%eax
c010498e:	85 c0                	test   %eax,%eax
c0104990:	74 24                	je     c01049b6 <check_pgdir+0x71>
c0104992:	c7 44 24 0c 00 6e 10 	movl   $0xc0106e00,0xc(%esp)
c0104999:	c0 
c010499a:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c01049a1:	c0 
c01049a2:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
c01049a9:	00 
c01049aa:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c01049b1:	e8 3d c3 ff ff       	call   c0100cf3 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01049b6:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01049bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049c2:	00 
c01049c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01049ca:	00 
c01049cb:	89 04 24             	mov    %eax,(%esp)
c01049ce:	e8 9c fd ff ff       	call   c010476f <get_page>
c01049d3:	85 c0                	test   %eax,%eax
c01049d5:	74 24                	je     c01049fb <check_pgdir+0xb6>
c01049d7:	c7 44 24 0c 38 6e 10 	movl   $0xc0106e38,0xc(%esp)
c01049de:	c0 
c01049df:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c01049e6:	c0 
c01049e7:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
c01049ee:	00 
c01049ef:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c01049f6:	e8 f8 c2 ff ff       	call   c0100cf3 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01049fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a02:	e8 a7 f6 ff ff       	call   c01040ae <alloc_pages>
c0104a07:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104a0a:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104a0f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104a16:	00 
c0104a17:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a1e:	00 
c0104a1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104a22:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a26:	89 04 24             	mov    %eax,(%esp)
c0104a29:	e8 e3 fd ff ff       	call   c0104811 <page_insert>
c0104a2e:	85 c0                	test   %eax,%eax
c0104a30:	74 24                	je     c0104a56 <check_pgdir+0x111>
c0104a32:	c7 44 24 0c 60 6e 10 	movl   $0xc0106e60,0xc(%esp)
c0104a39:	c0 
c0104a3a:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104a41:	c0 
c0104a42:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
c0104a49:	00 
c0104a4a:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104a51:	e8 9d c2 ff ff       	call   c0100cf3 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104a56:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104a5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a62:	00 
c0104a63:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a6a:	00 
c0104a6b:	89 04 24             	mov    %eax,(%esp)
c0104a6e:	e8 f7 fc ff ff       	call   c010476a <get_pte>
c0104a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a7a:	75 24                	jne    c0104aa0 <check_pgdir+0x15b>
c0104a7c:	c7 44 24 0c 8c 6e 10 	movl   $0xc0106e8c,0xc(%esp)
c0104a83:	c0 
c0104a84:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104a8b:	c0 
c0104a8c:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
c0104a93:	00 
c0104a94:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104a9b:	e8 53 c2 ff ff       	call   c0100cf3 <__panic>
    assert(pte2page(*ptep) == p1);
c0104aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104aa3:	8b 00                	mov    (%eax),%eax
c0104aa5:	89 04 24             	mov    %eax,(%esp)
c0104aa8:	e8 b3 f3 ff ff       	call   c0103e60 <pte2page>
c0104aad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104ab0:	74 24                	je     c0104ad6 <check_pgdir+0x191>
c0104ab2:	c7 44 24 0c b9 6e 10 	movl   $0xc0106eb9,0xc(%esp)
c0104ab9:	c0 
c0104aba:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104ac1:	c0 
c0104ac2:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
c0104ac9:	00 
c0104aca:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104ad1:	e8 1d c2 ff ff       	call   c0100cf3 <__panic>
    assert(page_ref(p1) == 1);
c0104ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ad9:	89 04 24             	mov    %eax,(%esp)
c0104adc:	e8 d5 f3 ff ff       	call   c0103eb6 <page_ref>
c0104ae1:	83 f8 01             	cmp    $0x1,%eax
c0104ae4:	74 24                	je     c0104b0a <check_pgdir+0x1c5>
c0104ae6:	c7 44 24 0c cf 6e 10 	movl   $0xc0106ecf,0xc(%esp)
c0104aed:	c0 
c0104aee:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104af5:	c0 
c0104af6:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c0104afd:	00 
c0104afe:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104b05:	e8 e9 c1 ff ff       	call   c0100cf3 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104b0a:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104b0f:	8b 00                	mov    (%eax),%eax
c0104b11:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b16:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b1c:	c1 e8 0c             	shr    $0xc,%eax
c0104b1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104b22:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0104b27:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104b2a:	72 23                	jb     c0104b4f <check_pgdir+0x20a>
c0104b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b33:	c7 44 24 08 9c 6c 10 	movl   $0xc0106c9c,0x8(%esp)
c0104b3a:	c0 
c0104b3b:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
c0104b42:	00 
c0104b43:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104b4a:	e8 a4 c1 ff ff       	call   c0100cf3 <__panic>
c0104b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b52:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104b57:	83 c0 04             	add    $0x4,%eax
c0104b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104b5d:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104b62:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b69:	00 
c0104b6a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b71:	00 
c0104b72:	89 04 24             	mov    %eax,(%esp)
c0104b75:	e8 f0 fb ff ff       	call   c010476a <get_pte>
c0104b7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104b7d:	74 24                	je     c0104ba3 <check_pgdir+0x25e>
c0104b7f:	c7 44 24 0c e4 6e 10 	movl   $0xc0106ee4,0xc(%esp)
c0104b86:	c0 
c0104b87:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104b8e:	c0 
c0104b8f:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
c0104b96:	00 
c0104b97:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104b9e:	e8 50 c1 ff ff       	call   c0100cf3 <__panic>

    p2 = alloc_page();
c0104ba3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104baa:	e8 ff f4 ff ff       	call   c01040ae <alloc_pages>
c0104baf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104bb2:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104bb7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104bbe:	00 
c0104bbf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104bc6:	00 
c0104bc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104bca:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104bce:	89 04 24             	mov    %eax,(%esp)
c0104bd1:	e8 3b fc ff ff       	call   c0104811 <page_insert>
c0104bd6:	85 c0                	test   %eax,%eax
c0104bd8:	74 24                	je     c0104bfe <check_pgdir+0x2b9>
c0104bda:	c7 44 24 0c 0c 6f 10 	movl   $0xc0106f0c,0xc(%esp)
c0104be1:	c0 
c0104be2:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104be9:	c0 
c0104bea:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
c0104bf1:	00 
c0104bf2:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104bf9:	e8 f5 c0 ff ff       	call   c0100cf3 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104bfe:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104c03:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c0a:	00 
c0104c0b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c12:	00 
c0104c13:	89 04 24             	mov    %eax,(%esp)
c0104c16:	e8 4f fb ff ff       	call   c010476a <get_pte>
c0104c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c22:	75 24                	jne    c0104c48 <check_pgdir+0x303>
c0104c24:	c7 44 24 0c 44 6f 10 	movl   $0xc0106f44,0xc(%esp)
c0104c2b:	c0 
c0104c2c:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104c33:	c0 
c0104c34:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
c0104c3b:	00 
c0104c3c:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104c43:	e8 ab c0 ff ff       	call   c0100cf3 <__panic>
    assert(*ptep & PTE_U);
c0104c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c4b:	8b 00                	mov    (%eax),%eax
c0104c4d:	83 e0 04             	and    $0x4,%eax
c0104c50:	85 c0                	test   %eax,%eax
c0104c52:	75 24                	jne    c0104c78 <check_pgdir+0x333>
c0104c54:	c7 44 24 0c 74 6f 10 	movl   $0xc0106f74,0xc(%esp)
c0104c5b:	c0 
c0104c5c:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104c63:	c0 
c0104c64:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
c0104c6b:	00 
c0104c6c:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104c73:	e8 7b c0 ff ff       	call   c0100cf3 <__panic>
    assert(*ptep & PTE_W);
c0104c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c7b:	8b 00                	mov    (%eax),%eax
c0104c7d:	83 e0 02             	and    $0x2,%eax
c0104c80:	85 c0                	test   %eax,%eax
c0104c82:	75 24                	jne    c0104ca8 <check_pgdir+0x363>
c0104c84:	c7 44 24 0c 82 6f 10 	movl   $0xc0106f82,0xc(%esp)
c0104c8b:	c0 
c0104c8c:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104c93:	c0 
c0104c94:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c0104c9b:	00 
c0104c9c:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104ca3:	e8 4b c0 ff ff       	call   c0100cf3 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104ca8:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104cad:	8b 00                	mov    (%eax),%eax
c0104caf:	83 e0 04             	and    $0x4,%eax
c0104cb2:	85 c0                	test   %eax,%eax
c0104cb4:	75 24                	jne    c0104cda <check_pgdir+0x395>
c0104cb6:	c7 44 24 0c 90 6f 10 	movl   $0xc0106f90,0xc(%esp)
c0104cbd:	c0 
c0104cbe:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104cc5:	c0 
c0104cc6:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0104ccd:	00 
c0104cce:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104cd5:	e8 19 c0 ff ff       	call   c0100cf3 <__panic>
    assert(page_ref(p2) == 1);
c0104cda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104cdd:	89 04 24             	mov    %eax,(%esp)
c0104ce0:	e8 d1 f1 ff ff       	call   c0103eb6 <page_ref>
c0104ce5:	83 f8 01             	cmp    $0x1,%eax
c0104ce8:	74 24                	je     c0104d0e <check_pgdir+0x3c9>
c0104cea:	c7 44 24 0c a6 6f 10 	movl   $0xc0106fa6,0xc(%esp)
c0104cf1:	c0 
c0104cf2:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104cf9:	c0 
c0104cfa:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0104d01:	00 
c0104d02:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104d09:	e8 e5 bf ff ff       	call   c0100cf3 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104d0e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104d13:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104d1a:	00 
c0104d1b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104d22:	00 
c0104d23:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104d26:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d2a:	89 04 24             	mov    %eax,(%esp)
c0104d2d:	e8 df fa ff ff       	call   c0104811 <page_insert>
c0104d32:	85 c0                	test   %eax,%eax
c0104d34:	74 24                	je     c0104d5a <check_pgdir+0x415>
c0104d36:	c7 44 24 0c b8 6f 10 	movl   $0xc0106fb8,0xc(%esp)
c0104d3d:	c0 
c0104d3e:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104d45:	c0 
c0104d46:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c0104d4d:	00 
c0104d4e:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104d55:	e8 99 bf ff ff       	call   c0100cf3 <__panic>
    assert(page_ref(p1) == 2);
c0104d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d5d:	89 04 24             	mov    %eax,(%esp)
c0104d60:	e8 51 f1 ff ff       	call   c0103eb6 <page_ref>
c0104d65:	83 f8 02             	cmp    $0x2,%eax
c0104d68:	74 24                	je     c0104d8e <check_pgdir+0x449>
c0104d6a:	c7 44 24 0c e4 6f 10 	movl   $0xc0106fe4,0xc(%esp)
c0104d71:	c0 
c0104d72:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104d79:	c0 
c0104d7a:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c0104d81:	00 
c0104d82:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104d89:	e8 65 bf ff ff       	call   c0100cf3 <__panic>
    assert(page_ref(p2) == 0);
c0104d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d91:	89 04 24             	mov    %eax,(%esp)
c0104d94:	e8 1d f1 ff ff       	call   c0103eb6 <page_ref>
c0104d99:	85 c0                	test   %eax,%eax
c0104d9b:	74 24                	je     c0104dc1 <check_pgdir+0x47c>
c0104d9d:	c7 44 24 0c f6 6f 10 	movl   $0xc0106ff6,0xc(%esp)
c0104da4:	c0 
c0104da5:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104dac:	c0 
c0104dad:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
c0104db4:	00 
c0104db5:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104dbc:	e8 32 bf ff ff       	call   c0100cf3 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104dc1:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104dc6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104dcd:	00 
c0104dce:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104dd5:	00 
c0104dd6:	89 04 24             	mov    %eax,(%esp)
c0104dd9:	e8 8c f9 ff ff       	call   c010476a <get_pte>
c0104dde:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104de1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104de5:	75 24                	jne    c0104e0b <check_pgdir+0x4c6>
c0104de7:	c7 44 24 0c 44 6f 10 	movl   $0xc0106f44,0xc(%esp)
c0104dee:	c0 
c0104def:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104df6:	c0 
c0104df7:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c0104dfe:	00 
c0104dff:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104e06:	e8 e8 be ff ff       	call   c0100cf3 <__panic>
    assert(pte2page(*ptep) == p1);
c0104e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e0e:	8b 00                	mov    (%eax),%eax
c0104e10:	89 04 24             	mov    %eax,(%esp)
c0104e13:	e8 48 f0 ff ff       	call   c0103e60 <pte2page>
c0104e18:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104e1b:	74 24                	je     c0104e41 <check_pgdir+0x4fc>
c0104e1d:	c7 44 24 0c b9 6e 10 	movl   $0xc0106eb9,0xc(%esp)
c0104e24:	c0 
c0104e25:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104e2c:	c0 
c0104e2d:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0104e34:	00 
c0104e35:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104e3c:	e8 b2 be ff ff       	call   c0100cf3 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e44:	8b 00                	mov    (%eax),%eax
c0104e46:	83 e0 04             	and    $0x4,%eax
c0104e49:	85 c0                	test   %eax,%eax
c0104e4b:	74 24                	je     c0104e71 <check_pgdir+0x52c>
c0104e4d:	c7 44 24 0c 08 70 10 	movl   $0xc0107008,0xc(%esp)
c0104e54:	c0 
c0104e55:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104e5c:	c0 
c0104e5d:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0104e64:	00 
c0104e65:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104e6c:	e8 82 be ff ff       	call   c0100cf3 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104e71:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104e76:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104e7d:	00 
c0104e7e:	89 04 24             	mov    %eax,(%esp)
c0104e81:	e8 47 f9 ff ff       	call   c01047cd <page_remove>
    assert(page_ref(p1) == 1);
c0104e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e89:	89 04 24             	mov    %eax,(%esp)
c0104e8c:	e8 25 f0 ff ff       	call   c0103eb6 <page_ref>
c0104e91:	83 f8 01             	cmp    $0x1,%eax
c0104e94:	74 24                	je     c0104eba <check_pgdir+0x575>
c0104e96:	c7 44 24 0c cf 6e 10 	movl   $0xc0106ecf,0xc(%esp)
c0104e9d:	c0 
c0104e9e:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104ea5:	c0 
c0104ea6:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0104ead:	00 
c0104eae:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104eb5:	e8 39 be ff ff       	call   c0100cf3 <__panic>
    assert(page_ref(p2) == 0);
c0104eba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ebd:	89 04 24             	mov    %eax,(%esp)
c0104ec0:	e8 f1 ef ff ff       	call   c0103eb6 <page_ref>
c0104ec5:	85 c0                	test   %eax,%eax
c0104ec7:	74 24                	je     c0104eed <check_pgdir+0x5a8>
c0104ec9:	c7 44 24 0c f6 6f 10 	movl   $0xc0106ff6,0xc(%esp)
c0104ed0:	c0 
c0104ed1:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104ed8:	c0 
c0104ed9:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c0104ee0:	00 
c0104ee1:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104ee8:	e8 06 be ff ff       	call   c0100cf3 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104eed:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104ef2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104ef9:	00 
c0104efa:	89 04 24             	mov    %eax,(%esp)
c0104efd:	e8 cb f8 ff ff       	call   c01047cd <page_remove>
    assert(page_ref(p1) == 0);
c0104f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f05:	89 04 24             	mov    %eax,(%esp)
c0104f08:	e8 a9 ef ff ff       	call   c0103eb6 <page_ref>
c0104f0d:	85 c0                	test   %eax,%eax
c0104f0f:	74 24                	je     c0104f35 <check_pgdir+0x5f0>
c0104f11:	c7 44 24 0c 1d 70 10 	movl   $0xc010701d,0xc(%esp)
c0104f18:	c0 
c0104f19:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104f20:	c0 
c0104f21:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0104f28:	00 
c0104f29:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104f30:	e8 be bd ff ff       	call   c0100cf3 <__panic>
    assert(page_ref(p2) == 0);
c0104f35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f38:	89 04 24             	mov    %eax,(%esp)
c0104f3b:	e8 76 ef ff ff       	call   c0103eb6 <page_ref>
c0104f40:	85 c0                	test   %eax,%eax
c0104f42:	74 24                	je     c0104f68 <check_pgdir+0x623>
c0104f44:	c7 44 24 0c f6 6f 10 	movl   $0xc0106ff6,0xc(%esp)
c0104f4b:	c0 
c0104f4c:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104f53:	c0 
c0104f54:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0104f5b:	00 
c0104f5c:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104f63:	e8 8b bd ff ff       	call   c0100cf3 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0104f68:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104f6d:	8b 00                	mov    (%eax),%eax
c0104f6f:	89 04 24             	mov    %eax,(%esp)
c0104f72:	e8 27 ef ff ff       	call   c0103e9e <pde2page>
c0104f77:	89 04 24             	mov    %eax,(%esp)
c0104f7a:	e8 37 ef ff ff       	call   c0103eb6 <page_ref>
c0104f7f:	83 f8 01             	cmp    $0x1,%eax
c0104f82:	74 24                	je     c0104fa8 <check_pgdir+0x663>
c0104f84:	c7 44 24 0c 30 70 10 	movl   $0xc0107030,0xc(%esp)
c0104f8b:	c0 
c0104f8c:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0104f93:	c0 
c0104f94:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0104f9b:	00 
c0104f9c:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0104fa3:	e8 4b bd ff ff       	call   c0100cf3 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0104fa8:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104fad:	8b 00                	mov    (%eax),%eax
c0104faf:	89 04 24             	mov    %eax,(%esp)
c0104fb2:	e8 e7 ee ff ff       	call   c0103e9e <pde2page>
c0104fb7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104fbe:	00 
c0104fbf:	89 04 24             	mov    %eax,(%esp)
c0104fc2:	e8 1f f1 ff ff       	call   c01040e6 <free_pages>
    boot_pgdir[0] = 0;
c0104fc7:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104fcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104fd2:	c7 04 24 57 70 10 c0 	movl   $0xc0107057,(%esp)
c0104fd9:	e8 6a b3 ff ff       	call   c0100348 <cprintf>
}
c0104fde:	c9                   	leave  
c0104fdf:	c3                   	ret    

c0104fe0 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104fe0:	55                   	push   %ebp
c0104fe1:	89 e5                	mov    %esp,%ebp
c0104fe3:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104fe6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104fed:	e9 ca 00 00 00       	jmp    c01050bc <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ff5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ffb:	c1 e8 0c             	shr    $0xc,%eax
c0104ffe:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105001:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0105006:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105009:	72 23                	jb     c010502e <check_boot_pgdir+0x4e>
c010500b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010500e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105012:	c7 44 24 08 9c 6c 10 	movl   $0xc0106c9c,0x8(%esp)
c0105019:	c0 
c010501a:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0105021:	00 
c0105022:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0105029:	e8 c5 bc ff ff       	call   c0100cf3 <__panic>
c010502e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105031:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105036:	89 c2                	mov    %eax,%edx
c0105038:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010503d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105044:	00 
c0105045:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105049:	89 04 24             	mov    %eax,(%esp)
c010504c:	e8 19 f7 ff ff       	call   c010476a <get_pte>
c0105051:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105054:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105058:	75 24                	jne    c010507e <check_boot_pgdir+0x9e>
c010505a:	c7 44 24 0c 74 70 10 	movl   $0xc0107074,0xc(%esp)
c0105061:	c0 
c0105062:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0105069:	c0 
c010506a:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0105071:	00 
c0105072:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0105079:	e8 75 bc ff ff       	call   c0100cf3 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c010507e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105081:	8b 00                	mov    (%eax),%eax
c0105083:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105088:	89 c2                	mov    %eax,%edx
c010508a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010508d:	39 c2                	cmp    %eax,%edx
c010508f:	74 24                	je     c01050b5 <check_boot_pgdir+0xd5>
c0105091:	c7 44 24 0c b1 70 10 	movl   $0xc01070b1,0xc(%esp)
c0105098:	c0 
c0105099:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c01050a0:	c0 
c01050a1:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c01050a8:	00 
c01050a9:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c01050b0:	e8 3e bc ff ff       	call   c0100cf3 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01050b5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01050bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01050bf:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01050c4:	39 c2                	cmp    %eax,%edx
c01050c6:	0f 82 26 ff ff ff    	jb     c0104ff2 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01050cc:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01050d1:	05 ac 0f 00 00       	add    $0xfac,%eax
c01050d6:	8b 00                	mov    (%eax),%eax
c01050d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01050dd:	89 c2                	mov    %eax,%edx
c01050df:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01050e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01050e7:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01050ee:	77 23                	ja     c0105113 <check_boot_pgdir+0x133>
c01050f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01050f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01050f7:	c7 44 24 08 40 6d 10 	movl   $0xc0106d40,0x8(%esp)
c01050fe:	c0 
c01050ff:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0105106:	00 
c0105107:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c010510e:	e8 e0 bb ff ff       	call   c0100cf3 <__panic>
c0105113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105116:	05 00 00 00 40       	add    $0x40000000,%eax
c010511b:	39 c2                	cmp    %eax,%edx
c010511d:	74 24                	je     c0105143 <check_boot_pgdir+0x163>
c010511f:	c7 44 24 0c c8 70 10 	movl   $0xc01070c8,0xc(%esp)
c0105126:	c0 
c0105127:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c010512e:	c0 
c010512f:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0105136:	00 
c0105137:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c010513e:	e8 b0 bb ff ff       	call   c0100cf3 <__panic>

    assert(boot_pgdir[0] == 0);
c0105143:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0105148:	8b 00                	mov    (%eax),%eax
c010514a:	85 c0                	test   %eax,%eax
c010514c:	74 24                	je     c0105172 <check_boot_pgdir+0x192>
c010514e:	c7 44 24 0c fc 70 10 	movl   $0xc01070fc,0xc(%esp)
c0105155:	c0 
c0105156:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c010515d:	c0 
c010515e:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0105165:	00 
c0105166:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c010516d:	e8 81 bb ff ff       	call   c0100cf3 <__panic>

    struct Page *p;
    p = alloc_page();
c0105172:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105179:	e8 30 ef ff ff       	call   c01040ae <alloc_pages>
c010517e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105181:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0105186:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010518d:	00 
c010518e:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105195:	00 
c0105196:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105199:	89 54 24 04          	mov    %edx,0x4(%esp)
c010519d:	89 04 24             	mov    %eax,(%esp)
c01051a0:	e8 6c f6 ff ff       	call   c0104811 <page_insert>
c01051a5:	85 c0                	test   %eax,%eax
c01051a7:	74 24                	je     c01051cd <check_boot_pgdir+0x1ed>
c01051a9:	c7 44 24 0c 10 71 10 	movl   $0xc0107110,0xc(%esp)
c01051b0:	c0 
c01051b1:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c01051b8:	c0 
c01051b9:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c01051c0:	00 
c01051c1:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c01051c8:	e8 26 bb ff ff       	call   c0100cf3 <__panic>
    assert(page_ref(p) == 1);
c01051cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051d0:	89 04 24             	mov    %eax,(%esp)
c01051d3:	e8 de ec ff ff       	call   c0103eb6 <page_ref>
c01051d8:	83 f8 01             	cmp    $0x1,%eax
c01051db:	74 24                	je     c0105201 <check_boot_pgdir+0x221>
c01051dd:	c7 44 24 0c 3e 71 10 	movl   $0xc010713e,0xc(%esp)
c01051e4:	c0 
c01051e5:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c01051ec:	c0 
c01051ed:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c01051f4:	00 
c01051f5:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c01051fc:	e8 f2 ba ff ff       	call   c0100cf3 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105201:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0105206:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010520d:	00 
c010520e:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105215:	00 
c0105216:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105219:	89 54 24 04          	mov    %edx,0x4(%esp)
c010521d:	89 04 24             	mov    %eax,(%esp)
c0105220:	e8 ec f5 ff ff       	call   c0104811 <page_insert>
c0105225:	85 c0                	test   %eax,%eax
c0105227:	74 24                	je     c010524d <check_boot_pgdir+0x26d>
c0105229:	c7 44 24 0c 50 71 10 	movl   $0xc0107150,0xc(%esp)
c0105230:	c0 
c0105231:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0105238:	c0 
c0105239:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0105240:	00 
c0105241:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0105248:	e8 a6 ba ff ff       	call   c0100cf3 <__panic>
    assert(page_ref(p) == 2);
c010524d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105250:	89 04 24             	mov    %eax,(%esp)
c0105253:	e8 5e ec ff ff       	call   c0103eb6 <page_ref>
c0105258:	83 f8 02             	cmp    $0x2,%eax
c010525b:	74 24                	je     c0105281 <check_boot_pgdir+0x2a1>
c010525d:	c7 44 24 0c 87 71 10 	movl   $0xc0107187,0xc(%esp)
c0105264:	c0 
c0105265:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c010526c:	c0 
c010526d:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0105274:	00 
c0105275:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c010527c:	e8 72 ba ff ff       	call   c0100cf3 <__panic>

    const char *str = "ucore: Hello world!!";
c0105281:	c7 45 dc 98 71 10 c0 	movl   $0xc0107198,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105288:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010528b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010528f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105296:	e8 19 0a 00 00       	call   c0105cb4 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c010529b:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01052a2:	00 
c01052a3:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01052aa:	e8 7e 0a 00 00       	call   c0105d2d <strcmp>
c01052af:	85 c0                	test   %eax,%eax
c01052b1:	74 24                	je     c01052d7 <check_boot_pgdir+0x2f7>
c01052b3:	c7 44 24 0c b0 71 10 	movl   $0xc01071b0,0xc(%esp)
c01052ba:	c0 
c01052bb:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c01052c2:	c0 
c01052c3:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c01052ca:	00 
c01052cb:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c01052d2:	e8 1c ba ff ff       	call   c0100cf3 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01052d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052da:	89 04 24             	mov    %eax,(%esp)
c01052dd:	e8 2a eb ff ff       	call   c0103e0c <page2kva>
c01052e2:	05 00 01 00 00       	add    $0x100,%eax
c01052e7:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01052ea:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01052f1:	e8 66 09 00 00       	call   c0105c5c <strlen>
c01052f6:	85 c0                	test   %eax,%eax
c01052f8:	74 24                	je     c010531e <check_boot_pgdir+0x33e>
c01052fa:	c7 44 24 0c e8 71 10 	movl   $0xc01071e8,0xc(%esp)
c0105301:	c0 
c0105302:	c7 44 24 08 89 6d 10 	movl   $0xc0106d89,0x8(%esp)
c0105309:	c0 
c010530a:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0105311:	00 
c0105312:	c7 04 24 64 6d 10 c0 	movl   $0xc0106d64,(%esp)
c0105319:	e8 d5 b9 ff ff       	call   c0100cf3 <__panic>

    free_page(p);
c010531e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105325:	00 
c0105326:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105329:	89 04 24             	mov    %eax,(%esp)
c010532c:	e8 b5 ed ff ff       	call   c01040e6 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105331:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0105336:	8b 00                	mov    (%eax),%eax
c0105338:	89 04 24             	mov    %eax,(%esp)
c010533b:	e8 5e eb ff ff       	call   c0103e9e <pde2page>
c0105340:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105347:	00 
c0105348:	89 04 24             	mov    %eax,(%esp)
c010534b:	e8 96 ed ff ff       	call   c01040e6 <free_pages>
    boot_pgdir[0] = 0;
c0105350:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0105355:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c010535b:	c7 04 24 0c 72 10 c0 	movl   $0xc010720c,(%esp)
c0105362:	e8 e1 af ff ff       	call   c0100348 <cprintf>
}
c0105367:	c9                   	leave  
c0105368:	c3                   	ret    

c0105369 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105369:	55                   	push   %ebp
c010536a:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c010536c:	8b 45 08             	mov    0x8(%ebp),%eax
c010536f:	83 e0 04             	and    $0x4,%eax
c0105372:	85 c0                	test   %eax,%eax
c0105374:	74 07                	je     c010537d <perm2str+0x14>
c0105376:	b8 75 00 00 00       	mov    $0x75,%eax
c010537b:	eb 05                	jmp    c0105382 <perm2str+0x19>
c010537d:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105382:	a2 08 af 11 c0       	mov    %al,0xc011af08
    str[1] = 'r';
c0105387:	c6 05 09 af 11 c0 72 	movb   $0x72,0xc011af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010538e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105391:	83 e0 02             	and    $0x2,%eax
c0105394:	85 c0                	test   %eax,%eax
c0105396:	74 07                	je     c010539f <perm2str+0x36>
c0105398:	b8 77 00 00 00       	mov    $0x77,%eax
c010539d:	eb 05                	jmp    c01053a4 <perm2str+0x3b>
c010539f:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01053a4:	a2 0a af 11 c0       	mov    %al,0xc011af0a
    str[3] = '\0';
c01053a9:	c6 05 0b af 11 c0 00 	movb   $0x0,0xc011af0b
    return str;
c01053b0:	b8 08 af 11 c0       	mov    $0xc011af08,%eax
}
c01053b5:	5d                   	pop    %ebp
c01053b6:	c3                   	ret    

c01053b7 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01053b7:	55                   	push   %ebp
c01053b8:	89 e5                	mov    %esp,%ebp
c01053ba:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01053bd:	8b 45 10             	mov    0x10(%ebp),%eax
c01053c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01053c3:	72 0a                	jb     c01053cf <get_pgtable_items+0x18>
        return 0;
c01053c5:	b8 00 00 00 00       	mov    $0x0,%eax
c01053ca:	e9 9c 00 00 00       	jmp    c010546b <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01053cf:	eb 04                	jmp    c01053d5 <get_pgtable_items+0x1e>
        start ++;
c01053d1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01053d5:	8b 45 10             	mov    0x10(%ebp),%eax
c01053d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01053db:	73 18                	jae    c01053f5 <get_pgtable_items+0x3e>
c01053dd:	8b 45 10             	mov    0x10(%ebp),%eax
c01053e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01053e7:	8b 45 14             	mov    0x14(%ebp),%eax
c01053ea:	01 d0                	add    %edx,%eax
c01053ec:	8b 00                	mov    (%eax),%eax
c01053ee:	83 e0 01             	and    $0x1,%eax
c01053f1:	85 c0                	test   %eax,%eax
c01053f3:	74 dc                	je     c01053d1 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01053f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01053f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01053fb:	73 69                	jae    c0105466 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01053fd:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105401:	74 08                	je     c010540b <get_pgtable_items+0x54>
            *left_store = start;
c0105403:	8b 45 18             	mov    0x18(%ebp),%eax
c0105406:	8b 55 10             	mov    0x10(%ebp),%edx
c0105409:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010540b:	8b 45 10             	mov    0x10(%ebp),%eax
c010540e:	8d 50 01             	lea    0x1(%eax),%edx
c0105411:	89 55 10             	mov    %edx,0x10(%ebp)
c0105414:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010541b:	8b 45 14             	mov    0x14(%ebp),%eax
c010541e:	01 d0                	add    %edx,%eax
c0105420:	8b 00                	mov    (%eax),%eax
c0105422:	83 e0 07             	and    $0x7,%eax
c0105425:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105428:	eb 04                	jmp    c010542e <get_pgtable_items+0x77>
            start ++;
c010542a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c010542e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105431:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105434:	73 1d                	jae    c0105453 <get_pgtable_items+0x9c>
c0105436:	8b 45 10             	mov    0x10(%ebp),%eax
c0105439:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105440:	8b 45 14             	mov    0x14(%ebp),%eax
c0105443:	01 d0                	add    %edx,%eax
c0105445:	8b 00                	mov    (%eax),%eax
c0105447:	83 e0 07             	and    $0x7,%eax
c010544a:	89 c2                	mov    %eax,%edx
c010544c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010544f:	39 c2                	cmp    %eax,%edx
c0105451:	74 d7                	je     c010542a <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105453:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105457:	74 08                	je     c0105461 <get_pgtable_items+0xaa>
            *right_store = start;
c0105459:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010545c:	8b 55 10             	mov    0x10(%ebp),%edx
c010545f:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105461:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105464:	eb 05                	jmp    c010546b <get_pgtable_items+0xb4>
    }
    return 0;
c0105466:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010546b:	c9                   	leave  
c010546c:	c3                   	ret    

c010546d <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c010546d:	55                   	push   %ebp
c010546e:	89 e5                	mov    %esp,%ebp
c0105470:	57                   	push   %edi
c0105471:	56                   	push   %esi
c0105472:	53                   	push   %ebx
c0105473:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105476:	c7 04 24 2c 72 10 c0 	movl   $0xc010722c,(%esp)
c010547d:	e8 c6 ae ff ff       	call   c0100348 <cprintf>
    size_t left, right = 0, perm;
c0105482:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105489:	e9 fa 00 00 00       	jmp    c0105588 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010548e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105491:	89 04 24             	mov    %eax,(%esp)
c0105494:	e8 d0 fe ff ff       	call   c0105369 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105499:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010549c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010549f:	29 d1                	sub    %edx,%ecx
c01054a1:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01054a3:	89 d6                	mov    %edx,%esi
c01054a5:	c1 e6 16             	shl    $0x16,%esi
c01054a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01054ab:	89 d3                	mov    %edx,%ebx
c01054ad:	c1 e3 16             	shl    $0x16,%ebx
c01054b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01054b3:	89 d1                	mov    %edx,%ecx
c01054b5:	c1 e1 16             	shl    $0x16,%ecx
c01054b8:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01054bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01054be:	29 d7                	sub    %edx,%edi
c01054c0:	89 fa                	mov    %edi,%edx
c01054c2:	89 44 24 14          	mov    %eax,0x14(%esp)
c01054c6:	89 74 24 10          	mov    %esi,0x10(%esp)
c01054ca:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01054ce:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01054d2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01054d6:	c7 04 24 5d 72 10 c0 	movl   $0xc010725d,(%esp)
c01054dd:	e8 66 ae ff ff       	call   c0100348 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01054e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054e5:	c1 e0 0a             	shl    $0xa,%eax
c01054e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01054eb:	eb 54                	jmp    c0105541 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01054ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054f0:	89 04 24             	mov    %eax,(%esp)
c01054f3:	e8 71 fe ff ff       	call   c0105369 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01054f8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01054fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01054fe:	29 d1                	sub    %edx,%ecx
c0105500:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105502:	89 d6                	mov    %edx,%esi
c0105504:	c1 e6 0c             	shl    $0xc,%esi
c0105507:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010550a:	89 d3                	mov    %edx,%ebx
c010550c:	c1 e3 0c             	shl    $0xc,%ebx
c010550f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105512:	c1 e2 0c             	shl    $0xc,%edx
c0105515:	89 d1                	mov    %edx,%ecx
c0105517:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010551a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010551d:	29 d7                	sub    %edx,%edi
c010551f:	89 fa                	mov    %edi,%edx
c0105521:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105525:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105529:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010552d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105531:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105535:	c7 04 24 7c 72 10 c0 	movl   $0xc010727c,(%esp)
c010553c:	e8 07 ae ff ff       	call   c0100348 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105541:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105546:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105549:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010554c:	89 ce                	mov    %ecx,%esi
c010554e:	c1 e6 0a             	shl    $0xa,%esi
c0105551:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105554:	89 cb                	mov    %ecx,%ebx
c0105556:	c1 e3 0a             	shl    $0xa,%ebx
c0105559:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c010555c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105560:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105563:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105567:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010556b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010556f:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105573:	89 1c 24             	mov    %ebx,(%esp)
c0105576:	e8 3c fe ff ff       	call   c01053b7 <get_pgtable_items>
c010557b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010557e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105582:	0f 85 65 ff ff ff    	jne    c01054ed <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105588:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c010558d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105590:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105593:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105597:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c010559a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010559e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01055a2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01055a6:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01055ad:	00 
c01055ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01055b5:	e8 fd fd ff ff       	call   c01053b7 <get_pgtable_items>
c01055ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01055c1:	0f 85 c7 fe ff ff    	jne    c010548e <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01055c7:	c7 04 24 a0 72 10 c0 	movl   $0xc01072a0,(%esp)
c01055ce:	e8 75 ad ff ff       	call   c0100348 <cprintf>
}
c01055d3:	83 c4 4c             	add    $0x4c,%esp
c01055d6:	5b                   	pop    %ebx
c01055d7:	5e                   	pop    %esi
c01055d8:	5f                   	pop    %edi
c01055d9:	5d                   	pop    %ebp
c01055da:	c3                   	ret    

c01055db <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01055db:	55                   	push   %ebp
c01055dc:	89 e5                	mov    %esp,%ebp
c01055de:	83 ec 58             	sub    $0x58,%esp
c01055e1:	8b 45 10             	mov    0x10(%ebp),%eax
c01055e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01055e7:	8b 45 14             	mov    0x14(%ebp),%eax
c01055ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01055ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01055f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01055f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01055f6:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01055f9:	8b 45 18             	mov    0x18(%ebp),%eax
c01055fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01055ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105602:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105605:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105608:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010560b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010560e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105611:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105615:	74 1c                	je     c0105633 <printnum+0x58>
c0105617:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010561a:	ba 00 00 00 00       	mov    $0x0,%edx
c010561f:	f7 75 e4             	divl   -0x1c(%ebp)
c0105622:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105625:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105628:	ba 00 00 00 00       	mov    $0x0,%edx
c010562d:	f7 75 e4             	divl   -0x1c(%ebp)
c0105630:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105633:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105636:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105639:	f7 75 e4             	divl   -0x1c(%ebp)
c010563c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010563f:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105642:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105645:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105648:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010564b:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010564e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105651:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105654:	8b 45 18             	mov    0x18(%ebp),%eax
c0105657:	ba 00 00 00 00       	mov    $0x0,%edx
c010565c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010565f:	77 56                	ja     c01056b7 <printnum+0xdc>
c0105661:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105664:	72 05                	jb     c010566b <printnum+0x90>
c0105666:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105669:	77 4c                	ja     c01056b7 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010566b:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010566e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105671:	8b 45 20             	mov    0x20(%ebp),%eax
c0105674:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105678:	89 54 24 14          	mov    %edx,0x14(%esp)
c010567c:	8b 45 18             	mov    0x18(%ebp),%eax
c010567f:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105683:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105686:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105689:	89 44 24 08          	mov    %eax,0x8(%esp)
c010568d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105691:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105694:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105698:	8b 45 08             	mov    0x8(%ebp),%eax
c010569b:	89 04 24             	mov    %eax,(%esp)
c010569e:	e8 38 ff ff ff       	call   c01055db <printnum>
c01056a3:	eb 1c                	jmp    c01056c1 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01056a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056ac:	8b 45 20             	mov    0x20(%ebp),%eax
c01056af:	89 04 24             	mov    %eax,(%esp)
c01056b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01056b5:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01056b7:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01056bb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01056bf:	7f e4                	jg     c01056a5 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01056c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01056c4:	05 54 73 10 c0       	add    $0xc0107354,%eax
c01056c9:	0f b6 00             	movzbl (%eax),%eax
c01056cc:	0f be c0             	movsbl %al,%eax
c01056cf:	8b 55 0c             	mov    0xc(%ebp),%edx
c01056d2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01056d6:	89 04 24             	mov    %eax,(%esp)
c01056d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01056dc:	ff d0                	call   *%eax
}
c01056de:	c9                   	leave  
c01056df:	c3                   	ret    

c01056e0 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01056e0:	55                   	push   %ebp
c01056e1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01056e3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01056e7:	7e 14                	jle    c01056fd <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c01056e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ec:	8b 00                	mov    (%eax),%eax
c01056ee:	8d 48 08             	lea    0x8(%eax),%ecx
c01056f1:	8b 55 08             	mov    0x8(%ebp),%edx
c01056f4:	89 0a                	mov    %ecx,(%edx)
c01056f6:	8b 50 04             	mov    0x4(%eax),%edx
c01056f9:	8b 00                	mov    (%eax),%eax
c01056fb:	eb 30                	jmp    c010572d <getuint+0x4d>
    }
    else if (lflag) {
c01056fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105701:	74 16                	je     c0105719 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105703:	8b 45 08             	mov    0x8(%ebp),%eax
c0105706:	8b 00                	mov    (%eax),%eax
c0105708:	8d 48 04             	lea    0x4(%eax),%ecx
c010570b:	8b 55 08             	mov    0x8(%ebp),%edx
c010570e:	89 0a                	mov    %ecx,(%edx)
c0105710:	8b 00                	mov    (%eax),%eax
c0105712:	ba 00 00 00 00       	mov    $0x0,%edx
c0105717:	eb 14                	jmp    c010572d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105719:	8b 45 08             	mov    0x8(%ebp),%eax
c010571c:	8b 00                	mov    (%eax),%eax
c010571e:	8d 48 04             	lea    0x4(%eax),%ecx
c0105721:	8b 55 08             	mov    0x8(%ebp),%edx
c0105724:	89 0a                	mov    %ecx,(%edx)
c0105726:	8b 00                	mov    (%eax),%eax
c0105728:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010572d:	5d                   	pop    %ebp
c010572e:	c3                   	ret    

c010572f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010572f:	55                   	push   %ebp
c0105730:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105732:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105736:	7e 14                	jle    c010574c <getint+0x1d>
        return va_arg(*ap, long long);
c0105738:	8b 45 08             	mov    0x8(%ebp),%eax
c010573b:	8b 00                	mov    (%eax),%eax
c010573d:	8d 48 08             	lea    0x8(%eax),%ecx
c0105740:	8b 55 08             	mov    0x8(%ebp),%edx
c0105743:	89 0a                	mov    %ecx,(%edx)
c0105745:	8b 50 04             	mov    0x4(%eax),%edx
c0105748:	8b 00                	mov    (%eax),%eax
c010574a:	eb 28                	jmp    c0105774 <getint+0x45>
    }
    else if (lflag) {
c010574c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105750:	74 12                	je     c0105764 <getint+0x35>
        return va_arg(*ap, long);
c0105752:	8b 45 08             	mov    0x8(%ebp),%eax
c0105755:	8b 00                	mov    (%eax),%eax
c0105757:	8d 48 04             	lea    0x4(%eax),%ecx
c010575a:	8b 55 08             	mov    0x8(%ebp),%edx
c010575d:	89 0a                	mov    %ecx,(%edx)
c010575f:	8b 00                	mov    (%eax),%eax
c0105761:	99                   	cltd   
c0105762:	eb 10                	jmp    c0105774 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105764:	8b 45 08             	mov    0x8(%ebp),%eax
c0105767:	8b 00                	mov    (%eax),%eax
c0105769:	8d 48 04             	lea    0x4(%eax),%ecx
c010576c:	8b 55 08             	mov    0x8(%ebp),%edx
c010576f:	89 0a                	mov    %ecx,(%edx)
c0105771:	8b 00                	mov    (%eax),%eax
c0105773:	99                   	cltd   
    }
}
c0105774:	5d                   	pop    %ebp
c0105775:	c3                   	ret    

c0105776 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105776:	55                   	push   %ebp
c0105777:	89 e5                	mov    %esp,%ebp
c0105779:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010577c:	8d 45 14             	lea    0x14(%ebp),%eax
c010577f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105782:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105785:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105789:	8b 45 10             	mov    0x10(%ebp),%eax
c010578c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105790:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105793:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105797:	8b 45 08             	mov    0x8(%ebp),%eax
c010579a:	89 04 24             	mov    %eax,(%esp)
c010579d:	e8 02 00 00 00       	call   c01057a4 <vprintfmt>
    va_end(ap);
}
c01057a2:	c9                   	leave  
c01057a3:	c3                   	ret    

c01057a4 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01057a4:	55                   	push   %ebp
c01057a5:	89 e5                	mov    %esp,%ebp
c01057a7:	56                   	push   %esi
c01057a8:	53                   	push   %ebx
c01057a9:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057ac:	eb 18                	jmp    c01057c6 <vprintfmt+0x22>
            if (ch == '\0') {
c01057ae:	85 db                	test   %ebx,%ebx
c01057b0:	75 05                	jne    c01057b7 <vprintfmt+0x13>
                return;
c01057b2:	e9 d1 03 00 00       	jmp    c0105b88 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c01057b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057be:	89 1c 24             	mov    %ebx,(%esp)
c01057c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c4:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01057c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01057c9:	8d 50 01             	lea    0x1(%eax),%edx
c01057cc:	89 55 10             	mov    %edx,0x10(%ebp)
c01057cf:	0f b6 00             	movzbl (%eax),%eax
c01057d2:	0f b6 d8             	movzbl %al,%ebx
c01057d5:	83 fb 25             	cmp    $0x25,%ebx
c01057d8:	75 d4                	jne    c01057ae <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01057da:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01057de:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01057e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01057eb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01057f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01057f5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01057f8:	8b 45 10             	mov    0x10(%ebp),%eax
c01057fb:	8d 50 01             	lea    0x1(%eax),%edx
c01057fe:	89 55 10             	mov    %edx,0x10(%ebp)
c0105801:	0f b6 00             	movzbl (%eax),%eax
c0105804:	0f b6 d8             	movzbl %al,%ebx
c0105807:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010580a:	83 f8 55             	cmp    $0x55,%eax
c010580d:	0f 87 44 03 00 00    	ja     c0105b57 <vprintfmt+0x3b3>
c0105813:	8b 04 85 78 73 10 c0 	mov    -0x3fef8c88(,%eax,4),%eax
c010581a:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010581c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105820:	eb d6                	jmp    c01057f8 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105822:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105826:	eb d0                	jmp    c01057f8 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105828:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010582f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105832:	89 d0                	mov    %edx,%eax
c0105834:	c1 e0 02             	shl    $0x2,%eax
c0105837:	01 d0                	add    %edx,%eax
c0105839:	01 c0                	add    %eax,%eax
c010583b:	01 d8                	add    %ebx,%eax
c010583d:	83 e8 30             	sub    $0x30,%eax
c0105840:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105843:	8b 45 10             	mov    0x10(%ebp),%eax
c0105846:	0f b6 00             	movzbl (%eax),%eax
c0105849:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010584c:	83 fb 2f             	cmp    $0x2f,%ebx
c010584f:	7e 0b                	jle    c010585c <vprintfmt+0xb8>
c0105851:	83 fb 39             	cmp    $0x39,%ebx
c0105854:	7f 06                	jg     c010585c <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105856:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010585a:	eb d3                	jmp    c010582f <vprintfmt+0x8b>
            goto process_precision;
c010585c:	eb 33                	jmp    c0105891 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c010585e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105861:	8d 50 04             	lea    0x4(%eax),%edx
c0105864:	89 55 14             	mov    %edx,0x14(%ebp)
c0105867:	8b 00                	mov    (%eax),%eax
c0105869:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010586c:	eb 23                	jmp    c0105891 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c010586e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105872:	79 0c                	jns    c0105880 <vprintfmt+0xdc>
                width = 0;
c0105874:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010587b:	e9 78 ff ff ff       	jmp    c01057f8 <vprintfmt+0x54>
c0105880:	e9 73 ff ff ff       	jmp    c01057f8 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0105885:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010588c:	e9 67 ff ff ff       	jmp    c01057f8 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105891:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105895:	79 12                	jns    c01058a9 <vprintfmt+0x105>
                width = precision, precision = -1;
c0105897:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010589a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010589d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01058a4:	e9 4f ff ff ff       	jmp    c01057f8 <vprintfmt+0x54>
c01058a9:	e9 4a ff ff ff       	jmp    c01057f8 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01058ae:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01058b2:	e9 41 ff ff ff       	jmp    c01057f8 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01058b7:	8b 45 14             	mov    0x14(%ebp),%eax
c01058ba:	8d 50 04             	lea    0x4(%eax),%edx
c01058bd:	89 55 14             	mov    %edx,0x14(%ebp)
c01058c0:	8b 00                	mov    (%eax),%eax
c01058c2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058c5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01058c9:	89 04 24             	mov    %eax,(%esp)
c01058cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01058cf:	ff d0                	call   *%eax
            break;
c01058d1:	e9 ac 02 00 00       	jmp    c0105b82 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01058d6:	8b 45 14             	mov    0x14(%ebp),%eax
c01058d9:	8d 50 04             	lea    0x4(%eax),%edx
c01058dc:	89 55 14             	mov    %edx,0x14(%ebp)
c01058df:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01058e1:	85 db                	test   %ebx,%ebx
c01058e3:	79 02                	jns    c01058e7 <vprintfmt+0x143>
                err = -err;
c01058e5:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01058e7:	83 fb 06             	cmp    $0x6,%ebx
c01058ea:	7f 0b                	jg     c01058f7 <vprintfmt+0x153>
c01058ec:	8b 34 9d 38 73 10 c0 	mov    -0x3fef8cc8(,%ebx,4),%esi
c01058f3:	85 f6                	test   %esi,%esi
c01058f5:	75 23                	jne    c010591a <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01058f7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01058fb:	c7 44 24 08 65 73 10 	movl   $0xc0107365,0x8(%esp)
c0105902:	c0 
c0105903:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105906:	89 44 24 04          	mov    %eax,0x4(%esp)
c010590a:	8b 45 08             	mov    0x8(%ebp),%eax
c010590d:	89 04 24             	mov    %eax,(%esp)
c0105910:	e8 61 fe ff ff       	call   c0105776 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105915:	e9 68 02 00 00       	jmp    c0105b82 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010591a:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010591e:	c7 44 24 08 6e 73 10 	movl   $0xc010736e,0x8(%esp)
c0105925:	c0 
c0105926:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105929:	89 44 24 04          	mov    %eax,0x4(%esp)
c010592d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105930:	89 04 24             	mov    %eax,(%esp)
c0105933:	e8 3e fe ff ff       	call   c0105776 <printfmt>
            }
            break;
c0105938:	e9 45 02 00 00       	jmp    c0105b82 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010593d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105940:	8d 50 04             	lea    0x4(%eax),%edx
c0105943:	89 55 14             	mov    %edx,0x14(%ebp)
c0105946:	8b 30                	mov    (%eax),%esi
c0105948:	85 f6                	test   %esi,%esi
c010594a:	75 05                	jne    c0105951 <vprintfmt+0x1ad>
                p = "(null)";
c010594c:	be 71 73 10 c0       	mov    $0xc0107371,%esi
            }
            if (width > 0 && padc != '-') {
c0105951:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105955:	7e 3e                	jle    c0105995 <vprintfmt+0x1f1>
c0105957:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010595b:	74 38                	je     c0105995 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010595d:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105960:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105963:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105967:	89 34 24             	mov    %esi,(%esp)
c010596a:	e8 15 03 00 00       	call   c0105c84 <strnlen>
c010596f:	29 c3                	sub    %eax,%ebx
c0105971:	89 d8                	mov    %ebx,%eax
c0105973:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105976:	eb 17                	jmp    c010598f <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0105978:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010597c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010597f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105983:	89 04 24             	mov    %eax,(%esp)
c0105986:	8b 45 08             	mov    0x8(%ebp),%eax
c0105989:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010598b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010598f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105993:	7f e3                	jg     c0105978 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105995:	eb 38                	jmp    c01059cf <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105997:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010599b:	74 1f                	je     c01059bc <vprintfmt+0x218>
c010599d:	83 fb 1f             	cmp    $0x1f,%ebx
c01059a0:	7e 05                	jle    c01059a7 <vprintfmt+0x203>
c01059a2:	83 fb 7e             	cmp    $0x7e,%ebx
c01059a5:	7e 15                	jle    c01059bc <vprintfmt+0x218>
                    putch('?', putdat);
c01059a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059ae:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01059b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b8:	ff d0                	call   *%eax
c01059ba:	eb 0f                	jmp    c01059cb <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c01059bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059c3:	89 1c 24             	mov    %ebx,(%esp)
c01059c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01059c9:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01059cb:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01059cf:	89 f0                	mov    %esi,%eax
c01059d1:	8d 70 01             	lea    0x1(%eax),%esi
c01059d4:	0f b6 00             	movzbl (%eax),%eax
c01059d7:	0f be d8             	movsbl %al,%ebx
c01059da:	85 db                	test   %ebx,%ebx
c01059dc:	74 10                	je     c01059ee <vprintfmt+0x24a>
c01059de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059e2:	78 b3                	js     c0105997 <vprintfmt+0x1f3>
c01059e4:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01059e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01059ec:	79 a9                	jns    c0105997 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01059ee:	eb 17                	jmp    c0105a07 <vprintfmt+0x263>
                putch(' ', putdat);
c01059f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059f7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01059fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a01:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105a03:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105a07:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a0b:	7f e3                	jg     c01059f0 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105a0d:	e9 70 01 00 00       	jmp    c0105b82 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105a12:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a15:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a19:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a1c:	89 04 24             	mov    %eax,(%esp)
c0105a1f:	e8 0b fd ff ff       	call   c010572f <getint>
c0105a24:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a27:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a30:	85 d2                	test   %edx,%edx
c0105a32:	79 26                	jns    c0105a5a <vprintfmt+0x2b6>
                putch('-', putdat);
c0105a34:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a3b:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105a42:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a45:	ff d0                	call   *%eax
                num = -(long long)num;
c0105a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a4d:	f7 d8                	neg    %eax
c0105a4f:	83 d2 00             	adc    $0x0,%edx
c0105a52:	f7 da                	neg    %edx
c0105a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a57:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105a5a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a61:	e9 a8 00 00 00       	jmp    c0105b0e <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105a66:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a69:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a6d:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a70:	89 04 24             	mov    %eax,(%esp)
c0105a73:	e8 68 fc ff ff       	call   c01056e0 <getuint>
c0105a78:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a7b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105a7e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105a85:	e9 84 00 00 00       	jmp    c0105b0e <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105a8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a91:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a94:	89 04 24             	mov    %eax,(%esp)
c0105a97:	e8 44 fc ff ff       	call   c01056e0 <getuint>
c0105a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a9f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105aa2:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105aa9:	eb 63                	jmp    c0105b0e <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105aab:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105aae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ab2:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105ab9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105abc:	ff d0                	call   *%eax
            putch('x', putdat);
c0105abe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ac1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ac5:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105acc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105acf:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105ad1:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ad4:	8d 50 04             	lea    0x4(%eax),%edx
c0105ad7:	89 55 14             	mov    %edx,0x14(%ebp)
c0105ada:	8b 00                	mov    (%eax),%eax
c0105adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105adf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105ae6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105aed:	eb 1f                	jmp    c0105b0e <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105aef:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105af2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105af6:	8d 45 14             	lea    0x14(%ebp),%eax
c0105af9:	89 04 24             	mov    %eax,(%esp)
c0105afc:	e8 df fb ff ff       	call   c01056e0 <getuint>
c0105b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b04:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105b07:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105b0e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105b12:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b15:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105b19:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105b1c:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105b20:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b27:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b2a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b2e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105b32:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b35:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b39:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b3c:	89 04 24             	mov    %eax,(%esp)
c0105b3f:	e8 97 fa ff ff       	call   c01055db <printnum>
            break;
c0105b44:	eb 3c                	jmp    c0105b82 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105b46:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b49:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b4d:	89 1c 24             	mov    %ebx,(%esp)
c0105b50:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b53:	ff d0                	call   *%eax
            break;
c0105b55:	eb 2b                	jmp    c0105b82 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105b57:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b5e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105b65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b68:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105b6a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105b6e:	eb 04                	jmp    c0105b74 <vprintfmt+0x3d0>
c0105b70:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105b74:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b77:	83 e8 01             	sub    $0x1,%eax
c0105b7a:	0f b6 00             	movzbl (%eax),%eax
c0105b7d:	3c 25                	cmp    $0x25,%al
c0105b7f:	75 ef                	jne    c0105b70 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105b81:	90                   	nop
        }
    }
c0105b82:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105b83:	e9 3e fc ff ff       	jmp    c01057c6 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105b88:	83 c4 40             	add    $0x40,%esp
c0105b8b:	5b                   	pop    %ebx
c0105b8c:	5e                   	pop    %esi
c0105b8d:	5d                   	pop    %ebp
c0105b8e:	c3                   	ret    

c0105b8f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105b8f:	55                   	push   %ebp
c0105b90:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105b92:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b95:	8b 40 08             	mov    0x8(%eax),%eax
c0105b98:	8d 50 01             	lea    0x1(%eax),%edx
c0105b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b9e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ba4:	8b 10                	mov    (%eax),%edx
c0105ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ba9:	8b 40 04             	mov    0x4(%eax),%eax
c0105bac:	39 c2                	cmp    %eax,%edx
c0105bae:	73 12                	jae    c0105bc2 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bb3:	8b 00                	mov    (%eax),%eax
c0105bb5:	8d 48 01             	lea    0x1(%eax),%ecx
c0105bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105bbb:	89 0a                	mov    %ecx,(%edx)
c0105bbd:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bc0:	88 10                	mov    %dl,(%eax)
    }
}
c0105bc2:	5d                   	pop    %ebp
c0105bc3:	c3                   	ret    

c0105bc4 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105bc4:	55                   	push   %ebp
c0105bc5:	89 e5                	mov    %esp,%ebp
c0105bc7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105bca:	8d 45 14             	lea    0x14(%ebp),%eax
c0105bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bd3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105bd7:	8b 45 10             	mov    0x10(%ebp),%eax
c0105bda:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105bde:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105be1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105be5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105be8:	89 04 24             	mov    %eax,(%esp)
c0105beb:	e8 08 00 00 00       	call   c0105bf8 <vsnprintf>
c0105bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105bf6:	c9                   	leave  
c0105bf7:	c3                   	ret    

c0105bf8 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105bf8:	55                   	push   %ebp
c0105bf9:	89 e5                	mov    %esp,%ebp
c0105bfb:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c01:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c07:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105c0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c0d:	01 d0                	add    %edx,%eax
c0105c0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105c19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105c1d:	74 0a                	je     c0105c29 <vsnprintf+0x31>
c0105c1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c25:	39 c2                	cmp    %eax,%edx
c0105c27:	76 07                	jbe    c0105c30 <vsnprintf+0x38>
        return -E_INVAL;
c0105c29:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105c2e:	eb 2a                	jmp    c0105c5a <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105c30:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c33:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105c37:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c3a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105c3e:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105c41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c45:	c7 04 24 8f 5b 10 c0 	movl   $0xc0105b8f,(%esp)
c0105c4c:	e8 53 fb ff ff       	call   c01057a4 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105c51:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c54:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105c5a:	c9                   	leave  
c0105c5b:	c3                   	ret    

c0105c5c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105c5c:	55                   	push   %ebp
c0105c5d:	89 e5                	mov    %esp,%ebp
c0105c5f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105c62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105c69:	eb 04                	jmp    c0105c6f <strlen+0x13>
        cnt ++;
c0105c6b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105c6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c72:	8d 50 01             	lea    0x1(%eax),%edx
c0105c75:	89 55 08             	mov    %edx,0x8(%ebp)
c0105c78:	0f b6 00             	movzbl (%eax),%eax
c0105c7b:	84 c0                	test   %al,%al
c0105c7d:	75 ec                	jne    c0105c6b <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105c82:	c9                   	leave  
c0105c83:	c3                   	ret    

c0105c84 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105c84:	55                   	push   %ebp
c0105c85:	89 e5                	mov    %esp,%ebp
c0105c87:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105c8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105c91:	eb 04                	jmp    c0105c97 <strnlen+0x13>
        cnt ++;
c0105c93:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105c9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105c9d:	73 10                	jae    c0105caf <strnlen+0x2b>
c0105c9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca2:	8d 50 01             	lea    0x1(%eax),%edx
c0105ca5:	89 55 08             	mov    %edx,0x8(%ebp)
c0105ca8:	0f b6 00             	movzbl (%eax),%eax
c0105cab:	84 c0                	test   %al,%al
c0105cad:	75 e4                	jne    c0105c93 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105caf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105cb2:	c9                   	leave  
c0105cb3:	c3                   	ret    

c0105cb4 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105cb4:	55                   	push   %ebp
c0105cb5:	89 e5                	mov    %esp,%ebp
c0105cb7:	57                   	push   %edi
c0105cb8:	56                   	push   %esi
c0105cb9:	83 ec 20             	sub    $0x20,%esp
c0105cbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105cc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cce:	89 d1                	mov    %edx,%ecx
c0105cd0:	89 c2                	mov    %eax,%edx
c0105cd2:	89 ce                	mov    %ecx,%esi
c0105cd4:	89 d7                	mov    %edx,%edi
c0105cd6:	ac                   	lods   %ds:(%esi),%al
c0105cd7:	aa                   	stos   %al,%es:(%edi)
c0105cd8:	84 c0                	test   %al,%al
c0105cda:	75 fa                	jne    c0105cd6 <strcpy+0x22>
c0105cdc:	89 fa                	mov    %edi,%edx
c0105cde:	89 f1                	mov    %esi,%ecx
c0105ce0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105ce3:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105ce6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105cec:	83 c4 20             	add    $0x20,%esp
c0105cef:	5e                   	pop    %esi
c0105cf0:	5f                   	pop    %edi
c0105cf1:	5d                   	pop    %ebp
c0105cf2:	c3                   	ret    

c0105cf3 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105cf3:	55                   	push   %ebp
c0105cf4:	89 e5                	mov    %esp,%ebp
c0105cf6:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105cf9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105cff:	eb 21                	jmp    c0105d22 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105d01:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d04:	0f b6 10             	movzbl (%eax),%edx
c0105d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d0a:	88 10                	mov    %dl,(%eax)
c0105d0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105d0f:	0f b6 00             	movzbl (%eax),%eax
c0105d12:	84 c0                	test   %al,%al
c0105d14:	74 04                	je     c0105d1a <strncpy+0x27>
            src ++;
c0105d16:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105d1a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105d1e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105d22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d26:	75 d9                	jne    c0105d01 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105d28:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105d2b:	c9                   	leave  
c0105d2c:	c3                   	ret    

c0105d2d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105d2d:	55                   	push   %ebp
c0105d2e:	89 e5                	mov    %esp,%ebp
c0105d30:	57                   	push   %edi
c0105d31:	56                   	push   %esi
c0105d32:	83 ec 20             	sub    $0x20,%esp
c0105d35:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105d41:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d47:	89 d1                	mov    %edx,%ecx
c0105d49:	89 c2                	mov    %eax,%edx
c0105d4b:	89 ce                	mov    %ecx,%esi
c0105d4d:	89 d7                	mov    %edx,%edi
c0105d4f:	ac                   	lods   %ds:(%esi),%al
c0105d50:	ae                   	scas   %es:(%edi),%al
c0105d51:	75 08                	jne    c0105d5b <strcmp+0x2e>
c0105d53:	84 c0                	test   %al,%al
c0105d55:	75 f8                	jne    c0105d4f <strcmp+0x22>
c0105d57:	31 c0                	xor    %eax,%eax
c0105d59:	eb 04                	jmp    c0105d5f <strcmp+0x32>
c0105d5b:	19 c0                	sbb    %eax,%eax
c0105d5d:	0c 01                	or     $0x1,%al
c0105d5f:	89 fa                	mov    %edi,%edx
c0105d61:	89 f1                	mov    %esi,%ecx
c0105d63:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d66:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105d69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105d6f:	83 c4 20             	add    $0x20,%esp
c0105d72:	5e                   	pop    %esi
c0105d73:	5f                   	pop    %edi
c0105d74:	5d                   	pop    %ebp
c0105d75:	c3                   	ret    

c0105d76 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105d76:	55                   	push   %ebp
c0105d77:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105d79:	eb 0c                	jmp    c0105d87 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105d7b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105d7f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d83:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105d87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d8b:	74 1a                	je     c0105da7 <strncmp+0x31>
c0105d8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d90:	0f b6 00             	movzbl (%eax),%eax
c0105d93:	84 c0                	test   %al,%al
c0105d95:	74 10                	je     c0105da7 <strncmp+0x31>
c0105d97:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d9a:	0f b6 10             	movzbl (%eax),%edx
c0105d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105da0:	0f b6 00             	movzbl (%eax),%eax
c0105da3:	38 c2                	cmp    %al,%dl
c0105da5:	74 d4                	je     c0105d7b <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105da7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105dab:	74 18                	je     c0105dc5 <strncmp+0x4f>
c0105dad:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db0:	0f b6 00             	movzbl (%eax),%eax
c0105db3:	0f b6 d0             	movzbl %al,%edx
c0105db6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105db9:	0f b6 00             	movzbl (%eax),%eax
c0105dbc:	0f b6 c0             	movzbl %al,%eax
c0105dbf:	29 c2                	sub    %eax,%edx
c0105dc1:	89 d0                	mov    %edx,%eax
c0105dc3:	eb 05                	jmp    c0105dca <strncmp+0x54>
c0105dc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105dca:	5d                   	pop    %ebp
c0105dcb:	c3                   	ret    

c0105dcc <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105dcc:	55                   	push   %ebp
c0105dcd:	89 e5                	mov    %esp,%ebp
c0105dcf:	83 ec 04             	sub    $0x4,%esp
c0105dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dd5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105dd8:	eb 14                	jmp    c0105dee <strchr+0x22>
        if (*s == c) {
c0105dda:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ddd:	0f b6 00             	movzbl (%eax),%eax
c0105de0:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105de3:	75 05                	jne    c0105dea <strchr+0x1e>
            return (char *)s;
c0105de5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105de8:	eb 13                	jmp    c0105dfd <strchr+0x31>
        }
        s ++;
c0105dea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105dee:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df1:	0f b6 00             	movzbl (%eax),%eax
c0105df4:	84 c0                	test   %al,%al
c0105df6:	75 e2                	jne    c0105dda <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105df8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105dfd:	c9                   	leave  
c0105dfe:	c3                   	ret    

c0105dff <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105dff:	55                   	push   %ebp
c0105e00:	89 e5                	mov    %esp,%ebp
c0105e02:	83 ec 04             	sub    $0x4,%esp
c0105e05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e08:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105e0b:	eb 11                	jmp    c0105e1e <strfind+0x1f>
        if (*s == c) {
c0105e0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e10:	0f b6 00             	movzbl (%eax),%eax
c0105e13:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105e16:	75 02                	jne    c0105e1a <strfind+0x1b>
            break;
c0105e18:	eb 0e                	jmp    c0105e28 <strfind+0x29>
        }
        s ++;
c0105e1a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105e1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e21:	0f b6 00             	movzbl (%eax),%eax
c0105e24:	84 c0                	test   %al,%al
c0105e26:	75 e5                	jne    c0105e0d <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105e28:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105e2b:	c9                   	leave  
c0105e2c:	c3                   	ret    

c0105e2d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105e2d:	55                   	push   %ebp
c0105e2e:	89 e5                	mov    %esp,%ebp
c0105e30:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105e33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105e3a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105e41:	eb 04                	jmp    c0105e47 <strtol+0x1a>
        s ++;
c0105e43:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105e47:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e4a:	0f b6 00             	movzbl (%eax),%eax
c0105e4d:	3c 20                	cmp    $0x20,%al
c0105e4f:	74 f2                	je     c0105e43 <strtol+0x16>
c0105e51:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e54:	0f b6 00             	movzbl (%eax),%eax
c0105e57:	3c 09                	cmp    $0x9,%al
c0105e59:	74 e8                	je     c0105e43 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105e5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e5e:	0f b6 00             	movzbl (%eax),%eax
c0105e61:	3c 2b                	cmp    $0x2b,%al
c0105e63:	75 06                	jne    c0105e6b <strtol+0x3e>
        s ++;
c0105e65:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105e69:	eb 15                	jmp    c0105e80 <strtol+0x53>
    }
    else if (*s == '-') {
c0105e6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e6e:	0f b6 00             	movzbl (%eax),%eax
c0105e71:	3c 2d                	cmp    $0x2d,%al
c0105e73:	75 0b                	jne    c0105e80 <strtol+0x53>
        s ++, neg = 1;
c0105e75:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105e79:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105e80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e84:	74 06                	je     c0105e8c <strtol+0x5f>
c0105e86:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105e8a:	75 24                	jne    c0105eb0 <strtol+0x83>
c0105e8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e8f:	0f b6 00             	movzbl (%eax),%eax
c0105e92:	3c 30                	cmp    $0x30,%al
c0105e94:	75 1a                	jne    c0105eb0 <strtol+0x83>
c0105e96:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e99:	83 c0 01             	add    $0x1,%eax
c0105e9c:	0f b6 00             	movzbl (%eax),%eax
c0105e9f:	3c 78                	cmp    $0x78,%al
c0105ea1:	75 0d                	jne    c0105eb0 <strtol+0x83>
        s += 2, base = 16;
c0105ea3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105ea7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105eae:	eb 2a                	jmp    c0105eda <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105eb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105eb4:	75 17                	jne    c0105ecd <strtol+0xa0>
c0105eb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eb9:	0f b6 00             	movzbl (%eax),%eax
c0105ebc:	3c 30                	cmp    $0x30,%al
c0105ebe:	75 0d                	jne    c0105ecd <strtol+0xa0>
        s ++, base = 8;
c0105ec0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ec4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105ecb:	eb 0d                	jmp    c0105eda <strtol+0xad>
    }
    else if (base == 0) {
c0105ecd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ed1:	75 07                	jne    c0105eda <strtol+0xad>
        base = 10;
c0105ed3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105eda:	8b 45 08             	mov    0x8(%ebp),%eax
c0105edd:	0f b6 00             	movzbl (%eax),%eax
c0105ee0:	3c 2f                	cmp    $0x2f,%al
c0105ee2:	7e 1b                	jle    c0105eff <strtol+0xd2>
c0105ee4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ee7:	0f b6 00             	movzbl (%eax),%eax
c0105eea:	3c 39                	cmp    $0x39,%al
c0105eec:	7f 11                	jg     c0105eff <strtol+0xd2>
            dig = *s - '0';
c0105eee:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ef1:	0f b6 00             	movzbl (%eax),%eax
c0105ef4:	0f be c0             	movsbl %al,%eax
c0105ef7:	83 e8 30             	sub    $0x30,%eax
c0105efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105efd:	eb 48                	jmp    c0105f47 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105eff:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f02:	0f b6 00             	movzbl (%eax),%eax
c0105f05:	3c 60                	cmp    $0x60,%al
c0105f07:	7e 1b                	jle    c0105f24 <strtol+0xf7>
c0105f09:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f0c:	0f b6 00             	movzbl (%eax),%eax
c0105f0f:	3c 7a                	cmp    $0x7a,%al
c0105f11:	7f 11                	jg     c0105f24 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105f13:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f16:	0f b6 00             	movzbl (%eax),%eax
c0105f19:	0f be c0             	movsbl %al,%eax
c0105f1c:	83 e8 57             	sub    $0x57,%eax
c0105f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105f22:	eb 23                	jmp    c0105f47 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105f24:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f27:	0f b6 00             	movzbl (%eax),%eax
c0105f2a:	3c 40                	cmp    $0x40,%al
c0105f2c:	7e 3d                	jle    c0105f6b <strtol+0x13e>
c0105f2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f31:	0f b6 00             	movzbl (%eax),%eax
c0105f34:	3c 5a                	cmp    $0x5a,%al
c0105f36:	7f 33                	jg     c0105f6b <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105f38:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f3b:	0f b6 00             	movzbl (%eax),%eax
c0105f3e:	0f be c0             	movsbl %al,%eax
c0105f41:	83 e8 37             	sub    $0x37,%eax
c0105f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f4a:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105f4d:	7c 02                	jl     c0105f51 <strtol+0x124>
            break;
c0105f4f:	eb 1a                	jmp    c0105f6b <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105f51:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105f55:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f58:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105f5c:	89 c2                	mov    %eax,%edx
c0105f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f61:	01 d0                	add    %edx,%eax
c0105f63:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105f66:	e9 6f ff ff ff       	jmp    c0105eda <strtol+0xad>

    if (endptr) {
c0105f6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105f6f:	74 08                	je     c0105f79 <strtol+0x14c>
        *endptr = (char *) s;
c0105f71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f74:	8b 55 08             	mov    0x8(%ebp),%edx
c0105f77:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105f79:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105f7d:	74 07                	je     c0105f86 <strtol+0x159>
c0105f7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f82:	f7 d8                	neg    %eax
c0105f84:	eb 03                	jmp    c0105f89 <strtol+0x15c>
c0105f86:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105f89:	c9                   	leave  
c0105f8a:	c3                   	ret    

c0105f8b <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105f8b:	55                   	push   %ebp
c0105f8c:	89 e5                	mov    %esp,%ebp
c0105f8e:	57                   	push   %edi
c0105f8f:	83 ec 24             	sub    $0x24,%esp
c0105f92:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f95:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105f98:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105f9c:	8b 55 08             	mov    0x8(%ebp),%edx
c0105f9f:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105fa2:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105fa5:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105fab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105fae:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105fb2:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105fb5:	89 d7                	mov    %edx,%edi
c0105fb7:	f3 aa                	rep stos %al,%es:(%edi)
c0105fb9:	89 fa                	mov    %edi,%edx
c0105fbb:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105fbe:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105fc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105fc4:	83 c4 24             	add    $0x24,%esp
c0105fc7:	5f                   	pop    %edi
c0105fc8:	5d                   	pop    %ebp
c0105fc9:	c3                   	ret    

c0105fca <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105fca:	55                   	push   %ebp
c0105fcb:	89 e5                	mov    %esp,%ebp
c0105fcd:	57                   	push   %edi
c0105fce:	56                   	push   %esi
c0105fcf:	53                   	push   %ebx
c0105fd0:	83 ec 30             	sub    $0x30,%esp
c0105fd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fdc:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105fdf:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fe2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fe8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105feb:	73 42                	jae    c010602f <memmove+0x65>
c0105fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ff0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105ff3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ff6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105ff9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ffc:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105fff:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106002:	c1 e8 02             	shr    $0x2,%eax
c0106005:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0106007:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010600a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010600d:	89 d7                	mov    %edx,%edi
c010600f:	89 c6                	mov    %eax,%esi
c0106011:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106013:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106016:	83 e1 03             	and    $0x3,%ecx
c0106019:	74 02                	je     c010601d <memmove+0x53>
c010601b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010601d:	89 f0                	mov    %esi,%eax
c010601f:	89 fa                	mov    %edi,%edx
c0106021:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0106024:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0106027:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010602a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010602d:	eb 36                	jmp    c0106065 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010602f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106032:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106035:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106038:	01 c2                	add    %eax,%edx
c010603a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010603d:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0106040:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106043:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0106046:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106049:	89 c1                	mov    %eax,%ecx
c010604b:	89 d8                	mov    %ebx,%eax
c010604d:	89 d6                	mov    %edx,%esi
c010604f:	89 c7                	mov    %eax,%edi
c0106051:	fd                   	std    
c0106052:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106054:	fc                   	cld    
c0106055:	89 f8                	mov    %edi,%eax
c0106057:	89 f2                	mov    %esi,%edx
c0106059:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010605c:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010605f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0106062:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0106065:	83 c4 30             	add    $0x30,%esp
c0106068:	5b                   	pop    %ebx
c0106069:	5e                   	pop    %esi
c010606a:	5f                   	pop    %edi
c010606b:	5d                   	pop    %ebp
c010606c:	c3                   	ret    

c010606d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010606d:	55                   	push   %ebp
c010606e:	89 e5                	mov    %esp,%ebp
c0106070:	57                   	push   %edi
c0106071:	56                   	push   %esi
c0106072:	83 ec 20             	sub    $0x20,%esp
c0106075:	8b 45 08             	mov    0x8(%ebp),%eax
c0106078:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010607b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010607e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106081:	8b 45 10             	mov    0x10(%ebp),%eax
c0106084:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106087:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010608a:	c1 e8 02             	shr    $0x2,%eax
c010608d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010608f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106092:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106095:	89 d7                	mov    %edx,%edi
c0106097:	89 c6                	mov    %eax,%esi
c0106099:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010609b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c010609e:	83 e1 03             	and    $0x3,%ecx
c01060a1:	74 02                	je     c01060a5 <memcpy+0x38>
c01060a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01060a5:	89 f0                	mov    %esi,%eax
c01060a7:	89 fa                	mov    %edi,%edx
c01060a9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01060ac:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01060af:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01060b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01060b5:	83 c4 20             	add    $0x20,%esp
c01060b8:	5e                   	pop    %esi
c01060b9:	5f                   	pop    %edi
c01060ba:	5d                   	pop    %ebp
c01060bb:	c3                   	ret    

c01060bc <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01060bc:	55                   	push   %ebp
c01060bd:	89 e5                	mov    %esp,%ebp
c01060bf:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01060c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01060c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01060c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c01060ce:	eb 30                	jmp    c0106100 <memcmp+0x44>
        if (*s1 != *s2) {
c01060d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01060d3:	0f b6 10             	movzbl (%eax),%edx
c01060d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01060d9:	0f b6 00             	movzbl (%eax),%eax
c01060dc:	38 c2                	cmp    %al,%dl
c01060de:	74 18                	je     c01060f8 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c01060e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01060e3:	0f b6 00             	movzbl (%eax),%eax
c01060e6:	0f b6 d0             	movzbl %al,%edx
c01060e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01060ec:	0f b6 00             	movzbl (%eax),%eax
c01060ef:	0f b6 c0             	movzbl %al,%eax
c01060f2:	29 c2                	sub    %eax,%edx
c01060f4:	89 d0                	mov    %edx,%eax
c01060f6:	eb 1a                	jmp    c0106112 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c01060f8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01060fc:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0106100:	8b 45 10             	mov    0x10(%ebp),%eax
c0106103:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106106:	89 55 10             	mov    %edx,0x10(%ebp)
c0106109:	85 c0                	test   %eax,%eax
c010610b:	75 c3                	jne    c01060d0 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010610d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106112:	c9                   	leave  
c0106113:	c3                   	ret    
