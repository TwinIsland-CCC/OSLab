
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 80 11 40       	mov    $0x40118000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 80 11 00       	mov    %eax,0x118000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	ba e4 af 11 00       	mov    $0x11afe4,%edx
  100041:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  100046:	29 c2                	sub    %eax,%edx
  100048:	89 d0                	mov    %edx,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  10005d:	e8 29 5f 00 00       	call   105f8b <memset>

    cons_init();                // init the console
  100062:	e8 a3 15 00 00       	call   10160a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 20 61 10 00 	movl   $0x106120,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 3c 61 10 00 	movl   $0x10613c,(%esp)
  10007c:	e8 c7 02 00 00       	call   100348 <cprintf>

    print_kerninfo();
  100081:	e8 f6 07 00 00       	call   10087c <print_kerninfo>

    grade_backtrace();
  100086:	e8 86 00 00 00       	call   100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 f5 45 00 00       	call   104685 <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 de 16 00 00       	call   101773 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 30 18 00 00       	call   1018ca <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 21 0d 00 00       	call   100dc0 <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 3d 16 00 00       	call   1016e1 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a4:	eb fe                	jmp    1000a4 <kern_init+0x6e>

001000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a6:	55                   	push   %ebp
  1000a7:	89 e5                	mov    %esp,%ebp
  1000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b3:	00 
  1000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000bb:	00 
  1000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c3:	e8 19 0c 00 00       	call   100ce1 <mon_backtrace>
}
  1000c8:	c9                   	leave  
  1000c9:	c3                   	ret    

001000ca <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000ca:	55                   	push   %ebp
  1000cb:	89 e5                	mov    %esp,%ebp
  1000cd:	53                   	push   %ebx
  1000ce:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d1:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000d7:	8d 55 08             	lea    0x8(%ebp),%edx
  1000da:	8b 45 08             	mov    0x8(%ebp),%eax
  1000dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000e9:	89 04 24             	mov    %eax,(%esp)
  1000ec:	e8 b5 ff ff ff       	call   1000a6 <grade_backtrace2>
}
  1000f1:	83 c4 14             	add    $0x14,%esp
  1000f4:	5b                   	pop    %ebx
  1000f5:	5d                   	pop    %ebp
  1000f6:	c3                   	ret    

001000f7 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000f7:	55                   	push   %ebp
  1000f8:	89 e5                	mov    %esp,%ebp
  1000fa:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000fd:	8b 45 10             	mov    0x10(%ebp),%eax
  100100:	89 44 24 04          	mov    %eax,0x4(%esp)
  100104:	8b 45 08             	mov    0x8(%ebp),%eax
  100107:	89 04 24             	mov    %eax,(%esp)
  10010a:	e8 bb ff ff ff       	call   1000ca <grade_backtrace1>
}
  10010f:	c9                   	leave  
  100110:	c3                   	ret    

00100111 <grade_backtrace>:

void
grade_backtrace(void) {
  100111:	55                   	push   %ebp
  100112:	89 e5                	mov    %esp,%ebp
  100114:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  100117:	b8 36 00 10 00       	mov    $0x100036,%eax
  10011c:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100123:	ff 
  100124:	89 44 24 04          	mov    %eax,0x4(%esp)
  100128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10012f:	e8 c3 ff ff ff       	call   1000f7 <grade_backtrace0>
}
  100134:	c9                   	leave  
  100135:	c3                   	ret    

00100136 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100136:	55                   	push   %ebp
  100137:	89 e5                	mov    %esp,%ebp
  100139:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10014c:	0f b7 c0             	movzwl %ax,%eax
  10014f:	83 e0 03             	and    $0x3,%eax
  100152:	89 c2                	mov    %eax,%edx
  100154:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100159:	89 54 24 08          	mov    %edx,0x8(%esp)
  10015d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100161:	c7 04 24 41 61 10 00 	movl   $0x106141,(%esp)
  100168:	e8 db 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10016d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100171:	0f b7 d0             	movzwl %ax,%edx
  100174:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100179:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100181:	c7 04 24 4f 61 10 00 	movl   $0x10614f,(%esp)
  100188:	e8 bb 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100191:	0f b7 d0             	movzwl %ax,%edx
  100194:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100199:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a1:	c7 04 24 5d 61 10 00 	movl   $0x10615d,(%esp)
  1001a8:	e8 9b 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001ad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b1:	0f b7 d0             	movzwl %ax,%edx
  1001b4:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c1:	c7 04 24 6b 61 10 00 	movl   $0x10616b,(%esp)
  1001c8:	e8 7b 01 00 00       	call   100348 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d1:	0f b7 d0             	movzwl %ax,%edx
  1001d4:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001d9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e1:	c7 04 24 79 61 10 00 	movl   $0x106179,(%esp)
  1001e8:	e8 5b 01 00 00       	call   100348 <cprintf>
    round ++;
  1001ed:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001f2:	83 c0 01             	add    $0x1,%eax
  1001f5:	a3 00 a0 11 00       	mov    %eax,0x11a000
}
  1001fa:	c9                   	leave  
  1001fb:	c3                   	ret    

001001fc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001fc:	55                   	push   %ebp
  1001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001ff:	5d                   	pop    %ebp
  100200:	c3                   	ret    

00100201 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100201:	55                   	push   %ebp
  100202:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  100204:	5d                   	pop    %ebp
  100205:	c3                   	ret    

00100206 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100206:	55                   	push   %ebp
  100207:	89 e5                	mov    %esp,%ebp
  100209:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10020c:	e8 25 ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100211:	c7 04 24 88 61 10 00 	movl   $0x106188,(%esp)
  100218:	e8 2b 01 00 00       	call   100348 <cprintf>
    lab1_switch_to_user();
  10021d:	e8 da ff ff ff       	call   1001fc <lab1_switch_to_user>
    lab1_print_cur_status();
  100222:	e8 0f ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100227:	c7 04 24 a8 61 10 00 	movl   $0x1061a8,(%esp)
  10022e:	e8 15 01 00 00       	call   100348 <cprintf>
    lab1_switch_to_kernel();
  100233:	e8 c9 ff ff ff       	call   100201 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100238:	e8 f9 fe ff ff       	call   100136 <lab1_print_cur_status>
}
  10023d:	c9                   	leave  
  10023e:	c3                   	ret    

0010023f <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10023f:	55                   	push   %ebp
  100240:	89 e5                	mov    %esp,%ebp
  100242:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100245:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100249:	74 13                	je     10025e <readline+0x1f>
        cprintf("%s", prompt);
  10024b:	8b 45 08             	mov    0x8(%ebp),%eax
  10024e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100252:	c7 04 24 c7 61 10 00 	movl   $0x1061c7,(%esp)
  100259:	e8 ea 00 00 00       	call   100348 <cprintf>
    }
    int i = 0, c;
  10025e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100265:	e8 66 01 00 00       	call   1003d0 <getchar>
  10026a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10026d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100271:	79 07                	jns    10027a <readline+0x3b>
            return NULL;
  100273:	b8 00 00 00 00       	mov    $0x0,%eax
  100278:	eb 79                	jmp    1002f3 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10027a:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10027e:	7e 28                	jle    1002a8 <readline+0x69>
  100280:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100287:	7f 1f                	jg     1002a8 <readline+0x69>
            cputchar(c);
  100289:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10028c:	89 04 24             	mov    %eax,(%esp)
  10028f:	e8 da 00 00 00       	call   10036e <cputchar>
            buf[i ++] = c;
  100294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100297:	8d 50 01             	lea    0x1(%eax),%edx
  10029a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10029d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1002a0:	88 90 20 a0 11 00    	mov    %dl,0x11a020(%eax)
  1002a6:	eb 46                	jmp    1002ee <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  1002a8:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002ac:	75 17                	jne    1002c5 <readline+0x86>
  1002ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002b2:	7e 11                	jle    1002c5 <readline+0x86>
            cputchar(c);
  1002b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b7:	89 04 24             	mov    %eax,(%esp)
  1002ba:	e8 af 00 00 00       	call   10036e <cputchar>
            i --;
  1002bf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002c3:	eb 29                	jmp    1002ee <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002c5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002c9:	74 06                	je     1002d1 <readline+0x92>
  1002cb:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002cf:	75 1d                	jne    1002ee <readline+0xaf>
            cputchar(c);
  1002d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002d4:	89 04 24             	mov    %eax,(%esp)
  1002d7:	e8 92 00 00 00       	call   10036e <cputchar>
            buf[i] = '\0';
  1002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002df:	05 20 a0 11 00       	add    $0x11a020,%eax
  1002e4:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002e7:	b8 20 a0 11 00       	mov    $0x11a020,%eax
  1002ec:	eb 05                	jmp    1002f3 <readline+0xb4>
        }
    }
  1002ee:	e9 72 ff ff ff       	jmp    100265 <readline+0x26>
}
  1002f3:	c9                   	leave  
  1002f4:	c3                   	ret    

001002f5 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002f5:	55                   	push   %ebp
  1002f6:	89 e5                	mov    %esp,%ebp
  1002f8:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fe:	89 04 24             	mov    %eax,(%esp)
  100301:	e8 30 13 00 00       	call   101636 <cons_putc>
    (*cnt) ++;
  100306:	8b 45 0c             	mov    0xc(%ebp),%eax
  100309:	8b 00                	mov    (%eax),%eax
  10030b:	8d 50 01             	lea    0x1(%eax),%edx
  10030e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100311:	89 10                	mov    %edx,(%eax)
}
  100313:	c9                   	leave  
  100314:	c3                   	ret    

00100315 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100315:	55                   	push   %ebp
  100316:	89 e5                	mov    %esp,%ebp
  100318:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10031b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100322:	8b 45 0c             	mov    0xc(%ebp),%eax
  100325:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100329:	8b 45 08             	mov    0x8(%ebp),%eax
  10032c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100330:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100333:	89 44 24 04          	mov    %eax,0x4(%esp)
  100337:	c7 04 24 f5 02 10 00 	movl   $0x1002f5,(%esp)
  10033e:	e8 61 54 00 00       	call   1057a4 <vprintfmt>
    return cnt;
  100343:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100346:	c9                   	leave  
  100347:	c3                   	ret    

00100348 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100348:	55                   	push   %ebp
  100349:	89 e5                	mov    %esp,%ebp
  10034b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10034e:	8d 45 0c             	lea    0xc(%ebp),%eax
  100351:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100354:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100357:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035b:	8b 45 08             	mov    0x8(%ebp),%eax
  10035e:	89 04 24             	mov    %eax,(%esp)
  100361:	e8 af ff ff ff       	call   100315 <vcprintf>
  100366:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100369:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10036c:	c9                   	leave  
  10036d:	c3                   	ret    

0010036e <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10036e:	55                   	push   %ebp
  10036f:	89 e5                	mov    %esp,%ebp
  100371:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100374:	8b 45 08             	mov    0x8(%ebp),%eax
  100377:	89 04 24             	mov    %eax,(%esp)
  10037a:	e8 b7 12 00 00       	call   101636 <cons_putc>
}
  10037f:	c9                   	leave  
  100380:	c3                   	ret    

00100381 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100381:	55                   	push   %ebp
  100382:	89 e5                	mov    %esp,%ebp
  100384:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100387:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10038e:	eb 13                	jmp    1003a3 <cputs+0x22>
        cputch(c, &cnt);
  100390:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100394:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100397:	89 54 24 04          	mov    %edx,0x4(%esp)
  10039b:	89 04 24             	mov    %eax,(%esp)
  10039e:	e8 52 ff ff ff       	call   1002f5 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1003a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1003a6:	8d 50 01             	lea    0x1(%eax),%edx
  1003a9:	89 55 08             	mov    %edx,0x8(%ebp)
  1003ac:	0f b6 00             	movzbl (%eax),%eax
  1003af:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003b2:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003b6:	75 d8                	jne    100390 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003bf:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003c6:	e8 2a ff ff ff       	call   1002f5 <cputch>
    return cnt;
  1003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003ce:	c9                   	leave  
  1003cf:	c3                   	ret    

001003d0 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003d0:	55                   	push   %ebp
  1003d1:	89 e5                	mov    %esp,%ebp
  1003d3:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003d6:	e8 97 12 00 00       	call   101672 <cons_getc>
  1003db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003e2:	74 f2                	je     1003d6 <getchar+0x6>
        /* do nothing */;
    return c;
  1003e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003e7:	c9                   	leave  
  1003e8:	c3                   	ret    

001003e9 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003e9:	55                   	push   %ebp
  1003ea:	89 e5                	mov    %esp,%ebp
  1003ec:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003f2:	8b 00                	mov    (%eax),%eax
  1003f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1003fa:	8b 00                	mov    (%eax),%eax
  1003fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100406:	e9 d2 00 00 00       	jmp    1004dd <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  10040b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10040e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100411:	01 d0                	add    %edx,%eax
  100413:	89 c2                	mov    %eax,%edx
  100415:	c1 ea 1f             	shr    $0x1f,%edx
  100418:	01 d0                	add    %edx,%eax
  10041a:	d1 f8                	sar    %eax
  10041c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100422:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100425:	eb 04                	jmp    10042b <stab_binsearch+0x42>
            m --;
  100427:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10042b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10042e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100431:	7c 1f                	jl     100452 <stab_binsearch+0x69>
  100433:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100436:	89 d0                	mov    %edx,%eax
  100438:	01 c0                	add    %eax,%eax
  10043a:	01 d0                	add    %edx,%eax
  10043c:	c1 e0 02             	shl    $0x2,%eax
  10043f:	89 c2                	mov    %eax,%edx
  100441:	8b 45 08             	mov    0x8(%ebp),%eax
  100444:	01 d0                	add    %edx,%eax
  100446:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10044a:	0f b6 c0             	movzbl %al,%eax
  10044d:	3b 45 14             	cmp    0x14(%ebp),%eax
  100450:	75 d5                	jne    100427 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100455:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100458:	7d 0b                	jge    100465 <stab_binsearch+0x7c>
            l = true_m + 1;
  10045a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045d:	83 c0 01             	add    $0x1,%eax
  100460:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100463:	eb 78                	jmp    1004dd <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100465:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10046c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10046f:	89 d0                	mov    %edx,%eax
  100471:	01 c0                	add    %eax,%eax
  100473:	01 d0                	add    %edx,%eax
  100475:	c1 e0 02             	shl    $0x2,%eax
  100478:	89 c2                	mov    %eax,%edx
  10047a:	8b 45 08             	mov    0x8(%ebp),%eax
  10047d:	01 d0                	add    %edx,%eax
  10047f:	8b 40 08             	mov    0x8(%eax),%eax
  100482:	3b 45 18             	cmp    0x18(%ebp),%eax
  100485:	73 13                	jae    10049a <stab_binsearch+0xb1>
            *region_left = m;
  100487:	8b 45 0c             	mov    0xc(%ebp),%eax
  10048a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10048d:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10048f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100492:	83 c0 01             	add    $0x1,%eax
  100495:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100498:	eb 43                	jmp    1004dd <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10049a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049d:	89 d0                	mov    %edx,%eax
  10049f:	01 c0                	add    %eax,%eax
  1004a1:	01 d0                	add    %edx,%eax
  1004a3:	c1 e0 02             	shl    $0x2,%eax
  1004a6:	89 c2                	mov    %eax,%edx
  1004a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ab:	01 d0                	add    %edx,%eax
  1004ad:	8b 40 08             	mov    0x8(%eax),%eax
  1004b0:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004b3:	76 16                	jbe    1004cb <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004bb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004be:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c3:	83 e8 01             	sub    $0x1,%eax
  1004c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004c9:	eb 12                	jmp    1004dd <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004d1:	89 10                	mov    %edx,(%eax)
            l = m;
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004d9:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004e3:	0f 8e 22 ff ff ff    	jle    10040b <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004ed:	75 0f                	jne    1004fe <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004f2:	8b 00                	mov    (%eax),%eax
  1004f4:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004f7:	8b 45 10             	mov    0x10(%ebp),%eax
  1004fa:	89 10                	mov    %edx,(%eax)
  1004fc:	eb 3f                	jmp    10053d <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004fe:	8b 45 10             	mov    0x10(%ebp),%eax
  100501:	8b 00                	mov    (%eax),%eax
  100503:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100506:	eb 04                	jmp    10050c <stab_binsearch+0x123>
  100508:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  10050c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050f:	8b 00                	mov    (%eax),%eax
  100511:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100514:	7d 1f                	jge    100535 <stab_binsearch+0x14c>
  100516:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100519:	89 d0                	mov    %edx,%eax
  10051b:	01 c0                	add    %eax,%eax
  10051d:	01 d0                	add    %edx,%eax
  10051f:	c1 e0 02             	shl    $0x2,%eax
  100522:	89 c2                	mov    %eax,%edx
  100524:	8b 45 08             	mov    0x8(%ebp),%eax
  100527:	01 d0                	add    %edx,%eax
  100529:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10052d:	0f b6 c0             	movzbl %al,%eax
  100530:	3b 45 14             	cmp    0x14(%ebp),%eax
  100533:	75 d3                	jne    100508 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100535:	8b 45 0c             	mov    0xc(%ebp),%eax
  100538:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10053b:	89 10                	mov    %edx,(%eax)
    }
}
  10053d:	c9                   	leave  
  10053e:	c3                   	ret    

0010053f <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10053f:	55                   	push   %ebp
  100540:	89 e5                	mov    %esp,%ebp
  100542:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100545:	8b 45 0c             	mov    0xc(%ebp),%eax
  100548:	c7 00 cc 61 10 00    	movl   $0x1061cc,(%eax)
    info->eip_line = 0;
  10054e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100558:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055b:	c7 40 08 cc 61 10 00 	movl   $0x1061cc,0x8(%eax)
    info->eip_fn_namelen = 9;
  100562:	8b 45 0c             	mov    0xc(%ebp),%eax
  100565:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10056c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056f:	8b 55 08             	mov    0x8(%ebp),%edx
  100572:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100575:	8b 45 0c             	mov    0xc(%ebp),%eax
  100578:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  10057f:	c7 45 f4 d0 74 10 00 	movl   $0x1074d0,-0xc(%ebp)
    stab_end = __STAB_END__;
  100586:	c7 45 f0 c0 20 11 00 	movl   $0x1120c0,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10058d:	c7 45 ec c1 20 11 00 	movl   $0x1120c1,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100594:	c7 45 e8 1d 4b 11 00 	movl   $0x114b1d,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10059b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1005a1:	76 0d                	jbe    1005b0 <debuginfo_eip+0x71>
  1005a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1005a6:	83 e8 01             	sub    $0x1,%eax
  1005a9:	0f b6 00             	movzbl (%eax),%eax
  1005ac:	84 c0                	test   %al,%al
  1005ae:	74 0a                	je     1005ba <debuginfo_eip+0x7b>
        return -1;
  1005b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005b5:	e9 c0 02 00 00       	jmp    10087a <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c7:	29 c2                	sub    %eax,%edx
  1005c9:	89 d0                	mov    %edx,%eax
  1005cb:	c1 f8 02             	sar    $0x2,%eax
  1005ce:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005d4:	83 e8 01             	sub    $0x1,%eax
  1005d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005da:	8b 45 08             	mov    0x8(%ebp),%eax
  1005dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005e1:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005e8:	00 
  1005e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005fa:	89 04 24             	mov    %eax,(%esp)
  1005fd:	e8 e7 fd ff ff       	call   1003e9 <stab_binsearch>
    if (lfile == 0)
  100602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100605:	85 c0                	test   %eax,%eax
  100607:	75 0a                	jne    100613 <debuginfo_eip+0xd4>
        return -1;
  100609:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10060e:	e9 67 02 00 00       	jmp    10087a <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100616:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100619:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10061c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10061f:	8b 45 08             	mov    0x8(%ebp),%eax
  100622:	89 44 24 10          	mov    %eax,0x10(%esp)
  100626:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  10062d:	00 
  10062e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100631:	89 44 24 08          	mov    %eax,0x8(%esp)
  100635:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100638:	89 44 24 04          	mov    %eax,0x4(%esp)
  10063c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10063f:	89 04 24             	mov    %eax,(%esp)
  100642:	e8 a2 fd ff ff       	call   1003e9 <stab_binsearch>

    if (lfun <= rfun) {
  100647:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10064a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10064d:	39 c2                	cmp    %eax,%edx
  10064f:	7f 7c                	jg     1006cd <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100651:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100654:	89 c2                	mov    %eax,%edx
  100656:	89 d0                	mov    %edx,%eax
  100658:	01 c0                	add    %eax,%eax
  10065a:	01 d0                	add    %edx,%eax
  10065c:	c1 e0 02             	shl    $0x2,%eax
  10065f:	89 c2                	mov    %eax,%edx
  100661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100664:	01 d0                	add    %edx,%eax
  100666:	8b 10                	mov    (%eax),%edx
  100668:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10066b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10066e:	29 c1                	sub    %eax,%ecx
  100670:	89 c8                	mov    %ecx,%eax
  100672:	39 c2                	cmp    %eax,%edx
  100674:	73 22                	jae    100698 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100676:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100679:	89 c2                	mov    %eax,%edx
  10067b:	89 d0                	mov    %edx,%eax
  10067d:	01 c0                	add    %eax,%eax
  10067f:	01 d0                	add    %edx,%eax
  100681:	c1 e0 02             	shl    $0x2,%eax
  100684:	89 c2                	mov    %eax,%edx
  100686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100689:	01 d0                	add    %edx,%eax
  10068b:	8b 10                	mov    (%eax),%edx
  10068d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100690:	01 c2                	add    %eax,%edx
  100692:	8b 45 0c             	mov    0xc(%ebp),%eax
  100695:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100698:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10069b:	89 c2                	mov    %eax,%edx
  10069d:	89 d0                	mov    %edx,%eax
  10069f:	01 c0                	add    %eax,%eax
  1006a1:	01 d0                	add    %edx,%eax
  1006a3:	c1 e0 02             	shl    $0x2,%eax
  1006a6:	89 c2                	mov    %eax,%edx
  1006a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ab:	01 d0                	add    %edx,%eax
  1006ad:	8b 50 08             	mov    0x8(%eax),%edx
  1006b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b3:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006b9:	8b 40 10             	mov    0x10(%eax),%eax
  1006bc:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006cb:	eb 15                	jmp    1006e2 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d0:	8b 55 08             	mov    0x8(%ebp),%edx
  1006d3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006df:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006e5:	8b 40 08             	mov    0x8(%eax),%eax
  1006e8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006ef:	00 
  1006f0:	89 04 24             	mov    %eax,(%esp)
  1006f3:	e8 07 57 00 00       	call   105dff <strfind>
  1006f8:	89 c2                	mov    %eax,%edx
  1006fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006fd:	8b 40 08             	mov    0x8(%eax),%eax
  100700:	29 c2                	sub    %eax,%edx
  100702:	8b 45 0c             	mov    0xc(%ebp),%eax
  100705:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100708:	8b 45 08             	mov    0x8(%ebp),%eax
  10070b:	89 44 24 10          	mov    %eax,0x10(%esp)
  10070f:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100716:	00 
  100717:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10071a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100721:	89 44 24 04          	mov    %eax,0x4(%esp)
  100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100728:	89 04 24             	mov    %eax,(%esp)
  10072b:	e8 b9 fc ff ff       	call   1003e9 <stab_binsearch>
    if (lline <= rline) {
  100730:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100733:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100736:	39 c2                	cmp    %eax,%edx
  100738:	7f 24                	jg     10075e <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10073a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10073d:	89 c2                	mov    %eax,%edx
  10073f:	89 d0                	mov    %edx,%eax
  100741:	01 c0                	add    %eax,%eax
  100743:	01 d0                	add    %edx,%eax
  100745:	c1 e0 02             	shl    $0x2,%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074d:	01 d0                	add    %edx,%eax
  10074f:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100753:	0f b7 d0             	movzwl %ax,%edx
  100756:	8b 45 0c             	mov    0xc(%ebp),%eax
  100759:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10075c:	eb 13                	jmp    100771 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  10075e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100763:	e9 12 01 00 00       	jmp    10087a <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100768:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10076b:	83 e8 01             	sub    $0x1,%eax
  10076e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100771:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100774:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100777:	39 c2                	cmp    %eax,%edx
  100779:	7c 56                	jl     1007d1 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10077b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10077e:	89 c2                	mov    %eax,%edx
  100780:	89 d0                	mov    %edx,%eax
  100782:	01 c0                	add    %eax,%eax
  100784:	01 d0                	add    %edx,%eax
  100786:	c1 e0 02             	shl    $0x2,%eax
  100789:	89 c2                	mov    %eax,%edx
  10078b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10078e:	01 d0                	add    %edx,%eax
  100790:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100794:	3c 84                	cmp    $0x84,%al
  100796:	74 39                	je     1007d1 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10079b:	89 c2                	mov    %eax,%edx
  10079d:	89 d0                	mov    %edx,%eax
  10079f:	01 c0                	add    %eax,%eax
  1007a1:	01 d0                	add    %edx,%eax
  1007a3:	c1 e0 02             	shl    $0x2,%eax
  1007a6:	89 c2                	mov    %eax,%edx
  1007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ab:	01 d0                	add    %edx,%eax
  1007ad:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007b1:	3c 64                	cmp    $0x64,%al
  1007b3:	75 b3                	jne    100768 <debuginfo_eip+0x229>
  1007b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b8:	89 c2                	mov    %eax,%edx
  1007ba:	89 d0                	mov    %edx,%eax
  1007bc:	01 c0                	add    %eax,%eax
  1007be:	01 d0                	add    %edx,%eax
  1007c0:	c1 e0 02             	shl    $0x2,%eax
  1007c3:	89 c2                	mov    %eax,%edx
  1007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c8:	01 d0                	add    %edx,%eax
  1007ca:	8b 40 08             	mov    0x8(%eax),%eax
  1007cd:	85 c0                	test   %eax,%eax
  1007cf:	74 97                	je     100768 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007d1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007d7:	39 c2                	cmp    %eax,%edx
  1007d9:	7c 46                	jl     100821 <debuginfo_eip+0x2e2>
  1007db:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007de:	89 c2                	mov    %eax,%edx
  1007e0:	89 d0                	mov    %edx,%eax
  1007e2:	01 c0                	add    %eax,%eax
  1007e4:	01 d0                	add    %edx,%eax
  1007e6:	c1 e0 02             	shl    $0x2,%eax
  1007e9:	89 c2                	mov    %eax,%edx
  1007eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ee:	01 d0                	add    %edx,%eax
  1007f0:	8b 10                	mov    (%eax),%edx
  1007f2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f8:	29 c1                	sub    %eax,%ecx
  1007fa:	89 c8                	mov    %ecx,%eax
  1007fc:	39 c2                	cmp    %eax,%edx
  1007fe:	73 21                	jae    100821 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100800:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100803:	89 c2                	mov    %eax,%edx
  100805:	89 d0                	mov    %edx,%eax
  100807:	01 c0                	add    %eax,%eax
  100809:	01 d0                	add    %edx,%eax
  10080b:	c1 e0 02             	shl    $0x2,%eax
  10080e:	89 c2                	mov    %eax,%edx
  100810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100813:	01 d0                	add    %edx,%eax
  100815:	8b 10                	mov    (%eax),%edx
  100817:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10081a:	01 c2                	add    %eax,%edx
  10081c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081f:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100821:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100824:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100827:	39 c2                	cmp    %eax,%edx
  100829:	7d 4a                	jge    100875 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10082b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10082e:	83 c0 01             	add    $0x1,%eax
  100831:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100834:	eb 18                	jmp    10084e <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100836:	8b 45 0c             	mov    0xc(%ebp),%eax
  100839:	8b 40 14             	mov    0x14(%eax),%eax
  10083c:	8d 50 01             	lea    0x1(%eax),%edx
  10083f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100842:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100845:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100848:	83 c0 01             	add    $0x1,%eax
  10084b:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100851:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100854:	39 c2                	cmp    %eax,%edx
  100856:	7d 1d                	jge    100875 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085b:	89 c2                	mov    %eax,%edx
  10085d:	89 d0                	mov    %edx,%eax
  10085f:	01 c0                	add    %eax,%eax
  100861:	01 d0                	add    %edx,%eax
  100863:	c1 e0 02             	shl    $0x2,%eax
  100866:	89 c2                	mov    %eax,%edx
  100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086b:	01 d0                	add    %edx,%eax
  10086d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100871:	3c a0                	cmp    $0xa0,%al
  100873:	74 c1                	je     100836 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100875:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10087a:	c9                   	leave  
  10087b:	c3                   	ret    

0010087c <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10087c:	55                   	push   %ebp
  10087d:	89 e5                	mov    %esp,%ebp
  10087f:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100882:	c7 04 24 d6 61 10 00 	movl   $0x1061d6,(%esp)
  100889:	e8 ba fa ff ff       	call   100348 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10088e:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100895:	00 
  100896:	c7 04 24 ef 61 10 00 	movl   $0x1061ef,(%esp)
  10089d:	e8 a6 fa ff ff       	call   100348 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1008a2:	c7 44 24 04 14 61 10 	movl   $0x106114,0x4(%esp)
  1008a9:	00 
  1008aa:	c7 04 24 07 62 10 00 	movl   $0x106207,(%esp)
  1008b1:	e8 92 fa ff ff       	call   100348 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008b6:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008bd:	00 
  1008be:	c7 04 24 1f 62 10 00 	movl   $0x10621f,(%esp)
  1008c5:	e8 7e fa ff ff       	call   100348 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008ca:	c7 44 24 04 e4 af 11 	movl   $0x11afe4,0x4(%esp)
  1008d1:	00 
  1008d2:	c7 04 24 37 62 10 00 	movl   $0x106237,(%esp)
  1008d9:	e8 6a fa ff ff       	call   100348 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008de:	b8 e4 af 11 00       	mov    $0x11afe4,%eax
  1008e3:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008e9:	b8 36 00 10 00       	mov    $0x100036,%eax
  1008ee:	29 c2                	sub    %eax,%edx
  1008f0:	89 d0                	mov    %edx,%eax
  1008f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008f8:	85 c0                	test   %eax,%eax
  1008fa:	0f 48 c2             	cmovs  %edx,%eax
  1008fd:	c1 f8 0a             	sar    $0xa,%eax
  100900:	89 44 24 04          	mov    %eax,0x4(%esp)
  100904:	c7 04 24 50 62 10 00 	movl   $0x106250,(%esp)
  10090b:	e8 38 fa ff ff       	call   100348 <cprintf>
}
  100910:	c9                   	leave  
  100911:	c3                   	ret    

00100912 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100912:	55                   	push   %ebp
  100913:	89 e5                	mov    %esp,%ebp
  100915:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10091b:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10091e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100922:	8b 45 08             	mov    0x8(%ebp),%eax
  100925:	89 04 24             	mov    %eax,(%esp)
  100928:	e8 12 fc ff ff       	call   10053f <debuginfo_eip>
  10092d:	85 c0                	test   %eax,%eax
  10092f:	74 15                	je     100946 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100931:	8b 45 08             	mov    0x8(%ebp),%eax
  100934:	89 44 24 04          	mov    %eax,0x4(%esp)
  100938:	c7 04 24 7a 62 10 00 	movl   $0x10627a,(%esp)
  10093f:	e8 04 fa ff ff       	call   100348 <cprintf>
  100944:	eb 6d                	jmp    1009b3 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100946:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10094d:	eb 1c                	jmp    10096b <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  10094f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100955:	01 d0                	add    %edx,%eax
  100957:	0f b6 00             	movzbl (%eax),%eax
  10095a:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100963:	01 ca                	add    %ecx,%edx
  100965:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100967:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10096b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10096e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100971:	7f dc                	jg     10094f <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100973:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10097c:	01 d0                	add    %edx,%eax
  10097e:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100981:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100984:	8b 55 08             	mov    0x8(%ebp),%edx
  100987:	89 d1                	mov    %edx,%ecx
  100989:	29 c1                	sub    %eax,%ecx
  10098b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10098e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100991:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100995:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10099b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  10099f:	89 54 24 08          	mov    %edx,0x8(%esp)
  1009a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009a7:	c7 04 24 96 62 10 00 	movl   $0x106296,(%esp)
  1009ae:	e8 95 f9 ff ff       	call   100348 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009b3:	c9                   	leave  
  1009b4:	c3                   	ret    

001009b5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009b5:	55                   	push   %ebp
  1009b6:	89 e5                	mov    %esp,%ebp
  1009b8:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009bb:	8b 45 04             	mov    0x4(%ebp),%eax
  1009be:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009c4:	c9                   	leave  
  1009c5:	c3                   	ret    

001009c6 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009c6:	55                   	push   %ebp
  1009c7:	89 e5                	mov    %esp,%ebp
  1009c9:	53                   	push   %ebx
  1009ca:	83 ec 54             	sub    $0x54,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009cd:	89 e8                	mov    %ebp,%eax
  1009cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  1009d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

    uint32_t ebp_val = read_ebp();
  1009d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip_val = read_eip();
  1009d8:	e8 d8 ff ff ff       	call   1009b5 <read_eip>
  1009dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i = 0;
  1009e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for(i = 0; i < STACKFRAME_DEPTH && ebp_val != 0; i++){
  1009e7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009ee:	e9 9d 00 00 00       	jmp    100a90 <print_stackframe+0xca>
        cprintf("ebp:0x%08x, eip:0x%08x", ebp_val, eip_val);  // 输出八位十六进制（即32位寄存器值）
  1009f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a01:	c7 04 24 a8 62 10 00 	movl   $0x1062a8,(%esp)
  100a08:	e8 3b f9 ff ff       	call   100348 <cprintf>
        uint32_t* ebp_ptr = (uint32_t*)ebp_val;
  100a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a10:	89 45 e8             	mov    %eax,-0x18(%ebp)
        uint32_t args[] = {*(ebp_ptr+2), *(ebp_ptr+3), *(ebp_ptr+4), *(ebp_ptr+5)};
  100a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a16:	8b 40 08             	mov    0x8(%eax),%eax
  100a19:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100a1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a1f:	8b 40 0c             	mov    0xc(%eax),%eax
  100a22:	89 45 d8             	mov    %eax,-0x28(%ebp)
  100a25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a28:	8b 40 10             	mov    0x10(%eax),%eax
  100a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100a2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a31:	8b 40 14             	mov    0x14(%eax),%eax
  100a34:	89 45 e0             	mov    %eax,-0x20(%ebp)
        cprintf(" args:0x%08x 0x%08x 0x%08x 0x%08x", args[0], args[1], args[2], args[3]);
  100a37:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  100a3a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  100a3d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  100a40:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100a43:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100a47:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a4b:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a53:	c7 04 24 c0 62 10 00 	movl   $0x1062c0,(%esp)
  100a5a:	e8 e9 f8 ff ff       	call   100348 <cprintf>
        cprintf("\n");
  100a5f:	c7 04 24 e2 62 10 00 	movl   $0x1062e2,(%esp)
  100a66:	e8 dd f8 ff ff       	call   100348 <cprintf>
        print_debuginfo(eip_val - 1);
  100a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a6e:	83 e8 01             	sub    $0x1,%eax
  100a71:	89 04 24             	mov    %eax,(%esp)
  100a74:	e8 99 fe ff ff       	call   100912 <print_debuginfo>
        eip_val = *(uint32_t*)(ebp_val + 4);
  100a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a7c:	83 c0 04             	add    $0x4,%eax
  100a7f:	8b 00                	mov    (%eax),%eax
  100a81:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp_val = *(uint32_t*)ebp_val;
  100a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a87:	8b 00                	mov    (%eax),%eax
  100a89:	89 45 f4             	mov    %eax,-0xc(%ebp)
      */

    uint32_t ebp_val = read_ebp();
    uint32_t eip_val = read_eip();
    int i = 0;
    for(i = 0; i < STACKFRAME_DEPTH && ebp_val != 0; i++){
  100a8c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a90:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a94:	7f 0a                	jg     100aa0 <print_stackframe+0xda>
  100a96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a9a:	0f 85 53 ff ff ff    	jne    1009f3 <print_stackframe+0x2d>
        cprintf("\n");
        print_debuginfo(eip_val - 1);
        eip_val = *(uint32_t*)(ebp_val + 4);
        ebp_val = *(uint32_t*)ebp_val;
    }
}
  100aa0:	83 c4 54             	add    $0x54,%esp
  100aa3:	5b                   	pop    %ebx
  100aa4:	5d                   	pop    %ebp
  100aa5:	c3                   	ret    

00100aa6 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100aa6:	55                   	push   %ebp
  100aa7:	89 e5                	mov    %esp,%ebp
  100aa9:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100aac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ab3:	eb 0c                	jmp    100ac1 <parse+0x1b>
            *buf ++ = '\0';
  100ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ab8:	8d 50 01             	lea    0x1(%eax),%edx
  100abb:	89 55 08             	mov    %edx,0x8(%ebp)
  100abe:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac4:	0f b6 00             	movzbl (%eax),%eax
  100ac7:	84 c0                	test   %al,%al
  100ac9:	74 1d                	je     100ae8 <parse+0x42>
  100acb:	8b 45 08             	mov    0x8(%ebp),%eax
  100ace:	0f b6 00             	movzbl (%eax),%eax
  100ad1:	0f be c0             	movsbl %al,%eax
  100ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ad8:	c7 04 24 64 63 10 00 	movl   $0x106364,(%esp)
  100adf:	e8 e8 52 00 00       	call   105dcc <strchr>
  100ae4:	85 c0                	test   %eax,%eax
  100ae6:	75 cd                	jne    100ab5 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  100aeb:	0f b6 00             	movzbl (%eax),%eax
  100aee:	84 c0                	test   %al,%al
  100af0:	75 02                	jne    100af4 <parse+0x4e>
            break;
  100af2:	eb 67                	jmp    100b5b <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100af4:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100af8:	75 14                	jne    100b0e <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100afa:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b01:	00 
  100b02:	c7 04 24 69 63 10 00 	movl   $0x106369,(%esp)
  100b09:	e8 3a f8 ff ff       	call   100348 <cprintf>
        }
        argv[argc ++] = buf;
  100b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b11:	8d 50 01             	lea    0x1(%eax),%edx
  100b14:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b17:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b21:	01 c2                	add    %eax,%edx
  100b23:	8b 45 08             	mov    0x8(%ebp),%eax
  100b26:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b28:	eb 04                	jmp    100b2e <parse+0x88>
            buf ++;
  100b2a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b31:	0f b6 00             	movzbl (%eax),%eax
  100b34:	84 c0                	test   %al,%al
  100b36:	74 1d                	je     100b55 <parse+0xaf>
  100b38:	8b 45 08             	mov    0x8(%ebp),%eax
  100b3b:	0f b6 00             	movzbl (%eax),%eax
  100b3e:	0f be c0             	movsbl %al,%eax
  100b41:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b45:	c7 04 24 64 63 10 00 	movl   $0x106364,(%esp)
  100b4c:	e8 7b 52 00 00       	call   105dcc <strchr>
  100b51:	85 c0                	test   %eax,%eax
  100b53:	74 d5                	je     100b2a <parse+0x84>
            buf ++;
        }
    }
  100b55:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b56:	e9 66 ff ff ff       	jmp    100ac1 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b5e:	c9                   	leave  
  100b5f:	c3                   	ret    

00100b60 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b60:	55                   	push   %ebp
  100b61:	89 e5                	mov    %esp,%ebp
  100b63:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b66:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b69:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b70:	89 04 24             	mov    %eax,(%esp)
  100b73:	e8 2e ff ff ff       	call   100aa6 <parse>
  100b78:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b7f:	75 0a                	jne    100b8b <runcmd+0x2b>
        return 0;
  100b81:	b8 00 00 00 00       	mov    $0x0,%eax
  100b86:	e9 85 00 00 00       	jmp    100c10 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b92:	eb 5c                	jmp    100bf0 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b94:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b9a:	89 d0                	mov    %edx,%eax
  100b9c:	01 c0                	add    %eax,%eax
  100b9e:	01 d0                	add    %edx,%eax
  100ba0:	c1 e0 02             	shl    $0x2,%eax
  100ba3:	05 00 70 11 00       	add    $0x117000,%eax
  100ba8:	8b 00                	mov    (%eax),%eax
  100baa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100bae:	89 04 24             	mov    %eax,(%esp)
  100bb1:	e8 77 51 00 00       	call   105d2d <strcmp>
  100bb6:	85 c0                	test   %eax,%eax
  100bb8:	75 32                	jne    100bec <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bbd:	89 d0                	mov    %edx,%eax
  100bbf:	01 c0                	add    %eax,%eax
  100bc1:	01 d0                	add    %edx,%eax
  100bc3:	c1 e0 02             	shl    $0x2,%eax
  100bc6:	05 00 70 11 00       	add    $0x117000,%eax
  100bcb:	8b 40 08             	mov    0x8(%eax),%eax
  100bce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100bd1:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bd7:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bdb:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bde:	83 c2 04             	add    $0x4,%edx
  100be1:	89 54 24 04          	mov    %edx,0x4(%esp)
  100be5:	89 0c 24             	mov    %ecx,(%esp)
  100be8:	ff d0                	call   *%eax
  100bea:	eb 24                	jmp    100c10 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bf3:	83 f8 02             	cmp    $0x2,%eax
  100bf6:	76 9c                	jbe    100b94 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bf8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bff:	c7 04 24 87 63 10 00 	movl   $0x106387,(%esp)
  100c06:	e8 3d f7 ff ff       	call   100348 <cprintf>
    return 0;
  100c0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c10:	c9                   	leave  
  100c11:	c3                   	ret    

00100c12 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c12:	55                   	push   %ebp
  100c13:	89 e5                	mov    %esp,%ebp
  100c15:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c18:	c7 04 24 a0 63 10 00 	movl   $0x1063a0,(%esp)
  100c1f:	e8 24 f7 ff ff       	call   100348 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c24:	c7 04 24 c8 63 10 00 	movl   $0x1063c8,(%esp)
  100c2b:	e8 18 f7 ff ff       	call   100348 <cprintf>

    if (tf != NULL) {
  100c30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c34:	74 0b                	je     100c41 <kmonitor+0x2f>
        print_trapframe(tf);
  100c36:	8b 45 08             	mov    0x8(%ebp),%eax
  100c39:	89 04 24             	mov    %eax,(%esp)
  100c3c:	e8 c6 0e 00 00       	call   101b07 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c41:	c7 04 24 ed 63 10 00 	movl   $0x1063ed,(%esp)
  100c48:	e8 f2 f5 ff ff       	call   10023f <readline>
  100c4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c54:	74 18                	je     100c6e <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c56:	8b 45 08             	mov    0x8(%ebp),%eax
  100c59:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c60:	89 04 24             	mov    %eax,(%esp)
  100c63:	e8 f8 fe ff ff       	call   100b60 <runcmd>
  100c68:	85 c0                	test   %eax,%eax
  100c6a:	79 02                	jns    100c6e <kmonitor+0x5c>
                break;
  100c6c:	eb 02                	jmp    100c70 <kmonitor+0x5e>
            }
        }
    }
  100c6e:	eb d1                	jmp    100c41 <kmonitor+0x2f>
}
  100c70:	c9                   	leave  
  100c71:	c3                   	ret    

00100c72 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c72:	55                   	push   %ebp
  100c73:	89 e5                	mov    %esp,%ebp
  100c75:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c7f:	eb 3f                	jmp    100cc0 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c81:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c84:	89 d0                	mov    %edx,%eax
  100c86:	01 c0                	add    %eax,%eax
  100c88:	01 d0                	add    %edx,%eax
  100c8a:	c1 e0 02             	shl    $0x2,%eax
  100c8d:	05 00 70 11 00       	add    $0x117000,%eax
  100c92:	8b 48 04             	mov    0x4(%eax),%ecx
  100c95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c98:	89 d0                	mov    %edx,%eax
  100c9a:	01 c0                	add    %eax,%eax
  100c9c:	01 d0                	add    %edx,%eax
  100c9e:	c1 e0 02             	shl    $0x2,%eax
  100ca1:	05 00 70 11 00       	add    $0x117000,%eax
  100ca6:	8b 00                	mov    (%eax),%eax
  100ca8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100cac:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cb0:	c7 04 24 f1 63 10 00 	movl   $0x1063f1,(%esp)
  100cb7:	e8 8c f6 ff ff       	call   100348 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cbc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cc3:	83 f8 02             	cmp    $0x2,%eax
  100cc6:	76 b9                	jbe    100c81 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100cc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ccd:	c9                   	leave  
  100cce:	c3                   	ret    

00100ccf <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ccf:	55                   	push   %ebp
  100cd0:	89 e5                	mov    %esp,%ebp
  100cd2:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100cd5:	e8 a2 fb ff ff       	call   10087c <print_kerninfo>
    return 0;
  100cda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cdf:	c9                   	leave  
  100ce0:	c3                   	ret    

00100ce1 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100ce1:	55                   	push   %ebp
  100ce2:	89 e5                	mov    %esp,%ebp
  100ce4:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100ce7:	e8 da fc ff ff       	call   1009c6 <print_stackframe>
    return 0;
  100cec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cf1:	c9                   	leave  
  100cf2:	c3                   	ret    

00100cf3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cf3:	55                   	push   %ebp
  100cf4:	89 e5                	mov    %esp,%ebp
  100cf6:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cf9:	a1 20 a4 11 00       	mov    0x11a420,%eax
  100cfe:	85 c0                	test   %eax,%eax
  100d00:	74 02                	je     100d04 <__panic+0x11>
        goto panic_dead;
  100d02:	eb 59                	jmp    100d5d <__panic+0x6a>
    }
    is_panic = 1;
  100d04:	c7 05 20 a4 11 00 01 	movl   $0x1,0x11a420
  100d0b:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100d0e:	8d 45 14             	lea    0x14(%ebp),%eax
  100d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100d14:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d17:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  100d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d22:	c7 04 24 fa 63 10 00 	movl   $0x1063fa,(%esp)
  100d29:	e8 1a f6 ff ff       	call   100348 <cprintf>
    vcprintf(fmt, ap);
  100d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d31:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d35:	8b 45 10             	mov    0x10(%ebp),%eax
  100d38:	89 04 24             	mov    %eax,(%esp)
  100d3b:	e8 d5 f5 ff ff       	call   100315 <vcprintf>
    cprintf("\n");
  100d40:	c7 04 24 16 64 10 00 	movl   $0x106416,(%esp)
  100d47:	e8 fc f5 ff ff       	call   100348 <cprintf>
    
    cprintf("stack trackback:\n");
  100d4c:	c7 04 24 18 64 10 00 	movl   $0x106418,(%esp)
  100d53:	e8 f0 f5 ff ff       	call   100348 <cprintf>
    print_stackframe();
  100d58:	e8 69 fc ff ff       	call   1009c6 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d5d:	e8 85 09 00 00       	call   1016e7 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d69:	e8 a4 fe ff ff       	call   100c12 <kmonitor>
    }
  100d6e:	eb f2                	jmp    100d62 <__panic+0x6f>

00100d70 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d70:	55                   	push   %ebp
  100d71:	89 e5                	mov    %esp,%ebp
  100d73:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d76:	8d 45 14             	lea    0x14(%ebp),%eax
  100d79:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d7f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d83:	8b 45 08             	mov    0x8(%ebp),%eax
  100d86:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d8a:	c7 04 24 2a 64 10 00 	movl   $0x10642a,(%esp)
  100d91:	e8 b2 f5 ff ff       	call   100348 <cprintf>
    vcprintf(fmt, ap);
  100d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d99:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d9d:	8b 45 10             	mov    0x10(%ebp),%eax
  100da0:	89 04 24             	mov    %eax,(%esp)
  100da3:	e8 6d f5 ff ff       	call   100315 <vcprintf>
    cprintf("\n");
  100da8:	c7 04 24 16 64 10 00 	movl   $0x106416,(%esp)
  100daf:	e8 94 f5 ff ff       	call   100348 <cprintf>
    va_end(ap);
}
  100db4:	c9                   	leave  
  100db5:	c3                   	ret    

00100db6 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100db6:	55                   	push   %ebp
  100db7:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100db9:	a1 20 a4 11 00       	mov    0x11a420,%eax
}
  100dbe:	5d                   	pop    %ebp
  100dbf:	c3                   	ret    

00100dc0 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dc0:	55                   	push   %ebp
  100dc1:	89 e5                	mov    %esp,%ebp
  100dc3:	83 ec 28             	sub    $0x28,%esp
  100dc6:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100dcc:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100dd0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dd4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dd8:	ee                   	out    %al,(%dx)
  100dd9:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100ddf:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100de3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100de7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100deb:	ee                   	out    %al,(%dx)
  100dec:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100df2:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100df6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dfa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dfe:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dff:	c7 05 0c af 11 00 00 	movl   $0x0,0x11af0c
  100e06:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e09:	c7 04 24 48 64 10 00 	movl   $0x106448,(%esp)
  100e10:	e8 33 f5 ff ff       	call   100348 <cprintf>
    pic_enable(IRQ_TIMER);
  100e15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e1c:	e8 24 09 00 00       	call   101745 <pic_enable>
}
  100e21:	c9                   	leave  
  100e22:	c3                   	ret    

00100e23 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e23:	55                   	push   %ebp
  100e24:	89 e5                	mov    %esp,%ebp
  100e26:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e29:	9c                   	pushf  
  100e2a:	58                   	pop    %eax
  100e2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e31:	25 00 02 00 00       	and    $0x200,%eax
  100e36:	85 c0                	test   %eax,%eax
  100e38:	74 0c                	je     100e46 <__intr_save+0x23>
        intr_disable();
  100e3a:	e8 a8 08 00 00       	call   1016e7 <intr_disable>
        return 1;
  100e3f:	b8 01 00 00 00       	mov    $0x1,%eax
  100e44:	eb 05                	jmp    100e4b <__intr_save+0x28>
    }
    return 0;
  100e46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e4b:	c9                   	leave  
  100e4c:	c3                   	ret    

00100e4d <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e4d:	55                   	push   %ebp
  100e4e:	89 e5                	mov    %esp,%ebp
  100e50:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e57:	74 05                	je     100e5e <__intr_restore+0x11>
        intr_enable();
  100e59:	e8 83 08 00 00       	call   1016e1 <intr_enable>
    }
}
  100e5e:	c9                   	leave  
  100e5f:	c3                   	ret    

00100e60 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e60:	55                   	push   %ebp
  100e61:	89 e5                	mov    %esp,%ebp
  100e63:	83 ec 10             	sub    $0x10,%esp
  100e66:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e6c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e70:	89 c2                	mov    %eax,%edx
  100e72:	ec                   	in     (%dx),%al
  100e73:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e76:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e7c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e80:	89 c2                	mov    %eax,%edx
  100e82:	ec                   	in     (%dx),%al
  100e83:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e86:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e8c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e90:	89 c2                	mov    %eax,%edx
  100e92:	ec                   	in     (%dx),%al
  100e93:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e96:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e9c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ea0:	89 c2                	mov    %eax,%edx
  100ea2:	ec                   	in     (%dx),%al
  100ea3:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100ea6:	c9                   	leave  
  100ea7:	c3                   	ret    

00100ea8 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100ea8:	55                   	push   %ebp
  100ea9:	89 e5                	mov    %esp,%ebp
  100eab:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100eae:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100eb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb8:	0f b7 00             	movzwl (%eax),%eax
  100ebb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100ebf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ec2:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100ec7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eca:	0f b7 00             	movzwl (%eax),%eax
  100ecd:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100ed1:	74 12                	je     100ee5 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ed3:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100eda:	66 c7 05 46 a4 11 00 	movw   $0x3b4,0x11a446
  100ee1:	b4 03 
  100ee3:	eb 13                	jmp    100ef8 <cga_init+0x50>
    } else {
        *cp = was;
  100ee5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ee8:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eec:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eef:	66 c7 05 46 a4 11 00 	movw   $0x3d4,0x11a446
  100ef6:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ef8:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100eff:	0f b7 c0             	movzwl %ax,%eax
  100f02:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100f06:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f0a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f0e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f12:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100f13:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f1a:	83 c0 01             	add    $0x1,%eax
  100f1d:	0f b7 c0             	movzwl %ax,%eax
  100f20:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f24:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f28:	89 c2                	mov    %eax,%edx
  100f2a:	ec                   	in     (%dx),%al
  100f2b:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f2e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f32:	0f b6 c0             	movzbl %al,%eax
  100f35:	c1 e0 08             	shl    $0x8,%eax
  100f38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f3b:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f42:	0f b7 c0             	movzwl %ax,%eax
  100f45:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f49:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f4d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f51:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f55:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f56:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f5d:	83 c0 01             	add    $0x1,%eax
  100f60:	0f b7 c0             	movzwl %ax,%eax
  100f63:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f67:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f6b:	89 c2                	mov    %eax,%edx
  100f6d:	ec                   	in     (%dx),%al
  100f6e:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f71:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f75:	0f b6 c0             	movzbl %al,%eax
  100f78:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f7e:	a3 40 a4 11 00       	mov    %eax,0x11a440
    crt_pos = pos;
  100f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f86:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
}
  100f8c:	c9                   	leave  
  100f8d:	c3                   	ret    

00100f8e <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f8e:	55                   	push   %ebp
  100f8f:	89 e5                	mov    %esp,%ebp
  100f91:	83 ec 48             	sub    $0x48,%esp
  100f94:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f9a:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f9e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100fa2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100fa6:	ee                   	out    %al,(%dx)
  100fa7:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100fad:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100fb1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fb5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100fb9:	ee                   	out    %al,(%dx)
  100fba:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100fc0:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100fc4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100fc8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fcc:	ee                   	out    %al,(%dx)
  100fcd:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fd3:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fd7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fdb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fdf:	ee                   	out    %al,(%dx)
  100fe0:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fe6:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fea:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fee:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ff2:	ee                   	out    %al,(%dx)
  100ff3:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100ff9:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100ffd:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101001:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101005:	ee                   	out    %al,(%dx)
  101006:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  10100c:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  101010:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101014:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101018:	ee                   	out    %al,(%dx)
  101019:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10101f:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  101023:	89 c2                	mov    %eax,%edx
  101025:	ec                   	in     (%dx),%al
  101026:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  101029:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10102d:	3c ff                	cmp    $0xff,%al
  10102f:	0f 95 c0             	setne  %al
  101032:	0f b6 c0             	movzbl %al,%eax
  101035:	a3 48 a4 11 00       	mov    %eax,0x11a448
  10103a:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101040:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101044:	89 c2                	mov    %eax,%edx
  101046:	ec                   	in     (%dx),%al
  101047:	88 45 d5             	mov    %al,-0x2b(%ebp)
  10104a:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101050:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101054:	89 c2                	mov    %eax,%edx
  101056:	ec                   	in     (%dx),%al
  101057:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10105a:	a1 48 a4 11 00       	mov    0x11a448,%eax
  10105f:	85 c0                	test   %eax,%eax
  101061:	74 0c                	je     10106f <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101063:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10106a:	e8 d6 06 00 00       	call   101745 <pic_enable>
    }
}
  10106f:	c9                   	leave  
  101070:	c3                   	ret    

00101071 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101071:	55                   	push   %ebp
  101072:	89 e5                	mov    %esp,%ebp
  101074:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101077:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10107e:	eb 09                	jmp    101089 <lpt_putc_sub+0x18>
        delay();
  101080:	e8 db fd ff ff       	call   100e60 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101085:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101089:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10108f:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101093:	89 c2                	mov    %eax,%edx
  101095:	ec                   	in     (%dx),%al
  101096:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101099:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10109d:	84 c0                	test   %al,%al
  10109f:	78 09                	js     1010aa <lpt_putc_sub+0x39>
  1010a1:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010a8:	7e d6                	jle    101080 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  1010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ad:	0f b6 c0             	movzbl %al,%eax
  1010b0:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  1010b6:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010b9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010bd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010c1:	ee                   	out    %al,(%dx)
  1010c2:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010c8:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  1010cc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010d0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010d4:	ee                   	out    %al,(%dx)
  1010d5:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010db:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010df:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010e3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010e7:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010e8:	c9                   	leave  
  1010e9:	c3                   	ret    

001010ea <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010ea:	55                   	push   %ebp
  1010eb:	89 e5                	mov    %esp,%ebp
  1010ed:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010f0:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010f4:	74 0d                	je     101103 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f9:	89 04 24             	mov    %eax,(%esp)
  1010fc:	e8 70 ff ff ff       	call   101071 <lpt_putc_sub>
  101101:	eb 24                	jmp    101127 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101103:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10110a:	e8 62 ff ff ff       	call   101071 <lpt_putc_sub>
        lpt_putc_sub(' ');
  10110f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101116:	e8 56 ff ff ff       	call   101071 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10111b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101122:	e8 4a ff ff ff       	call   101071 <lpt_putc_sub>
    }
}
  101127:	c9                   	leave  
  101128:	c3                   	ret    

00101129 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101129:	55                   	push   %ebp
  10112a:	89 e5                	mov    %esp,%ebp
  10112c:	53                   	push   %ebx
  10112d:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101130:	8b 45 08             	mov    0x8(%ebp),%eax
  101133:	b0 00                	mov    $0x0,%al
  101135:	85 c0                	test   %eax,%eax
  101137:	75 07                	jne    101140 <cga_putc+0x17>
        c |= 0x0700;
  101139:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101140:	8b 45 08             	mov    0x8(%ebp),%eax
  101143:	0f b6 c0             	movzbl %al,%eax
  101146:	83 f8 0a             	cmp    $0xa,%eax
  101149:	74 4c                	je     101197 <cga_putc+0x6e>
  10114b:	83 f8 0d             	cmp    $0xd,%eax
  10114e:	74 57                	je     1011a7 <cga_putc+0x7e>
  101150:	83 f8 08             	cmp    $0x8,%eax
  101153:	0f 85 88 00 00 00    	jne    1011e1 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101159:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101160:	66 85 c0             	test   %ax,%ax
  101163:	74 30                	je     101195 <cga_putc+0x6c>
            crt_pos --;
  101165:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10116c:	83 e8 01             	sub    $0x1,%eax
  10116f:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101175:	a1 40 a4 11 00       	mov    0x11a440,%eax
  10117a:	0f b7 15 44 a4 11 00 	movzwl 0x11a444,%edx
  101181:	0f b7 d2             	movzwl %dx,%edx
  101184:	01 d2                	add    %edx,%edx
  101186:	01 c2                	add    %eax,%edx
  101188:	8b 45 08             	mov    0x8(%ebp),%eax
  10118b:	b0 00                	mov    $0x0,%al
  10118d:	83 c8 20             	or     $0x20,%eax
  101190:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101193:	eb 72                	jmp    101207 <cga_putc+0xde>
  101195:	eb 70                	jmp    101207 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101197:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10119e:	83 c0 50             	add    $0x50,%eax
  1011a1:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011a7:	0f b7 1d 44 a4 11 00 	movzwl 0x11a444,%ebx
  1011ae:	0f b7 0d 44 a4 11 00 	movzwl 0x11a444,%ecx
  1011b5:	0f b7 c1             	movzwl %cx,%eax
  1011b8:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1011be:	c1 e8 10             	shr    $0x10,%eax
  1011c1:	89 c2                	mov    %eax,%edx
  1011c3:	66 c1 ea 06          	shr    $0x6,%dx
  1011c7:	89 d0                	mov    %edx,%eax
  1011c9:	c1 e0 02             	shl    $0x2,%eax
  1011cc:	01 d0                	add    %edx,%eax
  1011ce:	c1 e0 04             	shl    $0x4,%eax
  1011d1:	29 c1                	sub    %eax,%ecx
  1011d3:	89 ca                	mov    %ecx,%edx
  1011d5:	89 d8                	mov    %ebx,%eax
  1011d7:	29 d0                	sub    %edx,%eax
  1011d9:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
        break;
  1011df:	eb 26                	jmp    101207 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011e1:	8b 0d 40 a4 11 00    	mov    0x11a440,%ecx
  1011e7:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011ee:	8d 50 01             	lea    0x1(%eax),%edx
  1011f1:	66 89 15 44 a4 11 00 	mov    %dx,0x11a444
  1011f8:	0f b7 c0             	movzwl %ax,%eax
  1011fb:	01 c0                	add    %eax,%eax
  1011fd:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101200:	8b 45 08             	mov    0x8(%ebp),%eax
  101203:	66 89 02             	mov    %ax,(%edx)
        break;
  101206:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101207:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10120e:	66 3d cf 07          	cmp    $0x7cf,%ax
  101212:	76 5b                	jbe    10126f <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101214:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101219:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10121f:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101224:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10122b:	00 
  10122c:	89 54 24 04          	mov    %edx,0x4(%esp)
  101230:	89 04 24             	mov    %eax,(%esp)
  101233:	e8 92 4d 00 00       	call   105fca <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101238:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10123f:	eb 15                	jmp    101256 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101241:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101246:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101249:	01 d2                	add    %edx,%edx
  10124b:	01 d0                	add    %edx,%eax
  10124d:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101252:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101256:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10125d:	7e e2                	jle    101241 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10125f:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101266:	83 e8 50             	sub    $0x50,%eax
  101269:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10126f:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  101276:	0f b7 c0             	movzwl %ax,%eax
  101279:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10127d:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101281:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101285:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101289:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10128a:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101291:	66 c1 e8 08          	shr    $0x8,%ax
  101295:	0f b6 c0             	movzbl %al,%eax
  101298:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  10129f:	83 c2 01             	add    $0x1,%edx
  1012a2:	0f b7 d2             	movzwl %dx,%edx
  1012a5:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1012a9:	88 45 ed             	mov    %al,-0x13(%ebp)
  1012ac:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012b0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012b4:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1012b5:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  1012bc:	0f b7 c0             	movzwl %ax,%eax
  1012bf:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1012c3:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  1012c7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012cb:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012cf:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012d0:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1012d7:	0f b6 c0             	movzbl %al,%eax
  1012da:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  1012e1:	83 c2 01             	add    $0x1,%edx
  1012e4:	0f b7 d2             	movzwl %dx,%edx
  1012e7:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012eb:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012ee:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012f2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012f6:	ee                   	out    %al,(%dx)
}
  1012f7:	83 c4 34             	add    $0x34,%esp
  1012fa:	5b                   	pop    %ebx
  1012fb:	5d                   	pop    %ebp
  1012fc:	c3                   	ret    

001012fd <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012fd:	55                   	push   %ebp
  1012fe:	89 e5                	mov    %esp,%ebp
  101300:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101303:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10130a:	eb 09                	jmp    101315 <serial_putc_sub+0x18>
        delay();
  10130c:	e8 4f fb ff ff       	call   100e60 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101311:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101315:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10131b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10131f:	89 c2                	mov    %eax,%edx
  101321:	ec                   	in     (%dx),%al
  101322:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101325:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101329:	0f b6 c0             	movzbl %al,%eax
  10132c:	83 e0 20             	and    $0x20,%eax
  10132f:	85 c0                	test   %eax,%eax
  101331:	75 09                	jne    10133c <serial_putc_sub+0x3f>
  101333:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10133a:	7e d0                	jle    10130c <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  10133c:	8b 45 08             	mov    0x8(%ebp),%eax
  10133f:	0f b6 c0             	movzbl %al,%eax
  101342:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101348:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10134b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10134f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101353:	ee                   	out    %al,(%dx)
}
  101354:	c9                   	leave  
  101355:	c3                   	ret    

00101356 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101356:	55                   	push   %ebp
  101357:	89 e5                	mov    %esp,%ebp
  101359:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10135c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101360:	74 0d                	je     10136f <serial_putc+0x19>
        serial_putc_sub(c);
  101362:	8b 45 08             	mov    0x8(%ebp),%eax
  101365:	89 04 24             	mov    %eax,(%esp)
  101368:	e8 90 ff ff ff       	call   1012fd <serial_putc_sub>
  10136d:	eb 24                	jmp    101393 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  10136f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101376:	e8 82 ff ff ff       	call   1012fd <serial_putc_sub>
        serial_putc_sub(' ');
  10137b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101382:	e8 76 ff ff ff       	call   1012fd <serial_putc_sub>
        serial_putc_sub('\b');
  101387:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10138e:	e8 6a ff ff ff       	call   1012fd <serial_putc_sub>
    }
}
  101393:	c9                   	leave  
  101394:	c3                   	ret    

00101395 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101395:	55                   	push   %ebp
  101396:	89 e5                	mov    %esp,%ebp
  101398:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10139b:	eb 33                	jmp    1013d0 <cons_intr+0x3b>
        if (c != 0) {
  10139d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013a1:	74 2d                	je     1013d0 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1013a3:	a1 64 a6 11 00       	mov    0x11a664,%eax
  1013a8:	8d 50 01             	lea    0x1(%eax),%edx
  1013ab:	89 15 64 a6 11 00    	mov    %edx,0x11a664
  1013b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013b4:	88 90 60 a4 11 00    	mov    %dl,0x11a460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013ba:	a1 64 a6 11 00       	mov    0x11a664,%eax
  1013bf:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013c4:	75 0a                	jne    1013d0 <cons_intr+0x3b>
                cons.wpos = 0;
  1013c6:	c7 05 64 a6 11 00 00 	movl   $0x0,0x11a664
  1013cd:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1013d3:	ff d0                	call   *%eax
  1013d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013d8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013dc:	75 bf                	jne    10139d <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013de:	c9                   	leave  
  1013df:	c3                   	ret    

001013e0 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013e0:	55                   	push   %ebp
  1013e1:	89 e5                	mov    %esp,%ebp
  1013e3:	83 ec 10             	sub    $0x10,%esp
  1013e6:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013ec:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013f0:	89 c2                	mov    %eax,%edx
  1013f2:	ec                   	in     (%dx),%al
  1013f3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013f6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013fa:	0f b6 c0             	movzbl %al,%eax
  1013fd:	83 e0 01             	and    $0x1,%eax
  101400:	85 c0                	test   %eax,%eax
  101402:	75 07                	jne    10140b <serial_proc_data+0x2b>
        return -1;
  101404:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101409:	eb 2a                	jmp    101435 <serial_proc_data+0x55>
  10140b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101411:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101415:	89 c2                	mov    %eax,%edx
  101417:	ec                   	in     (%dx),%al
  101418:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10141b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10141f:	0f b6 c0             	movzbl %al,%eax
  101422:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101425:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101429:	75 07                	jne    101432 <serial_proc_data+0x52>
        c = '\b';
  10142b:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101432:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101435:	c9                   	leave  
  101436:	c3                   	ret    

00101437 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101437:	55                   	push   %ebp
  101438:	89 e5                	mov    %esp,%ebp
  10143a:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10143d:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101442:	85 c0                	test   %eax,%eax
  101444:	74 0c                	je     101452 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101446:	c7 04 24 e0 13 10 00 	movl   $0x1013e0,(%esp)
  10144d:	e8 43 ff ff ff       	call   101395 <cons_intr>
    }
}
  101452:	c9                   	leave  
  101453:	c3                   	ret    

00101454 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101454:	55                   	push   %ebp
  101455:	89 e5                	mov    %esp,%ebp
  101457:	83 ec 38             	sub    $0x38,%esp
  10145a:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101460:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101464:	89 c2                	mov    %eax,%edx
  101466:	ec                   	in     (%dx),%al
  101467:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10146a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10146e:	0f b6 c0             	movzbl %al,%eax
  101471:	83 e0 01             	and    $0x1,%eax
  101474:	85 c0                	test   %eax,%eax
  101476:	75 0a                	jne    101482 <kbd_proc_data+0x2e>
        return -1;
  101478:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10147d:	e9 59 01 00 00       	jmp    1015db <kbd_proc_data+0x187>
  101482:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101488:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10148c:	89 c2                	mov    %eax,%edx
  10148e:	ec                   	in     (%dx),%al
  10148f:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101492:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101496:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101499:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10149d:	75 17                	jne    1014b6 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10149f:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014a4:	83 c8 40             	or     $0x40,%eax
  1014a7:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  1014ac:	b8 00 00 00 00       	mov    $0x0,%eax
  1014b1:	e9 25 01 00 00       	jmp    1015db <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1014b6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ba:	84 c0                	test   %al,%al
  1014bc:	79 47                	jns    101505 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014be:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014c3:	83 e0 40             	and    $0x40,%eax
  1014c6:	85 c0                	test   %eax,%eax
  1014c8:	75 09                	jne    1014d3 <kbd_proc_data+0x7f>
  1014ca:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ce:	83 e0 7f             	and    $0x7f,%eax
  1014d1:	eb 04                	jmp    1014d7 <kbd_proc_data+0x83>
  1014d3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d7:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014da:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014de:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  1014e5:	83 c8 40             	or     $0x40,%eax
  1014e8:	0f b6 c0             	movzbl %al,%eax
  1014eb:	f7 d0                	not    %eax
  1014ed:	89 c2                	mov    %eax,%edx
  1014ef:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014f4:	21 d0                	and    %edx,%eax
  1014f6:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  1014fb:	b8 00 00 00 00       	mov    $0x0,%eax
  101500:	e9 d6 00 00 00       	jmp    1015db <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101505:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10150a:	83 e0 40             	and    $0x40,%eax
  10150d:	85 c0                	test   %eax,%eax
  10150f:	74 11                	je     101522 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101511:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101515:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10151a:	83 e0 bf             	and    $0xffffffbf,%eax
  10151d:	a3 68 a6 11 00       	mov    %eax,0x11a668
    }

    shift |= shiftcode[data];
  101522:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101526:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  10152d:	0f b6 d0             	movzbl %al,%edx
  101530:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101535:	09 d0                	or     %edx,%eax
  101537:	a3 68 a6 11 00       	mov    %eax,0x11a668
    shift ^= togglecode[data];
  10153c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101540:	0f b6 80 40 71 11 00 	movzbl 0x117140(%eax),%eax
  101547:	0f b6 d0             	movzbl %al,%edx
  10154a:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10154f:	31 d0                	xor    %edx,%eax
  101551:	a3 68 a6 11 00       	mov    %eax,0x11a668

    c = charcode[shift & (CTL | SHIFT)][data];
  101556:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10155b:	83 e0 03             	and    $0x3,%eax
  10155e:	8b 14 85 40 75 11 00 	mov    0x117540(,%eax,4),%edx
  101565:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101569:	01 d0                	add    %edx,%eax
  10156b:	0f b6 00             	movzbl (%eax),%eax
  10156e:	0f b6 c0             	movzbl %al,%eax
  101571:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101574:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101579:	83 e0 08             	and    $0x8,%eax
  10157c:	85 c0                	test   %eax,%eax
  10157e:	74 22                	je     1015a2 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101580:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101584:	7e 0c                	jle    101592 <kbd_proc_data+0x13e>
  101586:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10158a:	7f 06                	jg     101592 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10158c:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101590:	eb 10                	jmp    1015a2 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101592:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101596:	7e 0a                	jle    1015a2 <kbd_proc_data+0x14e>
  101598:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10159c:	7f 04                	jg     1015a2 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10159e:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015a2:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1015a7:	f7 d0                	not    %eax
  1015a9:	83 e0 06             	and    $0x6,%eax
  1015ac:	85 c0                	test   %eax,%eax
  1015ae:	75 28                	jne    1015d8 <kbd_proc_data+0x184>
  1015b0:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015b7:	75 1f                	jne    1015d8 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1015b9:	c7 04 24 63 64 10 00 	movl   $0x106463,(%esp)
  1015c0:	e8 83 ed ff ff       	call   100348 <cprintf>
  1015c5:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015cb:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1015cf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015d3:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015d7:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015db:	c9                   	leave  
  1015dc:	c3                   	ret    

001015dd <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015dd:	55                   	push   %ebp
  1015de:	89 e5                	mov    %esp,%ebp
  1015e0:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015e3:	c7 04 24 54 14 10 00 	movl   $0x101454,(%esp)
  1015ea:	e8 a6 fd ff ff       	call   101395 <cons_intr>
}
  1015ef:	c9                   	leave  
  1015f0:	c3                   	ret    

001015f1 <kbd_init>:

static void
kbd_init(void) {
  1015f1:	55                   	push   %ebp
  1015f2:	89 e5                	mov    %esp,%ebp
  1015f4:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015f7:	e8 e1 ff ff ff       	call   1015dd <kbd_intr>
    pic_enable(IRQ_KBD);
  1015fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101603:	e8 3d 01 00 00       	call   101745 <pic_enable>
}
  101608:	c9                   	leave  
  101609:	c3                   	ret    

0010160a <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10160a:	55                   	push   %ebp
  10160b:	89 e5                	mov    %esp,%ebp
  10160d:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101610:	e8 93 f8 ff ff       	call   100ea8 <cga_init>
    serial_init();
  101615:	e8 74 f9 ff ff       	call   100f8e <serial_init>
    kbd_init();
  10161a:	e8 d2 ff ff ff       	call   1015f1 <kbd_init>
    if (!serial_exists) {
  10161f:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101624:	85 c0                	test   %eax,%eax
  101626:	75 0c                	jne    101634 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101628:	c7 04 24 6f 64 10 00 	movl   $0x10646f,(%esp)
  10162f:	e8 14 ed ff ff       	call   100348 <cprintf>
    }
}
  101634:	c9                   	leave  
  101635:	c3                   	ret    

00101636 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101636:	55                   	push   %ebp
  101637:	89 e5                	mov    %esp,%ebp
  101639:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  10163c:	e8 e2 f7 ff ff       	call   100e23 <__intr_save>
  101641:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101644:	8b 45 08             	mov    0x8(%ebp),%eax
  101647:	89 04 24             	mov    %eax,(%esp)
  10164a:	e8 9b fa ff ff       	call   1010ea <lpt_putc>
        cga_putc(c);
  10164f:	8b 45 08             	mov    0x8(%ebp),%eax
  101652:	89 04 24             	mov    %eax,(%esp)
  101655:	e8 cf fa ff ff       	call   101129 <cga_putc>
        serial_putc(c);
  10165a:	8b 45 08             	mov    0x8(%ebp),%eax
  10165d:	89 04 24             	mov    %eax,(%esp)
  101660:	e8 f1 fc ff ff       	call   101356 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101668:	89 04 24             	mov    %eax,(%esp)
  10166b:	e8 dd f7 ff ff       	call   100e4d <__intr_restore>
}
  101670:	c9                   	leave  
  101671:	c3                   	ret    

00101672 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101672:	55                   	push   %ebp
  101673:	89 e5                	mov    %esp,%ebp
  101675:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101678:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10167f:	e8 9f f7 ff ff       	call   100e23 <__intr_save>
  101684:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101687:	e8 ab fd ff ff       	call   101437 <serial_intr>
        kbd_intr();
  10168c:	e8 4c ff ff ff       	call   1015dd <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101691:	8b 15 60 a6 11 00    	mov    0x11a660,%edx
  101697:	a1 64 a6 11 00       	mov    0x11a664,%eax
  10169c:	39 c2                	cmp    %eax,%edx
  10169e:	74 31                	je     1016d1 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  1016a0:	a1 60 a6 11 00       	mov    0x11a660,%eax
  1016a5:	8d 50 01             	lea    0x1(%eax),%edx
  1016a8:	89 15 60 a6 11 00    	mov    %edx,0x11a660
  1016ae:	0f b6 80 60 a4 11 00 	movzbl 0x11a460(%eax),%eax
  1016b5:	0f b6 c0             	movzbl %al,%eax
  1016b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  1016bb:	a1 60 a6 11 00       	mov    0x11a660,%eax
  1016c0:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016c5:	75 0a                	jne    1016d1 <cons_getc+0x5f>
                cons.rpos = 0;
  1016c7:	c7 05 60 a6 11 00 00 	movl   $0x0,0x11a660
  1016ce:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1016d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016d4:	89 04 24             	mov    %eax,(%esp)
  1016d7:	e8 71 f7 ff ff       	call   100e4d <__intr_restore>
    return c;
  1016dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016df:	c9                   	leave  
  1016e0:	c3                   	ret    

001016e1 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016e1:	55                   	push   %ebp
  1016e2:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016e4:	fb                   	sti    
    sti();
}
  1016e5:	5d                   	pop    %ebp
  1016e6:	c3                   	ret    

001016e7 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016e7:	55                   	push   %ebp
  1016e8:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016ea:	fa                   	cli    
    cli();
}
  1016eb:	5d                   	pop    %ebp
  1016ec:	c3                   	ret    

001016ed <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016ed:	55                   	push   %ebp
  1016ee:	89 e5                	mov    %esp,%ebp
  1016f0:	83 ec 14             	sub    $0x14,%esp
  1016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1016f6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016fa:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016fe:	66 a3 50 75 11 00    	mov    %ax,0x117550
    if (did_init) {
  101704:	a1 6c a6 11 00       	mov    0x11a66c,%eax
  101709:	85 c0                	test   %eax,%eax
  10170b:	74 36                	je     101743 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10170d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101711:	0f b6 c0             	movzbl %al,%eax
  101714:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10171a:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10171d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101721:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101725:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101726:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10172a:	66 c1 e8 08          	shr    $0x8,%ax
  10172e:	0f b6 c0             	movzbl %al,%eax
  101731:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101737:	88 45 f9             	mov    %al,-0x7(%ebp)
  10173a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10173e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101742:	ee                   	out    %al,(%dx)
    }
}
  101743:	c9                   	leave  
  101744:	c3                   	ret    

00101745 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101745:	55                   	push   %ebp
  101746:	89 e5                	mov    %esp,%ebp
  101748:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10174b:	8b 45 08             	mov    0x8(%ebp),%eax
  10174e:	ba 01 00 00 00       	mov    $0x1,%edx
  101753:	89 c1                	mov    %eax,%ecx
  101755:	d3 e2                	shl    %cl,%edx
  101757:	89 d0                	mov    %edx,%eax
  101759:	f7 d0                	not    %eax
  10175b:	89 c2                	mov    %eax,%edx
  10175d:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101764:	21 d0                	and    %edx,%eax
  101766:	0f b7 c0             	movzwl %ax,%eax
  101769:	89 04 24             	mov    %eax,(%esp)
  10176c:	e8 7c ff ff ff       	call   1016ed <pic_setmask>
}
  101771:	c9                   	leave  
  101772:	c3                   	ret    

00101773 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101773:	55                   	push   %ebp
  101774:	89 e5                	mov    %esp,%ebp
  101776:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101779:	c7 05 6c a6 11 00 01 	movl   $0x1,0x11a66c
  101780:	00 00 00 
  101783:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101789:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10178d:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101791:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101795:	ee                   	out    %al,(%dx)
  101796:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10179c:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1017a0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017a4:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017a8:	ee                   	out    %al,(%dx)
  1017a9:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1017af:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1017b3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1017b7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017bb:	ee                   	out    %al,(%dx)
  1017bc:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1017c2:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1017c6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1017ca:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017ce:	ee                   	out    %al,(%dx)
  1017cf:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017d5:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017d9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017dd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017e1:	ee                   	out    %al,(%dx)
  1017e2:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017e8:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017ec:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017f0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017f4:	ee                   	out    %al,(%dx)
  1017f5:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017fb:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017ff:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101803:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101807:	ee                   	out    %al,(%dx)
  101808:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  10180e:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101812:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101816:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10181a:	ee                   	out    %al,(%dx)
  10181b:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101821:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101825:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101829:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10182d:	ee                   	out    %al,(%dx)
  10182e:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101834:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101838:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10183c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101840:	ee                   	out    %al,(%dx)
  101841:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101847:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10184b:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10184f:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101853:	ee                   	out    %al,(%dx)
  101854:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10185a:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10185e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101862:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101866:	ee                   	out    %al,(%dx)
  101867:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10186d:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101871:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101875:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101879:	ee                   	out    %al,(%dx)
  10187a:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101880:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101884:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101888:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10188c:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10188d:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101894:	66 83 f8 ff          	cmp    $0xffff,%ax
  101898:	74 12                	je     1018ac <pic_init+0x139>
        pic_setmask(irq_mask);
  10189a:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  1018a1:	0f b7 c0             	movzwl %ax,%eax
  1018a4:	89 04 24             	mov    %eax,(%esp)
  1018a7:	e8 41 fe ff ff       	call   1016ed <pic_setmask>
    }
}
  1018ac:	c9                   	leave  
  1018ad:	c3                   	ret    

001018ae <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1018ae:	55                   	push   %ebp
  1018af:	89 e5                	mov    %esp,%ebp
  1018b1:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1018b4:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018bb:	00 
  1018bc:	c7 04 24 a0 64 10 00 	movl   $0x1064a0,(%esp)
  1018c3:	e8 80 ea ff ff       	call   100348 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1018c8:	c9                   	leave  
  1018c9:	c3                   	ret    

001018ca <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018ca:	55                   	push   %ebp
  1018cb:	89 e5                	mov    %esp,%ebp
  1018cd:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i = 0;
  1018d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    for(i = 0; i < 256; i++) SETGATE(idt[i], 0, GD_KTEXT , __vectors[i], DPL_KERNEL);
  1018d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018de:	e9 c3 00 00 00       	jmp    1019a6 <idt_init+0xdc>
  1018e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e6:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  1018ed:	89 c2                	mov    %eax,%edx
  1018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f2:	66 89 14 c5 80 a6 11 	mov    %dx,0x11a680(,%eax,8)
  1018f9:	00 
  1018fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fd:	66 c7 04 c5 82 a6 11 	movw   $0x8,0x11a682(,%eax,8)
  101904:	00 08 00 
  101907:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190a:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  101911:	00 
  101912:	83 e2 e0             	and    $0xffffffe0,%edx
  101915:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  10191c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191f:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  101926:	00 
  101927:	83 e2 1f             	and    $0x1f,%edx
  10192a:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  101931:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101934:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10193b:	00 
  10193c:	83 e2 f0             	and    $0xfffffff0,%edx
  10193f:	83 ca 0e             	or     $0xe,%edx
  101942:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101949:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194c:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101953:	00 
  101954:	83 e2 ef             	and    $0xffffffef,%edx
  101957:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  10195e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101961:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101968:	00 
  101969:	83 e2 9f             	and    $0xffffff9f,%edx
  10196c:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101973:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101976:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10197d:	00 
  10197e:	83 ca 80             	or     $0xffffff80,%edx
  101981:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101988:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198b:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  101992:	c1 e8 10             	shr    $0x10,%eax
  101995:	89 c2                	mov    %eax,%edx
  101997:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10199a:	66 89 14 c5 86 a6 11 	mov    %dx,0x11a686(,%eax,8)
  1019a1:	00 
  1019a2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1019a6:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1019ad:	0f 8e 30 ff ff ff    	jle    1018e3 <idt_init+0x19>
    SETGATE(idt[T_SYSCALL], 0, GD_KTEXT , __vectors[T_SYSCALL], DPL_USER);
  1019b3:	a1 e0 77 11 00       	mov    0x1177e0,%eax
  1019b8:	66 a3 80 aa 11 00    	mov    %ax,0x11aa80
  1019be:	66 c7 05 82 aa 11 00 	movw   $0x8,0x11aa82
  1019c5:	08 00 
  1019c7:	0f b6 05 84 aa 11 00 	movzbl 0x11aa84,%eax
  1019ce:	83 e0 e0             	and    $0xffffffe0,%eax
  1019d1:	a2 84 aa 11 00       	mov    %al,0x11aa84
  1019d6:	0f b6 05 84 aa 11 00 	movzbl 0x11aa84,%eax
  1019dd:	83 e0 1f             	and    $0x1f,%eax
  1019e0:	a2 84 aa 11 00       	mov    %al,0x11aa84
  1019e5:	0f b6 05 85 aa 11 00 	movzbl 0x11aa85,%eax
  1019ec:	83 e0 f0             	and    $0xfffffff0,%eax
  1019ef:	83 c8 0e             	or     $0xe,%eax
  1019f2:	a2 85 aa 11 00       	mov    %al,0x11aa85
  1019f7:	0f b6 05 85 aa 11 00 	movzbl 0x11aa85,%eax
  1019fe:	83 e0 ef             	and    $0xffffffef,%eax
  101a01:	a2 85 aa 11 00       	mov    %al,0x11aa85
  101a06:	0f b6 05 85 aa 11 00 	movzbl 0x11aa85,%eax
  101a0d:	83 c8 60             	or     $0x60,%eax
  101a10:	a2 85 aa 11 00       	mov    %al,0x11aa85
  101a15:	0f b6 05 85 aa 11 00 	movzbl 0x11aa85,%eax
  101a1c:	83 c8 80             	or     $0xffffff80,%eax
  101a1f:	a2 85 aa 11 00       	mov    %al,0x11aa85
  101a24:	a1 e0 77 11 00       	mov    0x1177e0,%eax
  101a29:	c1 e8 10             	shr    $0x10,%eax
  101a2c:	66 a3 86 aa 11 00    	mov    %ax,0x11aa86
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101a32:	a1 c4 77 11 00       	mov    0x1177c4,%eax
  101a37:	66 a3 48 aa 11 00    	mov    %ax,0x11aa48
  101a3d:	66 c7 05 4a aa 11 00 	movw   $0x8,0x11aa4a
  101a44:	08 00 
  101a46:	0f b6 05 4c aa 11 00 	movzbl 0x11aa4c,%eax
  101a4d:	83 e0 e0             	and    $0xffffffe0,%eax
  101a50:	a2 4c aa 11 00       	mov    %al,0x11aa4c
  101a55:	0f b6 05 4c aa 11 00 	movzbl 0x11aa4c,%eax
  101a5c:	83 e0 1f             	and    $0x1f,%eax
  101a5f:	a2 4c aa 11 00       	mov    %al,0x11aa4c
  101a64:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  101a6b:	83 e0 f0             	and    $0xfffffff0,%eax
  101a6e:	83 c8 0e             	or     $0xe,%eax
  101a71:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a76:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  101a7d:	83 e0 ef             	and    $0xffffffef,%eax
  101a80:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a85:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  101a8c:	83 c8 60             	or     $0x60,%eax
  101a8f:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a94:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  101a9b:	83 c8 80             	or     $0xffffff80,%eax
  101a9e:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101aa3:	a1 c4 77 11 00       	mov    0x1177c4,%eax
  101aa8:	c1 e8 10             	shr    $0x10,%eax
  101aab:	66 a3 4e aa 11 00    	mov    %ax,0x11aa4e
  101ab1:	c7 45 f8 60 75 11 00 	movl   $0x117560,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101ab8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101abb:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd);
}
  101abe:	c9                   	leave  
  101abf:	c3                   	ret    

00101ac0 <trapname>:

static const char *
trapname(int trapno) {
  101ac0:	55                   	push   %ebp
  101ac1:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac6:	83 f8 13             	cmp    $0x13,%eax
  101ac9:	77 0c                	ja     101ad7 <trapname+0x17>
        return excnames[trapno];
  101acb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ace:	8b 04 85 40 68 10 00 	mov    0x106840(,%eax,4),%eax
  101ad5:	eb 18                	jmp    101aef <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101ad7:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101adb:	7e 0d                	jle    101aea <trapname+0x2a>
  101add:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101ae1:	7f 07                	jg     101aea <trapname+0x2a>
        return "Hardware Interrupt";
  101ae3:	b8 aa 64 10 00       	mov    $0x1064aa,%eax
  101ae8:	eb 05                	jmp    101aef <trapname+0x2f>
    }
    return "(unknown trap)";
  101aea:	b8 bd 64 10 00       	mov    $0x1064bd,%eax
}
  101aef:	5d                   	pop    %ebp
  101af0:	c3                   	ret    

00101af1 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101af1:	55                   	push   %ebp
  101af2:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101af4:	8b 45 08             	mov    0x8(%ebp),%eax
  101af7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101afb:	66 83 f8 08          	cmp    $0x8,%ax
  101aff:	0f 94 c0             	sete   %al
  101b02:	0f b6 c0             	movzbl %al,%eax
}
  101b05:	5d                   	pop    %ebp
  101b06:	c3                   	ret    

00101b07 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b07:	55                   	push   %ebp
  101b08:	89 e5                	mov    %esp,%ebp
  101b0a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b10:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b14:	c7 04 24 fe 64 10 00 	movl   $0x1064fe,(%esp)
  101b1b:	e8 28 e8 ff ff       	call   100348 <cprintf>
    print_regs(&tf->tf_regs);
  101b20:	8b 45 08             	mov    0x8(%ebp),%eax
  101b23:	89 04 24             	mov    %eax,(%esp)
  101b26:	e8 a1 01 00 00       	call   101ccc <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b32:	0f b7 c0             	movzwl %ax,%eax
  101b35:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b39:	c7 04 24 0f 65 10 00 	movl   $0x10650f,(%esp)
  101b40:	e8 03 e8 ff ff       	call   100348 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b45:	8b 45 08             	mov    0x8(%ebp),%eax
  101b48:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b4c:	0f b7 c0             	movzwl %ax,%eax
  101b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b53:	c7 04 24 22 65 10 00 	movl   $0x106522,(%esp)
  101b5a:	e8 e9 e7 ff ff       	call   100348 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b62:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b66:	0f b7 c0             	movzwl %ax,%eax
  101b69:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6d:	c7 04 24 35 65 10 00 	movl   $0x106535,(%esp)
  101b74:	e8 cf e7 ff ff       	call   100348 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b79:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7c:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b80:	0f b7 c0             	movzwl %ax,%eax
  101b83:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b87:	c7 04 24 48 65 10 00 	movl   $0x106548,(%esp)
  101b8e:	e8 b5 e7 ff ff       	call   100348 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b93:	8b 45 08             	mov    0x8(%ebp),%eax
  101b96:	8b 40 30             	mov    0x30(%eax),%eax
  101b99:	89 04 24             	mov    %eax,(%esp)
  101b9c:	e8 1f ff ff ff       	call   101ac0 <trapname>
  101ba1:	8b 55 08             	mov    0x8(%ebp),%edx
  101ba4:	8b 52 30             	mov    0x30(%edx),%edx
  101ba7:	89 44 24 08          	mov    %eax,0x8(%esp)
  101bab:	89 54 24 04          	mov    %edx,0x4(%esp)
  101baf:	c7 04 24 5b 65 10 00 	movl   $0x10655b,(%esp)
  101bb6:	e8 8d e7 ff ff       	call   100348 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbe:	8b 40 34             	mov    0x34(%eax),%eax
  101bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc5:	c7 04 24 6d 65 10 00 	movl   $0x10656d,(%esp)
  101bcc:	e8 77 e7 ff ff       	call   100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd4:	8b 40 38             	mov    0x38(%eax),%eax
  101bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdb:	c7 04 24 7c 65 10 00 	movl   $0x10657c,(%esp)
  101be2:	e8 61 e7 ff ff       	call   100348 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101be7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bea:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bee:	0f b7 c0             	movzwl %ax,%eax
  101bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf5:	c7 04 24 8b 65 10 00 	movl   $0x10658b,(%esp)
  101bfc:	e8 47 e7 ff ff       	call   100348 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c01:	8b 45 08             	mov    0x8(%ebp),%eax
  101c04:	8b 40 40             	mov    0x40(%eax),%eax
  101c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0b:	c7 04 24 9e 65 10 00 	movl   $0x10659e,(%esp)
  101c12:	e8 31 e7 ff ff       	call   100348 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c1e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c25:	eb 3e                	jmp    101c65 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c27:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2a:	8b 50 40             	mov    0x40(%eax),%edx
  101c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c30:	21 d0                	and    %edx,%eax
  101c32:	85 c0                	test   %eax,%eax
  101c34:	74 28                	je     101c5e <print_trapframe+0x157>
  101c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c39:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101c40:	85 c0                	test   %eax,%eax
  101c42:	74 1a                	je     101c5e <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c47:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c52:	c7 04 24 ad 65 10 00 	movl   $0x1065ad,(%esp)
  101c59:	e8 ea e6 ff ff       	call   100348 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c5e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101c62:	d1 65 f0             	shll   -0x10(%ebp)
  101c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c68:	83 f8 17             	cmp    $0x17,%eax
  101c6b:	76 ba                	jbe    101c27 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c70:	8b 40 40             	mov    0x40(%eax),%eax
  101c73:	25 00 30 00 00       	and    $0x3000,%eax
  101c78:	c1 e8 0c             	shr    $0xc,%eax
  101c7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7f:	c7 04 24 b1 65 10 00 	movl   $0x1065b1,(%esp)
  101c86:	e8 bd e6 ff ff       	call   100348 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8e:	89 04 24             	mov    %eax,(%esp)
  101c91:	e8 5b fe ff ff       	call   101af1 <trap_in_kernel>
  101c96:	85 c0                	test   %eax,%eax
  101c98:	75 30                	jne    101cca <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9d:	8b 40 44             	mov    0x44(%eax),%eax
  101ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca4:	c7 04 24 ba 65 10 00 	movl   $0x1065ba,(%esp)
  101cab:	e8 98 e6 ff ff       	call   100348 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb3:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101cb7:	0f b7 c0             	movzwl %ax,%eax
  101cba:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbe:	c7 04 24 c9 65 10 00 	movl   $0x1065c9,(%esp)
  101cc5:	e8 7e e6 ff ff       	call   100348 <cprintf>
    }
}
  101cca:	c9                   	leave  
  101ccb:	c3                   	ret    

00101ccc <print_regs>:

void
print_regs(struct pushregs *regs) {
  101ccc:	55                   	push   %ebp
  101ccd:	89 e5                	mov    %esp,%ebp
  101ccf:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd5:	8b 00                	mov    (%eax),%eax
  101cd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cdb:	c7 04 24 dc 65 10 00 	movl   $0x1065dc,(%esp)
  101ce2:	e8 61 e6 ff ff       	call   100348 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  101cea:	8b 40 04             	mov    0x4(%eax),%eax
  101ced:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf1:	c7 04 24 eb 65 10 00 	movl   $0x1065eb,(%esp)
  101cf8:	e8 4b e6 ff ff       	call   100348 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  101d00:	8b 40 08             	mov    0x8(%eax),%eax
  101d03:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d07:	c7 04 24 fa 65 10 00 	movl   $0x1065fa,(%esp)
  101d0e:	e8 35 e6 ff ff       	call   100348 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d13:	8b 45 08             	mov    0x8(%ebp),%eax
  101d16:	8b 40 0c             	mov    0xc(%eax),%eax
  101d19:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d1d:	c7 04 24 09 66 10 00 	movl   $0x106609,(%esp)
  101d24:	e8 1f e6 ff ff       	call   100348 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d29:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2c:	8b 40 10             	mov    0x10(%eax),%eax
  101d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d33:	c7 04 24 18 66 10 00 	movl   $0x106618,(%esp)
  101d3a:	e8 09 e6 ff ff       	call   100348 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d42:	8b 40 14             	mov    0x14(%eax),%eax
  101d45:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d49:	c7 04 24 27 66 10 00 	movl   $0x106627,(%esp)
  101d50:	e8 f3 e5 ff ff       	call   100348 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d55:	8b 45 08             	mov    0x8(%ebp),%eax
  101d58:	8b 40 18             	mov    0x18(%eax),%eax
  101d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d5f:	c7 04 24 36 66 10 00 	movl   $0x106636,(%esp)
  101d66:	e8 dd e5 ff ff       	call   100348 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6e:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d75:	c7 04 24 45 66 10 00 	movl   $0x106645,(%esp)
  101d7c:	e8 c7 e5 ff ff       	call   100348 <cprintf>
}
  101d81:	c9                   	leave  
  101d82:	c3                   	ret    

00101d83 <trap_dispatch>:

struct trapframe k2u, u2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d83:	55                   	push   %ebp
  101d84:	89 e5                	mov    %esp,%ebp
  101d86:	57                   	push   %edi
  101d87:	56                   	push   %esi
  101d88:	53                   	push   %ebx
  101d89:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8f:	8b 40 30             	mov    0x30(%eax),%eax
  101d92:	83 f8 24             	cmp    $0x24,%eax
  101d95:	74 6a                	je     101e01 <trap_dispatch+0x7e>
  101d97:	83 f8 24             	cmp    $0x24,%eax
  101d9a:	77 13                	ja     101daf <trap_dispatch+0x2c>
  101d9c:	83 f8 20             	cmp    $0x20,%eax
  101d9f:	74 25                	je     101dc6 <trap_dispatch+0x43>
  101da1:	83 f8 21             	cmp    $0x21,%eax
  101da4:	0f 84 80 00 00 00    	je     101e2a <trap_dispatch+0xa7>
  101daa:	e9 9c 02 00 00       	jmp    10204b <trap_dispatch+0x2c8>
  101daf:	83 f8 78             	cmp    $0x78,%eax
  101db2:	0f 84 ab 01 00 00    	je     101f63 <trap_dispatch+0x1e0>
  101db8:	83 f8 79             	cmp    $0x79,%eax
  101dbb:	0f 84 19 02 00 00    	je     101fda <trap_dispatch+0x257>
  101dc1:	e9 85 02 00 00       	jmp    10204b <trap_dispatch+0x2c8>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++ != 0 ? ticks % TICK_NUM == 0 ? print_ticks() : NULL : NULL;
  101dc6:	a1 0c af 11 00       	mov    0x11af0c,%eax
  101dcb:	8d 50 01             	lea    0x1(%eax),%edx
  101dce:	89 15 0c af 11 00    	mov    %edx,0x11af0c
  101dd4:	85 c0                	test   %eax,%eax
  101dd6:	74 24                	je     101dfc <trap_dispatch+0x79>
  101dd8:	8b 0d 0c af 11 00    	mov    0x11af0c,%ecx
  101dde:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101de3:	89 c8                	mov    %ecx,%eax
  101de5:	f7 e2                	mul    %edx
  101de7:	89 d0                	mov    %edx,%eax
  101de9:	c1 e8 05             	shr    $0x5,%eax
  101dec:	6b c0 64             	imul   $0x64,%eax,%eax
  101def:	29 c1                	sub    %eax,%ecx
  101df1:	89 c8                	mov    %ecx,%eax
  101df3:	85 c0                	test   %eax,%eax
  101df5:	75 05                	jne    101dfc <trap_dispatch+0x79>
  101df7:	e8 b2 fa ff ff       	call   1018ae <print_ticks>
        break;
  101dfc:	e9 82 02 00 00       	jmp    102083 <trap_dispatch+0x300>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e01:	e8 6c f8 ff ff       	call   101672 <cons_getc>
  101e06:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e09:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e0d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e11:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e19:	c7 04 24 54 66 10 00 	movl   $0x106654,(%esp)
  101e20:	e8 23 e5 ff ff       	call   100348 <cprintf>
        break;
  101e25:	e9 59 02 00 00       	jmp    102083 <trap_dispatch+0x300>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e2a:	e8 43 f8 ff ff       	call   101672 <cons_getc>
  101e2f:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e32:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e36:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e3a:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e42:	c7 04 24 66 66 10 00 	movl   $0x106666,(%esp)
  101e49:	e8 fa e4 ff ff       	call   100348 <cprintf>
        if(c == '0'){
  101e4e:	80 7d e7 30          	cmpb   $0x30,-0x19(%ebp)
  101e52:	0f 85 82 00 00 00    	jne    101eda <trap_dispatch+0x157>
            if (tf->tf_cs != KERNEL_CS) {
  101e58:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e5f:	66 83 f8 08          	cmp    $0x8,%ax
  101e63:	0f 84 f5 00 00 00    	je     101f5e <trap_dispatch+0x1db>
                cprintf("+++ switch to  kernel  mode +++\n");
  101e69:	c7 04 24 78 66 10 00 	movl   $0x106678,(%esp)
  101e70:	e8 d3 e4 ff ff       	call   100348 <cprintf>
                u2k = *tf;
  101e75:	8b 45 08             	mov    0x8(%ebp),%eax
  101e78:	ba 80 af 11 00       	mov    $0x11af80,%edx
  101e7d:	89 c3                	mov    %eax,%ebx
  101e7f:	b8 13 00 00 00       	mov    $0x13,%eax
  101e84:	89 d7                	mov    %edx,%edi
  101e86:	89 de                	mov    %ebx,%esi
  101e88:	89 c1                	mov    %eax,%ecx
  101e8a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
                u2k.tf_cs = KERNEL_CS;
  101e8c:	66 c7 05 bc af 11 00 	movw   $0x8,0x11afbc
  101e93:	08 00 
                u2k.tf_ds = KERNEL_DS;
  101e95:	66 c7 05 ac af 11 00 	movw   $0x10,0x11afac
  101e9c:	10 00 
                u2k.tf_es = KERNEL_DS;
  101e9e:	66 c7 05 a8 af 11 00 	movw   $0x10,0x11afa8
  101ea5:	10 00 
                u2k.tf_ss = KERNEL_DS;
  101ea7:	66 c7 05 c8 af 11 00 	movw   $0x10,0x11afc8
  101eae:	10 00 
                u2k.tf_esp = tf->tf_esp;
  101eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb3:	8b 40 44             	mov    0x44(%eax),%eax
  101eb6:	a3 c4 af 11 00       	mov    %eax,0x11afc4
                u2k.tf_eflags &= ~FL_IOPL_MASK;  // 保证printf正常
  101ebb:	a1 c0 af 11 00       	mov    0x11afc0,%eax
  101ec0:	80 e4 cf             	and    $0xcf,%ah
  101ec3:	a3 c0 af 11 00       	mov    %eax,0x11afc0
                
                *((uint32_t *)tf - 1) = (uint32_t)&u2k;
  101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  101ecb:	8d 50 fc             	lea    -0x4(%eax),%edx
  101ece:	b8 80 af 11 00       	mov    $0x11af80,%eax
  101ed3:	89 02                	mov    %eax,(%edx)
                k2u.tf_esp = tf->tf_esp;
                k2u.tf_eflags |= FL_IOPL_MASK;  // 保证printf正常
                *((uint32_t *)tf - 1) = (uint32_t)&k2u;
            }
        }
        break;
  101ed5:	e9 a9 01 00 00       	jmp    102083 <trap_dispatch+0x300>
                u2k.tf_eflags &= ~FL_IOPL_MASK;  // 保证printf正常
                
                *((uint32_t *)tf - 1) = (uint32_t)&u2k;
            }
        }
        else if(c == '3')
  101eda:	80 7d e7 33          	cmpb   $0x33,-0x19(%ebp)
  101ede:	75 7e                	jne    101f5e <trap_dispatch+0x1db>
        {
            if (tf->tf_cs != USER_CS) {
  101ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ee7:	66 83 f8 1b          	cmp    $0x1b,%ax
  101eeb:	74 71                	je     101f5e <trap_dispatch+0x1db>
                cprintf("+++ switch to  user  mode +++\n");
  101eed:	c7 04 24 9c 66 10 00 	movl   $0x10669c,(%esp)
  101ef4:	e8 4f e4 ff ff       	call   100348 <cprintf>
                k2u = *tf;
  101ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  101efc:	ba 20 af 11 00       	mov    $0x11af20,%edx
  101f01:	89 c3                	mov    %eax,%ebx
  101f03:	b8 13 00 00 00       	mov    $0x13,%eax
  101f08:	89 d7                	mov    %edx,%edi
  101f0a:	89 de                	mov    %ebx,%esi
  101f0c:	89 c1                	mov    %eax,%ecx
  101f0e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
                k2u.tf_cs = USER_CS;
  101f10:	66 c7 05 5c af 11 00 	movw   $0x1b,0x11af5c
  101f17:	1b 00 
                k2u.tf_ds = USER_DS;
  101f19:	66 c7 05 4c af 11 00 	movw   $0x23,0x11af4c
  101f20:	23 00 
                k2u.tf_es = USER_DS;
  101f22:	66 c7 05 48 af 11 00 	movw   $0x23,0x11af48
  101f29:	23 00 
                k2u.tf_ss = USER_DS;
  101f2b:	66 c7 05 68 af 11 00 	movw   $0x23,0x11af68
  101f32:	23 00 
                k2u.tf_esp = tf->tf_esp;
  101f34:	8b 45 08             	mov    0x8(%ebp),%eax
  101f37:	8b 40 44             	mov    0x44(%eax),%eax
  101f3a:	a3 64 af 11 00       	mov    %eax,0x11af64
                k2u.tf_eflags |= FL_IOPL_MASK;  // 保证printf正常
  101f3f:	a1 60 af 11 00       	mov    0x11af60,%eax
  101f44:	80 cc 30             	or     $0x30,%ah
  101f47:	a3 60 af 11 00       	mov    %eax,0x11af60
                *((uint32_t *)tf - 1) = (uint32_t)&k2u;
  101f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101f4f:	8d 50 fc             	lea    -0x4(%eax),%edx
  101f52:	b8 20 af 11 00       	mov    $0x11af20,%eax
  101f57:	89 02                	mov    %eax,(%edx)
            }
        }
        break;
  101f59:	e9 25 01 00 00       	jmp    102083 <trap_dispatch+0x300>
  101f5e:	e9 20 01 00 00       	jmp    102083 <trap_dispatch+0x300>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if(tf->tf_cs != USER_CS){  // 不等则切换
  101f63:	8b 45 08             	mov    0x8(%ebp),%eax
  101f66:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f6a:	66 83 f8 1b          	cmp    $0x1b,%ax
  101f6e:	74 65                	je     101fd5 <trap_dispatch+0x252>
            k2u = *tf;
  101f70:	8b 45 08             	mov    0x8(%ebp),%eax
  101f73:	ba 20 af 11 00       	mov    $0x11af20,%edx
  101f78:	89 c3                	mov    %eax,%ebx
  101f7a:	b8 13 00 00 00       	mov    $0x13,%eax
  101f7f:	89 d7                	mov    %edx,%edi
  101f81:	89 de                	mov    %ebx,%esi
  101f83:	89 c1                	mov    %eax,%ecx
  101f85:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            k2u.tf_cs = USER_CS;
  101f87:	66 c7 05 5c af 11 00 	movw   $0x1b,0x11af5c
  101f8e:	1b 00 
            k2u.tf_ds = USER_DS;
  101f90:	66 c7 05 4c af 11 00 	movw   $0x23,0x11af4c
  101f97:	23 00 
            k2u.tf_es = USER_DS;
  101f99:	66 c7 05 48 af 11 00 	movw   $0x23,0x11af48
  101fa0:	23 00 
            k2u.tf_ss = USER_DS;
  101fa2:	66 c7 05 68 af 11 00 	movw   $0x23,0x11af68
  101fa9:	23 00 
            k2u.tf_esp = tf->tf_esp;
  101fab:	8b 45 08             	mov    0x8(%ebp),%eax
  101fae:	8b 40 44             	mov    0x44(%eax),%eax
  101fb1:	a3 64 af 11 00       	mov    %eax,0x11af64
            k2u.tf_eflags |= FL_IOPL_MASK;  // 保证printf正常
  101fb6:	a1 60 af 11 00       	mov    0x11af60,%eax
  101fbb:	80 cc 30             	or     $0x30,%ah
  101fbe:	a3 60 af 11 00       	mov    %eax,0x11af60
            
            *((uint32_t *)tf - 1) = (uint32_t)&k2u;
  101fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  101fc6:	8d 50 fc             	lea    -0x4(%eax),%edx
  101fc9:	b8 20 af 11 00       	mov    $0x11af20,%eax
  101fce:	89 02                	mov    %eax,(%edx)
        }

        break;
  101fd0:	e9 ae 00 00 00       	jmp    102083 <trap_dispatch+0x300>
  101fd5:	e9 a9 00 00 00       	jmp    102083 <trap_dispatch+0x300>
    case T_SWITCH_TOK:
        if(tf->tf_cs != KERNEL_CS){  // 不等则切换
  101fda:	8b 45 08             	mov    0x8(%ebp),%eax
  101fdd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fe1:	66 83 f8 08          	cmp    $0x8,%ax
  101fe5:	74 62                	je     102049 <trap_dispatch+0x2c6>
            u2k = *tf;
  101fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  101fea:	ba 80 af 11 00       	mov    $0x11af80,%edx
  101fef:	89 c3                	mov    %eax,%ebx
  101ff1:	b8 13 00 00 00       	mov    $0x13,%eax
  101ff6:	89 d7                	mov    %edx,%edi
  101ff8:	89 de                	mov    %ebx,%esi
  101ffa:	89 c1                	mov    %eax,%ecx
  101ffc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            u2k.tf_cs = KERNEL_CS;
  101ffe:	66 c7 05 bc af 11 00 	movw   $0x8,0x11afbc
  102005:	08 00 
            u2k.tf_ds = KERNEL_DS;
  102007:	66 c7 05 ac af 11 00 	movw   $0x10,0x11afac
  10200e:	10 00 
            u2k.tf_es = KERNEL_DS;
  102010:	66 c7 05 a8 af 11 00 	movw   $0x10,0x11afa8
  102017:	10 00 
            u2k.tf_ss = KERNEL_DS;
  102019:	66 c7 05 c8 af 11 00 	movw   $0x10,0x11afc8
  102020:	10 00 
            u2k.tf_esp = tf->tf_esp;
  102022:	8b 45 08             	mov    0x8(%ebp),%eax
  102025:	8b 40 44             	mov    0x44(%eax),%eax
  102028:	a3 c4 af 11 00       	mov    %eax,0x11afc4
            u2k.tf_eflags &= ~FL_IOPL_MASK;  // 保证printf正常
  10202d:	a1 c0 af 11 00       	mov    0x11afc0,%eax
  102032:	80 e4 cf             	and    $0xcf,%ah
  102035:	a3 c0 af 11 00       	mov    %eax,0x11afc0
            
            *((uint32_t *)tf - 1) = (uint32_t)&u2k;
  10203a:	8b 45 08             	mov    0x8(%ebp),%eax
  10203d:	8d 50 fc             	lea    -0x4(%eax),%edx
  102040:	b8 80 af 11 00       	mov    $0x11af80,%eax
  102045:	89 02                	mov    %eax,(%edx)

        }
        //panic("T_SWITCH_** ??\n");
        break;
  102047:	eb 3a                	jmp    102083 <trap_dispatch+0x300>
  102049:	eb 38                	jmp    102083 <trap_dispatch+0x300>
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  10204b:	8b 45 08             	mov    0x8(%ebp),%eax
  10204e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102052:	0f b7 c0             	movzwl %ax,%eax
  102055:	83 e0 03             	and    $0x3,%eax
  102058:	85 c0                	test   %eax,%eax
  10205a:	75 27                	jne    102083 <trap_dispatch+0x300>
            print_trapframe(tf);
  10205c:	8b 45 08             	mov    0x8(%ebp),%eax
  10205f:	89 04 24             	mov    %eax,(%esp)
  102062:	e8 a0 fa ff ff       	call   101b07 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  102067:	c7 44 24 08 bb 66 10 	movl   $0x1066bb,0x8(%esp)
  10206e:	00 
  10206f:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  102076:	00 
  102077:	c7 04 24 d7 66 10 00 	movl   $0x1066d7,(%esp)
  10207e:	e8 70 ec ff ff       	call   100cf3 <__panic>
        }
    }
}
  102083:	83 c4 2c             	add    $0x2c,%esp
  102086:	5b                   	pop    %ebx
  102087:	5e                   	pop    %esi
  102088:	5f                   	pop    %edi
  102089:	5d                   	pop    %ebp
  10208a:	c3                   	ret    

0010208b <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  10208b:	55                   	push   %ebp
  10208c:	89 e5                	mov    %esp,%ebp
  10208e:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  102091:	8b 45 08             	mov    0x8(%ebp),%eax
  102094:	89 04 24             	mov    %eax,(%esp)
  102097:	e8 e7 fc ff ff       	call   101d83 <trap_dispatch>
}
  10209c:	c9                   	leave  
  10209d:	c3                   	ret    

0010209e <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10209e:	1e                   	push   %ds
    pushl %es
  10209f:	06                   	push   %es
    pushl %fs
  1020a0:	0f a0                	push   %fs
    pushl %gs
  1020a2:	0f a8                	push   %gs
    pushal
  1020a4:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1020a5:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1020aa:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1020ac:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1020ae:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1020af:	e8 d7 ff ff ff       	call   10208b <trap>

    # pop the pushed stack pointer
    popl %esp
  1020b4:	5c                   	pop    %esp

001020b5 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1020b5:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1020b6:	0f a9                	pop    %gs
    popl %fs
  1020b8:	0f a1                	pop    %fs
    popl %es
  1020ba:	07                   	pop    %es
    popl %ds
  1020bb:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1020bc:	83 c4 08             	add    $0x8,%esp
    iret
  1020bf:	cf                   	iret   

001020c0 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $0
  1020c2:	6a 00                	push   $0x0
  jmp __alltraps
  1020c4:	e9 d5 ff ff ff       	jmp    10209e <__alltraps>

001020c9 <vector1>:
.globl vector1
vector1:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $1
  1020cb:	6a 01                	push   $0x1
  jmp __alltraps
  1020cd:	e9 cc ff ff ff       	jmp    10209e <__alltraps>

001020d2 <vector2>:
.globl vector2
vector2:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $2
  1020d4:	6a 02                	push   $0x2
  jmp __alltraps
  1020d6:	e9 c3 ff ff ff       	jmp    10209e <__alltraps>

001020db <vector3>:
.globl vector3
vector3:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $3
  1020dd:	6a 03                	push   $0x3
  jmp __alltraps
  1020df:	e9 ba ff ff ff       	jmp    10209e <__alltraps>

001020e4 <vector4>:
.globl vector4
vector4:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $4
  1020e6:	6a 04                	push   $0x4
  jmp __alltraps
  1020e8:	e9 b1 ff ff ff       	jmp    10209e <__alltraps>

001020ed <vector5>:
.globl vector5
vector5:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $5
  1020ef:	6a 05                	push   $0x5
  jmp __alltraps
  1020f1:	e9 a8 ff ff ff       	jmp    10209e <__alltraps>

001020f6 <vector6>:
.globl vector6
vector6:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $6
  1020f8:	6a 06                	push   $0x6
  jmp __alltraps
  1020fa:	e9 9f ff ff ff       	jmp    10209e <__alltraps>

001020ff <vector7>:
.globl vector7
vector7:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $7
  102101:	6a 07                	push   $0x7
  jmp __alltraps
  102103:	e9 96 ff ff ff       	jmp    10209e <__alltraps>

00102108 <vector8>:
.globl vector8
vector8:
  pushl $8
  102108:	6a 08                	push   $0x8
  jmp __alltraps
  10210a:	e9 8f ff ff ff       	jmp    10209e <__alltraps>

0010210f <vector9>:
.globl vector9
vector9:
  pushl $0
  10210f:	6a 00                	push   $0x0
  pushl $9
  102111:	6a 09                	push   $0x9
  jmp __alltraps
  102113:	e9 86 ff ff ff       	jmp    10209e <__alltraps>

00102118 <vector10>:
.globl vector10
vector10:
  pushl $10
  102118:	6a 0a                	push   $0xa
  jmp __alltraps
  10211a:	e9 7f ff ff ff       	jmp    10209e <__alltraps>

0010211f <vector11>:
.globl vector11
vector11:
  pushl $11
  10211f:	6a 0b                	push   $0xb
  jmp __alltraps
  102121:	e9 78 ff ff ff       	jmp    10209e <__alltraps>

00102126 <vector12>:
.globl vector12
vector12:
  pushl $12
  102126:	6a 0c                	push   $0xc
  jmp __alltraps
  102128:	e9 71 ff ff ff       	jmp    10209e <__alltraps>

0010212d <vector13>:
.globl vector13
vector13:
  pushl $13
  10212d:	6a 0d                	push   $0xd
  jmp __alltraps
  10212f:	e9 6a ff ff ff       	jmp    10209e <__alltraps>

00102134 <vector14>:
.globl vector14
vector14:
  pushl $14
  102134:	6a 0e                	push   $0xe
  jmp __alltraps
  102136:	e9 63 ff ff ff       	jmp    10209e <__alltraps>

0010213b <vector15>:
.globl vector15
vector15:
  pushl $0
  10213b:	6a 00                	push   $0x0
  pushl $15
  10213d:	6a 0f                	push   $0xf
  jmp __alltraps
  10213f:	e9 5a ff ff ff       	jmp    10209e <__alltraps>

00102144 <vector16>:
.globl vector16
vector16:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $16
  102146:	6a 10                	push   $0x10
  jmp __alltraps
  102148:	e9 51 ff ff ff       	jmp    10209e <__alltraps>

0010214d <vector17>:
.globl vector17
vector17:
  pushl $17
  10214d:	6a 11                	push   $0x11
  jmp __alltraps
  10214f:	e9 4a ff ff ff       	jmp    10209e <__alltraps>

00102154 <vector18>:
.globl vector18
vector18:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $18
  102156:	6a 12                	push   $0x12
  jmp __alltraps
  102158:	e9 41 ff ff ff       	jmp    10209e <__alltraps>

0010215d <vector19>:
.globl vector19
vector19:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $19
  10215f:	6a 13                	push   $0x13
  jmp __alltraps
  102161:	e9 38 ff ff ff       	jmp    10209e <__alltraps>

00102166 <vector20>:
.globl vector20
vector20:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $20
  102168:	6a 14                	push   $0x14
  jmp __alltraps
  10216a:	e9 2f ff ff ff       	jmp    10209e <__alltraps>

0010216f <vector21>:
.globl vector21
vector21:
  pushl $0
  10216f:	6a 00                	push   $0x0
  pushl $21
  102171:	6a 15                	push   $0x15
  jmp __alltraps
  102173:	e9 26 ff ff ff       	jmp    10209e <__alltraps>

00102178 <vector22>:
.globl vector22
vector22:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $22
  10217a:	6a 16                	push   $0x16
  jmp __alltraps
  10217c:	e9 1d ff ff ff       	jmp    10209e <__alltraps>

00102181 <vector23>:
.globl vector23
vector23:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $23
  102183:	6a 17                	push   $0x17
  jmp __alltraps
  102185:	e9 14 ff ff ff       	jmp    10209e <__alltraps>

0010218a <vector24>:
.globl vector24
vector24:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $24
  10218c:	6a 18                	push   $0x18
  jmp __alltraps
  10218e:	e9 0b ff ff ff       	jmp    10209e <__alltraps>

00102193 <vector25>:
.globl vector25
vector25:
  pushl $0
  102193:	6a 00                	push   $0x0
  pushl $25
  102195:	6a 19                	push   $0x19
  jmp __alltraps
  102197:	e9 02 ff ff ff       	jmp    10209e <__alltraps>

0010219c <vector26>:
.globl vector26
vector26:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $26
  10219e:	6a 1a                	push   $0x1a
  jmp __alltraps
  1021a0:	e9 f9 fe ff ff       	jmp    10209e <__alltraps>

001021a5 <vector27>:
.globl vector27
vector27:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $27
  1021a7:	6a 1b                	push   $0x1b
  jmp __alltraps
  1021a9:	e9 f0 fe ff ff       	jmp    10209e <__alltraps>

001021ae <vector28>:
.globl vector28
vector28:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $28
  1021b0:	6a 1c                	push   $0x1c
  jmp __alltraps
  1021b2:	e9 e7 fe ff ff       	jmp    10209e <__alltraps>

001021b7 <vector29>:
.globl vector29
vector29:
  pushl $0
  1021b7:	6a 00                	push   $0x0
  pushl $29
  1021b9:	6a 1d                	push   $0x1d
  jmp __alltraps
  1021bb:	e9 de fe ff ff       	jmp    10209e <__alltraps>

001021c0 <vector30>:
.globl vector30
vector30:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $30
  1021c2:	6a 1e                	push   $0x1e
  jmp __alltraps
  1021c4:	e9 d5 fe ff ff       	jmp    10209e <__alltraps>

001021c9 <vector31>:
.globl vector31
vector31:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $31
  1021cb:	6a 1f                	push   $0x1f
  jmp __alltraps
  1021cd:	e9 cc fe ff ff       	jmp    10209e <__alltraps>

001021d2 <vector32>:
.globl vector32
vector32:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $32
  1021d4:	6a 20                	push   $0x20
  jmp __alltraps
  1021d6:	e9 c3 fe ff ff       	jmp    10209e <__alltraps>

001021db <vector33>:
.globl vector33
vector33:
  pushl $0
  1021db:	6a 00                	push   $0x0
  pushl $33
  1021dd:	6a 21                	push   $0x21
  jmp __alltraps
  1021df:	e9 ba fe ff ff       	jmp    10209e <__alltraps>

001021e4 <vector34>:
.globl vector34
vector34:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $34
  1021e6:	6a 22                	push   $0x22
  jmp __alltraps
  1021e8:	e9 b1 fe ff ff       	jmp    10209e <__alltraps>

001021ed <vector35>:
.globl vector35
vector35:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $35
  1021ef:	6a 23                	push   $0x23
  jmp __alltraps
  1021f1:	e9 a8 fe ff ff       	jmp    10209e <__alltraps>

001021f6 <vector36>:
.globl vector36
vector36:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $36
  1021f8:	6a 24                	push   $0x24
  jmp __alltraps
  1021fa:	e9 9f fe ff ff       	jmp    10209e <__alltraps>

001021ff <vector37>:
.globl vector37
vector37:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $37
  102201:	6a 25                	push   $0x25
  jmp __alltraps
  102203:	e9 96 fe ff ff       	jmp    10209e <__alltraps>

00102208 <vector38>:
.globl vector38
vector38:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $38
  10220a:	6a 26                	push   $0x26
  jmp __alltraps
  10220c:	e9 8d fe ff ff       	jmp    10209e <__alltraps>

00102211 <vector39>:
.globl vector39
vector39:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $39
  102213:	6a 27                	push   $0x27
  jmp __alltraps
  102215:	e9 84 fe ff ff       	jmp    10209e <__alltraps>

0010221a <vector40>:
.globl vector40
vector40:
  pushl $0
  10221a:	6a 00                	push   $0x0
  pushl $40
  10221c:	6a 28                	push   $0x28
  jmp __alltraps
  10221e:	e9 7b fe ff ff       	jmp    10209e <__alltraps>

00102223 <vector41>:
.globl vector41
vector41:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $41
  102225:	6a 29                	push   $0x29
  jmp __alltraps
  102227:	e9 72 fe ff ff       	jmp    10209e <__alltraps>

0010222c <vector42>:
.globl vector42
vector42:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $42
  10222e:	6a 2a                	push   $0x2a
  jmp __alltraps
  102230:	e9 69 fe ff ff       	jmp    10209e <__alltraps>

00102235 <vector43>:
.globl vector43
vector43:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $43
  102237:	6a 2b                	push   $0x2b
  jmp __alltraps
  102239:	e9 60 fe ff ff       	jmp    10209e <__alltraps>

0010223e <vector44>:
.globl vector44
vector44:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $44
  102240:	6a 2c                	push   $0x2c
  jmp __alltraps
  102242:	e9 57 fe ff ff       	jmp    10209e <__alltraps>

00102247 <vector45>:
.globl vector45
vector45:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $45
  102249:	6a 2d                	push   $0x2d
  jmp __alltraps
  10224b:	e9 4e fe ff ff       	jmp    10209e <__alltraps>

00102250 <vector46>:
.globl vector46
vector46:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $46
  102252:	6a 2e                	push   $0x2e
  jmp __alltraps
  102254:	e9 45 fe ff ff       	jmp    10209e <__alltraps>

00102259 <vector47>:
.globl vector47
vector47:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $47
  10225b:	6a 2f                	push   $0x2f
  jmp __alltraps
  10225d:	e9 3c fe ff ff       	jmp    10209e <__alltraps>

00102262 <vector48>:
.globl vector48
vector48:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $48
  102264:	6a 30                	push   $0x30
  jmp __alltraps
  102266:	e9 33 fe ff ff       	jmp    10209e <__alltraps>

0010226b <vector49>:
.globl vector49
vector49:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $49
  10226d:	6a 31                	push   $0x31
  jmp __alltraps
  10226f:	e9 2a fe ff ff       	jmp    10209e <__alltraps>

00102274 <vector50>:
.globl vector50
vector50:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $50
  102276:	6a 32                	push   $0x32
  jmp __alltraps
  102278:	e9 21 fe ff ff       	jmp    10209e <__alltraps>

0010227d <vector51>:
.globl vector51
vector51:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $51
  10227f:	6a 33                	push   $0x33
  jmp __alltraps
  102281:	e9 18 fe ff ff       	jmp    10209e <__alltraps>

00102286 <vector52>:
.globl vector52
vector52:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $52
  102288:	6a 34                	push   $0x34
  jmp __alltraps
  10228a:	e9 0f fe ff ff       	jmp    10209e <__alltraps>

0010228f <vector53>:
.globl vector53
vector53:
  pushl $0
  10228f:	6a 00                	push   $0x0
  pushl $53
  102291:	6a 35                	push   $0x35
  jmp __alltraps
  102293:	e9 06 fe ff ff       	jmp    10209e <__alltraps>

00102298 <vector54>:
.globl vector54
vector54:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $54
  10229a:	6a 36                	push   $0x36
  jmp __alltraps
  10229c:	e9 fd fd ff ff       	jmp    10209e <__alltraps>

001022a1 <vector55>:
.globl vector55
vector55:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $55
  1022a3:	6a 37                	push   $0x37
  jmp __alltraps
  1022a5:	e9 f4 fd ff ff       	jmp    10209e <__alltraps>

001022aa <vector56>:
.globl vector56
vector56:
  pushl $0
  1022aa:	6a 00                	push   $0x0
  pushl $56
  1022ac:	6a 38                	push   $0x38
  jmp __alltraps
  1022ae:	e9 eb fd ff ff       	jmp    10209e <__alltraps>

001022b3 <vector57>:
.globl vector57
vector57:
  pushl $0
  1022b3:	6a 00                	push   $0x0
  pushl $57
  1022b5:	6a 39                	push   $0x39
  jmp __alltraps
  1022b7:	e9 e2 fd ff ff       	jmp    10209e <__alltraps>

001022bc <vector58>:
.globl vector58
vector58:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $58
  1022be:	6a 3a                	push   $0x3a
  jmp __alltraps
  1022c0:	e9 d9 fd ff ff       	jmp    10209e <__alltraps>

001022c5 <vector59>:
.globl vector59
vector59:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $59
  1022c7:	6a 3b                	push   $0x3b
  jmp __alltraps
  1022c9:	e9 d0 fd ff ff       	jmp    10209e <__alltraps>

001022ce <vector60>:
.globl vector60
vector60:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $60
  1022d0:	6a 3c                	push   $0x3c
  jmp __alltraps
  1022d2:	e9 c7 fd ff ff       	jmp    10209e <__alltraps>

001022d7 <vector61>:
.globl vector61
vector61:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $61
  1022d9:	6a 3d                	push   $0x3d
  jmp __alltraps
  1022db:	e9 be fd ff ff       	jmp    10209e <__alltraps>

001022e0 <vector62>:
.globl vector62
vector62:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $62
  1022e2:	6a 3e                	push   $0x3e
  jmp __alltraps
  1022e4:	e9 b5 fd ff ff       	jmp    10209e <__alltraps>

001022e9 <vector63>:
.globl vector63
vector63:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $63
  1022eb:	6a 3f                	push   $0x3f
  jmp __alltraps
  1022ed:	e9 ac fd ff ff       	jmp    10209e <__alltraps>

001022f2 <vector64>:
.globl vector64
vector64:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $64
  1022f4:	6a 40                	push   $0x40
  jmp __alltraps
  1022f6:	e9 a3 fd ff ff       	jmp    10209e <__alltraps>

001022fb <vector65>:
.globl vector65
vector65:
  pushl $0
  1022fb:	6a 00                	push   $0x0
  pushl $65
  1022fd:	6a 41                	push   $0x41
  jmp __alltraps
  1022ff:	e9 9a fd ff ff       	jmp    10209e <__alltraps>

00102304 <vector66>:
.globl vector66
vector66:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $66
  102306:	6a 42                	push   $0x42
  jmp __alltraps
  102308:	e9 91 fd ff ff       	jmp    10209e <__alltraps>

0010230d <vector67>:
.globl vector67
vector67:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $67
  10230f:	6a 43                	push   $0x43
  jmp __alltraps
  102311:	e9 88 fd ff ff       	jmp    10209e <__alltraps>

00102316 <vector68>:
.globl vector68
vector68:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $68
  102318:	6a 44                	push   $0x44
  jmp __alltraps
  10231a:	e9 7f fd ff ff       	jmp    10209e <__alltraps>

0010231f <vector69>:
.globl vector69
vector69:
  pushl $0
  10231f:	6a 00                	push   $0x0
  pushl $69
  102321:	6a 45                	push   $0x45
  jmp __alltraps
  102323:	e9 76 fd ff ff       	jmp    10209e <__alltraps>

00102328 <vector70>:
.globl vector70
vector70:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $70
  10232a:	6a 46                	push   $0x46
  jmp __alltraps
  10232c:	e9 6d fd ff ff       	jmp    10209e <__alltraps>

00102331 <vector71>:
.globl vector71
vector71:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $71
  102333:	6a 47                	push   $0x47
  jmp __alltraps
  102335:	e9 64 fd ff ff       	jmp    10209e <__alltraps>

0010233a <vector72>:
.globl vector72
vector72:
  pushl $0
  10233a:	6a 00                	push   $0x0
  pushl $72
  10233c:	6a 48                	push   $0x48
  jmp __alltraps
  10233e:	e9 5b fd ff ff       	jmp    10209e <__alltraps>

00102343 <vector73>:
.globl vector73
vector73:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $73
  102345:	6a 49                	push   $0x49
  jmp __alltraps
  102347:	e9 52 fd ff ff       	jmp    10209e <__alltraps>

0010234c <vector74>:
.globl vector74
vector74:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $74
  10234e:	6a 4a                	push   $0x4a
  jmp __alltraps
  102350:	e9 49 fd ff ff       	jmp    10209e <__alltraps>

00102355 <vector75>:
.globl vector75
vector75:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $75
  102357:	6a 4b                	push   $0x4b
  jmp __alltraps
  102359:	e9 40 fd ff ff       	jmp    10209e <__alltraps>

0010235e <vector76>:
.globl vector76
vector76:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $76
  102360:	6a 4c                	push   $0x4c
  jmp __alltraps
  102362:	e9 37 fd ff ff       	jmp    10209e <__alltraps>

00102367 <vector77>:
.globl vector77
vector77:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $77
  102369:	6a 4d                	push   $0x4d
  jmp __alltraps
  10236b:	e9 2e fd ff ff       	jmp    10209e <__alltraps>

00102370 <vector78>:
.globl vector78
vector78:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $78
  102372:	6a 4e                	push   $0x4e
  jmp __alltraps
  102374:	e9 25 fd ff ff       	jmp    10209e <__alltraps>

00102379 <vector79>:
.globl vector79
vector79:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $79
  10237b:	6a 4f                	push   $0x4f
  jmp __alltraps
  10237d:	e9 1c fd ff ff       	jmp    10209e <__alltraps>

00102382 <vector80>:
.globl vector80
vector80:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $80
  102384:	6a 50                	push   $0x50
  jmp __alltraps
  102386:	e9 13 fd ff ff       	jmp    10209e <__alltraps>

0010238b <vector81>:
.globl vector81
vector81:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $81
  10238d:	6a 51                	push   $0x51
  jmp __alltraps
  10238f:	e9 0a fd ff ff       	jmp    10209e <__alltraps>

00102394 <vector82>:
.globl vector82
vector82:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $82
  102396:	6a 52                	push   $0x52
  jmp __alltraps
  102398:	e9 01 fd ff ff       	jmp    10209e <__alltraps>

0010239d <vector83>:
.globl vector83
vector83:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $83
  10239f:	6a 53                	push   $0x53
  jmp __alltraps
  1023a1:	e9 f8 fc ff ff       	jmp    10209e <__alltraps>

001023a6 <vector84>:
.globl vector84
vector84:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $84
  1023a8:	6a 54                	push   $0x54
  jmp __alltraps
  1023aa:	e9 ef fc ff ff       	jmp    10209e <__alltraps>

001023af <vector85>:
.globl vector85
vector85:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $85
  1023b1:	6a 55                	push   $0x55
  jmp __alltraps
  1023b3:	e9 e6 fc ff ff       	jmp    10209e <__alltraps>

001023b8 <vector86>:
.globl vector86
vector86:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $86
  1023ba:	6a 56                	push   $0x56
  jmp __alltraps
  1023bc:	e9 dd fc ff ff       	jmp    10209e <__alltraps>

001023c1 <vector87>:
.globl vector87
vector87:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $87
  1023c3:	6a 57                	push   $0x57
  jmp __alltraps
  1023c5:	e9 d4 fc ff ff       	jmp    10209e <__alltraps>

001023ca <vector88>:
.globl vector88
vector88:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $88
  1023cc:	6a 58                	push   $0x58
  jmp __alltraps
  1023ce:	e9 cb fc ff ff       	jmp    10209e <__alltraps>

001023d3 <vector89>:
.globl vector89
vector89:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $89
  1023d5:	6a 59                	push   $0x59
  jmp __alltraps
  1023d7:	e9 c2 fc ff ff       	jmp    10209e <__alltraps>

001023dc <vector90>:
.globl vector90
vector90:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $90
  1023de:	6a 5a                	push   $0x5a
  jmp __alltraps
  1023e0:	e9 b9 fc ff ff       	jmp    10209e <__alltraps>

001023e5 <vector91>:
.globl vector91
vector91:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $91
  1023e7:	6a 5b                	push   $0x5b
  jmp __alltraps
  1023e9:	e9 b0 fc ff ff       	jmp    10209e <__alltraps>

001023ee <vector92>:
.globl vector92
vector92:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $92
  1023f0:	6a 5c                	push   $0x5c
  jmp __alltraps
  1023f2:	e9 a7 fc ff ff       	jmp    10209e <__alltraps>

001023f7 <vector93>:
.globl vector93
vector93:
  pushl $0
  1023f7:	6a 00                	push   $0x0
  pushl $93
  1023f9:	6a 5d                	push   $0x5d
  jmp __alltraps
  1023fb:	e9 9e fc ff ff       	jmp    10209e <__alltraps>

00102400 <vector94>:
.globl vector94
vector94:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $94
  102402:	6a 5e                	push   $0x5e
  jmp __alltraps
  102404:	e9 95 fc ff ff       	jmp    10209e <__alltraps>

00102409 <vector95>:
.globl vector95
vector95:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $95
  10240b:	6a 5f                	push   $0x5f
  jmp __alltraps
  10240d:	e9 8c fc ff ff       	jmp    10209e <__alltraps>

00102412 <vector96>:
.globl vector96
vector96:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $96
  102414:	6a 60                	push   $0x60
  jmp __alltraps
  102416:	e9 83 fc ff ff       	jmp    10209e <__alltraps>

0010241b <vector97>:
.globl vector97
vector97:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $97
  10241d:	6a 61                	push   $0x61
  jmp __alltraps
  10241f:	e9 7a fc ff ff       	jmp    10209e <__alltraps>

00102424 <vector98>:
.globl vector98
vector98:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $98
  102426:	6a 62                	push   $0x62
  jmp __alltraps
  102428:	e9 71 fc ff ff       	jmp    10209e <__alltraps>

0010242d <vector99>:
.globl vector99
vector99:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $99
  10242f:	6a 63                	push   $0x63
  jmp __alltraps
  102431:	e9 68 fc ff ff       	jmp    10209e <__alltraps>

00102436 <vector100>:
.globl vector100
vector100:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $100
  102438:	6a 64                	push   $0x64
  jmp __alltraps
  10243a:	e9 5f fc ff ff       	jmp    10209e <__alltraps>

0010243f <vector101>:
.globl vector101
vector101:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $101
  102441:	6a 65                	push   $0x65
  jmp __alltraps
  102443:	e9 56 fc ff ff       	jmp    10209e <__alltraps>

00102448 <vector102>:
.globl vector102
vector102:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $102
  10244a:	6a 66                	push   $0x66
  jmp __alltraps
  10244c:	e9 4d fc ff ff       	jmp    10209e <__alltraps>

00102451 <vector103>:
.globl vector103
vector103:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $103
  102453:	6a 67                	push   $0x67
  jmp __alltraps
  102455:	e9 44 fc ff ff       	jmp    10209e <__alltraps>

0010245a <vector104>:
.globl vector104
vector104:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $104
  10245c:	6a 68                	push   $0x68
  jmp __alltraps
  10245e:	e9 3b fc ff ff       	jmp    10209e <__alltraps>

00102463 <vector105>:
.globl vector105
vector105:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $105
  102465:	6a 69                	push   $0x69
  jmp __alltraps
  102467:	e9 32 fc ff ff       	jmp    10209e <__alltraps>

0010246c <vector106>:
.globl vector106
vector106:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $106
  10246e:	6a 6a                	push   $0x6a
  jmp __alltraps
  102470:	e9 29 fc ff ff       	jmp    10209e <__alltraps>

00102475 <vector107>:
.globl vector107
vector107:
  pushl $0
  102475:	6a 00                	push   $0x0
  pushl $107
  102477:	6a 6b                	push   $0x6b
  jmp __alltraps
  102479:	e9 20 fc ff ff       	jmp    10209e <__alltraps>

0010247e <vector108>:
.globl vector108
vector108:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $108
  102480:	6a 6c                	push   $0x6c
  jmp __alltraps
  102482:	e9 17 fc ff ff       	jmp    10209e <__alltraps>

00102487 <vector109>:
.globl vector109
vector109:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $109
  102489:	6a 6d                	push   $0x6d
  jmp __alltraps
  10248b:	e9 0e fc ff ff       	jmp    10209e <__alltraps>

00102490 <vector110>:
.globl vector110
vector110:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $110
  102492:	6a 6e                	push   $0x6e
  jmp __alltraps
  102494:	e9 05 fc ff ff       	jmp    10209e <__alltraps>

00102499 <vector111>:
.globl vector111
vector111:
  pushl $0
  102499:	6a 00                	push   $0x0
  pushl $111
  10249b:	6a 6f                	push   $0x6f
  jmp __alltraps
  10249d:	e9 fc fb ff ff       	jmp    10209e <__alltraps>

001024a2 <vector112>:
.globl vector112
vector112:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $112
  1024a4:	6a 70                	push   $0x70
  jmp __alltraps
  1024a6:	e9 f3 fb ff ff       	jmp    10209e <__alltraps>

001024ab <vector113>:
.globl vector113
vector113:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $113
  1024ad:	6a 71                	push   $0x71
  jmp __alltraps
  1024af:	e9 ea fb ff ff       	jmp    10209e <__alltraps>

001024b4 <vector114>:
.globl vector114
vector114:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $114
  1024b6:	6a 72                	push   $0x72
  jmp __alltraps
  1024b8:	e9 e1 fb ff ff       	jmp    10209e <__alltraps>

001024bd <vector115>:
.globl vector115
vector115:
  pushl $0
  1024bd:	6a 00                	push   $0x0
  pushl $115
  1024bf:	6a 73                	push   $0x73
  jmp __alltraps
  1024c1:	e9 d8 fb ff ff       	jmp    10209e <__alltraps>

001024c6 <vector116>:
.globl vector116
vector116:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $116
  1024c8:	6a 74                	push   $0x74
  jmp __alltraps
  1024ca:	e9 cf fb ff ff       	jmp    10209e <__alltraps>

001024cf <vector117>:
.globl vector117
vector117:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $117
  1024d1:	6a 75                	push   $0x75
  jmp __alltraps
  1024d3:	e9 c6 fb ff ff       	jmp    10209e <__alltraps>

001024d8 <vector118>:
.globl vector118
vector118:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $118
  1024da:	6a 76                	push   $0x76
  jmp __alltraps
  1024dc:	e9 bd fb ff ff       	jmp    10209e <__alltraps>

001024e1 <vector119>:
.globl vector119
vector119:
  pushl $0
  1024e1:	6a 00                	push   $0x0
  pushl $119
  1024e3:	6a 77                	push   $0x77
  jmp __alltraps
  1024e5:	e9 b4 fb ff ff       	jmp    10209e <__alltraps>

001024ea <vector120>:
.globl vector120
vector120:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $120
  1024ec:	6a 78                	push   $0x78
  jmp __alltraps
  1024ee:	e9 ab fb ff ff       	jmp    10209e <__alltraps>

001024f3 <vector121>:
.globl vector121
vector121:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $121
  1024f5:	6a 79                	push   $0x79
  jmp __alltraps
  1024f7:	e9 a2 fb ff ff       	jmp    10209e <__alltraps>

001024fc <vector122>:
.globl vector122
vector122:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $122
  1024fe:	6a 7a                	push   $0x7a
  jmp __alltraps
  102500:	e9 99 fb ff ff       	jmp    10209e <__alltraps>

00102505 <vector123>:
.globl vector123
vector123:
  pushl $0
  102505:	6a 00                	push   $0x0
  pushl $123
  102507:	6a 7b                	push   $0x7b
  jmp __alltraps
  102509:	e9 90 fb ff ff       	jmp    10209e <__alltraps>

0010250e <vector124>:
.globl vector124
vector124:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $124
  102510:	6a 7c                	push   $0x7c
  jmp __alltraps
  102512:	e9 87 fb ff ff       	jmp    10209e <__alltraps>

00102517 <vector125>:
.globl vector125
vector125:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $125
  102519:	6a 7d                	push   $0x7d
  jmp __alltraps
  10251b:	e9 7e fb ff ff       	jmp    10209e <__alltraps>

00102520 <vector126>:
.globl vector126
vector126:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $126
  102522:	6a 7e                	push   $0x7e
  jmp __alltraps
  102524:	e9 75 fb ff ff       	jmp    10209e <__alltraps>

00102529 <vector127>:
.globl vector127
vector127:
  pushl $0
  102529:	6a 00                	push   $0x0
  pushl $127
  10252b:	6a 7f                	push   $0x7f
  jmp __alltraps
  10252d:	e9 6c fb ff ff       	jmp    10209e <__alltraps>

00102532 <vector128>:
.globl vector128
vector128:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $128
  102534:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102539:	e9 60 fb ff ff       	jmp    10209e <__alltraps>

0010253e <vector129>:
.globl vector129
vector129:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $129
  102540:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102545:	e9 54 fb ff ff       	jmp    10209e <__alltraps>

0010254a <vector130>:
.globl vector130
vector130:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $130
  10254c:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102551:	e9 48 fb ff ff       	jmp    10209e <__alltraps>

00102556 <vector131>:
.globl vector131
vector131:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $131
  102558:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10255d:	e9 3c fb ff ff       	jmp    10209e <__alltraps>

00102562 <vector132>:
.globl vector132
vector132:
  pushl $0
  102562:	6a 00                	push   $0x0
  pushl $132
  102564:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102569:	e9 30 fb ff ff       	jmp    10209e <__alltraps>

0010256e <vector133>:
.globl vector133
vector133:
  pushl $0
  10256e:	6a 00                	push   $0x0
  pushl $133
  102570:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102575:	e9 24 fb ff ff       	jmp    10209e <__alltraps>

0010257a <vector134>:
.globl vector134
vector134:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $134
  10257c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102581:	e9 18 fb ff ff       	jmp    10209e <__alltraps>

00102586 <vector135>:
.globl vector135
vector135:
  pushl $0
  102586:	6a 00                	push   $0x0
  pushl $135
  102588:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10258d:	e9 0c fb ff ff       	jmp    10209e <__alltraps>

00102592 <vector136>:
.globl vector136
vector136:
  pushl $0
  102592:	6a 00                	push   $0x0
  pushl $136
  102594:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102599:	e9 00 fb ff ff       	jmp    10209e <__alltraps>

0010259e <vector137>:
.globl vector137
vector137:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $137
  1025a0:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1025a5:	e9 f4 fa ff ff       	jmp    10209e <__alltraps>

001025aa <vector138>:
.globl vector138
vector138:
  pushl $0
  1025aa:	6a 00                	push   $0x0
  pushl $138
  1025ac:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1025b1:	e9 e8 fa ff ff       	jmp    10209e <__alltraps>

001025b6 <vector139>:
.globl vector139
vector139:
  pushl $0
  1025b6:	6a 00                	push   $0x0
  pushl $139
  1025b8:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1025bd:	e9 dc fa ff ff       	jmp    10209e <__alltraps>

001025c2 <vector140>:
.globl vector140
vector140:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $140
  1025c4:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1025c9:	e9 d0 fa ff ff       	jmp    10209e <__alltraps>

001025ce <vector141>:
.globl vector141
vector141:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $141
  1025d0:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1025d5:	e9 c4 fa ff ff       	jmp    10209e <__alltraps>

001025da <vector142>:
.globl vector142
vector142:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $142
  1025dc:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1025e1:	e9 b8 fa ff ff       	jmp    10209e <__alltraps>

001025e6 <vector143>:
.globl vector143
vector143:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $143
  1025e8:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1025ed:	e9 ac fa ff ff       	jmp    10209e <__alltraps>

001025f2 <vector144>:
.globl vector144
vector144:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $144
  1025f4:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1025f9:	e9 a0 fa ff ff       	jmp    10209e <__alltraps>

001025fe <vector145>:
.globl vector145
vector145:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $145
  102600:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102605:	e9 94 fa ff ff       	jmp    10209e <__alltraps>

0010260a <vector146>:
.globl vector146
vector146:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $146
  10260c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102611:	e9 88 fa ff ff       	jmp    10209e <__alltraps>

00102616 <vector147>:
.globl vector147
vector147:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $147
  102618:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10261d:	e9 7c fa ff ff       	jmp    10209e <__alltraps>

00102622 <vector148>:
.globl vector148
vector148:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $148
  102624:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102629:	e9 70 fa ff ff       	jmp    10209e <__alltraps>

0010262e <vector149>:
.globl vector149
vector149:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $149
  102630:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102635:	e9 64 fa ff ff       	jmp    10209e <__alltraps>

0010263a <vector150>:
.globl vector150
vector150:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $150
  10263c:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102641:	e9 58 fa ff ff       	jmp    10209e <__alltraps>

00102646 <vector151>:
.globl vector151
vector151:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $151
  102648:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10264d:	e9 4c fa ff ff       	jmp    10209e <__alltraps>

00102652 <vector152>:
.globl vector152
vector152:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $152
  102654:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102659:	e9 40 fa ff ff       	jmp    10209e <__alltraps>

0010265e <vector153>:
.globl vector153
vector153:
  pushl $0
  10265e:	6a 00                	push   $0x0
  pushl $153
  102660:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102665:	e9 34 fa ff ff       	jmp    10209e <__alltraps>

0010266a <vector154>:
.globl vector154
vector154:
  pushl $0
  10266a:	6a 00                	push   $0x0
  pushl $154
  10266c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102671:	e9 28 fa ff ff       	jmp    10209e <__alltraps>

00102676 <vector155>:
.globl vector155
vector155:
  pushl $0
  102676:	6a 00                	push   $0x0
  pushl $155
  102678:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10267d:	e9 1c fa ff ff       	jmp    10209e <__alltraps>

00102682 <vector156>:
.globl vector156
vector156:
  pushl $0
  102682:	6a 00                	push   $0x0
  pushl $156
  102684:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102689:	e9 10 fa ff ff       	jmp    10209e <__alltraps>

0010268e <vector157>:
.globl vector157
vector157:
  pushl $0
  10268e:	6a 00                	push   $0x0
  pushl $157
  102690:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102695:	e9 04 fa ff ff       	jmp    10209e <__alltraps>

0010269a <vector158>:
.globl vector158
vector158:
  pushl $0
  10269a:	6a 00                	push   $0x0
  pushl $158
  10269c:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1026a1:	e9 f8 f9 ff ff       	jmp    10209e <__alltraps>

001026a6 <vector159>:
.globl vector159
vector159:
  pushl $0
  1026a6:	6a 00                	push   $0x0
  pushl $159
  1026a8:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1026ad:	e9 ec f9 ff ff       	jmp    10209e <__alltraps>

001026b2 <vector160>:
.globl vector160
vector160:
  pushl $0
  1026b2:	6a 00                	push   $0x0
  pushl $160
  1026b4:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1026b9:	e9 e0 f9 ff ff       	jmp    10209e <__alltraps>

001026be <vector161>:
.globl vector161
vector161:
  pushl $0
  1026be:	6a 00                	push   $0x0
  pushl $161
  1026c0:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1026c5:	e9 d4 f9 ff ff       	jmp    10209e <__alltraps>

001026ca <vector162>:
.globl vector162
vector162:
  pushl $0
  1026ca:	6a 00                	push   $0x0
  pushl $162
  1026cc:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1026d1:	e9 c8 f9 ff ff       	jmp    10209e <__alltraps>

001026d6 <vector163>:
.globl vector163
vector163:
  pushl $0
  1026d6:	6a 00                	push   $0x0
  pushl $163
  1026d8:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1026dd:	e9 bc f9 ff ff       	jmp    10209e <__alltraps>

001026e2 <vector164>:
.globl vector164
vector164:
  pushl $0
  1026e2:	6a 00                	push   $0x0
  pushl $164
  1026e4:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1026e9:	e9 b0 f9 ff ff       	jmp    10209e <__alltraps>

001026ee <vector165>:
.globl vector165
vector165:
  pushl $0
  1026ee:	6a 00                	push   $0x0
  pushl $165
  1026f0:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1026f5:	e9 a4 f9 ff ff       	jmp    10209e <__alltraps>

001026fa <vector166>:
.globl vector166
vector166:
  pushl $0
  1026fa:	6a 00                	push   $0x0
  pushl $166
  1026fc:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102701:	e9 98 f9 ff ff       	jmp    10209e <__alltraps>

00102706 <vector167>:
.globl vector167
vector167:
  pushl $0
  102706:	6a 00                	push   $0x0
  pushl $167
  102708:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10270d:	e9 8c f9 ff ff       	jmp    10209e <__alltraps>

00102712 <vector168>:
.globl vector168
vector168:
  pushl $0
  102712:	6a 00                	push   $0x0
  pushl $168
  102714:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102719:	e9 80 f9 ff ff       	jmp    10209e <__alltraps>

0010271e <vector169>:
.globl vector169
vector169:
  pushl $0
  10271e:	6a 00                	push   $0x0
  pushl $169
  102720:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102725:	e9 74 f9 ff ff       	jmp    10209e <__alltraps>

0010272a <vector170>:
.globl vector170
vector170:
  pushl $0
  10272a:	6a 00                	push   $0x0
  pushl $170
  10272c:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102731:	e9 68 f9 ff ff       	jmp    10209e <__alltraps>

00102736 <vector171>:
.globl vector171
vector171:
  pushl $0
  102736:	6a 00                	push   $0x0
  pushl $171
  102738:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10273d:	e9 5c f9 ff ff       	jmp    10209e <__alltraps>

00102742 <vector172>:
.globl vector172
vector172:
  pushl $0
  102742:	6a 00                	push   $0x0
  pushl $172
  102744:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102749:	e9 50 f9 ff ff       	jmp    10209e <__alltraps>

0010274e <vector173>:
.globl vector173
vector173:
  pushl $0
  10274e:	6a 00                	push   $0x0
  pushl $173
  102750:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102755:	e9 44 f9 ff ff       	jmp    10209e <__alltraps>

0010275a <vector174>:
.globl vector174
vector174:
  pushl $0
  10275a:	6a 00                	push   $0x0
  pushl $174
  10275c:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102761:	e9 38 f9 ff ff       	jmp    10209e <__alltraps>

00102766 <vector175>:
.globl vector175
vector175:
  pushl $0
  102766:	6a 00                	push   $0x0
  pushl $175
  102768:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10276d:	e9 2c f9 ff ff       	jmp    10209e <__alltraps>

00102772 <vector176>:
.globl vector176
vector176:
  pushl $0
  102772:	6a 00                	push   $0x0
  pushl $176
  102774:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102779:	e9 20 f9 ff ff       	jmp    10209e <__alltraps>

0010277e <vector177>:
.globl vector177
vector177:
  pushl $0
  10277e:	6a 00                	push   $0x0
  pushl $177
  102780:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102785:	e9 14 f9 ff ff       	jmp    10209e <__alltraps>

0010278a <vector178>:
.globl vector178
vector178:
  pushl $0
  10278a:	6a 00                	push   $0x0
  pushl $178
  10278c:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102791:	e9 08 f9 ff ff       	jmp    10209e <__alltraps>

00102796 <vector179>:
.globl vector179
vector179:
  pushl $0
  102796:	6a 00                	push   $0x0
  pushl $179
  102798:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10279d:	e9 fc f8 ff ff       	jmp    10209e <__alltraps>

001027a2 <vector180>:
.globl vector180
vector180:
  pushl $0
  1027a2:	6a 00                	push   $0x0
  pushl $180
  1027a4:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1027a9:	e9 f0 f8 ff ff       	jmp    10209e <__alltraps>

001027ae <vector181>:
.globl vector181
vector181:
  pushl $0
  1027ae:	6a 00                	push   $0x0
  pushl $181
  1027b0:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1027b5:	e9 e4 f8 ff ff       	jmp    10209e <__alltraps>

001027ba <vector182>:
.globl vector182
vector182:
  pushl $0
  1027ba:	6a 00                	push   $0x0
  pushl $182
  1027bc:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1027c1:	e9 d8 f8 ff ff       	jmp    10209e <__alltraps>

001027c6 <vector183>:
.globl vector183
vector183:
  pushl $0
  1027c6:	6a 00                	push   $0x0
  pushl $183
  1027c8:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1027cd:	e9 cc f8 ff ff       	jmp    10209e <__alltraps>

001027d2 <vector184>:
.globl vector184
vector184:
  pushl $0
  1027d2:	6a 00                	push   $0x0
  pushl $184
  1027d4:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1027d9:	e9 c0 f8 ff ff       	jmp    10209e <__alltraps>

001027de <vector185>:
.globl vector185
vector185:
  pushl $0
  1027de:	6a 00                	push   $0x0
  pushl $185
  1027e0:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1027e5:	e9 b4 f8 ff ff       	jmp    10209e <__alltraps>

001027ea <vector186>:
.globl vector186
vector186:
  pushl $0
  1027ea:	6a 00                	push   $0x0
  pushl $186
  1027ec:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1027f1:	e9 a8 f8 ff ff       	jmp    10209e <__alltraps>

001027f6 <vector187>:
.globl vector187
vector187:
  pushl $0
  1027f6:	6a 00                	push   $0x0
  pushl $187
  1027f8:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1027fd:	e9 9c f8 ff ff       	jmp    10209e <__alltraps>

00102802 <vector188>:
.globl vector188
vector188:
  pushl $0
  102802:	6a 00                	push   $0x0
  pushl $188
  102804:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102809:	e9 90 f8 ff ff       	jmp    10209e <__alltraps>

0010280e <vector189>:
.globl vector189
vector189:
  pushl $0
  10280e:	6a 00                	push   $0x0
  pushl $189
  102810:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102815:	e9 84 f8 ff ff       	jmp    10209e <__alltraps>

0010281a <vector190>:
.globl vector190
vector190:
  pushl $0
  10281a:	6a 00                	push   $0x0
  pushl $190
  10281c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102821:	e9 78 f8 ff ff       	jmp    10209e <__alltraps>

00102826 <vector191>:
.globl vector191
vector191:
  pushl $0
  102826:	6a 00                	push   $0x0
  pushl $191
  102828:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10282d:	e9 6c f8 ff ff       	jmp    10209e <__alltraps>

00102832 <vector192>:
.globl vector192
vector192:
  pushl $0
  102832:	6a 00                	push   $0x0
  pushl $192
  102834:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102839:	e9 60 f8 ff ff       	jmp    10209e <__alltraps>

0010283e <vector193>:
.globl vector193
vector193:
  pushl $0
  10283e:	6a 00                	push   $0x0
  pushl $193
  102840:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102845:	e9 54 f8 ff ff       	jmp    10209e <__alltraps>

0010284a <vector194>:
.globl vector194
vector194:
  pushl $0
  10284a:	6a 00                	push   $0x0
  pushl $194
  10284c:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102851:	e9 48 f8 ff ff       	jmp    10209e <__alltraps>

00102856 <vector195>:
.globl vector195
vector195:
  pushl $0
  102856:	6a 00                	push   $0x0
  pushl $195
  102858:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10285d:	e9 3c f8 ff ff       	jmp    10209e <__alltraps>

00102862 <vector196>:
.globl vector196
vector196:
  pushl $0
  102862:	6a 00                	push   $0x0
  pushl $196
  102864:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102869:	e9 30 f8 ff ff       	jmp    10209e <__alltraps>

0010286e <vector197>:
.globl vector197
vector197:
  pushl $0
  10286e:	6a 00                	push   $0x0
  pushl $197
  102870:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102875:	e9 24 f8 ff ff       	jmp    10209e <__alltraps>

0010287a <vector198>:
.globl vector198
vector198:
  pushl $0
  10287a:	6a 00                	push   $0x0
  pushl $198
  10287c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102881:	e9 18 f8 ff ff       	jmp    10209e <__alltraps>

00102886 <vector199>:
.globl vector199
vector199:
  pushl $0
  102886:	6a 00                	push   $0x0
  pushl $199
  102888:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10288d:	e9 0c f8 ff ff       	jmp    10209e <__alltraps>

00102892 <vector200>:
.globl vector200
vector200:
  pushl $0
  102892:	6a 00                	push   $0x0
  pushl $200
  102894:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102899:	e9 00 f8 ff ff       	jmp    10209e <__alltraps>

0010289e <vector201>:
.globl vector201
vector201:
  pushl $0
  10289e:	6a 00                	push   $0x0
  pushl $201
  1028a0:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1028a5:	e9 f4 f7 ff ff       	jmp    10209e <__alltraps>

001028aa <vector202>:
.globl vector202
vector202:
  pushl $0
  1028aa:	6a 00                	push   $0x0
  pushl $202
  1028ac:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1028b1:	e9 e8 f7 ff ff       	jmp    10209e <__alltraps>

001028b6 <vector203>:
.globl vector203
vector203:
  pushl $0
  1028b6:	6a 00                	push   $0x0
  pushl $203
  1028b8:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1028bd:	e9 dc f7 ff ff       	jmp    10209e <__alltraps>

001028c2 <vector204>:
.globl vector204
vector204:
  pushl $0
  1028c2:	6a 00                	push   $0x0
  pushl $204
  1028c4:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1028c9:	e9 d0 f7 ff ff       	jmp    10209e <__alltraps>

001028ce <vector205>:
.globl vector205
vector205:
  pushl $0
  1028ce:	6a 00                	push   $0x0
  pushl $205
  1028d0:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1028d5:	e9 c4 f7 ff ff       	jmp    10209e <__alltraps>

001028da <vector206>:
.globl vector206
vector206:
  pushl $0
  1028da:	6a 00                	push   $0x0
  pushl $206
  1028dc:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1028e1:	e9 b8 f7 ff ff       	jmp    10209e <__alltraps>

001028e6 <vector207>:
.globl vector207
vector207:
  pushl $0
  1028e6:	6a 00                	push   $0x0
  pushl $207
  1028e8:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1028ed:	e9 ac f7 ff ff       	jmp    10209e <__alltraps>

001028f2 <vector208>:
.globl vector208
vector208:
  pushl $0
  1028f2:	6a 00                	push   $0x0
  pushl $208
  1028f4:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1028f9:	e9 a0 f7 ff ff       	jmp    10209e <__alltraps>

001028fe <vector209>:
.globl vector209
vector209:
  pushl $0
  1028fe:	6a 00                	push   $0x0
  pushl $209
  102900:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102905:	e9 94 f7 ff ff       	jmp    10209e <__alltraps>

0010290a <vector210>:
.globl vector210
vector210:
  pushl $0
  10290a:	6a 00                	push   $0x0
  pushl $210
  10290c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102911:	e9 88 f7 ff ff       	jmp    10209e <__alltraps>

00102916 <vector211>:
.globl vector211
vector211:
  pushl $0
  102916:	6a 00                	push   $0x0
  pushl $211
  102918:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10291d:	e9 7c f7 ff ff       	jmp    10209e <__alltraps>

00102922 <vector212>:
.globl vector212
vector212:
  pushl $0
  102922:	6a 00                	push   $0x0
  pushl $212
  102924:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102929:	e9 70 f7 ff ff       	jmp    10209e <__alltraps>

0010292e <vector213>:
.globl vector213
vector213:
  pushl $0
  10292e:	6a 00                	push   $0x0
  pushl $213
  102930:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102935:	e9 64 f7 ff ff       	jmp    10209e <__alltraps>

0010293a <vector214>:
.globl vector214
vector214:
  pushl $0
  10293a:	6a 00                	push   $0x0
  pushl $214
  10293c:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102941:	e9 58 f7 ff ff       	jmp    10209e <__alltraps>

00102946 <vector215>:
.globl vector215
vector215:
  pushl $0
  102946:	6a 00                	push   $0x0
  pushl $215
  102948:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10294d:	e9 4c f7 ff ff       	jmp    10209e <__alltraps>

00102952 <vector216>:
.globl vector216
vector216:
  pushl $0
  102952:	6a 00                	push   $0x0
  pushl $216
  102954:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102959:	e9 40 f7 ff ff       	jmp    10209e <__alltraps>

0010295e <vector217>:
.globl vector217
vector217:
  pushl $0
  10295e:	6a 00                	push   $0x0
  pushl $217
  102960:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102965:	e9 34 f7 ff ff       	jmp    10209e <__alltraps>

0010296a <vector218>:
.globl vector218
vector218:
  pushl $0
  10296a:	6a 00                	push   $0x0
  pushl $218
  10296c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102971:	e9 28 f7 ff ff       	jmp    10209e <__alltraps>

00102976 <vector219>:
.globl vector219
vector219:
  pushl $0
  102976:	6a 00                	push   $0x0
  pushl $219
  102978:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10297d:	e9 1c f7 ff ff       	jmp    10209e <__alltraps>

00102982 <vector220>:
.globl vector220
vector220:
  pushl $0
  102982:	6a 00                	push   $0x0
  pushl $220
  102984:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102989:	e9 10 f7 ff ff       	jmp    10209e <__alltraps>

0010298e <vector221>:
.globl vector221
vector221:
  pushl $0
  10298e:	6a 00                	push   $0x0
  pushl $221
  102990:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102995:	e9 04 f7 ff ff       	jmp    10209e <__alltraps>

0010299a <vector222>:
.globl vector222
vector222:
  pushl $0
  10299a:	6a 00                	push   $0x0
  pushl $222
  10299c:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1029a1:	e9 f8 f6 ff ff       	jmp    10209e <__alltraps>

001029a6 <vector223>:
.globl vector223
vector223:
  pushl $0
  1029a6:	6a 00                	push   $0x0
  pushl $223
  1029a8:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1029ad:	e9 ec f6 ff ff       	jmp    10209e <__alltraps>

001029b2 <vector224>:
.globl vector224
vector224:
  pushl $0
  1029b2:	6a 00                	push   $0x0
  pushl $224
  1029b4:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1029b9:	e9 e0 f6 ff ff       	jmp    10209e <__alltraps>

001029be <vector225>:
.globl vector225
vector225:
  pushl $0
  1029be:	6a 00                	push   $0x0
  pushl $225
  1029c0:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1029c5:	e9 d4 f6 ff ff       	jmp    10209e <__alltraps>

001029ca <vector226>:
.globl vector226
vector226:
  pushl $0
  1029ca:	6a 00                	push   $0x0
  pushl $226
  1029cc:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1029d1:	e9 c8 f6 ff ff       	jmp    10209e <__alltraps>

001029d6 <vector227>:
.globl vector227
vector227:
  pushl $0
  1029d6:	6a 00                	push   $0x0
  pushl $227
  1029d8:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1029dd:	e9 bc f6 ff ff       	jmp    10209e <__alltraps>

001029e2 <vector228>:
.globl vector228
vector228:
  pushl $0
  1029e2:	6a 00                	push   $0x0
  pushl $228
  1029e4:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1029e9:	e9 b0 f6 ff ff       	jmp    10209e <__alltraps>

001029ee <vector229>:
.globl vector229
vector229:
  pushl $0
  1029ee:	6a 00                	push   $0x0
  pushl $229
  1029f0:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1029f5:	e9 a4 f6 ff ff       	jmp    10209e <__alltraps>

001029fa <vector230>:
.globl vector230
vector230:
  pushl $0
  1029fa:	6a 00                	push   $0x0
  pushl $230
  1029fc:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102a01:	e9 98 f6 ff ff       	jmp    10209e <__alltraps>

00102a06 <vector231>:
.globl vector231
vector231:
  pushl $0
  102a06:	6a 00                	push   $0x0
  pushl $231
  102a08:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102a0d:	e9 8c f6 ff ff       	jmp    10209e <__alltraps>

00102a12 <vector232>:
.globl vector232
vector232:
  pushl $0
  102a12:	6a 00                	push   $0x0
  pushl $232
  102a14:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102a19:	e9 80 f6 ff ff       	jmp    10209e <__alltraps>

00102a1e <vector233>:
.globl vector233
vector233:
  pushl $0
  102a1e:	6a 00                	push   $0x0
  pushl $233
  102a20:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102a25:	e9 74 f6 ff ff       	jmp    10209e <__alltraps>

00102a2a <vector234>:
.globl vector234
vector234:
  pushl $0
  102a2a:	6a 00                	push   $0x0
  pushl $234
  102a2c:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102a31:	e9 68 f6 ff ff       	jmp    10209e <__alltraps>

00102a36 <vector235>:
.globl vector235
vector235:
  pushl $0
  102a36:	6a 00                	push   $0x0
  pushl $235
  102a38:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102a3d:	e9 5c f6 ff ff       	jmp    10209e <__alltraps>

00102a42 <vector236>:
.globl vector236
vector236:
  pushl $0
  102a42:	6a 00                	push   $0x0
  pushl $236
  102a44:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102a49:	e9 50 f6 ff ff       	jmp    10209e <__alltraps>

00102a4e <vector237>:
.globl vector237
vector237:
  pushl $0
  102a4e:	6a 00                	push   $0x0
  pushl $237
  102a50:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102a55:	e9 44 f6 ff ff       	jmp    10209e <__alltraps>

00102a5a <vector238>:
.globl vector238
vector238:
  pushl $0
  102a5a:	6a 00                	push   $0x0
  pushl $238
  102a5c:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102a61:	e9 38 f6 ff ff       	jmp    10209e <__alltraps>

00102a66 <vector239>:
.globl vector239
vector239:
  pushl $0
  102a66:	6a 00                	push   $0x0
  pushl $239
  102a68:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102a6d:	e9 2c f6 ff ff       	jmp    10209e <__alltraps>

00102a72 <vector240>:
.globl vector240
vector240:
  pushl $0
  102a72:	6a 00                	push   $0x0
  pushl $240
  102a74:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102a79:	e9 20 f6 ff ff       	jmp    10209e <__alltraps>

00102a7e <vector241>:
.globl vector241
vector241:
  pushl $0
  102a7e:	6a 00                	push   $0x0
  pushl $241
  102a80:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102a85:	e9 14 f6 ff ff       	jmp    10209e <__alltraps>

00102a8a <vector242>:
.globl vector242
vector242:
  pushl $0
  102a8a:	6a 00                	push   $0x0
  pushl $242
  102a8c:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102a91:	e9 08 f6 ff ff       	jmp    10209e <__alltraps>

00102a96 <vector243>:
.globl vector243
vector243:
  pushl $0
  102a96:	6a 00                	push   $0x0
  pushl $243
  102a98:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102a9d:	e9 fc f5 ff ff       	jmp    10209e <__alltraps>

00102aa2 <vector244>:
.globl vector244
vector244:
  pushl $0
  102aa2:	6a 00                	push   $0x0
  pushl $244
  102aa4:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102aa9:	e9 f0 f5 ff ff       	jmp    10209e <__alltraps>

00102aae <vector245>:
.globl vector245
vector245:
  pushl $0
  102aae:	6a 00                	push   $0x0
  pushl $245
  102ab0:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102ab5:	e9 e4 f5 ff ff       	jmp    10209e <__alltraps>

00102aba <vector246>:
.globl vector246
vector246:
  pushl $0
  102aba:	6a 00                	push   $0x0
  pushl $246
  102abc:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102ac1:	e9 d8 f5 ff ff       	jmp    10209e <__alltraps>

00102ac6 <vector247>:
.globl vector247
vector247:
  pushl $0
  102ac6:	6a 00                	push   $0x0
  pushl $247
  102ac8:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102acd:	e9 cc f5 ff ff       	jmp    10209e <__alltraps>

00102ad2 <vector248>:
.globl vector248
vector248:
  pushl $0
  102ad2:	6a 00                	push   $0x0
  pushl $248
  102ad4:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102ad9:	e9 c0 f5 ff ff       	jmp    10209e <__alltraps>

00102ade <vector249>:
.globl vector249
vector249:
  pushl $0
  102ade:	6a 00                	push   $0x0
  pushl $249
  102ae0:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102ae5:	e9 b4 f5 ff ff       	jmp    10209e <__alltraps>

00102aea <vector250>:
.globl vector250
vector250:
  pushl $0
  102aea:	6a 00                	push   $0x0
  pushl $250
  102aec:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102af1:	e9 a8 f5 ff ff       	jmp    10209e <__alltraps>

00102af6 <vector251>:
.globl vector251
vector251:
  pushl $0
  102af6:	6a 00                	push   $0x0
  pushl $251
  102af8:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102afd:	e9 9c f5 ff ff       	jmp    10209e <__alltraps>

00102b02 <vector252>:
.globl vector252
vector252:
  pushl $0
  102b02:	6a 00                	push   $0x0
  pushl $252
  102b04:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102b09:	e9 90 f5 ff ff       	jmp    10209e <__alltraps>

00102b0e <vector253>:
.globl vector253
vector253:
  pushl $0
  102b0e:	6a 00                	push   $0x0
  pushl $253
  102b10:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102b15:	e9 84 f5 ff ff       	jmp    10209e <__alltraps>

00102b1a <vector254>:
.globl vector254
vector254:
  pushl $0
  102b1a:	6a 00                	push   $0x0
  pushl $254
  102b1c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102b21:	e9 78 f5 ff ff       	jmp    10209e <__alltraps>

00102b26 <vector255>:
.globl vector255
vector255:
  pushl $0
  102b26:	6a 00                	push   $0x0
  pushl $255
  102b28:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102b2d:	e9 6c f5 ff ff       	jmp    10209e <__alltraps>

00102b32 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102b32:	55                   	push   %ebp
  102b33:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102b35:	8b 55 08             	mov    0x8(%ebp),%edx
  102b38:	a1 e0 af 11 00       	mov    0x11afe0,%eax
  102b3d:	29 c2                	sub    %eax,%edx
  102b3f:	89 d0                	mov    %edx,%eax
  102b41:	c1 f8 02             	sar    $0x2,%eax
  102b44:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102b4a:	5d                   	pop    %ebp
  102b4b:	c3                   	ret    

00102b4c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102b4c:	55                   	push   %ebp
  102b4d:	89 e5                	mov    %esp,%ebp
  102b4f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102b52:	8b 45 08             	mov    0x8(%ebp),%eax
  102b55:	89 04 24             	mov    %eax,(%esp)
  102b58:	e8 d5 ff ff ff       	call   102b32 <page2ppn>
  102b5d:	c1 e0 0c             	shl    $0xc,%eax
}
  102b60:	c9                   	leave  
  102b61:	c3                   	ret    

00102b62 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102b62:	55                   	push   %ebp
  102b63:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102b65:	8b 45 08             	mov    0x8(%ebp),%eax
  102b68:	8b 00                	mov    (%eax),%eax
}
  102b6a:	5d                   	pop    %ebp
  102b6b:	c3                   	ret    

00102b6c <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102b6c:	55                   	push   %ebp
  102b6d:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b72:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b75:	89 10                	mov    %edx,(%eax)
}
  102b77:	5d                   	pop    %ebp
  102b78:	c3                   	ret    

00102b79 <default_init>:

#define free_list (free_area.free_list)  // list itself
#define nr_free (free_area.nr_free)  // remaining capacity

static void
default_init(void) {
  102b79:	55                   	push   %ebp
  102b7a:	89 e5                	mov    %esp,%ebp
  102b7c:	83 ec 10             	sub    $0x10,%esp
  102b7f:	c7 45 fc cc af 11 00 	movl   $0x11afcc,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102b86:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b89:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102b8c:	89 50 04             	mov    %edx,0x4(%eax)
  102b8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b92:	8b 50 04             	mov    0x4(%eax),%edx
  102b95:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b98:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  102b9a:	c7 05 d4 af 11 00 00 	movl   $0x0,0x11afd4
  102ba1:	00 00 00 
}
  102ba4:	c9                   	leave  
  102ba5:	c3                   	ret    

00102ba6 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102ba6:	55                   	push   %ebp
  102ba7:	89 e5                	mov    %esp,%ebp
  102ba9:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);  // make sure n > 0
  102bac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bb0:	75 24                	jne    102bd6 <default_init_memmap+0x30>
  102bb2:	c7 44 24 0c 90 68 10 	movl   $0x106890,0xc(%esp)
  102bb9:	00 
  102bba:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  102bc1:	00 
  102bc2:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  102bc9:	00 
  102bca:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  102bd1:	e8 1d e1 ff ff       	call   100cf3 <__panic>
    struct Page *p = base;  // create a backup of base pointer
  102bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {  // allocate new physical page
  102bdc:	eb 7d                	jmp    102c5b <default_init_memmap+0xb5>
        assert(PageReserved(p));  // make sure this page is not a reserved page
  102bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102be1:	83 c0 04             	add    $0x4,%eax
  102be4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102beb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102bee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bf1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102bf4:	0f a3 10             	bt     %edx,(%eax)
  102bf7:	19 c0                	sbb    %eax,%eax
  102bf9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102bfc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c00:	0f 95 c0             	setne  %al
  102c03:	0f b6 c0             	movzbl %al,%eax
  102c06:	85 c0                	test   %eax,%eax
  102c08:	75 24                	jne    102c2e <default_init_memmap+0x88>
  102c0a:	c7 44 24 0c c1 68 10 	movl   $0x1068c1,0xc(%esp)
  102c11:	00 
  102c12:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  102c19:	00 
  102c1a:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  102c21:	00 
  102c22:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  102c29:	e8 c5 e0 ff ff       	call   100cf3 <__panic>
        p->flags = p->property = 0;  // clear the flags
  102c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c3b:	8b 50 08             	mov    0x8(%eax),%edx
  102c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c41:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);  // clear the number of this page's reference
  102c44:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102c4b:	00 
  102c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c4f:	89 04 24             	mov    %eax,(%esp)
  102c52:	e8 15 ff ff ff       	call   102b6c <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);  // make sure n > 0
    struct Page *p = base;  // create a backup of base pointer
    for (; p != base + n; p ++) {  // allocate new physical page
  102c57:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c5e:	89 d0                	mov    %edx,%eax
  102c60:	c1 e0 02             	shl    $0x2,%eax
  102c63:	01 d0                	add    %edx,%eax
  102c65:	c1 e0 02             	shl    $0x2,%eax
  102c68:	89 c2                	mov    %eax,%edx
  102c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6d:	01 d0                	add    %edx,%eax
  102c6f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102c72:	0f 85 66 ff ff ff    	jne    102bde <default_init_memmap+0x38>
        assert(PageReserved(p));  // make sure this page is not a reserved page
        p->flags = p->property = 0;  // clear the flags
        set_page_ref(p, 0);  // clear the number of this page's reference
    }
    base->property = n;  // set the property
  102c78:	8b 45 08             	mov    0x8(%ebp),%eax
  102c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c7e:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);  // let it can be used
  102c81:	8b 45 08             	mov    0x8(%ebp),%eax
  102c84:	83 c0 04             	add    $0x4,%eax
  102c87:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102c8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c94:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102c97:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;  // calculate the total nr_free
  102c9a:	8b 15 d4 af 11 00    	mov    0x11afd4,%edx
  102ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ca3:	01 d0                	add    %edx,%eax
  102ca5:	a3 d4 af 11 00       	mov    %eax,0x11afd4
    list_add_before(&free_list, &(base->page_link));  // follow the FF
  102caa:	8b 45 08             	mov    0x8(%ebp),%eax
  102cad:	83 c0 0c             	add    $0xc,%eax
  102cb0:	c7 45 dc cc af 11 00 	movl   $0x11afcc,-0x24(%ebp)
  102cb7:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102cba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cbd:	8b 00                	mov    (%eax),%eax
  102cbf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102cc2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102cc5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102cc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ccb:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102cce:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cd1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102cd4:	89 10                	mov    %edx,(%eax)
  102cd6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102cd9:	8b 10                	mov    (%eax),%edx
  102cdb:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102cde:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102ce1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102ce4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102ce7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102cea:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102ced:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102cf0:	89 10                	mov    %edx,(%eax)
}
  102cf2:	c9                   	leave  
  102cf3:	c3                   	ret    

00102cf4 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102cf4:	55                   	push   %ebp
  102cf5:	89 e5                	mov    %esp,%ebp
  102cf7:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);  // make sure n > 0
  102cfa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102cfe:	75 24                	jne    102d24 <default_alloc_pages+0x30>
  102d00:	c7 44 24 0c 90 68 10 	movl   $0x106890,0xc(%esp)
  102d07:	00 
  102d08:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  102d0f:	00 
  102d10:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  102d17:	00 
  102d18:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  102d1f:	e8 cf df ff ff       	call   100cf3 <__panic>
    if (n > nr_free) {  // full
  102d24:	a1 d4 af 11 00       	mov    0x11afd4,%eax
  102d29:	3b 45 08             	cmp    0x8(%ebp),%eax
  102d2c:	73 0a                	jae    102d38 <default_alloc_pages+0x44>
        return NULL;
  102d2e:	b8 00 00 00 00       	mov    $0x0,%eax
  102d33:	e9 49 01 00 00       	jmp    102e81 <default_alloc_pages+0x18d>
    }
    struct Page *page = NULL;
  102d38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102d3f:	c7 45 f0 cc af 11 00 	movl   $0x11afcc,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {  // double cycled list
  102d46:	eb 1c                	jmp    102d64 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d4b:	83 e8 0c             	sub    $0xc,%eax
  102d4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {  // divide this page to two parts
  102d51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d54:	8b 40 08             	mov    0x8(%eax),%eax
  102d57:	3b 45 08             	cmp    0x8(%ebp),%eax
  102d5a:	72 08                	jb     102d64 <default_alloc_pages+0x70>
            page = p;
  102d5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102d62:	eb 18                	jmp    102d7c <default_alloc_pages+0x88>
  102d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102d6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d6d:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {  // full
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {  // double cycled list
  102d70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d73:	81 7d f0 cc af 11 00 	cmpl   $0x11afcc,-0x10(%ebp)
  102d7a:	75 cc                	jne    102d48 <default_alloc_pages+0x54>
        if (p->property >= n) {  // divide this page to two parts
            page = p;
            break;
        }
    }
    if (page != NULL) {
  102d7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102d80:	0f 84 f8 00 00 00    	je     102e7e <default_alloc_pages+0x18a>
        if (page->property > n) {
  102d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d89:	8b 40 08             	mov    0x8(%eax),%eax
  102d8c:	3b 45 08             	cmp    0x8(%ebp),%eax
  102d8f:	0f 86 98 00 00 00    	jbe    102e2d <default_alloc_pages+0x139>
            struct Page *p = page + n;
  102d95:	8b 55 08             	mov    0x8(%ebp),%edx
  102d98:	89 d0                	mov    %edx,%eax
  102d9a:	c1 e0 02             	shl    $0x2,%eax
  102d9d:	01 d0                	add    %edx,%eax
  102d9f:	c1 e0 02             	shl    $0x2,%eax
  102da2:	89 c2                	mov    %eax,%edx
  102da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102da7:	01 d0                	add    %edx,%eax
  102da9:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  102dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102daf:	8b 40 08             	mov    0x8(%eax),%eax
  102db2:	2b 45 08             	sub    0x8(%ebp),%eax
  102db5:	89 c2                	mov    %eax,%edx
  102db7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102dba:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  102dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102dc0:	83 c0 04             	add    $0x4,%eax
  102dc3:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102dca:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102dcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102dd0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102dd3:	0f ab 10             	bts    %edx,(%eax)
            list_add(&(page->page_link), &(p->page_link));
  102dd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102dd9:	83 c0 0c             	add    $0xc,%eax
  102ddc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ddf:	83 c2 0c             	add    $0xc,%edx
  102de2:	89 55 d8             	mov    %edx,-0x28(%ebp)
  102de5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102de8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102deb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102dee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102df1:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102df4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102df7:	8b 40 04             	mov    0x4(%eax),%eax
  102dfa:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102dfd:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102e00:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102e03:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102e06:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102e09:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102e0c:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102e0f:	89 10                	mov    %edx,(%eax)
  102e11:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102e14:	8b 10                	mov    (%eax),%edx
  102e16:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102e19:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102e1c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102e1f:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102e22:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102e25:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102e28:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102e2b:	89 10                	mov    %edx,(%eax)
        }
        list_del(&(page->page_link));
  102e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e30:	83 c0 0c             	add    $0xc,%eax
  102e33:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102e36:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102e39:	8b 40 04             	mov    0x4(%eax),%eax
  102e3c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102e3f:	8b 12                	mov    (%edx),%edx
  102e41:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102e44:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102e47:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102e4a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102e4d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102e50:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102e53:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102e56:	89 10                	mov    %edx,(%eax)
        nr_free -= n;
  102e58:	a1 d4 af 11 00       	mov    0x11afd4,%eax
  102e5d:	2b 45 08             	sub    0x8(%ebp),%eax
  102e60:	a3 d4 af 11 00       	mov    %eax,0x11afd4
        ClearPageProperty(page);
  102e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e68:	83 c0 04             	add    $0x4,%eax
  102e6b:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  102e72:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102e75:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102e78:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102e7b:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  102e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102e81:	c9                   	leave  
  102e82:	c3                   	ret    

00102e83 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102e83:	55                   	push   %ebp
  102e84:	89 e5                	mov    %esp,%ebp
  102e86:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  102e8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102e90:	75 24                	jne    102eb6 <default_free_pages+0x33>
  102e92:	c7 44 24 0c 90 68 10 	movl   $0x106890,0xc(%esp)
  102e99:	00 
  102e9a:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  102ea1:	00 
  102ea2:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
  102ea9:	00 
  102eaa:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  102eb1:	e8 3d de ff ff       	call   100cf3 <__panic>
    struct Page *p = base;
  102eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102ebc:	e9 9d 00 00 00       	jmp    102f5e <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  102ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ec4:	83 c0 04             	add    $0x4,%eax
  102ec7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102ece:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102ed1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ed4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102ed7:	0f a3 10             	bt     %edx,(%eax)
  102eda:	19 c0                	sbb    %eax,%eax
  102edc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102edf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102ee3:	0f 95 c0             	setne  %al
  102ee6:	0f b6 c0             	movzbl %al,%eax
  102ee9:	85 c0                	test   %eax,%eax
  102eeb:	75 2c                	jne    102f19 <default_free_pages+0x96>
  102eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ef0:	83 c0 04             	add    $0x4,%eax
  102ef3:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102efa:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102efd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f00:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102f03:	0f a3 10             	bt     %edx,(%eax)
  102f06:	19 c0                	sbb    %eax,%eax
  102f08:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  102f0b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102f0f:	0f 95 c0             	setne  %al
  102f12:	0f b6 c0             	movzbl %al,%eax
  102f15:	85 c0                	test   %eax,%eax
  102f17:	74 24                	je     102f3d <default_free_pages+0xba>
  102f19:	c7 44 24 0c d4 68 10 	movl   $0x1068d4,0xc(%esp)
  102f20:	00 
  102f21:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  102f28:	00 
  102f29:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  102f30:	00 
  102f31:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  102f38:	e8 b6 dd ff ff       	call   100cf3 <__panic>
        p->flags = 0;
  102f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102f47:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102f4e:	00 
  102f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f52:	89 04 24             	mov    %eax,(%esp)
  102f55:	e8 12 fc ff ff       	call   102b6c <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102f5a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102f5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f61:	89 d0                	mov    %edx,%eax
  102f63:	c1 e0 02             	shl    $0x2,%eax
  102f66:	01 d0                	add    %edx,%eax
  102f68:	c1 e0 02             	shl    $0x2,%eax
  102f6b:	89 c2                	mov    %eax,%edx
  102f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  102f70:	01 d0                	add    %edx,%eax
  102f72:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f75:	0f 85 46 ff ff ff    	jne    102ec1 <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f81:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102f84:	8b 45 08             	mov    0x8(%ebp),%eax
  102f87:	83 c0 04             	add    $0x4,%eax
  102f8a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102f91:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102f94:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f97:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f9a:	0f ab 10             	bts    %edx,(%eax)
  102f9d:	c7 45 cc cc af 11 00 	movl   $0x11afcc,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102fa4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102fa7:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102faa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102fad:	e9 08 01 00 00       	jmp    1030ba <default_free_pages+0x237>
        p = le2page(le, page_link);
  102fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fb5:	83 e8 0c             	sub    $0xc,%eax
  102fb8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102fbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fbe:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102fc1:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102fc4:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102fc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  102fca:	8b 45 08             	mov    0x8(%ebp),%eax
  102fcd:	8b 50 08             	mov    0x8(%eax),%edx
  102fd0:	89 d0                	mov    %edx,%eax
  102fd2:	c1 e0 02             	shl    $0x2,%eax
  102fd5:	01 d0                	add    %edx,%eax
  102fd7:	c1 e0 02             	shl    $0x2,%eax
  102fda:	89 c2                	mov    %eax,%edx
  102fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  102fdf:	01 d0                	add    %edx,%eax
  102fe1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102fe4:	75 5a                	jne    103040 <default_free_pages+0x1bd>
            base->property += p->property;
  102fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe9:	8b 50 08             	mov    0x8(%eax),%edx
  102fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fef:	8b 40 08             	mov    0x8(%eax),%eax
  102ff2:	01 c2                	add    %eax,%edx
  102ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff7:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ffd:	83 c0 04             	add    $0x4,%eax
  103000:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  103007:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10300a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10300d:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  103010:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  103013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103016:	83 c0 0c             	add    $0xc,%eax
  103019:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  10301c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10301f:	8b 40 04             	mov    0x4(%eax),%eax
  103022:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103025:	8b 12                	mov    (%edx),%edx
  103027:	89 55 b8             	mov    %edx,-0x48(%ebp)
  10302a:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  10302d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103030:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103033:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  103036:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103039:	8b 55 b8             	mov    -0x48(%ebp),%edx
  10303c:	89 10                	mov    %edx,(%eax)
  10303e:	eb 7a                	jmp    1030ba <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  103040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103043:	8b 50 08             	mov    0x8(%eax),%edx
  103046:	89 d0                	mov    %edx,%eax
  103048:	c1 e0 02             	shl    $0x2,%eax
  10304b:	01 d0                	add    %edx,%eax
  10304d:	c1 e0 02             	shl    $0x2,%eax
  103050:	89 c2                	mov    %eax,%edx
  103052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103055:	01 d0                	add    %edx,%eax
  103057:	3b 45 08             	cmp    0x8(%ebp),%eax
  10305a:	75 5e                	jne    1030ba <default_free_pages+0x237>
            p->property += base->property;
  10305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10305f:	8b 50 08             	mov    0x8(%eax),%edx
  103062:	8b 45 08             	mov    0x8(%ebp),%eax
  103065:	8b 40 08             	mov    0x8(%eax),%eax
  103068:	01 c2                	add    %eax,%edx
  10306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10306d:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  103070:	8b 45 08             	mov    0x8(%ebp),%eax
  103073:	83 c0 04             	add    $0x4,%eax
  103076:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  10307d:	89 45 ac             	mov    %eax,-0x54(%ebp)
  103080:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103083:	8b 55 b0             	mov    -0x50(%ebp),%edx
  103086:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  103089:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10308c:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  10308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103092:	83 c0 0c             	add    $0xc,%eax
  103095:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  103098:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10309b:	8b 40 04             	mov    0x4(%eax),%eax
  10309e:	8b 55 a8             	mov    -0x58(%ebp),%edx
  1030a1:	8b 12                	mov    (%edx),%edx
  1030a3:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  1030a6:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1030a9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  1030ac:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1030af:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1030b2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1030b5:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1030b8:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
  1030ba:	81 7d f0 cc af 11 00 	cmpl   $0x11afcc,-0x10(%ebp)
  1030c1:	0f 85 eb fe ff ff    	jne    102fb2 <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
  1030c7:	8b 15 d4 af 11 00    	mov    0x11afd4,%edx
  1030cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030d0:	01 d0                	add    %edx,%eax
  1030d2:	a3 d4 af 11 00       	mov    %eax,0x11afd4
  1030d7:	c7 45 9c cc af 11 00 	movl   $0x11afcc,-0x64(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1030de:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1030e1:	8b 40 04             	mov    0x4(%eax),%eax
    //list_add(&free_list, &(base->page_link));
    // 将空闲页面按地址大小插入至链表中
    for(le = list_next(&free_list); le != &free_list; le = list_next(le))
  1030e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030e7:	eb 76                	jmp    10315f <default_free_pages+0x2dc>
    {
        p = le2page(le, page_link);
  1030e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030ec:	83 e8 0c             	sub    $0xc,%eax
  1030ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
  1030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f5:	8b 50 08             	mov    0x8(%eax),%edx
  1030f8:	89 d0                	mov    %edx,%eax
  1030fa:	c1 e0 02             	shl    $0x2,%eax
  1030fd:	01 d0                	add    %edx,%eax
  1030ff:	c1 e0 02             	shl    $0x2,%eax
  103102:	89 c2                	mov    %eax,%edx
  103104:	8b 45 08             	mov    0x8(%ebp),%eax
  103107:	01 d0                	add    %edx,%eax
  103109:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10310c:	77 42                	ja     103150 <default_free_pages+0x2cd>
            assert(base + base->property != p);
  10310e:	8b 45 08             	mov    0x8(%ebp),%eax
  103111:	8b 50 08             	mov    0x8(%eax),%edx
  103114:	89 d0                	mov    %edx,%eax
  103116:	c1 e0 02             	shl    $0x2,%eax
  103119:	01 d0                	add    %edx,%eax
  10311b:	c1 e0 02             	shl    $0x2,%eax
  10311e:	89 c2                	mov    %eax,%edx
  103120:	8b 45 08             	mov    0x8(%ebp),%eax
  103123:	01 d0                	add    %edx,%eax
  103125:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103128:	75 24                	jne    10314e <default_free_pages+0x2cb>
  10312a:	c7 44 24 0c f9 68 10 	movl   $0x1068f9,0xc(%esp)
  103131:	00 
  103132:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103139:	00 
  10313a:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  103141:	00 
  103142:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103149:	e8 a5 db ff ff       	call   100cf3 <__panic>
            break;
  10314e:	eb 18                	jmp    103168 <default_free_pages+0x2e5>
  103150:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103153:	89 45 98             	mov    %eax,-0x68(%ebp)
  103156:	8b 45 98             	mov    -0x68(%ebp),%eax
  103159:	8b 40 04             	mov    0x4(%eax),%eax
        }
    }
    nr_free += n;
    //list_add(&free_list, &(base->page_link));
    // 将空闲页面按地址大小插入至链表中
    for(le = list_next(&free_list); le != &free_list; le = list_next(le))
  10315c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10315f:	81 7d f0 cc af 11 00 	cmpl   $0x11afcc,-0x10(%ebp)
  103166:	75 81                	jne    1030e9 <default_free_pages+0x266>
        if (base + base->property <= p) {
            assert(base + base->property != p);
            break;
        }
    }
    list_add_before(le, &(base->page_link));
  103168:	8b 45 08             	mov    0x8(%ebp),%eax
  10316b:	8d 50 0c             	lea    0xc(%eax),%edx
  10316e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103171:	89 45 94             	mov    %eax,-0x6c(%ebp)
  103174:	89 55 90             	mov    %edx,-0x70(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  103177:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10317a:	8b 00                	mov    (%eax),%eax
  10317c:	8b 55 90             	mov    -0x70(%ebp),%edx
  10317f:	89 55 8c             	mov    %edx,-0x74(%ebp)
  103182:	89 45 88             	mov    %eax,-0x78(%ebp)
  103185:	8b 45 94             	mov    -0x6c(%ebp),%eax
  103188:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  10318b:	8b 45 84             	mov    -0x7c(%ebp),%eax
  10318e:	8b 55 8c             	mov    -0x74(%ebp),%edx
  103191:	89 10                	mov    %edx,(%eax)
  103193:	8b 45 84             	mov    -0x7c(%ebp),%eax
  103196:	8b 10                	mov    (%eax),%edx
  103198:	8b 45 88             	mov    -0x78(%ebp),%eax
  10319b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10319e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1031a1:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1031a4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1031a7:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1031aa:	8b 55 88             	mov    -0x78(%ebp),%edx
  1031ad:	89 10                	mov    %edx,(%eax)
}
  1031af:	c9                   	leave  
  1031b0:	c3                   	ret    

001031b1 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  1031b1:	55                   	push   %ebp
  1031b2:	89 e5                	mov    %esp,%ebp
    return nr_free;
  1031b4:	a1 d4 af 11 00       	mov    0x11afd4,%eax
}
  1031b9:	5d                   	pop    %ebp
  1031ba:	c3                   	ret    

001031bb <basic_check>:

static void
basic_check(void) {
  1031bb:	55                   	push   %ebp
  1031bc:	89 e5                	mov    %esp,%ebp
  1031be:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  1031c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  1031d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031db:	e8 ce 0e 00 00       	call   1040ae <alloc_pages>
  1031e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1031e7:	75 24                	jne    10320d <basic_check+0x52>
  1031e9:	c7 44 24 0c 14 69 10 	movl   $0x106914,0xc(%esp)
  1031f0:	00 
  1031f1:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  1031f8:	00 
  1031f9:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  103200:	00 
  103201:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103208:	e8 e6 da ff ff       	call   100cf3 <__panic>
    assert((p1 = alloc_page()) != NULL);
  10320d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103214:	e8 95 0e 00 00       	call   1040ae <alloc_pages>
  103219:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10321c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103220:	75 24                	jne    103246 <basic_check+0x8b>
  103222:	c7 44 24 0c 30 69 10 	movl   $0x106930,0xc(%esp)
  103229:	00 
  10322a:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103231:	00 
  103232:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  103239:	00 
  10323a:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103241:	e8 ad da ff ff       	call   100cf3 <__panic>
    assert((p2 = alloc_page()) != NULL);
  103246:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10324d:	e8 5c 0e 00 00       	call   1040ae <alloc_pages>
  103252:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103255:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103259:	75 24                	jne    10327f <basic_check+0xc4>
  10325b:	c7 44 24 0c 4c 69 10 	movl   $0x10694c,0xc(%esp)
  103262:	00 
  103263:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  10326a:	00 
  10326b:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  103272:	00 
  103273:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  10327a:	e8 74 da ff ff       	call   100cf3 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  10327f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103282:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103285:	74 10                	je     103297 <basic_check+0xdc>
  103287:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10328a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10328d:	74 08                	je     103297 <basic_check+0xdc>
  10328f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103292:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103295:	75 24                	jne    1032bb <basic_check+0x100>
  103297:	c7 44 24 0c 68 69 10 	movl   $0x106968,0xc(%esp)
  10329e:	00 
  10329f:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  1032a6:	00 
  1032a7:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  1032ae:	00 
  1032af:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  1032b6:	e8 38 da ff ff       	call   100cf3 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  1032bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032be:	89 04 24             	mov    %eax,(%esp)
  1032c1:	e8 9c f8 ff ff       	call   102b62 <page_ref>
  1032c6:	85 c0                	test   %eax,%eax
  1032c8:	75 1e                	jne    1032e8 <basic_check+0x12d>
  1032ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032cd:	89 04 24             	mov    %eax,(%esp)
  1032d0:	e8 8d f8 ff ff       	call   102b62 <page_ref>
  1032d5:	85 c0                	test   %eax,%eax
  1032d7:	75 0f                	jne    1032e8 <basic_check+0x12d>
  1032d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032dc:	89 04 24             	mov    %eax,(%esp)
  1032df:	e8 7e f8 ff ff       	call   102b62 <page_ref>
  1032e4:	85 c0                	test   %eax,%eax
  1032e6:	74 24                	je     10330c <basic_check+0x151>
  1032e8:	c7 44 24 0c 8c 69 10 	movl   $0x10698c,0xc(%esp)
  1032ef:	00 
  1032f0:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  1032f7:	00 
  1032f8:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  1032ff:	00 
  103300:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103307:	e8 e7 d9 ff ff       	call   100cf3 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  10330c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10330f:	89 04 24             	mov    %eax,(%esp)
  103312:	e8 35 f8 ff ff       	call   102b4c <page2pa>
  103317:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  10331d:	c1 e2 0c             	shl    $0xc,%edx
  103320:	39 d0                	cmp    %edx,%eax
  103322:	72 24                	jb     103348 <basic_check+0x18d>
  103324:	c7 44 24 0c c8 69 10 	movl   $0x1069c8,0xc(%esp)
  10332b:	00 
  10332c:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103333:	00 
  103334:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  10333b:	00 
  10333c:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103343:	e8 ab d9 ff ff       	call   100cf3 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  103348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10334b:	89 04 24             	mov    %eax,(%esp)
  10334e:	e8 f9 f7 ff ff       	call   102b4c <page2pa>
  103353:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  103359:	c1 e2 0c             	shl    $0xc,%edx
  10335c:	39 d0                	cmp    %edx,%eax
  10335e:	72 24                	jb     103384 <basic_check+0x1c9>
  103360:	c7 44 24 0c e5 69 10 	movl   $0x1069e5,0xc(%esp)
  103367:	00 
  103368:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  10336f:	00 
  103370:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  103377:	00 
  103378:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  10337f:	e8 6f d9 ff ff       	call   100cf3 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  103384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103387:	89 04 24             	mov    %eax,(%esp)
  10338a:	e8 bd f7 ff ff       	call   102b4c <page2pa>
  10338f:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  103395:	c1 e2 0c             	shl    $0xc,%edx
  103398:	39 d0                	cmp    %edx,%eax
  10339a:	72 24                	jb     1033c0 <basic_check+0x205>
  10339c:	c7 44 24 0c 02 6a 10 	movl   $0x106a02,0xc(%esp)
  1033a3:	00 
  1033a4:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  1033ab:	00 
  1033ac:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  1033b3:	00 
  1033b4:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  1033bb:	e8 33 d9 ff ff       	call   100cf3 <__panic>

    list_entry_t free_list_store = free_list;
  1033c0:	a1 cc af 11 00       	mov    0x11afcc,%eax
  1033c5:	8b 15 d0 af 11 00    	mov    0x11afd0,%edx
  1033cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1033ce:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1033d1:	c7 45 e0 cc af 11 00 	movl   $0x11afcc,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1033d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1033de:	89 50 04             	mov    %edx,0x4(%eax)
  1033e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033e4:	8b 50 04             	mov    0x4(%eax),%edx
  1033e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033ea:	89 10                	mov    %edx,(%eax)
  1033ec:	c7 45 dc cc af 11 00 	movl   $0x11afcc,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1033f3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1033f6:	8b 40 04             	mov    0x4(%eax),%eax
  1033f9:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1033fc:	0f 94 c0             	sete   %al
  1033ff:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103402:	85 c0                	test   %eax,%eax
  103404:	75 24                	jne    10342a <basic_check+0x26f>
  103406:	c7 44 24 0c 1f 6a 10 	movl   $0x106a1f,0xc(%esp)
  10340d:	00 
  10340e:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103415:	00 
  103416:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  10341d:	00 
  10341e:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103425:	e8 c9 d8 ff ff       	call   100cf3 <__panic>

    unsigned int nr_free_store = nr_free;
  10342a:	a1 d4 af 11 00       	mov    0x11afd4,%eax
  10342f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  103432:	c7 05 d4 af 11 00 00 	movl   $0x0,0x11afd4
  103439:	00 00 00 

    assert(alloc_page() == NULL);
  10343c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103443:	e8 66 0c 00 00       	call   1040ae <alloc_pages>
  103448:	85 c0                	test   %eax,%eax
  10344a:	74 24                	je     103470 <basic_check+0x2b5>
  10344c:	c7 44 24 0c 36 6a 10 	movl   $0x106a36,0xc(%esp)
  103453:	00 
  103454:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  10345b:	00 
  10345c:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103463:	00 
  103464:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  10346b:	e8 83 d8 ff ff       	call   100cf3 <__panic>

    free_page(p0);
  103470:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103477:	00 
  103478:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10347b:	89 04 24             	mov    %eax,(%esp)
  10347e:	e8 63 0c 00 00       	call   1040e6 <free_pages>
    free_page(p1);
  103483:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10348a:	00 
  10348b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10348e:	89 04 24             	mov    %eax,(%esp)
  103491:	e8 50 0c 00 00       	call   1040e6 <free_pages>
    free_page(p2);
  103496:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10349d:	00 
  10349e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034a1:	89 04 24             	mov    %eax,(%esp)
  1034a4:	e8 3d 0c 00 00       	call   1040e6 <free_pages>
    assert(nr_free == 3);
  1034a9:	a1 d4 af 11 00       	mov    0x11afd4,%eax
  1034ae:	83 f8 03             	cmp    $0x3,%eax
  1034b1:	74 24                	je     1034d7 <basic_check+0x31c>
  1034b3:	c7 44 24 0c 4b 6a 10 	movl   $0x106a4b,0xc(%esp)
  1034ba:	00 
  1034bb:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  1034c2:	00 
  1034c3:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  1034ca:	00 
  1034cb:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  1034d2:	e8 1c d8 ff ff       	call   100cf3 <__panic>

    assert((p0 = alloc_page()) != NULL);
  1034d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034de:	e8 cb 0b 00 00       	call   1040ae <alloc_pages>
  1034e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1034ea:	75 24                	jne    103510 <basic_check+0x355>
  1034ec:	c7 44 24 0c 14 69 10 	movl   $0x106914,0xc(%esp)
  1034f3:	00 
  1034f4:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  1034fb:	00 
  1034fc:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  103503:	00 
  103504:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  10350b:	e8 e3 d7 ff ff       	call   100cf3 <__panic>
    assert((p1 = alloc_page()) != NULL);
  103510:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103517:	e8 92 0b 00 00       	call   1040ae <alloc_pages>
  10351c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10351f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103523:	75 24                	jne    103549 <basic_check+0x38e>
  103525:	c7 44 24 0c 30 69 10 	movl   $0x106930,0xc(%esp)
  10352c:	00 
  10352d:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103534:	00 
  103535:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  10353c:	00 
  10353d:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103544:	e8 aa d7 ff ff       	call   100cf3 <__panic>
    assert((p2 = alloc_page()) != NULL);
  103549:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103550:	e8 59 0b 00 00       	call   1040ae <alloc_pages>
  103555:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103558:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10355c:	75 24                	jne    103582 <basic_check+0x3c7>
  10355e:	c7 44 24 0c 4c 69 10 	movl   $0x10694c,0xc(%esp)
  103565:	00 
  103566:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  10356d:	00 
  10356e:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  103575:	00 
  103576:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  10357d:	e8 71 d7 ff ff       	call   100cf3 <__panic>

    assert(alloc_page() == NULL);
  103582:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103589:	e8 20 0b 00 00       	call   1040ae <alloc_pages>
  10358e:	85 c0                	test   %eax,%eax
  103590:	74 24                	je     1035b6 <basic_check+0x3fb>
  103592:	c7 44 24 0c 36 6a 10 	movl   $0x106a36,0xc(%esp)
  103599:	00 
  10359a:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  1035a1:	00 
  1035a2:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  1035a9:	00 
  1035aa:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  1035b1:	e8 3d d7 ff ff       	call   100cf3 <__panic>

    free_page(p0);
  1035b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1035bd:	00 
  1035be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035c1:	89 04 24             	mov    %eax,(%esp)
  1035c4:	e8 1d 0b 00 00       	call   1040e6 <free_pages>
  1035c9:	c7 45 d8 cc af 11 00 	movl   $0x11afcc,-0x28(%ebp)
  1035d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1035d3:	8b 40 04             	mov    0x4(%eax),%eax
  1035d6:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1035d9:	0f 94 c0             	sete   %al
  1035dc:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1035df:	85 c0                	test   %eax,%eax
  1035e1:	74 24                	je     103607 <basic_check+0x44c>
  1035e3:	c7 44 24 0c 58 6a 10 	movl   $0x106a58,0xc(%esp)
  1035ea:	00 
  1035eb:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  1035f2:	00 
  1035f3:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  1035fa:	00 
  1035fb:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103602:	e8 ec d6 ff ff       	call   100cf3 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  103607:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10360e:	e8 9b 0a 00 00       	call   1040ae <alloc_pages>
  103613:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103619:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10361c:	74 24                	je     103642 <basic_check+0x487>
  10361e:	c7 44 24 0c 70 6a 10 	movl   $0x106a70,0xc(%esp)
  103625:	00 
  103626:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  10362d:	00 
  10362e:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  103635:	00 
  103636:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  10363d:	e8 b1 d6 ff ff       	call   100cf3 <__panic>
    assert(alloc_page() == NULL);
  103642:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103649:	e8 60 0a 00 00       	call   1040ae <alloc_pages>
  10364e:	85 c0                	test   %eax,%eax
  103650:	74 24                	je     103676 <basic_check+0x4bb>
  103652:	c7 44 24 0c 36 6a 10 	movl   $0x106a36,0xc(%esp)
  103659:	00 
  10365a:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103661:	00 
  103662:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  103669:	00 
  10366a:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103671:	e8 7d d6 ff ff       	call   100cf3 <__panic>

    assert(nr_free == 0);
  103676:	a1 d4 af 11 00       	mov    0x11afd4,%eax
  10367b:	85 c0                	test   %eax,%eax
  10367d:	74 24                	je     1036a3 <basic_check+0x4e8>
  10367f:	c7 44 24 0c 89 6a 10 	movl   $0x106a89,0xc(%esp)
  103686:	00 
  103687:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  10368e:	00 
  10368f:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  103696:	00 
  103697:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  10369e:	e8 50 d6 ff ff       	call   100cf3 <__panic>
    free_list = free_list_store;
  1036a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1036a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1036a9:	a3 cc af 11 00       	mov    %eax,0x11afcc
  1036ae:	89 15 d0 af 11 00    	mov    %edx,0x11afd0
    nr_free = nr_free_store;
  1036b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1036b7:	a3 d4 af 11 00       	mov    %eax,0x11afd4

    free_page(p);
  1036bc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036c3:	00 
  1036c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036c7:	89 04 24             	mov    %eax,(%esp)
  1036ca:	e8 17 0a 00 00       	call   1040e6 <free_pages>
    free_page(p1);
  1036cf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036d6:	00 
  1036d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036da:	89 04 24             	mov    %eax,(%esp)
  1036dd:	e8 04 0a 00 00       	call   1040e6 <free_pages>
    free_page(p2);
  1036e2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036e9:	00 
  1036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036ed:	89 04 24             	mov    %eax,(%esp)
  1036f0:	e8 f1 09 00 00       	call   1040e6 <free_pages>
}
  1036f5:	c9                   	leave  
  1036f6:	c3                   	ret    

001036f7 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1036f7:	55                   	push   %ebp
  1036f8:	89 e5                	mov    %esp,%ebp
  1036fa:	53                   	push   %ebx
  1036fb:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  103701:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103708:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  10370f:	c7 45 ec cc af 11 00 	movl   $0x11afcc,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103716:	eb 6b                	jmp    103783 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  103718:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10371b:	83 e8 0c             	sub    $0xc,%eax
  10371e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  103721:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103724:	83 c0 04             	add    $0x4,%eax
  103727:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10372e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103731:	8b 45 cc             	mov    -0x34(%ebp),%eax
  103734:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103737:	0f a3 10             	bt     %edx,(%eax)
  10373a:	19 c0                	sbb    %eax,%eax
  10373c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  10373f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  103743:	0f 95 c0             	setne  %al
  103746:	0f b6 c0             	movzbl %al,%eax
  103749:	85 c0                	test   %eax,%eax
  10374b:	75 24                	jne    103771 <default_check+0x7a>
  10374d:	c7 44 24 0c 96 6a 10 	movl   $0x106a96,0xc(%esp)
  103754:	00 
  103755:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  10375c:	00 
  10375d:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  103764:	00 
  103765:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  10376c:	e8 82 d5 ff ff       	call   100cf3 <__panic>
        count ++, total += p->property;
  103771:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103775:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103778:	8b 50 08             	mov    0x8(%eax),%edx
  10377b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10377e:	01 d0                	add    %edx,%eax
  103780:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103783:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103786:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103789:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10378c:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10378f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103792:	81 7d ec cc af 11 00 	cmpl   $0x11afcc,-0x14(%ebp)
  103799:	0f 85 79 ff ff ff    	jne    103718 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  10379f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  1037a2:	e8 71 09 00 00       	call   104118 <nr_free_pages>
  1037a7:	39 c3                	cmp    %eax,%ebx
  1037a9:	74 24                	je     1037cf <default_check+0xd8>
  1037ab:	c7 44 24 0c a6 6a 10 	movl   $0x106aa6,0xc(%esp)
  1037b2:	00 
  1037b3:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  1037ba:	00 
  1037bb:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  1037c2:	00 
  1037c3:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  1037ca:	e8 24 d5 ff ff       	call   100cf3 <__panic>

    basic_check();
  1037cf:	e8 e7 f9 ff ff       	call   1031bb <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1037d4:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1037db:	e8 ce 08 00 00       	call   1040ae <alloc_pages>
  1037e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  1037e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1037e7:	75 24                	jne    10380d <default_check+0x116>
  1037e9:	c7 44 24 0c bf 6a 10 	movl   $0x106abf,0xc(%esp)
  1037f0:	00 
  1037f1:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  1037f8:	00 
  1037f9:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  103800:	00 
  103801:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103808:	e8 e6 d4 ff ff       	call   100cf3 <__panic>
    assert(!PageProperty(p0));
  10380d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103810:	83 c0 04             	add    $0x4,%eax
  103813:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  10381a:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10381d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103820:	8b 55 c0             	mov    -0x40(%ebp),%edx
  103823:	0f a3 10             	bt     %edx,(%eax)
  103826:	19 c0                	sbb    %eax,%eax
  103828:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  10382b:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  10382f:	0f 95 c0             	setne  %al
  103832:	0f b6 c0             	movzbl %al,%eax
  103835:	85 c0                	test   %eax,%eax
  103837:	74 24                	je     10385d <default_check+0x166>
  103839:	c7 44 24 0c ca 6a 10 	movl   $0x106aca,0xc(%esp)
  103840:	00 
  103841:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103848:	00 
  103849:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  103850:	00 
  103851:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103858:	e8 96 d4 ff ff       	call   100cf3 <__panic>

    list_entry_t free_list_store = free_list;
  10385d:	a1 cc af 11 00       	mov    0x11afcc,%eax
  103862:	8b 15 d0 af 11 00    	mov    0x11afd0,%edx
  103868:	89 45 80             	mov    %eax,-0x80(%ebp)
  10386b:	89 55 84             	mov    %edx,-0x7c(%ebp)
  10386e:	c7 45 b4 cc af 11 00 	movl   $0x11afcc,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103875:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103878:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10387b:	89 50 04             	mov    %edx,0x4(%eax)
  10387e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103881:	8b 50 04             	mov    0x4(%eax),%edx
  103884:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103887:	89 10                	mov    %edx,(%eax)
  103889:	c7 45 b0 cc af 11 00 	movl   $0x11afcc,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103890:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103893:	8b 40 04             	mov    0x4(%eax),%eax
  103896:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103899:	0f 94 c0             	sete   %al
  10389c:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10389f:	85 c0                	test   %eax,%eax
  1038a1:	75 24                	jne    1038c7 <default_check+0x1d0>
  1038a3:	c7 44 24 0c 1f 6a 10 	movl   $0x106a1f,0xc(%esp)
  1038aa:	00 
  1038ab:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  1038b2:	00 
  1038b3:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  1038ba:	00 
  1038bb:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  1038c2:	e8 2c d4 ff ff       	call   100cf3 <__panic>
    assert(alloc_page() == NULL);
  1038c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038ce:	e8 db 07 00 00       	call   1040ae <alloc_pages>
  1038d3:	85 c0                	test   %eax,%eax
  1038d5:	74 24                	je     1038fb <default_check+0x204>
  1038d7:	c7 44 24 0c 36 6a 10 	movl   $0x106a36,0xc(%esp)
  1038de:	00 
  1038df:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  1038e6:	00 
  1038e7:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  1038ee:	00 
  1038ef:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  1038f6:	e8 f8 d3 ff ff       	call   100cf3 <__panic>

    unsigned int nr_free_store = nr_free;
  1038fb:	a1 d4 af 11 00       	mov    0x11afd4,%eax
  103900:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  103903:	c7 05 d4 af 11 00 00 	movl   $0x0,0x11afd4
  10390a:	00 00 00 

    free_pages(p0 + 2, 3);
  10390d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103910:	83 c0 28             	add    $0x28,%eax
  103913:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10391a:	00 
  10391b:	89 04 24             	mov    %eax,(%esp)
  10391e:	e8 c3 07 00 00       	call   1040e6 <free_pages>
    assert(alloc_pages(4) == NULL);
  103923:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10392a:	e8 7f 07 00 00       	call   1040ae <alloc_pages>
  10392f:	85 c0                	test   %eax,%eax
  103931:	74 24                	je     103957 <default_check+0x260>
  103933:	c7 44 24 0c dc 6a 10 	movl   $0x106adc,0xc(%esp)
  10393a:	00 
  10393b:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103942:	00 
  103943:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  10394a:	00 
  10394b:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103952:	e8 9c d3 ff ff       	call   100cf3 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  103957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10395a:	83 c0 28             	add    $0x28,%eax
  10395d:	83 c0 04             	add    $0x4,%eax
  103960:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103967:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10396a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10396d:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103970:	0f a3 10             	bt     %edx,(%eax)
  103973:	19 c0                	sbb    %eax,%eax
  103975:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103978:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10397c:	0f 95 c0             	setne  %al
  10397f:	0f b6 c0             	movzbl %al,%eax
  103982:	85 c0                	test   %eax,%eax
  103984:	74 0e                	je     103994 <default_check+0x29d>
  103986:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103989:	83 c0 28             	add    $0x28,%eax
  10398c:	8b 40 08             	mov    0x8(%eax),%eax
  10398f:	83 f8 03             	cmp    $0x3,%eax
  103992:	74 24                	je     1039b8 <default_check+0x2c1>
  103994:	c7 44 24 0c f4 6a 10 	movl   $0x106af4,0xc(%esp)
  10399b:	00 
  10399c:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  1039a3:	00 
  1039a4:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  1039ab:	00 
  1039ac:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  1039b3:	e8 3b d3 ff ff       	call   100cf3 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1039b8:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1039bf:	e8 ea 06 00 00       	call   1040ae <alloc_pages>
  1039c4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1039c7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1039cb:	75 24                	jne    1039f1 <default_check+0x2fa>
  1039cd:	c7 44 24 0c 20 6b 10 	movl   $0x106b20,0xc(%esp)
  1039d4:	00 
  1039d5:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  1039dc:	00 
  1039dd:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1039e4:	00 
  1039e5:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  1039ec:	e8 02 d3 ff ff       	call   100cf3 <__panic>
    assert(alloc_page() == NULL);
  1039f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1039f8:	e8 b1 06 00 00       	call   1040ae <alloc_pages>
  1039fd:	85 c0                	test   %eax,%eax
  1039ff:	74 24                	je     103a25 <default_check+0x32e>
  103a01:	c7 44 24 0c 36 6a 10 	movl   $0x106a36,0xc(%esp)
  103a08:	00 
  103a09:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103a10:	00 
  103a11:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  103a18:	00 
  103a19:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103a20:	e8 ce d2 ff ff       	call   100cf3 <__panic>
    assert(p0 + 2 == p1);
  103a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a28:	83 c0 28             	add    $0x28,%eax
  103a2b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103a2e:	74 24                	je     103a54 <default_check+0x35d>
  103a30:	c7 44 24 0c 3e 6b 10 	movl   $0x106b3e,0xc(%esp)
  103a37:	00 
  103a38:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103a3f:	00 
  103a40:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  103a47:	00 
  103a48:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103a4f:	e8 9f d2 ff ff       	call   100cf3 <__panic>

    p2 = p0 + 1;
  103a54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a57:	83 c0 14             	add    $0x14,%eax
  103a5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  103a5d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a64:	00 
  103a65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a68:	89 04 24             	mov    %eax,(%esp)
  103a6b:	e8 76 06 00 00       	call   1040e6 <free_pages>
    free_pages(p1, 3);
  103a70:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103a77:	00 
  103a78:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103a7b:	89 04 24             	mov    %eax,(%esp)
  103a7e:	e8 63 06 00 00       	call   1040e6 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  103a83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a86:	83 c0 04             	add    $0x4,%eax
  103a89:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103a90:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103a93:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103a96:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103a99:	0f a3 10             	bt     %edx,(%eax)
  103a9c:	19 c0                	sbb    %eax,%eax
  103a9e:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103aa1:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103aa5:	0f 95 c0             	setne  %al
  103aa8:	0f b6 c0             	movzbl %al,%eax
  103aab:	85 c0                	test   %eax,%eax
  103aad:	74 0b                	je     103aba <default_check+0x3c3>
  103aaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ab2:	8b 40 08             	mov    0x8(%eax),%eax
  103ab5:	83 f8 01             	cmp    $0x1,%eax
  103ab8:	74 24                	je     103ade <default_check+0x3e7>
  103aba:	c7 44 24 0c 4c 6b 10 	movl   $0x106b4c,0xc(%esp)
  103ac1:	00 
  103ac2:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103ac9:	00 
  103aca:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
  103ad1:	00 
  103ad2:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103ad9:	e8 15 d2 ff ff       	call   100cf3 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103ade:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103ae1:	83 c0 04             	add    $0x4,%eax
  103ae4:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103aeb:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103aee:	8b 45 90             	mov    -0x70(%ebp),%eax
  103af1:	8b 55 94             	mov    -0x6c(%ebp),%edx
  103af4:	0f a3 10             	bt     %edx,(%eax)
  103af7:	19 c0                	sbb    %eax,%eax
  103af9:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103afc:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103b00:	0f 95 c0             	setne  %al
  103b03:	0f b6 c0             	movzbl %al,%eax
  103b06:	85 c0                	test   %eax,%eax
  103b08:	74 0b                	je     103b15 <default_check+0x41e>
  103b0a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103b0d:	8b 40 08             	mov    0x8(%eax),%eax
  103b10:	83 f8 03             	cmp    $0x3,%eax
  103b13:	74 24                	je     103b39 <default_check+0x442>
  103b15:	c7 44 24 0c 74 6b 10 	movl   $0x106b74,0xc(%esp)
  103b1c:	00 
  103b1d:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103b24:	00 
  103b25:	c7 44 24 04 1e 01 00 	movl   $0x11e,0x4(%esp)
  103b2c:	00 
  103b2d:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103b34:	e8 ba d1 ff ff       	call   100cf3 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  103b39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103b40:	e8 69 05 00 00       	call   1040ae <alloc_pages>
  103b45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103b48:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103b4b:	83 e8 14             	sub    $0x14,%eax
  103b4e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103b51:	74 24                	je     103b77 <default_check+0x480>
  103b53:	c7 44 24 0c 9a 6b 10 	movl   $0x106b9a,0xc(%esp)
  103b5a:	00 
  103b5b:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103b62:	00 
  103b63:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
  103b6a:	00 
  103b6b:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103b72:	e8 7c d1 ff ff       	call   100cf3 <__panic>
    free_page(p0);
  103b77:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103b7e:	00 
  103b7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b82:	89 04 24             	mov    %eax,(%esp)
  103b85:	e8 5c 05 00 00       	call   1040e6 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103b8a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103b91:	e8 18 05 00 00       	call   1040ae <alloc_pages>
  103b96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103b99:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103b9c:	83 c0 14             	add    $0x14,%eax
  103b9f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103ba2:	74 24                	je     103bc8 <default_check+0x4d1>
  103ba4:	c7 44 24 0c b8 6b 10 	movl   $0x106bb8,0xc(%esp)
  103bab:	00 
  103bac:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103bb3:	00 
  103bb4:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
  103bbb:	00 
  103bbc:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103bc3:	e8 2b d1 ff ff       	call   100cf3 <__panic>

    free_pages(p0, 2);
  103bc8:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103bcf:	00 
  103bd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103bd3:	89 04 24             	mov    %eax,(%esp)
  103bd6:	e8 0b 05 00 00       	call   1040e6 <free_pages>
    free_page(p2);
  103bdb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103be2:	00 
  103be3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103be6:	89 04 24             	mov    %eax,(%esp)
  103be9:	e8 f8 04 00 00       	call   1040e6 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103bee:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103bf5:	e8 b4 04 00 00       	call   1040ae <alloc_pages>
  103bfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103bfd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103c01:	75 24                	jne    103c27 <default_check+0x530>
  103c03:	c7 44 24 0c d8 6b 10 	movl   $0x106bd8,0xc(%esp)
  103c0a:	00 
  103c0b:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103c12:	00 
  103c13:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  103c1a:	00 
  103c1b:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103c22:	e8 cc d0 ff ff       	call   100cf3 <__panic>
    assert(alloc_page() == NULL);
  103c27:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103c2e:	e8 7b 04 00 00       	call   1040ae <alloc_pages>
  103c33:	85 c0                	test   %eax,%eax
  103c35:	74 24                	je     103c5b <default_check+0x564>
  103c37:	c7 44 24 0c 36 6a 10 	movl   $0x106a36,0xc(%esp)
  103c3e:	00 
  103c3f:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103c46:	00 
  103c47:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  103c4e:	00 
  103c4f:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103c56:	e8 98 d0 ff ff       	call   100cf3 <__panic>

    assert(nr_free == 0);
  103c5b:	a1 d4 af 11 00       	mov    0x11afd4,%eax
  103c60:	85 c0                	test   %eax,%eax
  103c62:	74 24                	je     103c88 <default_check+0x591>
  103c64:	c7 44 24 0c 89 6a 10 	movl   $0x106a89,0xc(%esp)
  103c6b:	00 
  103c6c:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103c73:	00 
  103c74:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  103c7b:	00 
  103c7c:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103c83:	e8 6b d0 ff ff       	call   100cf3 <__panic>
    nr_free = nr_free_store;
  103c88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103c8b:	a3 d4 af 11 00       	mov    %eax,0x11afd4

    free_list = free_list_store;
  103c90:	8b 45 80             	mov    -0x80(%ebp),%eax
  103c93:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103c96:	a3 cc af 11 00       	mov    %eax,0x11afcc
  103c9b:	89 15 d0 af 11 00    	mov    %edx,0x11afd0
    free_pages(p0, 5);
  103ca1:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103ca8:	00 
  103ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103cac:	89 04 24             	mov    %eax,(%esp)
  103caf:	e8 32 04 00 00       	call   1040e6 <free_pages>

    le = &free_list;
  103cb4:	c7 45 ec cc af 11 00 	movl   $0x11afcc,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103cbb:	eb 5b                	jmp    103d18 <default_check+0x621>
        assert(le->next->prev == le && le->prev->next == le);
  103cbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103cc0:	8b 40 04             	mov    0x4(%eax),%eax
  103cc3:	8b 00                	mov    (%eax),%eax
  103cc5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103cc8:	75 0d                	jne    103cd7 <default_check+0x5e0>
  103cca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ccd:	8b 00                	mov    (%eax),%eax
  103ccf:	8b 40 04             	mov    0x4(%eax),%eax
  103cd2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103cd5:	74 24                	je     103cfb <default_check+0x604>
  103cd7:	c7 44 24 0c f8 6b 10 	movl   $0x106bf8,0xc(%esp)
  103cde:	00 
  103cdf:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103ce6:	00 
  103ce7:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
  103cee:	00 
  103cef:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103cf6:	e8 f8 cf ff ff       	call   100cf3 <__panic>
        struct Page *p = le2page(le, page_link);
  103cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103cfe:	83 e8 0c             	sub    $0xc,%eax
  103d01:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103d04:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103d08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103d0b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103d0e:	8b 40 08             	mov    0x8(%eax),%eax
  103d11:	29 c2                	sub    %eax,%edx
  103d13:	89 d0                	mov    %edx,%eax
  103d15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103d1b:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103d1e:	8b 45 88             	mov    -0x78(%ebp),%eax
  103d21:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103d24:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103d27:	81 7d ec cc af 11 00 	cmpl   $0x11afcc,-0x14(%ebp)
  103d2e:	75 8d                	jne    103cbd <default_check+0x5c6>
        assert(le->next->prev == le && le->prev->next == le);
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103d30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103d34:	74 24                	je     103d5a <default_check+0x663>
  103d36:	c7 44 24 0c 25 6c 10 	movl   $0x106c25,0xc(%esp)
  103d3d:	00 
  103d3e:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103d45:	00 
  103d46:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  103d4d:	00 
  103d4e:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103d55:	e8 99 cf ff ff       	call   100cf3 <__panic>
    assert(total == 0);
  103d5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103d5e:	74 24                	je     103d84 <default_check+0x68d>
  103d60:	c7 44 24 0c 30 6c 10 	movl   $0x106c30,0xc(%esp)
  103d67:	00 
  103d68:	c7 44 24 08 96 68 10 	movl   $0x106896,0x8(%esp)
  103d6f:	00 
  103d70:	c7 44 24 04 37 01 00 	movl   $0x137,0x4(%esp)
  103d77:	00 
  103d78:	c7 04 24 ab 68 10 00 	movl   $0x1068ab,(%esp)
  103d7f:	e8 6f cf ff ff       	call   100cf3 <__panic>
}
  103d84:	81 c4 94 00 00 00    	add    $0x94,%esp
  103d8a:	5b                   	pop    %ebx
  103d8b:	5d                   	pop    %ebp
  103d8c:	c3                   	ret    

00103d8d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103d8d:	55                   	push   %ebp
  103d8e:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103d90:	8b 55 08             	mov    0x8(%ebp),%edx
  103d93:	a1 e0 af 11 00       	mov    0x11afe0,%eax
  103d98:	29 c2                	sub    %eax,%edx
  103d9a:	89 d0                	mov    %edx,%eax
  103d9c:	c1 f8 02             	sar    $0x2,%eax
  103d9f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103da5:	5d                   	pop    %ebp
  103da6:	c3                   	ret    

00103da7 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103da7:	55                   	push   %ebp
  103da8:	89 e5                	mov    %esp,%ebp
  103daa:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103dad:	8b 45 08             	mov    0x8(%ebp),%eax
  103db0:	89 04 24             	mov    %eax,(%esp)
  103db3:	e8 d5 ff ff ff       	call   103d8d <page2ppn>
  103db8:	c1 e0 0c             	shl    $0xc,%eax
}
  103dbb:	c9                   	leave  
  103dbc:	c3                   	ret    

00103dbd <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103dbd:	55                   	push   %ebp
  103dbe:	89 e5                	mov    %esp,%ebp
  103dc0:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  103dc6:	c1 e8 0c             	shr    $0xc,%eax
  103dc9:	89 c2                	mov    %eax,%edx
  103dcb:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103dd0:	39 c2                	cmp    %eax,%edx
  103dd2:	72 1c                	jb     103df0 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103dd4:	c7 44 24 08 6c 6c 10 	movl   $0x106c6c,0x8(%esp)
  103ddb:	00 
  103ddc:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103de3:	00 
  103de4:	c7 04 24 8b 6c 10 00 	movl   $0x106c8b,(%esp)
  103deb:	e8 03 cf ff ff       	call   100cf3 <__panic>
    }
    return &pages[PPN(pa)];
  103df0:	8b 0d e0 af 11 00    	mov    0x11afe0,%ecx
  103df6:	8b 45 08             	mov    0x8(%ebp),%eax
  103df9:	c1 e8 0c             	shr    $0xc,%eax
  103dfc:	89 c2                	mov    %eax,%edx
  103dfe:	89 d0                	mov    %edx,%eax
  103e00:	c1 e0 02             	shl    $0x2,%eax
  103e03:	01 d0                	add    %edx,%eax
  103e05:	c1 e0 02             	shl    $0x2,%eax
  103e08:	01 c8                	add    %ecx,%eax
}
  103e0a:	c9                   	leave  
  103e0b:	c3                   	ret    

00103e0c <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103e0c:	55                   	push   %ebp
  103e0d:	89 e5                	mov    %esp,%ebp
  103e0f:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103e12:	8b 45 08             	mov    0x8(%ebp),%eax
  103e15:	89 04 24             	mov    %eax,(%esp)
  103e18:	e8 8a ff ff ff       	call   103da7 <page2pa>
  103e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e23:	c1 e8 0c             	shr    $0xc,%eax
  103e26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103e29:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103e2e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103e31:	72 23                	jb     103e56 <page2kva+0x4a>
  103e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e36:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e3a:	c7 44 24 08 9c 6c 10 	movl   $0x106c9c,0x8(%esp)
  103e41:	00 
  103e42:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103e49:	00 
  103e4a:	c7 04 24 8b 6c 10 00 	movl   $0x106c8b,(%esp)
  103e51:	e8 9d ce ff ff       	call   100cf3 <__panic>
  103e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e59:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103e5e:	c9                   	leave  
  103e5f:	c3                   	ret    

00103e60 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103e60:	55                   	push   %ebp
  103e61:	89 e5                	mov    %esp,%ebp
  103e63:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103e66:	8b 45 08             	mov    0x8(%ebp),%eax
  103e69:	83 e0 01             	and    $0x1,%eax
  103e6c:	85 c0                	test   %eax,%eax
  103e6e:	75 1c                	jne    103e8c <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103e70:	c7 44 24 08 c0 6c 10 	movl   $0x106cc0,0x8(%esp)
  103e77:	00 
  103e78:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103e7f:	00 
  103e80:	c7 04 24 8b 6c 10 00 	movl   $0x106c8b,(%esp)
  103e87:	e8 67 ce ff ff       	call   100cf3 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  103e8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103e94:	89 04 24             	mov    %eax,(%esp)
  103e97:	e8 21 ff ff ff       	call   103dbd <pa2page>
}
  103e9c:	c9                   	leave  
  103e9d:	c3                   	ret    

00103e9e <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  103e9e:	55                   	push   %ebp
  103e9f:	89 e5                	mov    %esp,%ebp
  103ea1:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  103ea7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103eac:	89 04 24             	mov    %eax,(%esp)
  103eaf:	e8 09 ff ff ff       	call   103dbd <pa2page>
}
  103eb4:	c9                   	leave  
  103eb5:	c3                   	ret    

00103eb6 <page_ref>:

static inline int
page_ref(struct Page *page) {
  103eb6:	55                   	push   %ebp
  103eb7:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  103ebc:	8b 00                	mov    (%eax),%eax
}
  103ebe:	5d                   	pop    %ebp
  103ebf:	c3                   	ret    

00103ec0 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  103ec0:	55                   	push   %ebp
  103ec1:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  103ec6:	8b 00                	mov    (%eax),%eax
  103ec8:	8d 50 01             	lea    0x1(%eax),%edx
  103ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  103ece:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  103ed3:	8b 00                	mov    (%eax),%eax
}
  103ed5:	5d                   	pop    %ebp
  103ed6:	c3                   	ret    

00103ed7 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103ed7:	55                   	push   %ebp
  103ed8:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103eda:	8b 45 08             	mov    0x8(%ebp),%eax
  103edd:	8b 00                	mov    (%eax),%eax
  103edf:	8d 50 ff             	lea    -0x1(%eax),%edx
  103ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  103ee5:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  103eea:	8b 00                	mov    (%eax),%eax
}
  103eec:	5d                   	pop    %ebp
  103eed:	c3                   	ret    

00103eee <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103eee:	55                   	push   %ebp
  103eef:	89 e5                	mov    %esp,%ebp
  103ef1:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103ef4:	9c                   	pushf  
  103ef5:	58                   	pop    %eax
  103ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103efc:	25 00 02 00 00       	and    $0x200,%eax
  103f01:	85 c0                	test   %eax,%eax
  103f03:	74 0c                	je     103f11 <__intr_save+0x23>
        intr_disable();
  103f05:	e8 dd d7 ff ff       	call   1016e7 <intr_disable>
        return 1;
  103f0a:	b8 01 00 00 00       	mov    $0x1,%eax
  103f0f:	eb 05                	jmp    103f16 <__intr_save+0x28>
    }
    return 0;
  103f11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103f16:	c9                   	leave  
  103f17:	c3                   	ret    

00103f18 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103f18:	55                   	push   %ebp
  103f19:	89 e5                	mov    %esp,%ebp
  103f1b:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103f1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103f22:	74 05                	je     103f29 <__intr_restore+0x11>
        intr_enable();
  103f24:	e8 b8 d7 ff ff       	call   1016e1 <intr_enable>
    }
}
  103f29:	c9                   	leave  
  103f2a:	c3                   	ret    

00103f2b <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103f2b:	55                   	push   %ebp
  103f2c:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  103f31:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103f34:	b8 23 00 00 00       	mov    $0x23,%eax
  103f39:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103f3b:	b8 23 00 00 00       	mov    $0x23,%eax
  103f40:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103f42:	b8 10 00 00 00       	mov    $0x10,%eax
  103f47:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103f49:	b8 10 00 00 00       	mov    $0x10,%eax
  103f4e:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103f50:	b8 10 00 00 00       	mov    $0x10,%eax
  103f55:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103f57:	ea 5e 3f 10 00 08 00 	ljmp   $0x8,$0x103f5e
}
  103f5e:	5d                   	pop    %ebp
  103f5f:	c3                   	ret    

00103f60 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103f60:	55                   	push   %ebp
  103f61:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103f63:	8b 45 08             	mov    0x8(%ebp),%eax
  103f66:	a3 a4 ae 11 00       	mov    %eax,0x11aea4
}
  103f6b:	5d                   	pop    %ebp
  103f6c:	c3                   	ret    

00103f6d <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103f6d:	55                   	push   %ebp
  103f6e:	89 e5                	mov    %esp,%ebp
  103f70:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103f73:	b8 00 70 11 00       	mov    $0x117000,%eax
  103f78:	89 04 24             	mov    %eax,(%esp)
  103f7b:	e8 e0 ff ff ff       	call   103f60 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103f80:	66 c7 05 a8 ae 11 00 	movw   $0x10,0x11aea8
  103f87:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103f89:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103f90:	68 00 
  103f92:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  103f97:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103f9d:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  103fa2:	c1 e8 10             	shr    $0x10,%eax
  103fa5:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103faa:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103fb1:	83 e0 f0             	and    $0xfffffff0,%eax
  103fb4:	83 c8 09             	or     $0x9,%eax
  103fb7:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103fbc:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103fc3:	83 e0 ef             	and    $0xffffffef,%eax
  103fc6:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103fcb:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103fd2:	83 e0 9f             	and    $0xffffff9f,%eax
  103fd5:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103fda:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103fe1:	83 c8 80             	or     $0xffffff80,%eax
  103fe4:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103fe9:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103ff0:	83 e0 f0             	and    $0xfffffff0,%eax
  103ff3:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103ff8:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103fff:	83 e0 ef             	and    $0xffffffef,%eax
  104002:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  104007:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  10400e:	83 e0 df             	and    $0xffffffdf,%eax
  104011:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  104016:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  10401d:	83 c8 40             	or     $0x40,%eax
  104020:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  104025:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  10402c:	83 e0 7f             	and    $0x7f,%eax
  10402f:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  104034:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  104039:	c1 e8 18             	shr    $0x18,%eax
  10403c:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  104041:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  104048:	e8 de fe ff ff       	call   103f2b <lgdt>
  10404d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  104053:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  104057:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10405a:	c9                   	leave  
  10405b:	c3                   	ret    

0010405c <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  10405c:	55                   	push   %ebp
  10405d:	89 e5                	mov    %esp,%ebp
  10405f:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  104062:	c7 05 d8 af 11 00 50 	movl   $0x106c50,0x11afd8
  104069:	6c 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  10406c:	a1 d8 af 11 00       	mov    0x11afd8,%eax
  104071:	8b 00                	mov    (%eax),%eax
  104073:	89 44 24 04          	mov    %eax,0x4(%esp)
  104077:	c7 04 24 ec 6c 10 00 	movl   $0x106cec,(%esp)
  10407e:	e8 c5 c2 ff ff       	call   100348 <cprintf>
    pmm_manager->init();
  104083:	a1 d8 af 11 00       	mov    0x11afd8,%eax
  104088:	8b 40 04             	mov    0x4(%eax),%eax
  10408b:	ff d0                	call   *%eax
}
  10408d:	c9                   	leave  
  10408e:	c3                   	ret    

0010408f <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  10408f:	55                   	push   %ebp
  104090:	89 e5                	mov    %esp,%ebp
  104092:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  104095:	a1 d8 af 11 00       	mov    0x11afd8,%eax
  10409a:	8b 40 08             	mov    0x8(%eax),%eax
  10409d:	8b 55 0c             	mov    0xc(%ebp),%edx
  1040a0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1040a4:	8b 55 08             	mov    0x8(%ebp),%edx
  1040a7:	89 14 24             	mov    %edx,(%esp)
  1040aa:	ff d0                	call   *%eax
}
  1040ac:	c9                   	leave  
  1040ad:	c3                   	ret    

001040ae <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  1040ae:	55                   	push   %ebp
  1040af:	89 e5                	mov    %esp,%ebp
  1040b1:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  1040b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  1040bb:	e8 2e fe ff ff       	call   103eee <__intr_save>
  1040c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  1040c3:	a1 d8 af 11 00       	mov    0x11afd8,%eax
  1040c8:	8b 40 0c             	mov    0xc(%eax),%eax
  1040cb:	8b 55 08             	mov    0x8(%ebp),%edx
  1040ce:	89 14 24             	mov    %edx,(%esp)
  1040d1:	ff d0                	call   *%eax
  1040d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  1040d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1040d9:	89 04 24             	mov    %eax,(%esp)
  1040dc:	e8 37 fe ff ff       	call   103f18 <__intr_restore>
    return page;
  1040e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1040e4:	c9                   	leave  
  1040e5:	c3                   	ret    

001040e6 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  1040e6:	55                   	push   %ebp
  1040e7:	89 e5                	mov    %esp,%ebp
  1040e9:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1040ec:	e8 fd fd ff ff       	call   103eee <__intr_save>
  1040f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  1040f4:	a1 d8 af 11 00       	mov    0x11afd8,%eax
  1040f9:	8b 40 10             	mov    0x10(%eax),%eax
  1040fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  1040ff:	89 54 24 04          	mov    %edx,0x4(%esp)
  104103:	8b 55 08             	mov    0x8(%ebp),%edx
  104106:	89 14 24             	mov    %edx,(%esp)
  104109:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  10410b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10410e:	89 04 24             	mov    %eax,(%esp)
  104111:	e8 02 fe ff ff       	call   103f18 <__intr_restore>
}
  104116:	c9                   	leave  
  104117:	c3                   	ret    

00104118 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  104118:	55                   	push   %ebp
  104119:	89 e5                	mov    %esp,%ebp
  10411b:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  10411e:	e8 cb fd ff ff       	call   103eee <__intr_save>
  104123:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  104126:	a1 d8 af 11 00       	mov    0x11afd8,%eax
  10412b:	8b 40 14             	mov    0x14(%eax),%eax
  10412e:	ff d0                	call   *%eax
  104130:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  104133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104136:	89 04 24             	mov    %eax,(%esp)
  104139:	e8 da fd ff ff       	call   103f18 <__intr_restore>
    return ret;
  10413e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  104141:	c9                   	leave  
  104142:	c3                   	ret    

00104143 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  104143:	55                   	push   %ebp
  104144:	89 e5                	mov    %esp,%ebp
  104146:	57                   	push   %edi
  104147:	56                   	push   %esi
  104148:	53                   	push   %ebx
  104149:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  10414f:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  104156:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  10415d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  104164:	c7 04 24 03 6d 10 00 	movl   $0x106d03,(%esp)
  10416b:	e8 d8 c1 ff ff       	call   100348 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  104170:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104177:	e9 15 01 00 00       	jmp    104291 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10417c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10417f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104182:	89 d0                	mov    %edx,%eax
  104184:	c1 e0 02             	shl    $0x2,%eax
  104187:	01 d0                	add    %edx,%eax
  104189:	c1 e0 02             	shl    $0x2,%eax
  10418c:	01 c8                	add    %ecx,%eax
  10418e:	8b 50 08             	mov    0x8(%eax),%edx
  104191:	8b 40 04             	mov    0x4(%eax),%eax
  104194:	89 45 b8             	mov    %eax,-0x48(%ebp)
  104197:	89 55 bc             	mov    %edx,-0x44(%ebp)
  10419a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10419d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041a0:	89 d0                	mov    %edx,%eax
  1041a2:	c1 e0 02             	shl    $0x2,%eax
  1041a5:	01 d0                	add    %edx,%eax
  1041a7:	c1 e0 02             	shl    $0x2,%eax
  1041aa:	01 c8                	add    %ecx,%eax
  1041ac:	8b 48 0c             	mov    0xc(%eax),%ecx
  1041af:	8b 58 10             	mov    0x10(%eax),%ebx
  1041b2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1041b5:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1041b8:	01 c8                	add    %ecx,%eax
  1041ba:	11 da                	adc    %ebx,%edx
  1041bc:	89 45 b0             	mov    %eax,-0x50(%ebp)
  1041bf:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  1041c2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1041c5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041c8:	89 d0                	mov    %edx,%eax
  1041ca:	c1 e0 02             	shl    $0x2,%eax
  1041cd:	01 d0                	add    %edx,%eax
  1041cf:	c1 e0 02             	shl    $0x2,%eax
  1041d2:	01 c8                	add    %ecx,%eax
  1041d4:	83 c0 14             	add    $0x14,%eax
  1041d7:	8b 00                	mov    (%eax),%eax
  1041d9:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  1041df:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1041e2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1041e5:	83 c0 ff             	add    $0xffffffff,%eax
  1041e8:	83 d2 ff             	adc    $0xffffffff,%edx
  1041eb:	89 c6                	mov    %eax,%esi
  1041ed:	89 d7                	mov    %edx,%edi
  1041ef:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1041f2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041f5:	89 d0                	mov    %edx,%eax
  1041f7:	c1 e0 02             	shl    $0x2,%eax
  1041fa:	01 d0                	add    %edx,%eax
  1041fc:	c1 e0 02             	shl    $0x2,%eax
  1041ff:	01 c8                	add    %ecx,%eax
  104201:	8b 48 0c             	mov    0xc(%eax),%ecx
  104204:	8b 58 10             	mov    0x10(%eax),%ebx
  104207:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  10420d:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  104211:	89 74 24 14          	mov    %esi,0x14(%esp)
  104215:	89 7c 24 18          	mov    %edi,0x18(%esp)
  104219:	8b 45 b8             	mov    -0x48(%ebp),%eax
  10421c:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10421f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104223:	89 54 24 10          	mov    %edx,0x10(%esp)
  104227:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  10422b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  10422f:	c7 04 24 10 6d 10 00 	movl   $0x106d10,(%esp)
  104236:	e8 0d c1 ff ff       	call   100348 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  10423b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10423e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104241:	89 d0                	mov    %edx,%eax
  104243:	c1 e0 02             	shl    $0x2,%eax
  104246:	01 d0                	add    %edx,%eax
  104248:	c1 e0 02             	shl    $0x2,%eax
  10424b:	01 c8                	add    %ecx,%eax
  10424d:	83 c0 14             	add    $0x14,%eax
  104250:	8b 00                	mov    (%eax),%eax
  104252:	83 f8 01             	cmp    $0x1,%eax
  104255:	75 36                	jne    10428d <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  104257:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10425a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10425d:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  104260:	77 2b                	ja     10428d <page_init+0x14a>
  104262:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  104265:	72 05                	jb     10426c <page_init+0x129>
  104267:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  10426a:	73 21                	jae    10428d <page_init+0x14a>
  10426c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  104270:	77 1b                	ja     10428d <page_init+0x14a>
  104272:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  104276:	72 09                	jb     104281 <page_init+0x13e>
  104278:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  10427f:	77 0c                	ja     10428d <page_init+0x14a>
                maxpa = end;
  104281:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104284:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104287:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10428a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  10428d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104291:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104294:	8b 00                	mov    (%eax),%eax
  104296:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104299:	0f 8f dd fe ff ff    	jg     10417c <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  10429f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1042a3:	72 1d                	jb     1042c2 <page_init+0x17f>
  1042a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1042a9:	77 09                	ja     1042b4 <page_init+0x171>
  1042ab:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  1042b2:	76 0e                	jbe    1042c2 <page_init+0x17f>
        maxpa = KMEMSIZE;
  1042b4:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  1042bb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  1042c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1042c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1042c8:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1042cc:	c1 ea 0c             	shr    $0xc,%edx
  1042cf:	a3 80 ae 11 00       	mov    %eax,0x11ae80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  1042d4:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  1042db:	b8 e4 af 11 00       	mov    $0x11afe4,%eax
  1042e0:	8d 50 ff             	lea    -0x1(%eax),%edx
  1042e3:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1042e6:	01 d0                	add    %edx,%eax
  1042e8:	89 45 a8             	mov    %eax,-0x58(%ebp)
  1042eb:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1042ee:	ba 00 00 00 00       	mov    $0x0,%edx
  1042f3:	f7 75 ac             	divl   -0x54(%ebp)
  1042f6:	89 d0                	mov    %edx,%eax
  1042f8:	8b 55 a8             	mov    -0x58(%ebp),%edx
  1042fb:	29 c2                	sub    %eax,%edx
  1042fd:	89 d0                	mov    %edx,%eax
  1042ff:	a3 e0 af 11 00       	mov    %eax,0x11afe0

    for (i = 0; i < npage; i ++) {
  104304:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10430b:	eb 2f                	jmp    10433c <page_init+0x1f9>
        SetPageReserved(pages + i);
  10430d:	8b 0d e0 af 11 00    	mov    0x11afe0,%ecx
  104313:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104316:	89 d0                	mov    %edx,%eax
  104318:	c1 e0 02             	shl    $0x2,%eax
  10431b:	01 d0                	add    %edx,%eax
  10431d:	c1 e0 02             	shl    $0x2,%eax
  104320:	01 c8                	add    %ecx,%eax
  104322:	83 c0 04             	add    $0x4,%eax
  104325:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  10432c:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10432f:	8b 45 8c             	mov    -0x74(%ebp),%eax
  104332:	8b 55 90             	mov    -0x70(%ebp),%edx
  104335:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  104338:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10433c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10433f:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104344:	39 c2                	cmp    %eax,%edx
  104346:	72 c5                	jb     10430d <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  104348:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  10434e:	89 d0                	mov    %edx,%eax
  104350:	c1 e0 02             	shl    $0x2,%eax
  104353:	01 d0                	add    %edx,%eax
  104355:	c1 e0 02             	shl    $0x2,%eax
  104358:	89 c2                	mov    %eax,%edx
  10435a:	a1 e0 af 11 00       	mov    0x11afe0,%eax
  10435f:	01 d0                	add    %edx,%eax
  104361:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  104364:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  10436b:	77 23                	ja     104390 <page_init+0x24d>
  10436d:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104370:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104374:	c7 44 24 08 40 6d 10 	movl   $0x106d40,0x8(%esp)
  10437b:	00 
  10437c:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  104383:	00 
  104384:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  10438b:	e8 63 c9 ff ff       	call   100cf3 <__panic>
  104390:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104393:	05 00 00 00 40       	add    $0x40000000,%eax
  104398:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  10439b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1043a2:	e9 74 01 00 00       	jmp    10451b <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  1043a7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1043aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1043ad:	89 d0                	mov    %edx,%eax
  1043af:	c1 e0 02             	shl    $0x2,%eax
  1043b2:	01 d0                	add    %edx,%eax
  1043b4:	c1 e0 02             	shl    $0x2,%eax
  1043b7:	01 c8                	add    %ecx,%eax
  1043b9:	8b 50 08             	mov    0x8(%eax),%edx
  1043bc:	8b 40 04             	mov    0x4(%eax),%eax
  1043bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1043c2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1043c5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1043c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1043cb:	89 d0                	mov    %edx,%eax
  1043cd:	c1 e0 02             	shl    $0x2,%eax
  1043d0:	01 d0                	add    %edx,%eax
  1043d2:	c1 e0 02             	shl    $0x2,%eax
  1043d5:	01 c8                	add    %ecx,%eax
  1043d7:	8b 48 0c             	mov    0xc(%eax),%ecx
  1043da:	8b 58 10             	mov    0x10(%eax),%ebx
  1043dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1043e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1043e3:	01 c8                	add    %ecx,%eax
  1043e5:	11 da                	adc    %ebx,%edx
  1043e7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1043ea:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  1043ed:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1043f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1043f3:	89 d0                	mov    %edx,%eax
  1043f5:	c1 e0 02             	shl    $0x2,%eax
  1043f8:	01 d0                	add    %edx,%eax
  1043fa:	c1 e0 02             	shl    $0x2,%eax
  1043fd:	01 c8                	add    %ecx,%eax
  1043ff:	83 c0 14             	add    $0x14,%eax
  104402:	8b 00                	mov    (%eax),%eax
  104404:	83 f8 01             	cmp    $0x1,%eax
  104407:	0f 85 0a 01 00 00    	jne    104517 <page_init+0x3d4>
            if (begin < freemem) {
  10440d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104410:	ba 00 00 00 00       	mov    $0x0,%edx
  104415:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104418:	72 17                	jb     104431 <page_init+0x2ee>
  10441a:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10441d:	77 05                	ja     104424 <page_init+0x2e1>
  10441f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  104422:	76 0d                	jbe    104431 <page_init+0x2ee>
                begin = freemem;
  104424:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104427:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10442a:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104431:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104435:	72 1d                	jb     104454 <page_init+0x311>
  104437:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10443b:	77 09                	ja     104446 <page_init+0x303>
  10443d:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  104444:	76 0e                	jbe    104454 <page_init+0x311>
                end = KMEMSIZE;
  104446:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  10444d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  104454:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104457:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10445a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10445d:	0f 87 b4 00 00 00    	ja     104517 <page_init+0x3d4>
  104463:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104466:	72 09                	jb     104471 <page_init+0x32e>
  104468:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10446b:	0f 83 a6 00 00 00    	jae    104517 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  104471:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  104478:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10447b:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10447e:	01 d0                	add    %edx,%eax
  104480:	83 e8 01             	sub    $0x1,%eax
  104483:	89 45 98             	mov    %eax,-0x68(%ebp)
  104486:	8b 45 98             	mov    -0x68(%ebp),%eax
  104489:	ba 00 00 00 00       	mov    $0x0,%edx
  10448e:	f7 75 9c             	divl   -0x64(%ebp)
  104491:	89 d0                	mov    %edx,%eax
  104493:	8b 55 98             	mov    -0x68(%ebp),%edx
  104496:	29 c2                	sub    %eax,%edx
  104498:	89 d0                	mov    %edx,%eax
  10449a:	ba 00 00 00 00       	mov    $0x0,%edx
  10449f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1044a2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1044a5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1044a8:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1044ab:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1044ae:	ba 00 00 00 00       	mov    $0x0,%edx
  1044b3:	89 c7                	mov    %eax,%edi
  1044b5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  1044bb:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1044be:	89 d0                	mov    %edx,%eax
  1044c0:	83 e0 00             	and    $0x0,%eax
  1044c3:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1044c6:	8b 45 80             	mov    -0x80(%ebp),%eax
  1044c9:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1044cc:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1044cf:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1044d2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1044d5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1044d8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1044db:	77 3a                	ja     104517 <page_init+0x3d4>
  1044dd:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1044e0:	72 05                	jb     1044e7 <page_init+0x3a4>
  1044e2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1044e5:	73 30                	jae    104517 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1044e7:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1044ea:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1044ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1044f0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1044f3:	29 c8                	sub    %ecx,%eax
  1044f5:	19 da                	sbb    %ebx,%edx
  1044f7:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1044fb:	c1 ea 0c             	shr    $0xc,%edx
  1044fe:	89 c3                	mov    %eax,%ebx
  104500:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104503:	89 04 24             	mov    %eax,(%esp)
  104506:	e8 b2 f8 ff ff       	call   103dbd <pa2page>
  10450b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  10450f:	89 04 24             	mov    %eax,(%esp)
  104512:	e8 78 fb ff ff       	call   10408f <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  104517:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10451b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10451e:	8b 00                	mov    (%eax),%eax
  104520:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104523:	0f 8f 7e fe ff ff    	jg     1043a7 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  104529:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  10452f:	5b                   	pop    %ebx
  104530:	5e                   	pop    %esi
  104531:	5f                   	pop    %edi
  104532:	5d                   	pop    %ebp
  104533:	c3                   	ret    

00104534 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  104534:	55                   	push   %ebp
  104535:	89 e5                	mov    %esp,%ebp
  104537:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  10453a:	8b 45 14             	mov    0x14(%ebp),%eax
  10453d:	8b 55 0c             	mov    0xc(%ebp),%edx
  104540:	31 d0                	xor    %edx,%eax
  104542:	25 ff 0f 00 00       	and    $0xfff,%eax
  104547:	85 c0                	test   %eax,%eax
  104549:	74 24                	je     10456f <boot_map_segment+0x3b>
  10454b:	c7 44 24 0c 72 6d 10 	movl   $0x106d72,0xc(%esp)
  104552:	00 
  104553:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  10455a:	00 
  10455b:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  104562:	00 
  104563:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  10456a:	e8 84 c7 ff ff       	call   100cf3 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10456f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  104576:	8b 45 0c             	mov    0xc(%ebp),%eax
  104579:	25 ff 0f 00 00       	and    $0xfff,%eax
  10457e:	89 c2                	mov    %eax,%edx
  104580:	8b 45 10             	mov    0x10(%ebp),%eax
  104583:	01 c2                	add    %eax,%edx
  104585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104588:	01 d0                	add    %edx,%eax
  10458a:	83 e8 01             	sub    $0x1,%eax
  10458d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104590:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104593:	ba 00 00 00 00       	mov    $0x0,%edx
  104598:	f7 75 f0             	divl   -0x10(%ebp)
  10459b:	89 d0                	mov    %edx,%eax
  10459d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1045a0:	29 c2                	sub    %eax,%edx
  1045a2:	89 d0                	mov    %edx,%eax
  1045a4:	c1 e8 0c             	shr    $0xc,%eax
  1045a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1045aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1045b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1045b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1045b8:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1045bb:	8b 45 14             	mov    0x14(%ebp),%eax
  1045be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1045c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1045c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1045c9:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1045cc:	eb 6b                	jmp    104639 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1045ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1045d5:	00 
  1045d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1045e0:	89 04 24             	mov    %eax,(%esp)
  1045e3:	e8 82 01 00 00       	call   10476a <get_pte>
  1045e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1045eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1045ef:	75 24                	jne    104615 <boot_map_segment+0xe1>
  1045f1:	c7 44 24 0c 9e 6d 10 	movl   $0x106d9e,0xc(%esp)
  1045f8:	00 
  1045f9:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104600:	00 
  104601:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  104608:	00 
  104609:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104610:	e8 de c6 ff ff       	call   100cf3 <__panic>
        *ptep = pa | PTE_P | perm;
  104615:	8b 45 18             	mov    0x18(%ebp),%eax
  104618:	8b 55 14             	mov    0x14(%ebp),%edx
  10461b:	09 d0                	or     %edx,%eax
  10461d:	83 c8 01             	or     $0x1,%eax
  104620:	89 c2                	mov    %eax,%edx
  104622:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104625:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104627:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10462b:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  104632:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10463d:	75 8f                	jne    1045ce <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  10463f:	c9                   	leave  
  104640:	c3                   	ret    

00104641 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  104641:	55                   	push   %ebp
  104642:	89 e5                	mov    %esp,%ebp
  104644:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  104647:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10464e:	e8 5b fa ff ff       	call   1040ae <alloc_pages>
  104653:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  104656:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10465a:	75 1c                	jne    104678 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  10465c:	c7 44 24 08 ab 6d 10 	movl   $0x106dab,0x8(%esp)
  104663:	00 
  104664:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  10466b:	00 
  10466c:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104673:	e8 7b c6 ff ff       	call   100cf3 <__panic>
    }
    return page2kva(p);
  104678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10467b:	89 04 24             	mov    %eax,(%esp)
  10467e:	e8 89 f7 ff ff       	call   103e0c <page2kva>
}
  104683:	c9                   	leave  
  104684:	c3                   	ret    

00104685 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104685:	55                   	push   %ebp
  104686:	89 e5                	mov    %esp,%ebp
  104688:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  10468b:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104690:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104693:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10469a:	77 23                	ja     1046bf <pmm_init+0x3a>
  10469c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10469f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1046a3:	c7 44 24 08 40 6d 10 	movl   $0x106d40,0x8(%esp)
  1046aa:	00 
  1046ab:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1046b2:	00 
  1046b3:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  1046ba:	e8 34 c6 ff ff       	call   100cf3 <__panic>
  1046bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046c2:	05 00 00 00 40       	add    $0x40000000,%eax
  1046c7:	a3 dc af 11 00       	mov    %eax,0x11afdc
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1046cc:	e8 8b f9 ff ff       	call   10405c <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1046d1:	e8 6d fa ff ff       	call   104143 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1046d6:	e8 4c 02 00 00       	call   104927 <check_alloc_page>

    check_pgdir();
  1046db:	e8 65 02 00 00       	call   104945 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1046e0:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1046e5:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1046eb:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1046f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1046f3:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1046fa:	77 23                	ja     10471f <pmm_init+0x9a>
  1046fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104703:	c7 44 24 08 40 6d 10 	movl   $0x106d40,0x8(%esp)
  10470a:	00 
  10470b:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  104712:	00 
  104713:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  10471a:	e8 d4 c5 ff ff       	call   100cf3 <__panic>
  10471f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104722:	05 00 00 00 40       	add    $0x40000000,%eax
  104727:	83 c8 03             	or     $0x3,%eax
  10472a:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10472c:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104731:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  104738:	00 
  104739:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104740:	00 
  104741:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  104748:	38 
  104749:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  104750:	c0 
  104751:	89 04 24             	mov    %eax,(%esp)
  104754:	e8 db fd ff ff       	call   104534 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104759:	e8 0f f8 ff ff       	call   103f6d <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10475e:	e8 7d 08 00 00       	call   104fe0 <check_boot_pgdir>

    print_pgdir();
  104763:	e8 05 0d 00 00       	call   10546d <print_pgdir>

}
  104768:	c9                   	leave  
  104769:	c3                   	ret    

0010476a <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10476a:	55                   	push   %ebp
  10476b:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  10476d:	5d                   	pop    %ebp
  10476e:	c3                   	ret    

0010476f <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10476f:	55                   	push   %ebp
  104770:	89 e5                	mov    %esp,%ebp
  104772:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104775:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10477c:	00 
  10477d:	8b 45 0c             	mov    0xc(%ebp),%eax
  104780:	89 44 24 04          	mov    %eax,0x4(%esp)
  104784:	8b 45 08             	mov    0x8(%ebp),%eax
  104787:	89 04 24             	mov    %eax,(%esp)
  10478a:	e8 db ff ff ff       	call   10476a <get_pte>
  10478f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104792:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104796:	74 08                	je     1047a0 <get_page+0x31>
        *ptep_store = ptep;
  104798:	8b 45 10             	mov    0x10(%ebp),%eax
  10479b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10479e:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1047a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1047a4:	74 1b                	je     1047c1 <get_page+0x52>
  1047a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047a9:	8b 00                	mov    (%eax),%eax
  1047ab:	83 e0 01             	and    $0x1,%eax
  1047ae:	85 c0                	test   %eax,%eax
  1047b0:	74 0f                	je     1047c1 <get_page+0x52>
        return pte2page(*ptep);
  1047b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047b5:	8b 00                	mov    (%eax),%eax
  1047b7:	89 04 24             	mov    %eax,(%esp)
  1047ba:	e8 a1 f6 ff ff       	call   103e60 <pte2page>
  1047bf:	eb 05                	jmp    1047c6 <get_page+0x57>
    }
    return NULL;
  1047c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1047c6:	c9                   	leave  
  1047c7:	c3                   	ret    

001047c8 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1047c8:	55                   	push   %ebp
  1047c9:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  1047cb:	5d                   	pop    %ebp
  1047cc:	c3                   	ret    

001047cd <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1047cd:	55                   	push   %ebp
  1047ce:	89 e5                	mov    %esp,%ebp
  1047d0:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1047d3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047da:	00 
  1047db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047de:	89 44 24 04          	mov    %eax,0x4(%esp)
  1047e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1047e5:	89 04 24             	mov    %eax,(%esp)
  1047e8:	e8 7d ff ff ff       	call   10476a <get_pte>
  1047ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  1047f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1047f4:	74 19                	je     10480f <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1047f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1047f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1047fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  104800:	89 44 24 04          	mov    %eax,0x4(%esp)
  104804:	8b 45 08             	mov    0x8(%ebp),%eax
  104807:	89 04 24             	mov    %eax,(%esp)
  10480a:	e8 b9 ff ff ff       	call   1047c8 <page_remove_pte>
    }
}
  10480f:	c9                   	leave  
  104810:	c3                   	ret    

00104811 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104811:	55                   	push   %ebp
  104812:	89 e5                	mov    %esp,%ebp
  104814:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104817:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10481e:	00 
  10481f:	8b 45 10             	mov    0x10(%ebp),%eax
  104822:	89 44 24 04          	mov    %eax,0x4(%esp)
  104826:	8b 45 08             	mov    0x8(%ebp),%eax
  104829:	89 04 24             	mov    %eax,(%esp)
  10482c:	e8 39 ff ff ff       	call   10476a <get_pte>
  104831:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  104834:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104838:	75 0a                	jne    104844 <page_insert+0x33>
        return -E_NO_MEM;
  10483a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10483f:	e9 84 00 00 00       	jmp    1048c8 <page_insert+0xb7>
    }
    page_ref_inc(page);
  104844:	8b 45 0c             	mov    0xc(%ebp),%eax
  104847:	89 04 24             	mov    %eax,(%esp)
  10484a:	e8 71 f6 ff ff       	call   103ec0 <page_ref_inc>
    if (*ptep & PTE_P) {
  10484f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104852:	8b 00                	mov    (%eax),%eax
  104854:	83 e0 01             	and    $0x1,%eax
  104857:	85 c0                	test   %eax,%eax
  104859:	74 3e                	je     104899 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  10485b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10485e:	8b 00                	mov    (%eax),%eax
  104860:	89 04 24             	mov    %eax,(%esp)
  104863:	e8 f8 f5 ff ff       	call   103e60 <pte2page>
  104868:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10486b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10486e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104871:	75 0d                	jne    104880 <page_insert+0x6f>
            page_ref_dec(page);
  104873:	8b 45 0c             	mov    0xc(%ebp),%eax
  104876:	89 04 24             	mov    %eax,(%esp)
  104879:	e8 59 f6 ff ff       	call   103ed7 <page_ref_dec>
  10487e:	eb 19                	jmp    104899 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104883:	89 44 24 08          	mov    %eax,0x8(%esp)
  104887:	8b 45 10             	mov    0x10(%ebp),%eax
  10488a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10488e:	8b 45 08             	mov    0x8(%ebp),%eax
  104891:	89 04 24             	mov    %eax,(%esp)
  104894:	e8 2f ff ff ff       	call   1047c8 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104899:	8b 45 0c             	mov    0xc(%ebp),%eax
  10489c:	89 04 24             	mov    %eax,(%esp)
  10489f:	e8 03 f5 ff ff       	call   103da7 <page2pa>
  1048a4:	0b 45 14             	or     0x14(%ebp),%eax
  1048a7:	83 c8 01             	or     $0x1,%eax
  1048aa:	89 c2                	mov    %eax,%edx
  1048ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048af:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1048b1:	8b 45 10             	mov    0x10(%ebp),%eax
  1048b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1048bb:	89 04 24             	mov    %eax,(%esp)
  1048be:	e8 07 00 00 00       	call   1048ca <tlb_invalidate>
    return 0;
  1048c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1048c8:	c9                   	leave  
  1048c9:	c3                   	ret    

001048ca <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1048ca:	55                   	push   %ebp
  1048cb:	89 e5                	mov    %esp,%ebp
  1048cd:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1048d0:	0f 20 d8             	mov    %cr3,%eax
  1048d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1048d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  1048d9:	89 c2                	mov    %eax,%edx
  1048db:	8b 45 08             	mov    0x8(%ebp),%eax
  1048de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1048e1:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1048e8:	77 23                	ja     10490d <tlb_invalidate+0x43>
  1048ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1048f1:	c7 44 24 08 40 6d 10 	movl   $0x106d40,0x8(%esp)
  1048f8:	00 
  1048f9:	c7 44 24 04 c3 01 00 	movl   $0x1c3,0x4(%esp)
  104900:	00 
  104901:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104908:	e8 e6 c3 ff ff       	call   100cf3 <__panic>
  10490d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104910:	05 00 00 00 40       	add    $0x40000000,%eax
  104915:	39 c2                	cmp    %eax,%edx
  104917:	75 0c                	jne    104925 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104919:	8b 45 0c             	mov    0xc(%ebp),%eax
  10491c:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10491f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104922:	0f 01 38             	invlpg (%eax)
    }
}
  104925:	c9                   	leave  
  104926:	c3                   	ret    

00104927 <check_alloc_page>:

static void
check_alloc_page(void) {
  104927:	55                   	push   %ebp
  104928:	89 e5                	mov    %esp,%ebp
  10492a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  10492d:	a1 d8 af 11 00       	mov    0x11afd8,%eax
  104932:	8b 40 18             	mov    0x18(%eax),%eax
  104935:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104937:	c7 04 24 c4 6d 10 00 	movl   $0x106dc4,(%esp)
  10493e:	e8 05 ba ff ff       	call   100348 <cprintf>
}
  104943:	c9                   	leave  
  104944:	c3                   	ret    

00104945 <check_pgdir>:

static void
check_pgdir(void) {
  104945:	55                   	push   %ebp
  104946:	89 e5                	mov    %esp,%ebp
  104948:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  10494b:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104950:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104955:	76 24                	jbe    10497b <check_pgdir+0x36>
  104957:	c7 44 24 0c e3 6d 10 	movl   $0x106de3,0xc(%esp)
  10495e:	00 
  10495f:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104966:	00 
  104967:	c7 44 24 04 d0 01 00 	movl   $0x1d0,0x4(%esp)
  10496e:	00 
  10496f:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104976:	e8 78 c3 ff ff       	call   100cf3 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  10497b:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104980:	85 c0                	test   %eax,%eax
  104982:	74 0e                	je     104992 <check_pgdir+0x4d>
  104984:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104989:	25 ff 0f 00 00       	and    $0xfff,%eax
  10498e:	85 c0                	test   %eax,%eax
  104990:	74 24                	je     1049b6 <check_pgdir+0x71>
  104992:	c7 44 24 0c 00 6e 10 	movl   $0x106e00,0xc(%esp)
  104999:	00 
  10499a:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  1049a1:	00 
  1049a2:	c7 44 24 04 d1 01 00 	movl   $0x1d1,0x4(%esp)
  1049a9:	00 
  1049aa:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  1049b1:	e8 3d c3 ff ff       	call   100cf3 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1049b6:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1049bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1049c2:	00 
  1049c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1049ca:	00 
  1049cb:	89 04 24             	mov    %eax,(%esp)
  1049ce:	e8 9c fd ff ff       	call   10476f <get_page>
  1049d3:	85 c0                	test   %eax,%eax
  1049d5:	74 24                	je     1049fb <check_pgdir+0xb6>
  1049d7:	c7 44 24 0c 38 6e 10 	movl   $0x106e38,0xc(%esp)
  1049de:	00 
  1049df:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  1049e6:	00 
  1049e7:	c7 44 24 04 d2 01 00 	movl   $0x1d2,0x4(%esp)
  1049ee:	00 
  1049ef:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  1049f6:	e8 f8 c2 ff ff       	call   100cf3 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1049fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a02:	e8 a7 f6 ff ff       	call   1040ae <alloc_pages>
  104a07:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104a0a:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104a0f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104a16:	00 
  104a17:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a1e:	00 
  104a1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104a22:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a26:	89 04 24             	mov    %eax,(%esp)
  104a29:	e8 e3 fd ff ff       	call   104811 <page_insert>
  104a2e:	85 c0                	test   %eax,%eax
  104a30:	74 24                	je     104a56 <check_pgdir+0x111>
  104a32:	c7 44 24 0c 60 6e 10 	movl   $0x106e60,0xc(%esp)
  104a39:	00 
  104a3a:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104a41:	00 
  104a42:	c7 44 24 04 d6 01 00 	movl   $0x1d6,0x4(%esp)
  104a49:	00 
  104a4a:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104a51:	e8 9d c2 ff ff       	call   100cf3 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104a56:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104a5b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a62:	00 
  104a63:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104a6a:	00 
  104a6b:	89 04 24             	mov    %eax,(%esp)
  104a6e:	e8 f7 fc ff ff       	call   10476a <get_pte>
  104a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a7a:	75 24                	jne    104aa0 <check_pgdir+0x15b>
  104a7c:	c7 44 24 0c 8c 6e 10 	movl   $0x106e8c,0xc(%esp)
  104a83:	00 
  104a84:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104a8b:	00 
  104a8c:	c7 44 24 04 d9 01 00 	movl   $0x1d9,0x4(%esp)
  104a93:	00 
  104a94:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104a9b:	e8 53 c2 ff ff       	call   100cf3 <__panic>
    assert(pte2page(*ptep) == p1);
  104aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104aa3:	8b 00                	mov    (%eax),%eax
  104aa5:	89 04 24             	mov    %eax,(%esp)
  104aa8:	e8 b3 f3 ff ff       	call   103e60 <pte2page>
  104aad:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104ab0:	74 24                	je     104ad6 <check_pgdir+0x191>
  104ab2:	c7 44 24 0c b9 6e 10 	movl   $0x106eb9,0xc(%esp)
  104ab9:	00 
  104aba:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104ac1:	00 
  104ac2:	c7 44 24 04 da 01 00 	movl   $0x1da,0x4(%esp)
  104ac9:	00 
  104aca:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104ad1:	e8 1d c2 ff ff       	call   100cf3 <__panic>
    assert(page_ref(p1) == 1);
  104ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ad9:	89 04 24             	mov    %eax,(%esp)
  104adc:	e8 d5 f3 ff ff       	call   103eb6 <page_ref>
  104ae1:	83 f8 01             	cmp    $0x1,%eax
  104ae4:	74 24                	je     104b0a <check_pgdir+0x1c5>
  104ae6:	c7 44 24 0c cf 6e 10 	movl   $0x106ecf,0xc(%esp)
  104aed:	00 
  104aee:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104af5:	00 
  104af6:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
  104afd:	00 
  104afe:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104b05:	e8 e9 c1 ff ff       	call   100cf3 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104b0a:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104b0f:	8b 00                	mov    (%eax),%eax
  104b11:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104b16:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b1c:	c1 e8 0c             	shr    $0xc,%eax
  104b1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104b22:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  104b27:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104b2a:	72 23                	jb     104b4f <check_pgdir+0x20a>
  104b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b2f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104b33:	c7 44 24 08 9c 6c 10 	movl   $0x106c9c,0x8(%esp)
  104b3a:	00 
  104b3b:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
  104b42:	00 
  104b43:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104b4a:	e8 a4 c1 ff ff       	call   100cf3 <__panic>
  104b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b52:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104b57:	83 c0 04             	add    $0x4,%eax
  104b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104b5d:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104b62:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b69:	00 
  104b6a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104b71:	00 
  104b72:	89 04 24             	mov    %eax,(%esp)
  104b75:	e8 f0 fb ff ff       	call   10476a <get_pte>
  104b7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104b7d:	74 24                	je     104ba3 <check_pgdir+0x25e>
  104b7f:	c7 44 24 0c e4 6e 10 	movl   $0x106ee4,0xc(%esp)
  104b86:	00 
  104b87:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104b8e:	00 
  104b8f:	c7 44 24 04 de 01 00 	movl   $0x1de,0x4(%esp)
  104b96:	00 
  104b97:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104b9e:	e8 50 c1 ff ff       	call   100cf3 <__panic>

    p2 = alloc_page();
  104ba3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104baa:	e8 ff f4 ff ff       	call   1040ae <alloc_pages>
  104baf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104bb2:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104bb7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104bbe:	00 
  104bbf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104bc6:	00 
  104bc7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104bca:	89 54 24 04          	mov    %edx,0x4(%esp)
  104bce:	89 04 24             	mov    %eax,(%esp)
  104bd1:	e8 3b fc ff ff       	call   104811 <page_insert>
  104bd6:	85 c0                	test   %eax,%eax
  104bd8:	74 24                	je     104bfe <check_pgdir+0x2b9>
  104bda:	c7 44 24 0c 0c 6f 10 	movl   $0x106f0c,0xc(%esp)
  104be1:	00 
  104be2:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104be9:	00 
  104bea:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
  104bf1:	00 
  104bf2:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104bf9:	e8 f5 c0 ff ff       	call   100cf3 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104bfe:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104c03:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c0a:	00 
  104c0b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c12:	00 
  104c13:	89 04 24             	mov    %eax,(%esp)
  104c16:	e8 4f fb ff ff       	call   10476a <get_pte>
  104c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c22:	75 24                	jne    104c48 <check_pgdir+0x303>
  104c24:	c7 44 24 0c 44 6f 10 	movl   $0x106f44,0xc(%esp)
  104c2b:	00 
  104c2c:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104c33:	00 
  104c34:	c7 44 24 04 e2 01 00 	movl   $0x1e2,0x4(%esp)
  104c3b:	00 
  104c3c:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104c43:	e8 ab c0 ff ff       	call   100cf3 <__panic>
    assert(*ptep & PTE_U);
  104c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c4b:	8b 00                	mov    (%eax),%eax
  104c4d:	83 e0 04             	and    $0x4,%eax
  104c50:	85 c0                	test   %eax,%eax
  104c52:	75 24                	jne    104c78 <check_pgdir+0x333>
  104c54:	c7 44 24 0c 74 6f 10 	movl   $0x106f74,0xc(%esp)
  104c5b:	00 
  104c5c:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104c63:	00 
  104c64:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
  104c6b:	00 
  104c6c:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104c73:	e8 7b c0 ff ff       	call   100cf3 <__panic>
    assert(*ptep & PTE_W);
  104c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c7b:	8b 00                	mov    (%eax),%eax
  104c7d:	83 e0 02             	and    $0x2,%eax
  104c80:	85 c0                	test   %eax,%eax
  104c82:	75 24                	jne    104ca8 <check_pgdir+0x363>
  104c84:	c7 44 24 0c 82 6f 10 	movl   $0x106f82,0xc(%esp)
  104c8b:	00 
  104c8c:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104c93:	00 
  104c94:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  104c9b:	00 
  104c9c:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104ca3:	e8 4b c0 ff ff       	call   100cf3 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104ca8:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104cad:	8b 00                	mov    (%eax),%eax
  104caf:	83 e0 04             	and    $0x4,%eax
  104cb2:	85 c0                	test   %eax,%eax
  104cb4:	75 24                	jne    104cda <check_pgdir+0x395>
  104cb6:	c7 44 24 0c 90 6f 10 	movl   $0x106f90,0xc(%esp)
  104cbd:	00 
  104cbe:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104cc5:	00 
  104cc6:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  104ccd:	00 
  104cce:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104cd5:	e8 19 c0 ff ff       	call   100cf3 <__panic>
    assert(page_ref(p2) == 1);
  104cda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104cdd:	89 04 24             	mov    %eax,(%esp)
  104ce0:	e8 d1 f1 ff ff       	call   103eb6 <page_ref>
  104ce5:	83 f8 01             	cmp    $0x1,%eax
  104ce8:	74 24                	je     104d0e <check_pgdir+0x3c9>
  104cea:	c7 44 24 0c a6 6f 10 	movl   $0x106fa6,0xc(%esp)
  104cf1:	00 
  104cf2:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104cf9:	00 
  104cfa:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  104d01:	00 
  104d02:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104d09:	e8 e5 bf ff ff       	call   100cf3 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104d0e:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104d13:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104d1a:	00 
  104d1b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104d22:	00 
  104d23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104d26:	89 54 24 04          	mov    %edx,0x4(%esp)
  104d2a:	89 04 24             	mov    %eax,(%esp)
  104d2d:	e8 df fa ff ff       	call   104811 <page_insert>
  104d32:	85 c0                	test   %eax,%eax
  104d34:	74 24                	je     104d5a <check_pgdir+0x415>
  104d36:	c7 44 24 0c b8 6f 10 	movl   $0x106fb8,0xc(%esp)
  104d3d:	00 
  104d3e:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104d45:	00 
  104d46:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  104d4d:	00 
  104d4e:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104d55:	e8 99 bf ff ff       	call   100cf3 <__panic>
    assert(page_ref(p1) == 2);
  104d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d5d:	89 04 24             	mov    %eax,(%esp)
  104d60:	e8 51 f1 ff ff       	call   103eb6 <page_ref>
  104d65:	83 f8 02             	cmp    $0x2,%eax
  104d68:	74 24                	je     104d8e <check_pgdir+0x449>
  104d6a:	c7 44 24 0c e4 6f 10 	movl   $0x106fe4,0xc(%esp)
  104d71:	00 
  104d72:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104d79:	00 
  104d7a:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  104d81:	00 
  104d82:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104d89:	e8 65 bf ff ff       	call   100cf3 <__panic>
    assert(page_ref(p2) == 0);
  104d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d91:	89 04 24             	mov    %eax,(%esp)
  104d94:	e8 1d f1 ff ff       	call   103eb6 <page_ref>
  104d99:	85 c0                	test   %eax,%eax
  104d9b:	74 24                	je     104dc1 <check_pgdir+0x47c>
  104d9d:	c7 44 24 0c f6 6f 10 	movl   $0x106ff6,0xc(%esp)
  104da4:	00 
  104da5:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104dac:	00 
  104dad:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  104db4:	00 
  104db5:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104dbc:	e8 32 bf ff ff       	call   100cf3 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104dc1:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104dc6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104dcd:	00 
  104dce:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104dd5:	00 
  104dd6:	89 04 24             	mov    %eax,(%esp)
  104dd9:	e8 8c f9 ff ff       	call   10476a <get_pte>
  104dde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104de1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104de5:	75 24                	jne    104e0b <check_pgdir+0x4c6>
  104de7:	c7 44 24 0c 44 6f 10 	movl   $0x106f44,0xc(%esp)
  104dee:	00 
  104def:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104df6:	00 
  104df7:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  104dfe:	00 
  104dff:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104e06:	e8 e8 be ff ff       	call   100cf3 <__panic>
    assert(pte2page(*ptep) == p1);
  104e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e0e:	8b 00                	mov    (%eax),%eax
  104e10:	89 04 24             	mov    %eax,(%esp)
  104e13:	e8 48 f0 ff ff       	call   103e60 <pte2page>
  104e18:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104e1b:	74 24                	je     104e41 <check_pgdir+0x4fc>
  104e1d:	c7 44 24 0c b9 6e 10 	movl   $0x106eb9,0xc(%esp)
  104e24:	00 
  104e25:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104e2c:	00 
  104e2d:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  104e34:	00 
  104e35:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104e3c:	e8 b2 be ff ff       	call   100cf3 <__panic>
    assert((*ptep & PTE_U) == 0);
  104e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e44:	8b 00                	mov    (%eax),%eax
  104e46:	83 e0 04             	and    $0x4,%eax
  104e49:	85 c0                	test   %eax,%eax
  104e4b:	74 24                	je     104e71 <check_pgdir+0x52c>
  104e4d:	c7 44 24 0c 08 70 10 	movl   $0x107008,0xc(%esp)
  104e54:	00 
  104e55:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104e5c:	00 
  104e5d:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  104e64:	00 
  104e65:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104e6c:	e8 82 be ff ff       	call   100cf3 <__panic>

    page_remove(boot_pgdir, 0x0);
  104e71:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104e76:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104e7d:	00 
  104e7e:	89 04 24             	mov    %eax,(%esp)
  104e81:	e8 47 f9 ff ff       	call   1047cd <page_remove>
    assert(page_ref(p1) == 1);
  104e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e89:	89 04 24             	mov    %eax,(%esp)
  104e8c:	e8 25 f0 ff ff       	call   103eb6 <page_ref>
  104e91:	83 f8 01             	cmp    $0x1,%eax
  104e94:	74 24                	je     104eba <check_pgdir+0x575>
  104e96:	c7 44 24 0c cf 6e 10 	movl   $0x106ecf,0xc(%esp)
  104e9d:	00 
  104e9e:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104ea5:	00 
  104ea6:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  104ead:	00 
  104eae:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104eb5:	e8 39 be ff ff       	call   100cf3 <__panic>
    assert(page_ref(p2) == 0);
  104eba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ebd:	89 04 24             	mov    %eax,(%esp)
  104ec0:	e8 f1 ef ff ff       	call   103eb6 <page_ref>
  104ec5:	85 c0                	test   %eax,%eax
  104ec7:	74 24                	je     104eed <check_pgdir+0x5a8>
  104ec9:	c7 44 24 0c f6 6f 10 	movl   $0x106ff6,0xc(%esp)
  104ed0:	00 
  104ed1:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104ed8:	00 
  104ed9:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  104ee0:	00 
  104ee1:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104ee8:	e8 06 be ff ff       	call   100cf3 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104eed:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104ef2:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104ef9:	00 
  104efa:	89 04 24             	mov    %eax,(%esp)
  104efd:	e8 cb f8 ff ff       	call   1047cd <page_remove>
    assert(page_ref(p1) == 0);
  104f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f05:	89 04 24             	mov    %eax,(%esp)
  104f08:	e8 a9 ef ff ff       	call   103eb6 <page_ref>
  104f0d:	85 c0                	test   %eax,%eax
  104f0f:	74 24                	je     104f35 <check_pgdir+0x5f0>
  104f11:	c7 44 24 0c 1d 70 10 	movl   $0x10701d,0xc(%esp)
  104f18:	00 
  104f19:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104f20:	00 
  104f21:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  104f28:	00 
  104f29:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104f30:	e8 be bd ff ff       	call   100cf3 <__panic>
    assert(page_ref(p2) == 0);
  104f35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f38:	89 04 24             	mov    %eax,(%esp)
  104f3b:	e8 76 ef ff ff       	call   103eb6 <page_ref>
  104f40:	85 c0                	test   %eax,%eax
  104f42:	74 24                	je     104f68 <check_pgdir+0x623>
  104f44:	c7 44 24 0c f6 6f 10 	movl   $0x106ff6,0xc(%esp)
  104f4b:	00 
  104f4c:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104f53:	00 
  104f54:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  104f5b:	00 
  104f5c:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104f63:	e8 8b bd ff ff       	call   100cf3 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  104f68:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104f6d:	8b 00                	mov    (%eax),%eax
  104f6f:	89 04 24             	mov    %eax,(%esp)
  104f72:	e8 27 ef ff ff       	call   103e9e <pde2page>
  104f77:	89 04 24             	mov    %eax,(%esp)
  104f7a:	e8 37 ef ff ff       	call   103eb6 <page_ref>
  104f7f:	83 f8 01             	cmp    $0x1,%eax
  104f82:	74 24                	je     104fa8 <check_pgdir+0x663>
  104f84:	c7 44 24 0c 30 70 10 	movl   $0x107030,0xc(%esp)
  104f8b:	00 
  104f8c:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  104f93:	00 
  104f94:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  104f9b:	00 
  104f9c:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  104fa3:	e8 4b bd ff ff       	call   100cf3 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  104fa8:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104fad:	8b 00                	mov    (%eax),%eax
  104faf:	89 04 24             	mov    %eax,(%esp)
  104fb2:	e8 e7 ee ff ff       	call   103e9e <pde2page>
  104fb7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104fbe:	00 
  104fbf:	89 04 24             	mov    %eax,(%esp)
  104fc2:	e8 1f f1 ff ff       	call   1040e6 <free_pages>
    boot_pgdir[0] = 0;
  104fc7:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104fcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104fd2:	c7 04 24 57 70 10 00 	movl   $0x107057,(%esp)
  104fd9:	e8 6a b3 ff ff       	call   100348 <cprintf>
}
  104fde:	c9                   	leave  
  104fdf:	c3                   	ret    

00104fe0 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104fe0:	55                   	push   %ebp
  104fe1:	89 e5                	mov    %esp,%ebp
  104fe3:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104fe6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104fed:	e9 ca 00 00 00       	jmp    1050bc <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ff5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ffb:	c1 e8 0c             	shr    $0xc,%eax
  104ffe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105001:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  105006:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  105009:	72 23                	jb     10502e <check_boot_pgdir+0x4e>
  10500b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10500e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105012:	c7 44 24 08 9c 6c 10 	movl   $0x106c9c,0x8(%esp)
  105019:	00 
  10501a:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  105021:	00 
  105022:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  105029:	e8 c5 bc ff ff       	call   100cf3 <__panic>
  10502e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105031:	2d 00 00 00 40       	sub    $0x40000000,%eax
  105036:	89 c2                	mov    %eax,%edx
  105038:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10503d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  105044:	00 
  105045:	89 54 24 04          	mov    %edx,0x4(%esp)
  105049:	89 04 24             	mov    %eax,(%esp)
  10504c:	e8 19 f7 ff ff       	call   10476a <get_pte>
  105051:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105054:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105058:	75 24                	jne    10507e <check_boot_pgdir+0x9e>
  10505a:	c7 44 24 0c 74 70 10 	movl   $0x107074,0xc(%esp)
  105061:	00 
  105062:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  105069:	00 
  10506a:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  105071:	00 
  105072:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  105079:	e8 75 bc ff ff       	call   100cf3 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  10507e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105081:	8b 00                	mov    (%eax),%eax
  105083:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105088:	89 c2                	mov    %eax,%edx
  10508a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10508d:	39 c2                	cmp    %eax,%edx
  10508f:	74 24                	je     1050b5 <check_boot_pgdir+0xd5>
  105091:	c7 44 24 0c b1 70 10 	movl   $0x1070b1,0xc(%esp)
  105098:	00 
  105099:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  1050a0:	00 
  1050a1:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  1050a8:	00 
  1050a9:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  1050b0:	e8 3e bc ff ff       	call   100cf3 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  1050b5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  1050bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1050bf:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  1050c4:	39 c2                	cmp    %eax,%edx
  1050c6:	0f 82 26 ff ff ff    	jb     104ff2 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  1050cc:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1050d1:	05 ac 0f 00 00       	add    $0xfac,%eax
  1050d6:	8b 00                	mov    (%eax),%eax
  1050d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1050dd:	89 c2                	mov    %eax,%edx
  1050df:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1050e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1050e7:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  1050ee:	77 23                	ja     105113 <check_boot_pgdir+0x133>
  1050f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1050f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1050f7:	c7 44 24 08 40 6d 10 	movl   $0x106d40,0x8(%esp)
  1050fe:	00 
  1050ff:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  105106:	00 
  105107:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  10510e:	e8 e0 bb ff ff       	call   100cf3 <__panic>
  105113:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105116:	05 00 00 00 40       	add    $0x40000000,%eax
  10511b:	39 c2                	cmp    %eax,%edx
  10511d:	74 24                	je     105143 <check_boot_pgdir+0x163>
  10511f:	c7 44 24 0c c8 70 10 	movl   $0x1070c8,0xc(%esp)
  105126:	00 
  105127:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  10512e:	00 
  10512f:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  105136:	00 
  105137:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  10513e:	e8 b0 bb ff ff       	call   100cf3 <__panic>

    assert(boot_pgdir[0] == 0);
  105143:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  105148:	8b 00                	mov    (%eax),%eax
  10514a:	85 c0                	test   %eax,%eax
  10514c:	74 24                	je     105172 <check_boot_pgdir+0x192>
  10514e:	c7 44 24 0c fc 70 10 	movl   $0x1070fc,0xc(%esp)
  105155:	00 
  105156:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  10515d:	00 
  10515e:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  105165:	00 
  105166:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  10516d:	e8 81 bb ff ff       	call   100cf3 <__panic>

    struct Page *p;
    p = alloc_page();
  105172:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105179:	e8 30 ef ff ff       	call   1040ae <alloc_pages>
  10517e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  105181:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  105186:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10518d:	00 
  10518e:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  105195:	00 
  105196:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105199:	89 54 24 04          	mov    %edx,0x4(%esp)
  10519d:	89 04 24             	mov    %eax,(%esp)
  1051a0:	e8 6c f6 ff ff       	call   104811 <page_insert>
  1051a5:	85 c0                	test   %eax,%eax
  1051a7:	74 24                	je     1051cd <check_boot_pgdir+0x1ed>
  1051a9:	c7 44 24 0c 10 71 10 	movl   $0x107110,0xc(%esp)
  1051b0:	00 
  1051b1:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  1051b8:	00 
  1051b9:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  1051c0:	00 
  1051c1:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  1051c8:	e8 26 bb ff ff       	call   100cf3 <__panic>
    assert(page_ref(p) == 1);
  1051cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051d0:	89 04 24             	mov    %eax,(%esp)
  1051d3:	e8 de ec ff ff       	call   103eb6 <page_ref>
  1051d8:	83 f8 01             	cmp    $0x1,%eax
  1051db:	74 24                	je     105201 <check_boot_pgdir+0x221>
  1051dd:	c7 44 24 0c 3e 71 10 	movl   $0x10713e,0xc(%esp)
  1051e4:	00 
  1051e5:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  1051ec:	00 
  1051ed:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  1051f4:	00 
  1051f5:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  1051fc:	e8 f2 ba ff ff       	call   100cf3 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  105201:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  105206:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  10520d:	00 
  10520e:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105215:	00 
  105216:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105219:	89 54 24 04          	mov    %edx,0x4(%esp)
  10521d:	89 04 24             	mov    %eax,(%esp)
  105220:	e8 ec f5 ff ff       	call   104811 <page_insert>
  105225:	85 c0                	test   %eax,%eax
  105227:	74 24                	je     10524d <check_boot_pgdir+0x26d>
  105229:	c7 44 24 0c 50 71 10 	movl   $0x107150,0xc(%esp)
  105230:	00 
  105231:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  105238:	00 
  105239:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  105240:	00 
  105241:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  105248:	e8 a6 ba ff ff       	call   100cf3 <__panic>
    assert(page_ref(p) == 2);
  10524d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105250:	89 04 24             	mov    %eax,(%esp)
  105253:	e8 5e ec ff ff       	call   103eb6 <page_ref>
  105258:	83 f8 02             	cmp    $0x2,%eax
  10525b:	74 24                	je     105281 <check_boot_pgdir+0x2a1>
  10525d:	c7 44 24 0c 87 71 10 	movl   $0x107187,0xc(%esp)
  105264:	00 
  105265:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  10526c:	00 
  10526d:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  105274:	00 
  105275:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  10527c:	e8 72 ba ff ff       	call   100cf3 <__panic>

    const char *str = "ucore: Hello world!!";
  105281:	c7 45 dc 98 71 10 00 	movl   $0x107198,-0x24(%ebp)
    strcpy((void *)0x100, str);
  105288:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10528b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10528f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105296:	e8 19 0a 00 00       	call   105cb4 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  10529b:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1052a2:	00 
  1052a3:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1052aa:	e8 7e 0a 00 00       	call   105d2d <strcmp>
  1052af:	85 c0                	test   %eax,%eax
  1052b1:	74 24                	je     1052d7 <check_boot_pgdir+0x2f7>
  1052b3:	c7 44 24 0c b0 71 10 	movl   $0x1071b0,0xc(%esp)
  1052ba:	00 
  1052bb:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  1052c2:	00 
  1052c3:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  1052ca:	00 
  1052cb:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  1052d2:	e8 1c ba ff ff       	call   100cf3 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1052d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052da:	89 04 24             	mov    %eax,(%esp)
  1052dd:	e8 2a eb ff ff       	call   103e0c <page2kva>
  1052e2:	05 00 01 00 00       	add    $0x100,%eax
  1052e7:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1052ea:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1052f1:	e8 66 09 00 00       	call   105c5c <strlen>
  1052f6:	85 c0                	test   %eax,%eax
  1052f8:	74 24                	je     10531e <check_boot_pgdir+0x33e>
  1052fa:	c7 44 24 0c e8 71 10 	movl   $0x1071e8,0xc(%esp)
  105301:	00 
  105302:	c7 44 24 08 89 6d 10 	movl   $0x106d89,0x8(%esp)
  105309:	00 
  10530a:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  105311:	00 
  105312:	c7 04 24 64 6d 10 00 	movl   $0x106d64,(%esp)
  105319:	e8 d5 b9 ff ff       	call   100cf3 <__panic>

    free_page(p);
  10531e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105325:	00 
  105326:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105329:	89 04 24             	mov    %eax,(%esp)
  10532c:	e8 b5 ed ff ff       	call   1040e6 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  105331:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  105336:	8b 00                	mov    (%eax),%eax
  105338:	89 04 24             	mov    %eax,(%esp)
  10533b:	e8 5e eb ff ff       	call   103e9e <pde2page>
  105340:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105347:	00 
  105348:	89 04 24             	mov    %eax,(%esp)
  10534b:	e8 96 ed ff ff       	call   1040e6 <free_pages>
    boot_pgdir[0] = 0;
  105350:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  105355:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  10535b:	c7 04 24 0c 72 10 00 	movl   $0x10720c,(%esp)
  105362:	e8 e1 af ff ff       	call   100348 <cprintf>
}
  105367:	c9                   	leave  
  105368:	c3                   	ret    

00105369 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105369:	55                   	push   %ebp
  10536a:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  10536c:	8b 45 08             	mov    0x8(%ebp),%eax
  10536f:	83 e0 04             	and    $0x4,%eax
  105372:	85 c0                	test   %eax,%eax
  105374:	74 07                	je     10537d <perm2str+0x14>
  105376:	b8 75 00 00 00       	mov    $0x75,%eax
  10537b:	eb 05                	jmp    105382 <perm2str+0x19>
  10537d:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105382:	a2 08 af 11 00       	mov    %al,0x11af08
    str[1] = 'r';
  105387:	c6 05 09 af 11 00 72 	movb   $0x72,0x11af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10538e:	8b 45 08             	mov    0x8(%ebp),%eax
  105391:	83 e0 02             	and    $0x2,%eax
  105394:	85 c0                	test   %eax,%eax
  105396:	74 07                	je     10539f <perm2str+0x36>
  105398:	b8 77 00 00 00       	mov    $0x77,%eax
  10539d:	eb 05                	jmp    1053a4 <perm2str+0x3b>
  10539f:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1053a4:	a2 0a af 11 00       	mov    %al,0x11af0a
    str[3] = '\0';
  1053a9:	c6 05 0b af 11 00 00 	movb   $0x0,0x11af0b
    return str;
  1053b0:	b8 08 af 11 00       	mov    $0x11af08,%eax
}
  1053b5:	5d                   	pop    %ebp
  1053b6:	c3                   	ret    

001053b7 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1053b7:	55                   	push   %ebp
  1053b8:	89 e5                	mov    %esp,%ebp
  1053ba:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1053bd:	8b 45 10             	mov    0x10(%ebp),%eax
  1053c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1053c3:	72 0a                	jb     1053cf <get_pgtable_items+0x18>
        return 0;
  1053c5:	b8 00 00 00 00       	mov    $0x0,%eax
  1053ca:	e9 9c 00 00 00       	jmp    10546b <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  1053cf:	eb 04                	jmp    1053d5 <get_pgtable_items+0x1e>
        start ++;
  1053d1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  1053d5:	8b 45 10             	mov    0x10(%ebp),%eax
  1053d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1053db:	73 18                	jae    1053f5 <get_pgtable_items+0x3e>
  1053dd:	8b 45 10             	mov    0x10(%ebp),%eax
  1053e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1053e7:	8b 45 14             	mov    0x14(%ebp),%eax
  1053ea:	01 d0                	add    %edx,%eax
  1053ec:	8b 00                	mov    (%eax),%eax
  1053ee:	83 e0 01             	and    $0x1,%eax
  1053f1:	85 c0                	test   %eax,%eax
  1053f3:	74 dc                	je     1053d1 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  1053f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1053f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1053fb:	73 69                	jae    105466 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  1053fd:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105401:	74 08                	je     10540b <get_pgtable_items+0x54>
            *left_store = start;
  105403:	8b 45 18             	mov    0x18(%ebp),%eax
  105406:	8b 55 10             	mov    0x10(%ebp),%edx
  105409:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10540b:	8b 45 10             	mov    0x10(%ebp),%eax
  10540e:	8d 50 01             	lea    0x1(%eax),%edx
  105411:	89 55 10             	mov    %edx,0x10(%ebp)
  105414:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10541b:	8b 45 14             	mov    0x14(%ebp),%eax
  10541e:	01 d0                	add    %edx,%eax
  105420:	8b 00                	mov    (%eax),%eax
  105422:	83 e0 07             	and    $0x7,%eax
  105425:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105428:	eb 04                	jmp    10542e <get_pgtable_items+0x77>
            start ++;
  10542a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  10542e:	8b 45 10             	mov    0x10(%ebp),%eax
  105431:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105434:	73 1d                	jae    105453 <get_pgtable_items+0x9c>
  105436:	8b 45 10             	mov    0x10(%ebp),%eax
  105439:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105440:	8b 45 14             	mov    0x14(%ebp),%eax
  105443:	01 d0                	add    %edx,%eax
  105445:	8b 00                	mov    (%eax),%eax
  105447:	83 e0 07             	and    $0x7,%eax
  10544a:	89 c2                	mov    %eax,%edx
  10544c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10544f:	39 c2                	cmp    %eax,%edx
  105451:	74 d7                	je     10542a <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  105453:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105457:	74 08                	je     105461 <get_pgtable_items+0xaa>
            *right_store = start;
  105459:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10545c:	8b 55 10             	mov    0x10(%ebp),%edx
  10545f:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105461:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105464:	eb 05                	jmp    10546b <get_pgtable_items+0xb4>
    }
    return 0;
  105466:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10546b:	c9                   	leave  
  10546c:	c3                   	ret    

0010546d <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  10546d:	55                   	push   %ebp
  10546e:	89 e5                	mov    %esp,%ebp
  105470:	57                   	push   %edi
  105471:	56                   	push   %esi
  105472:	53                   	push   %ebx
  105473:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  105476:	c7 04 24 2c 72 10 00 	movl   $0x10722c,(%esp)
  10547d:	e8 c6 ae ff ff       	call   100348 <cprintf>
    size_t left, right = 0, perm;
  105482:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105489:	e9 fa 00 00 00       	jmp    105588 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10548e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105491:	89 04 24             	mov    %eax,(%esp)
  105494:	e8 d0 fe ff ff       	call   105369 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  105499:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10549c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10549f:	29 d1                	sub    %edx,%ecx
  1054a1:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1054a3:	89 d6                	mov    %edx,%esi
  1054a5:	c1 e6 16             	shl    $0x16,%esi
  1054a8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1054ab:	89 d3                	mov    %edx,%ebx
  1054ad:	c1 e3 16             	shl    $0x16,%ebx
  1054b0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1054b3:	89 d1                	mov    %edx,%ecx
  1054b5:	c1 e1 16             	shl    $0x16,%ecx
  1054b8:	8b 7d dc             	mov    -0x24(%ebp),%edi
  1054bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1054be:	29 d7                	sub    %edx,%edi
  1054c0:	89 fa                	mov    %edi,%edx
  1054c2:	89 44 24 14          	mov    %eax,0x14(%esp)
  1054c6:	89 74 24 10          	mov    %esi,0x10(%esp)
  1054ca:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1054ce:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1054d2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1054d6:	c7 04 24 5d 72 10 00 	movl   $0x10725d,(%esp)
  1054dd:	e8 66 ae ff ff       	call   100348 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  1054e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054e5:	c1 e0 0a             	shl    $0xa,%eax
  1054e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1054eb:	eb 54                	jmp    105541 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1054ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054f0:	89 04 24             	mov    %eax,(%esp)
  1054f3:	e8 71 fe ff ff       	call   105369 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1054f8:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1054fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1054fe:	29 d1                	sub    %edx,%ecx
  105500:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105502:	89 d6                	mov    %edx,%esi
  105504:	c1 e6 0c             	shl    $0xc,%esi
  105507:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10550a:	89 d3                	mov    %edx,%ebx
  10550c:	c1 e3 0c             	shl    $0xc,%ebx
  10550f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105512:	c1 e2 0c             	shl    $0xc,%edx
  105515:	89 d1                	mov    %edx,%ecx
  105517:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  10551a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10551d:	29 d7                	sub    %edx,%edi
  10551f:	89 fa                	mov    %edi,%edx
  105521:	89 44 24 14          	mov    %eax,0x14(%esp)
  105525:	89 74 24 10          	mov    %esi,0x10(%esp)
  105529:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10552d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105531:	89 54 24 04          	mov    %edx,0x4(%esp)
  105535:	c7 04 24 7c 72 10 00 	movl   $0x10727c,(%esp)
  10553c:	e8 07 ae ff ff       	call   100348 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105541:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  105546:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105549:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10554c:	89 ce                	mov    %ecx,%esi
  10554e:	c1 e6 0a             	shl    $0xa,%esi
  105551:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  105554:	89 cb                	mov    %ecx,%ebx
  105556:	c1 e3 0a             	shl    $0xa,%ebx
  105559:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  10555c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105560:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  105563:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105567:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10556b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10556f:	89 74 24 04          	mov    %esi,0x4(%esp)
  105573:	89 1c 24             	mov    %ebx,(%esp)
  105576:	e8 3c fe ff ff       	call   1053b7 <get_pgtable_items>
  10557b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10557e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105582:	0f 85 65 ff ff ff    	jne    1054ed <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105588:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  10558d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105590:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  105593:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105597:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  10559a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10559e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1055a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055a6:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1055ad:	00 
  1055ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1055b5:	e8 fd fd ff ff       	call   1053b7 <get_pgtable_items>
  1055ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1055bd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1055c1:	0f 85 c7 fe ff ff    	jne    10548e <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1055c7:	c7 04 24 a0 72 10 00 	movl   $0x1072a0,(%esp)
  1055ce:	e8 75 ad ff ff       	call   100348 <cprintf>
}
  1055d3:	83 c4 4c             	add    $0x4c,%esp
  1055d6:	5b                   	pop    %ebx
  1055d7:	5e                   	pop    %esi
  1055d8:	5f                   	pop    %edi
  1055d9:	5d                   	pop    %ebp
  1055da:	c3                   	ret    

001055db <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1055db:	55                   	push   %ebp
  1055dc:	89 e5                	mov    %esp,%ebp
  1055de:	83 ec 58             	sub    $0x58,%esp
  1055e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1055e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1055e7:	8b 45 14             	mov    0x14(%ebp),%eax
  1055ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1055ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1055f0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1055f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1055f6:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1055f9:	8b 45 18             	mov    0x18(%ebp),%eax
  1055fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1055ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105602:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105605:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105608:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10560b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10560e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105611:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105615:	74 1c                	je     105633 <printnum+0x58>
  105617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10561a:	ba 00 00 00 00       	mov    $0x0,%edx
  10561f:	f7 75 e4             	divl   -0x1c(%ebp)
  105622:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105625:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105628:	ba 00 00 00 00       	mov    $0x0,%edx
  10562d:	f7 75 e4             	divl   -0x1c(%ebp)
  105630:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105633:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105636:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105639:	f7 75 e4             	divl   -0x1c(%ebp)
  10563c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10563f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105642:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105645:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105648:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10564b:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10564e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105651:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105654:	8b 45 18             	mov    0x18(%ebp),%eax
  105657:	ba 00 00 00 00       	mov    $0x0,%edx
  10565c:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10565f:	77 56                	ja     1056b7 <printnum+0xdc>
  105661:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105664:	72 05                	jb     10566b <printnum+0x90>
  105666:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105669:	77 4c                	ja     1056b7 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  10566b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10566e:	8d 50 ff             	lea    -0x1(%eax),%edx
  105671:	8b 45 20             	mov    0x20(%ebp),%eax
  105674:	89 44 24 18          	mov    %eax,0x18(%esp)
  105678:	89 54 24 14          	mov    %edx,0x14(%esp)
  10567c:	8b 45 18             	mov    0x18(%ebp),%eax
  10567f:	89 44 24 10          	mov    %eax,0x10(%esp)
  105683:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105686:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105689:	89 44 24 08          	mov    %eax,0x8(%esp)
  10568d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105691:	8b 45 0c             	mov    0xc(%ebp),%eax
  105694:	89 44 24 04          	mov    %eax,0x4(%esp)
  105698:	8b 45 08             	mov    0x8(%ebp),%eax
  10569b:	89 04 24             	mov    %eax,(%esp)
  10569e:	e8 38 ff ff ff       	call   1055db <printnum>
  1056a3:	eb 1c                	jmp    1056c1 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1056a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056ac:	8b 45 20             	mov    0x20(%ebp),%eax
  1056af:	89 04 24             	mov    %eax,(%esp)
  1056b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1056b5:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1056b7:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1056bb:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1056bf:	7f e4                	jg     1056a5 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1056c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1056c4:	05 54 73 10 00       	add    $0x107354,%eax
  1056c9:	0f b6 00             	movzbl (%eax),%eax
  1056cc:	0f be c0             	movsbl %al,%eax
  1056cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  1056d2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1056d6:	89 04 24             	mov    %eax,(%esp)
  1056d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1056dc:	ff d0                	call   *%eax
}
  1056de:	c9                   	leave  
  1056df:	c3                   	ret    

001056e0 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1056e0:	55                   	push   %ebp
  1056e1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1056e3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1056e7:	7e 14                	jle    1056fd <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1056e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1056ec:	8b 00                	mov    (%eax),%eax
  1056ee:	8d 48 08             	lea    0x8(%eax),%ecx
  1056f1:	8b 55 08             	mov    0x8(%ebp),%edx
  1056f4:	89 0a                	mov    %ecx,(%edx)
  1056f6:	8b 50 04             	mov    0x4(%eax),%edx
  1056f9:	8b 00                	mov    (%eax),%eax
  1056fb:	eb 30                	jmp    10572d <getuint+0x4d>
    }
    else if (lflag) {
  1056fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105701:	74 16                	je     105719 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105703:	8b 45 08             	mov    0x8(%ebp),%eax
  105706:	8b 00                	mov    (%eax),%eax
  105708:	8d 48 04             	lea    0x4(%eax),%ecx
  10570b:	8b 55 08             	mov    0x8(%ebp),%edx
  10570e:	89 0a                	mov    %ecx,(%edx)
  105710:	8b 00                	mov    (%eax),%eax
  105712:	ba 00 00 00 00       	mov    $0x0,%edx
  105717:	eb 14                	jmp    10572d <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105719:	8b 45 08             	mov    0x8(%ebp),%eax
  10571c:	8b 00                	mov    (%eax),%eax
  10571e:	8d 48 04             	lea    0x4(%eax),%ecx
  105721:	8b 55 08             	mov    0x8(%ebp),%edx
  105724:	89 0a                	mov    %ecx,(%edx)
  105726:	8b 00                	mov    (%eax),%eax
  105728:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10572d:	5d                   	pop    %ebp
  10572e:	c3                   	ret    

0010572f <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10572f:	55                   	push   %ebp
  105730:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105732:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105736:	7e 14                	jle    10574c <getint+0x1d>
        return va_arg(*ap, long long);
  105738:	8b 45 08             	mov    0x8(%ebp),%eax
  10573b:	8b 00                	mov    (%eax),%eax
  10573d:	8d 48 08             	lea    0x8(%eax),%ecx
  105740:	8b 55 08             	mov    0x8(%ebp),%edx
  105743:	89 0a                	mov    %ecx,(%edx)
  105745:	8b 50 04             	mov    0x4(%eax),%edx
  105748:	8b 00                	mov    (%eax),%eax
  10574a:	eb 28                	jmp    105774 <getint+0x45>
    }
    else if (lflag) {
  10574c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105750:	74 12                	je     105764 <getint+0x35>
        return va_arg(*ap, long);
  105752:	8b 45 08             	mov    0x8(%ebp),%eax
  105755:	8b 00                	mov    (%eax),%eax
  105757:	8d 48 04             	lea    0x4(%eax),%ecx
  10575a:	8b 55 08             	mov    0x8(%ebp),%edx
  10575d:	89 0a                	mov    %ecx,(%edx)
  10575f:	8b 00                	mov    (%eax),%eax
  105761:	99                   	cltd   
  105762:	eb 10                	jmp    105774 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105764:	8b 45 08             	mov    0x8(%ebp),%eax
  105767:	8b 00                	mov    (%eax),%eax
  105769:	8d 48 04             	lea    0x4(%eax),%ecx
  10576c:	8b 55 08             	mov    0x8(%ebp),%edx
  10576f:	89 0a                	mov    %ecx,(%edx)
  105771:	8b 00                	mov    (%eax),%eax
  105773:	99                   	cltd   
    }
}
  105774:	5d                   	pop    %ebp
  105775:	c3                   	ret    

00105776 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105776:	55                   	push   %ebp
  105777:	89 e5                	mov    %esp,%ebp
  105779:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10577c:	8d 45 14             	lea    0x14(%ebp),%eax
  10577f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105785:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105789:	8b 45 10             	mov    0x10(%ebp),%eax
  10578c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105790:	8b 45 0c             	mov    0xc(%ebp),%eax
  105793:	89 44 24 04          	mov    %eax,0x4(%esp)
  105797:	8b 45 08             	mov    0x8(%ebp),%eax
  10579a:	89 04 24             	mov    %eax,(%esp)
  10579d:	e8 02 00 00 00       	call   1057a4 <vprintfmt>
    va_end(ap);
}
  1057a2:	c9                   	leave  
  1057a3:	c3                   	ret    

001057a4 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1057a4:	55                   	push   %ebp
  1057a5:	89 e5                	mov    %esp,%ebp
  1057a7:	56                   	push   %esi
  1057a8:	53                   	push   %ebx
  1057a9:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1057ac:	eb 18                	jmp    1057c6 <vprintfmt+0x22>
            if (ch == '\0') {
  1057ae:	85 db                	test   %ebx,%ebx
  1057b0:	75 05                	jne    1057b7 <vprintfmt+0x13>
                return;
  1057b2:	e9 d1 03 00 00       	jmp    105b88 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  1057b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057be:	89 1c 24             	mov    %ebx,(%esp)
  1057c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1057c4:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1057c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1057c9:	8d 50 01             	lea    0x1(%eax),%edx
  1057cc:	89 55 10             	mov    %edx,0x10(%ebp)
  1057cf:	0f b6 00             	movzbl (%eax),%eax
  1057d2:	0f b6 d8             	movzbl %al,%ebx
  1057d5:	83 fb 25             	cmp    $0x25,%ebx
  1057d8:	75 d4                	jne    1057ae <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  1057da:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1057de:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1057e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1057eb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1057f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1057f5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1057f8:	8b 45 10             	mov    0x10(%ebp),%eax
  1057fb:	8d 50 01             	lea    0x1(%eax),%edx
  1057fe:	89 55 10             	mov    %edx,0x10(%ebp)
  105801:	0f b6 00             	movzbl (%eax),%eax
  105804:	0f b6 d8             	movzbl %al,%ebx
  105807:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10580a:	83 f8 55             	cmp    $0x55,%eax
  10580d:	0f 87 44 03 00 00    	ja     105b57 <vprintfmt+0x3b3>
  105813:	8b 04 85 78 73 10 00 	mov    0x107378(,%eax,4),%eax
  10581a:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10581c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105820:	eb d6                	jmp    1057f8 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105822:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105826:	eb d0                	jmp    1057f8 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105828:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10582f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105832:	89 d0                	mov    %edx,%eax
  105834:	c1 e0 02             	shl    $0x2,%eax
  105837:	01 d0                	add    %edx,%eax
  105839:	01 c0                	add    %eax,%eax
  10583b:	01 d8                	add    %ebx,%eax
  10583d:	83 e8 30             	sub    $0x30,%eax
  105840:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105843:	8b 45 10             	mov    0x10(%ebp),%eax
  105846:	0f b6 00             	movzbl (%eax),%eax
  105849:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10584c:	83 fb 2f             	cmp    $0x2f,%ebx
  10584f:	7e 0b                	jle    10585c <vprintfmt+0xb8>
  105851:	83 fb 39             	cmp    $0x39,%ebx
  105854:	7f 06                	jg     10585c <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105856:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  10585a:	eb d3                	jmp    10582f <vprintfmt+0x8b>
            goto process_precision;
  10585c:	eb 33                	jmp    105891 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  10585e:	8b 45 14             	mov    0x14(%ebp),%eax
  105861:	8d 50 04             	lea    0x4(%eax),%edx
  105864:	89 55 14             	mov    %edx,0x14(%ebp)
  105867:	8b 00                	mov    (%eax),%eax
  105869:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  10586c:	eb 23                	jmp    105891 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  10586e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105872:	79 0c                	jns    105880 <vprintfmt+0xdc>
                width = 0;
  105874:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10587b:	e9 78 ff ff ff       	jmp    1057f8 <vprintfmt+0x54>
  105880:	e9 73 ff ff ff       	jmp    1057f8 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  105885:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10588c:	e9 67 ff ff ff       	jmp    1057f8 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105891:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105895:	79 12                	jns    1058a9 <vprintfmt+0x105>
                width = precision, precision = -1;
  105897:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10589a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10589d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1058a4:	e9 4f ff ff ff       	jmp    1057f8 <vprintfmt+0x54>
  1058a9:	e9 4a ff ff ff       	jmp    1057f8 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1058ae:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1058b2:	e9 41 ff ff ff       	jmp    1057f8 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1058b7:	8b 45 14             	mov    0x14(%ebp),%eax
  1058ba:	8d 50 04             	lea    0x4(%eax),%edx
  1058bd:	89 55 14             	mov    %edx,0x14(%ebp)
  1058c0:	8b 00                	mov    (%eax),%eax
  1058c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1058c5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1058c9:	89 04 24             	mov    %eax,(%esp)
  1058cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1058cf:	ff d0                	call   *%eax
            break;
  1058d1:	e9 ac 02 00 00       	jmp    105b82 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1058d6:	8b 45 14             	mov    0x14(%ebp),%eax
  1058d9:	8d 50 04             	lea    0x4(%eax),%edx
  1058dc:	89 55 14             	mov    %edx,0x14(%ebp)
  1058df:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1058e1:	85 db                	test   %ebx,%ebx
  1058e3:	79 02                	jns    1058e7 <vprintfmt+0x143>
                err = -err;
  1058e5:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1058e7:	83 fb 06             	cmp    $0x6,%ebx
  1058ea:	7f 0b                	jg     1058f7 <vprintfmt+0x153>
  1058ec:	8b 34 9d 38 73 10 00 	mov    0x107338(,%ebx,4),%esi
  1058f3:	85 f6                	test   %esi,%esi
  1058f5:	75 23                	jne    10591a <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  1058f7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1058fb:	c7 44 24 08 65 73 10 	movl   $0x107365,0x8(%esp)
  105902:	00 
  105903:	8b 45 0c             	mov    0xc(%ebp),%eax
  105906:	89 44 24 04          	mov    %eax,0x4(%esp)
  10590a:	8b 45 08             	mov    0x8(%ebp),%eax
  10590d:	89 04 24             	mov    %eax,(%esp)
  105910:	e8 61 fe ff ff       	call   105776 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105915:	e9 68 02 00 00       	jmp    105b82 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  10591a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10591e:	c7 44 24 08 6e 73 10 	movl   $0x10736e,0x8(%esp)
  105925:	00 
  105926:	8b 45 0c             	mov    0xc(%ebp),%eax
  105929:	89 44 24 04          	mov    %eax,0x4(%esp)
  10592d:	8b 45 08             	mov    0x8(%ebp),%eax
  105930:	89 04 24             	mov    %eax,(%esp)
  105933:	e8 3e fe ff ff       	call   105776 <printfmt>
            }
            break;
  105938:	e9 45 02 00 00       	jmp    105b82 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10593d:	8b 45 14             	mov    0x14(%ebp),%eax
  105940:	8d 50 04             	lea    0x4(%eax),%edx
  105943:	89 55 14             	mov    %edx,0x14(%ebp)
  105946:	8b 30                	mov    (%eax),%esi
  105948:	85 f6                	test   %esi,%esi
  10594a:	75 05                	jne    105951 <vprintfmt+0x1ad>
                p = "(null)";
  10594c:	be 71 73 10 00       	mov    $0x107371,%esi
            }
            if (width > 0 && padc != '-') {
  105951:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105955:	7e 3e                	jle    105995 <vprintfmt+0x1f1>
  105957:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10595b:	74 38                	je     105995 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10595d:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105960:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105963:	89 44 24 04          	mov    %eax,0x4(%esp)
  105967:	89 34 24             	mov    %esi,(%esp)
  10596a:	e8 15 03 00 00       	call   105c84 <strnlen>
  10596f:	29 c3                	sub    %eax,%ebx
  105971:	89 d8                	mov    %ebx,%eax
  105973:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105976:	eb 17                	jmp    10598f <vprintfmt+0x1eb>
                    putch(padc, putdat);
  105978:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10597c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10597f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105983:	89 04 24             	mov    %eax,(%esp)
  105986:	8b 45 08             	mov    0x8(%ebp),%eax
  105989:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  10598b:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10598f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105993:	7f e3                	jg     105978 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105995:	eb 38                	jmp    1059cf <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105997:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10599b:	74 1f                	je     1059bc <vprintfmt+0x218>
  10599d:	83 fb 1f             	cmp    $0x1f,%ebx
  1059a0:	7e 05                	jle    1059a7 <vprintfmt+0x203>
  1059a2:	83 fb 7e             	cmp    $0x7e,%ebx
  1059a5:	7e 15                	jle    1059bc <vprintfmt+0x218>
                    putch('?', putdat);
  1059a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059ae:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1059b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b8:	ff d0                	call   *%eax
  1059ba:	eb 0f                	jmp    1059cb <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  1059bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059c3:	89 1c 24             	mov    %ebx,(%esp)
  1059c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1059c9:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1059cb:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1059cf:	89 f0                	mov    %esi,%eax
  1059d1:	8d 70 01             	lea    0x1(%eax),%esi
  1059d4:	0f b6 00             	movzbl (%eax),%eax
  1059d7:	0f be d8             	movsbl %al,%ebx
  1059da:	85 db                	test   %ebx,%ebx
  1059dc:	74 10                	je     1059ee <vprintfmt+0x24a>
  1059de:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1059e2:	78 b3                	js     105997 <vprintfmt+0x1f3>
  1059e4:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1059e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1059ec:	79 a9                	jns    105997 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1059ee:	eb 17                	jmp    105a07 <vprintfmt+0x263>
                putch(' ', putdat);
  1059f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059f7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1059fe:	8b 45 08             	mov    0x8(%ebp),%eax
  105a01:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105a03:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105a07:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105a0b:	7f e3                	jg     1059f0 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105a0d:	e9 70 01 00 00       	jmp    105b82 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105a12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a15:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a19:	8d 45 14             	lea    0x14(%ebp),%eax
  105a1c:	89 04 24             	mov    %eax,(%esp)
  105a1f:	e8 0b fd ff ff       	call   10572f <getint>
  105a24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a27:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a30:	85 d2                	test   %edx,%edx
  105a32:	79 26                	jns    105a5a <vprintfmt+0x2b6>
                putch('-', putdat);
  105a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a37:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a3b:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105a42:	8b 45 08             	mov    0x8(%ebp),%eax
  105a45:	ff d0                	call   *%eax
                num = -(long long)num;
  105a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105a4d:	f7 d8                	neg    %eax
  105a4f:	83 d2 00             	adc    $0x0,%edx
  105a52:	f7 da                	neg    %edx
  105a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a57:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105a5a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105a61:	e9 a8 00 00 00       	jmp    105b0e <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105a66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a69:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a6d:	8d 45 14             	lea    0x14(%ebp),%eax
  105a70:	89 04 24             	mov    %eax,(%esp)
  105a73:	e8 68 fc ff ff       	call   1056e0 <getuint>
  105a78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a7b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105a7e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105a85:	e9 84 00 00 00       	jmp    105b0e <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105a8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a91:	8d 45 14             	lea    0x14(%ebp),%eax
  105a94:	89 04 24             	mov    %eax,(%esp)
  105a97:	e8 44 fc ff ff       	call   1056e0 <getuint>
  105a9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a9f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105aa2:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105aa9:	eb 63                	jmp    105b0e <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105aab:	8b 45 0c             	mov    0xc(%ebp),%eax
  105aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ab2:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  105abc:	ff d0                	call   *%eax
            putch('x', putdat);
  105abe:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ac1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ac5:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105acc:	8b 45 08             	mov    0x8(%ebp),%eax
  105acf:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105ad1:	8b 45 14             	mov    0x14(%ebp),%eax
  105ad4:	8d 50 04             	lea    0x4(%eax),%edx
  105ad7:	89 55 14             	mov    %edx,0x14(%ebp)
  105ada:	8b 00                	mov    (%eax),%eax
  105adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105adf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105ae6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105aed:	eb 1f                	jmp    105b0e <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105aef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105af2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105af6:	8d 45 14             	lea    0x14(%ebp),%eax
  105af9:	89 04 24             	mov    %eax,(%esp)
  105afc:	e8 df fb ff ff       	call   1056e0 <getuint>
  105b01:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b04:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105b07:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105b0e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105b12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b15:	89 54 24 18          	mov    %edx,0x18(%esp)
  105b19:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105b1c:	89 54 24 14          	mov    %edx,0x14(%esp)
  105b20:	89 44 24 10          	mov    %eax,0x10(%esp)
  105b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b27:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b2e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105b32:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b35:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b39:	8b 45 08             	mov    0x8(%ebp),%eax
  105b3c:	89 04 24             	mov    %eax,(%esp)
  105b3f:	e8 97 fa ff ff       	call   1055db <printnum>
            break;
  105b44:	eb 3c                	jmp    105b82 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b49:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b4d:	89 1c 24             	mov    %ebx,(%esp)
  105b50:	8b 45 08             	mov    0x8(%ebp),%eax
  105b53:	ff d0                	call   *%eax
            break;
  105b55:	eb 2b                	jmp    105b82 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105b57:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b5e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105b65:	8b 45 08             	mov    0x8(%ebp),%eax
  105b68:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105b6a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105b6e:	eb 04                	jmp    105b74 <vprintfmt+0x3d0>
  105b70:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105b74:	8b 45 10             	mov    0x10(%ebp),%eax
  105b77:	83 e8 01             	sub    $0x1,%eax
  105b7a:	0f b6 00             	movzbl (%eax),%eax
  105b7d:	3c 25                	cmp    $0x25,%al
  105b7f:	75 ef                	jne    105b70 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105b81:	90                   	nop
        }
    }
  105b82:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105b83:	e9 3e fc ff ff       	jmp    1057c6 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105b88:	83 c4 40             	add    $0x40,%esp
  105b8b:	5b                   	pop    %ebx
  105b8c:	5e                   	pop    %esi
  105b8d:	5d                   	pop    %ebp
  105b8e:	c3                   	ret    

00105b8f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105b8f:	55                   	push   %ebp
  105b90:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105b92:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b95:	8b 40 08             	mov    0x8(%eax),%eax
  105b98:	8d 50 01             	lea    0x1(%eax),%edx
  105b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b9e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ba4:	8b 10                	mov    (%eax),%edx
  105ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ba9:	8b 40 04             	mov    0x4(%eax),%eax
  105bac:	39 c2                	cmp    %eax,%edx
  105bae:	73 12                	jae    105bc2 <sprintputch+0x33>
        *b->buf ++ = ch;
  105bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bb3:	8b 00                	mov    (%eax),%eax
  105bb5:	8d 48 01             	lea    0x1(%eax),%ecx
  105bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  105bbb:	89 0a                	mov    %ecx,(%edx)
  105bbd:	8b 55 08             	mov    0x8(%ebp),%edx
  105bc0:	88 10                	mov    %dl,(%eax)
    }
}
  105bc2:	5d                   	pop    %ebp
  105bc3:	c3                   	ret    

00105bc4 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105bc4:	55                   	push   %ebp
  105bc5:	89 e5                	mov    %esp,%ebp
  105bc7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105bca:	8d 45 14             	lea    0x14(%ebp),%eax
  105bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bd3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105bd7:	8b 45 10             	mov    0x10(%ebp),%eax
  105bda:	89 44 24 08          	mov    %eax,0x8(%esp)
  105bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  105be1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105be5:	8b 45 08             	mov    0x8(%ebp),%eax
  105be8:	89 04 24             	mov    %eax,(%esp)
  105beb:	e8 08 00 00 00       	call   105bf8 <vsnprintf>
  105bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105bf6:	c9                   	leave  
  105bf7:	c3                   	ret    

00105bf8 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105bf8:	55                   	push   %ebp
  105bf9:	89 e5                	mov    %esp,%ebp
  105bfb:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  105c01:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c07:	8d 50 ff             	lea    -0x1(%eax),%edx
  105c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  105c0d:	01 d0                	add    %edx,%eax
  105c0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105c19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105c1d:	74 0a                	je     105c29 <vsnprintf+0x31>
  105c1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c25:	39 c2                	cmp    %eax,%edx
  105c27:	76 07                	jbe    105c30 <vsnprintf+0x38>
        return -E_INVAL;
  105c29:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105c2e:	eb 2a                	jmp    105c5a <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105c30:	8b 45 14             	mov    0x14(%ebp),%eax
  105c33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105c37:	8b 45 10             	mov    0x10(%ebp),%eax
  105c3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  105c3e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105c41:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c45:	c7 04 24 8f 5b 10 00 	movl   $0x105b8f,(%esp)
  105c4c:	e8 53 fb ff ff       	call   1057a4 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105c51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c54:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105c5a:	c9                   	leave  
  105c5b:	c3                   	ret    

00105c5c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105c5c:	55                   	push   %ebp
  105c5d:	89 e5                	mov    %esp,%ebp
  105c5f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105c62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105c69:	eb 04                	jmp    105c6f <strlen+0x13>
        cnt ++;
  105c6b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c72:	8d 50 01             	lea    0x1(%eax),%edx
  105c75:	89 55 08             	mov    %edx,0x8(%ebp)
  105c78:	0f b6 00             	movzbl (%eax),%eax
  105c7b:	84 c0                	test   %al,%al
  105c7d:	75 ec                	jne    105c6b <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105c82:	c9                   	leave  
  105c83:	c3                   	ret    

00105c84 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105c84:	55                   	push   %ebp
  105c85:	89 e5                	mov    %esp,%ebp
  105c87:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105c8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105c91:	eb 04                	jmp    105c97 <strnlen+0x13>
        cnt ++;
  105c93:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105c9a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105c9d:	73 10                	jae    105caf <strnlen+0x2b>
  105c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca2:	8d 50 01             	lea    0x1(%eax),%edx
  105ca5:	89 55 08             	mov    %edx,0x8(%ebp)
  105ca8:	0f b6 00             	movzbl (%eax),%eax
  105cab:	84 c0                	test   %al,%al
  105cad:	75 e4                	jne    105c93 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105caf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105cb2:	c9                   	leave  
  105cb3:	c3                   	ret    

00105cb4 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105cb4:	55                   	push   %ebp
  105cb5:	89 e5                	mov    %esp,%ebp
  105cb7:	57                   	push   %edi
  105cb8:	56                   	push   %esi
  105cb9:	83 ec 20             	sub    $0x20,%esp
  105cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  105cbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105cc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105cce:	89 d1                	mov    %edx,%ecx
  105cd0:	89 c2                	mov    %eax,%edx
  105cd2:	89 ce                	mov    %ecx,%esi
  105cd4:	89 d7                	mov    %edx,%edi
  105cd6:	ac                   	lods   %ds:(%esi),%al
  105cd7:	aa                   	stos   %al,%es:(%edi)
  105cd8:	84 c0                	test   %al,%al
  105cda:	75 fa                	jne    105cd6 <strcpy+0x22>
  105cdc:	89 fa                	mov    %edi,%edx
  105cde:	89 f1                	mov    %esi,%ecx
  105ce0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105ce3:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105ce6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105cec:	83 c4 20             	add    $0x20,%esp
  105cef:	5e                   	pop    %esi
  105cf0:	5f                   	pop    %edi
  105cf1:	5d                   	pop    %ebp
  105cf2:	c3                   	ret    

00105cf3 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105cf3:	55                   	push   %ebp
  105cf4:	89 e5                	mov    %esp,%ebp
  105cf6:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  105cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105cff:	eb 21                	jmp    105d22 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105d01:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d04:	0f b6 10             	movzbl (%eax),%edx
  105d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d0a:	88 10                	mov    %dl,(%eax)
  105d0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105d0f:	0f b6 00             	movzbl (%eax),%eax
  105d12:	84 c0                	test   %al,%al
  105d14:	74 04                	je     105d1a <strncpy+0x27>
            src ++;
  105d16:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105d1a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105d1e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105d22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d26:	75 d9                	jne    105d01 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105d28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105d2b:	c9                   	leave  
  105d2c:	c3                   	ret    

00105d2d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105d2d:	55                   	push   %ebp
  105d2e:	89 e5                	mov    %esp,%ebp
  105d30:	57                   	push   %edi
  105d31:	56                   	push   %esi
  105d32:	83 ec 20             	sub    $0x20,%esp
  105d35:	8b 45 08             	mov    0x8(%ebp),%eax
  105d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105d41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d47:	89 d1                	mov    %edx,%ecx
  105d49:	89 c2                	mov    %eax,%edx
  105d4b:	89 ce                	mov    %ecx,%esi
  105d4d:	89 d7                	mov    %edx,%edi
  105d4f:	ac                   	lods   %ds:(%esi),%al
  105d50:	ae                   	scas   %es:(%edi),%al
  105d51:	75 08                	jne    105d5b <strcmp+0x2e>
  105d53:	84 c0                	test   %al,%al
  105d55:	75 f8                	jne    105d4f <strcmp+0x22>
  105d57:	31 c0                	xor    %eax,%eax
  105d59:	eb 04                	jmp    105d5f <strcmp+0x32>
  105d5b:	19 c0                	sbb    %eax,%eax
  105d5d:	0c 01                	or     $0x1,%al
  105d5f:	89 fa                	mov    %edi,%edx
  105d61:	89 f1                	mov    %esi,%ecx
  105d63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105d66:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105d69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105d6f:	83 c4 20             	add    $0x20,%esp
  105d72:	5e                   	pop    %esi
  105d73:	5f                   	pop    %edi
  105d74:	5d                   	pop    %ebp
  105d75:	c3                   	ret    

00105d76 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105d76:	55                   	push   %ebp
  105d77:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105d79:	eb 0c                	jmp    105d87 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105d7b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105d7f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d83:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105d87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d8b:	74 1a                	je     105da7 <strncmp+0x31>
  105d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d90:	0f b6 00             	movzbl (%eax),%eax
  105d93:	84 c0                	test   %al,%al
  105d95:	74 10                	je     105da7 <strncmp+0x31>
  105d97:	8b 45 08             	mov    0x8(%ebp),%eax
  105d9a:	0f b6 10             	movzbl (%eax),%edx
  105d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105da0:	0f b6 00             	movzbl (%eax),%eax
  105da3:	38 c2                	cmp    %al,%dl
  105da5:	74 d4                	je     105d7b <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105da7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105dab:	74 18                	je     105dc5 <strncmp+0x4f>
  105dad:	8b 45 08             	mov    0x8(%ebp),%eax
  105db0:	0f b6 00             	movzbl (%eax),%eax
  105db3:	0f b6 d0             	movzbl %al,%edx
  105db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105db9:	0f b6 00             	movzbl (%eax),%eax
  105dbc:	0f b6 c0             	movzbl %al,%eax
  105dbf:	29 c2                	sub    %eax,%edx
  105dc1:	89 d0                	mov    %edx,%eax
  105dc3:	eb 05                	jmp    105dca <strncmp+0x54>
  105dc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105dca:	5d                   	pop    %ebp
  105dcb:	c3                   	ret    

00105dcc <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105dcc:	55                   	push   %ebp
  105dcd:	89 e5                	mov    %esp,%ebp
  105dcf:	83 ec 04             	sub    $0x4,%esp
  105dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dd5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105dd8:	eb 14                	jmp    105dee <strchr+0x22>
        if (*s == c) {
  105dda:	8b 45 08             	mov    0x8(%ebp),%eax
  105ddd:	0f b6 00             	movzbl (%eax),%eax
  105de0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105de3:	75 05                	jne    105dea <strchr+0x1e>
            return (char *)s;
  105de5:	8b 45 08             	mov    0x8(%ebp),%eax
  105de8:	eb 13                	jmp    105dfd <strchr+0x31>
        }
        s ++;
  105dea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105dee:	8b 45 08             	mov    0x8(%ebp),%eax
  105df1:	0f b6 00             	movzbl (%eax),%eax
  105df4:	84 c0                	test   %al,%al
  105df6:	75 e2                	jne    105dda <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105df8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105dfd:	c9                   	leave  
  105dfe:	c3                   	ret    

00105dff <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105dff:	55                   	push   %ebp
  105e00:	89 e5                	mov    %esp,%ebp
  105e02:	83 ec 04             	sub    $0x4,%esp
  105e05:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e08:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105e0b:	eb 11                	jmp    105e1e <strfind+0x1f>
        if (*s == c) {
  105e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  105e10:	0f b6 00             	movzbl (%eax),%eax
  105e13:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105e16:	75 02                	jne    105e1a <strfind+0x1b>
            break;
  105e18:	eb 0e                	jmp    105e28 <strfind+0x29>
        }
        s ++;
  105e1a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  105e21:	0f b6 00             	movzbl (%eax),%eax
  105e24:	84 c0                	test   %al,%al
  105e26:	75 e5                	jne    105e0d <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105e28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105e2b:	c9                   	leave  
  105e2c:	c3                   	ret    

00105e2d <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105e2d:	55                   	push   %ebp
  105e2e:	89 e5                	mov    %esp,%ebp
  105e30:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105e33:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105e3a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105e41:	eb 04                	jmp    105e47 <strtol+0x1a>
        s ++;
  105e43:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105e47:	8b 45 08             	mov    0x8(%ebp),%eax
  105e4a:	0f b6 00             	movzbl (%eax),%eax
  105e4d:	3c 20                	cmp    $0x20,%al
  105e4f:	74 f2                	je     105e43 <strtol+0x16>
  105e51:	8b 45 08             	mov    0x8(%ebp),%eax
  105e54:	0f b6 00             	movzbl (%eax),%eax
  105e57:	3c 09                	cmp    $0x9,%al
  105e59:	74 e8                	je     105e43 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  105e5e:	0f b6 00             	movzbl (%eax),%eax
  105e61:	3c 2b                	cmp    $0x2b,%al
  105e63:	75 06                	jne    105e6b <strtol+0x3e>
        s ++;
  105e65:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105e69:	eb 15                	jmp    105e80 <strtol+0x53>
    }
    else if (*s == '-') {
  105e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  105e6e:	0f b6 00             	movzbl (%eax),%eax
  105e71:	3c 2d                	cmp    $0x2d,%al
  105e73:	75 0b                	jne    105e80 <strtol+0x53>
        s ++, neg = 1;
  105e75:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105e79:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105e80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e84:	74 06                	je     105e8c <strtol+0x5f>
  105e86:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105e8a:	75 24                	jne    105eb0 <strtol+0x83>
  105e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  105e8f:	0f b6 00             	movzbl (%eax),%eax
  105e92:	3c 30                	cmp    $0x30,%al
  105e94:	75 1a                	jne    105eb0 <strtol+0x83>
  105e96:	8b 45 08             	mov    0x8(%ebp),%eax
  105e99:	83 c0 01             	add    $0x1,%eax
  105e9c:	0f b6 00             	movzbl (%eax),%eax
  105e9f:	3c 78                	cmp    $0x78,%al
  105ea1:	75 0d                	jne    105eb0 <strtol+0x83>
        s += 2, base = 16;
  105ea3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105ea7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105eae:	eb 2a                	jmp    105eda <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105eb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105eb4:	75 17                	jne    105ecd <strtol+0xa0>
  105eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  105eb9:	0f b6 00             	movzbl (%eax),%eax
  105ebc:	3c 30                	cmp    $0x30,%al
  105ebe:	75 0d                	jne    105ecd <strtol+0xa0>
        s ++, base = 8;
  105ec0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ec4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105ecb:	eb 0d                	jmp    105eda <strtol+0xad>
    }
    else if (base == 0) {
  105ecd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ed1:	75 07                	jne    105eda <strtol+0xad>
        base = 10;
  105ed3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105eda:	8b 45 08             	mov    0x8(%ebp),%eax
  105edd:	0f b6 00             	movzbl (%eax),%eax
  105ee0:	3c 2f                	cmp    $0x2f,%al
  105ee2:	7e 1b                	jle    105eff <strtol+0xd2>
  105ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ee7:	0f b6 00             	movzbl (%eax),%eax
  105eea:	3c 39                	cmp    $0x39,%al
  105eec:	7f 11                	jg     105eff <strtol+0xd2>
            dig = *s - '0';
  105eee:	8b 45 08             	mov    0x8(%ebp),%eax
  105ef1:	0f b6 00             	movzbl (%eax),%eax
  105ef4:	0f be c0             	movsbl %al,%eax
  105ef7:	83 e8 30             	sub    $0x30,%eax
  105efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105efd:	eb 48                	jmp    105f47 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105eff:	8b 45 08             	mov    0x8(%ebp),%eax
  105f02:	0f b6 00             	movzbl (%eax),%eax
  105f05:	3c 60                	cmp    $0x60,%al
  105f07:	7e 1b                	jle    105f24 <strtol+0xf7>
  105f09:	8b 45 08             	mov    0x8(%ebp),%eax
  105f0c:	0f b6 00             	movzbl (%eax),%eax
  105f0f:	3c 7a                	cmp    $0x7a,%al
  105f11:	7f 11                	jg     105f24 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105f13:	8b 45 08             	mov    0x8(%ebp),%eax
  105f16:	0f b6 00             	movzbl (%eax),%eax
  105f19:	0f be c0             	movsbl %al,%eax
  105f1c:	83 e8 57             	sub    $0x57,%eax
  105f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105f22:	eb 23                	jmp    105f47 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105f24:	8b 45 08             	mov    0x8(%ebp),%eax
  105f27:	0f b6 00             	movzbl (%eax),%eax
  105f2a:	3c 40                	cmp    $0x40,%al
  105f2c:	7e 3d                	jle    105f6b <strtol+0x13e>
  105f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  105f31:	0f b6 00             	movzbl (%eax),%eax
  105f34:	3c 5a                	cmp    $0x5a,%al
  105f36:	7f 33                	jg     105f6b <strtol+0x13e>
            dig = *s - 'A' + 10;
  105f38:	8b 45 08             	mov    0x8(%ebp),%eax
  105f3b:	0f b6 00             	movzbl (%eax),%eax
  105f3e:	0f be c0             	movsbl %al,%eax
  105f41:	83 e8 37             	sub    $0x37,%eax
  105f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105f4a:	3b 45 10             	cmp    0x10(%ebp),%eax
  105f4d:	7c 02                	jl     105f51 <strtol+0x124>
            break;
  105f4f:	eb 1a                	jmp    105f6b <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105f51:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105f55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f58:	0f af 45 10          	imul   0x10(%ebp),%eax
  105f5c:	89 c2                	mov    %eax,%edx
  105f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105f61:	01 d0                	add    %edx,%eax
  105f63:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105f66:	e9 6f ff ff ff       	jmp    105eda <strtol+0xad>

    if (endptr) {
  105f6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105f6f:	74 08                	je     105f79 <strtol+0x14c>
        *endptr = (char *) s;
  105f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f74:	8b 55 08             	mov    0x8(%ebp),%edx
  105f77:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105f79:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105f7d:	74 07                	je     105f86 <strtol+0x159>
  105f7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f82:	f7 d8                	neg    %eax
  105f84:	eb 03                	jmp    105f89 <strtol+0x15c>
  105f86:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105f89:	c9                   	leave  
  105f8a:	c3                   	ret    

00105f8b <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105f8b:	55                   	push   %ebp
  105f8c:	89 e5                	mov    %esp,%ebp
  105f8e:	57                   	push   %edi
  105f8f:	83 ec 24             	sub    $0x24,%esp
  105f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f95:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105f98:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  105f9f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105fa2:	88 45 f7             	mov    %al,-0x9(%ebp)
  105fa5:	8b 45 10             	mov    0x10(%ebp),%eax
  105fa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105fab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105fae:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105fb2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105fb5:	89 d7                	mov    %edx,%edi
  105fb7:	f3 aa                	rep stos %al,%es:(%edi)
  105fb9:	89 fa                	mov    %edi,%edx
  105fbb:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105fbe:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105fc1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105fc4:	83 c4 24             	add    $0x24,%esp
  105fc7:	5f                   	pop    %edi
  105fc8:	5d                   	pop    %ebp
  105fc9:	c3                   	ret    

00105fca <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105fca:	55                   	push   %ebp
  105fcb:	89 e5                	mov    %esp,%ebp
  105fcd:	57                   	push   %edi
  105fce:	56                   	push   %esi
  105fcf:	53                   	push   %ebx
  105fd0:	83 ec 30             	sub    $0x30,%esp
  105fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  105fd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105fd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fdc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105fdf:	8b 45 10             	mov    0x10(%ebp),%eax
  105fe2:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105fe8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105feb:	73 42                	jae    10602f <memmove+0x65>
  105fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ff0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105ff3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ff6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105ff9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ffc:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105fff:	8b 45 dc             	mov    -0x24(%ebp),%eax
  106002:	c1 e8 02             	shr    $0x2,%eax
  106005:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  106007:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10600a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10600d:	89 d7                	mov    %edx,%edi
  10600f:	89 c6                	mov    %eax,%esi
  106011:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106013:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  106016:	83 e1 03             	and    $0x3,%ecx
  106019:	74 02                	je     10601d <memmove+0x53>
  10601b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10601d:	89 f0                	mov    %esi,%eax
  10601f:	89 fa                	mov    %edi,%edx
  106021:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  106024:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  106027:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  10602a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10602d:	eb 36                	jmp    106065 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10602f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106032:	8d 50 ff             	lea    -0x1(%eax),%edx
  106035:	8b 45 ec             	mov    -0x14(%ebp),%eax
  106038:	01 c2                	add    %eax,%edx
  10603a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10603d:	8d 48 ff             	lea    -0x1(%eax),%ecx
  106040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106043:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  106046:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106049:	89 c1                	mov    %eax,%ecx
  10604b:	89 d8                	mov    %ebx,%eax
  10604d:	89 d6                	mov    %edx,%esi
  10604f:	89 c7                	mov    %eax,%edi
  106051:	fd                   	std    
  106052:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106054:	fc                   	cld    
  106055:	89 f8                	mov    %edi,%eax
  106057:	89 f2                	mov    %esi,%edx
  106059:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10605c:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10605f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  106062:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  106065:	83 c4 30             	add    $0x30,%esp
  106068:	5b                   	pop    %ebx
  106069:	5e                   	pop    %esi
  10606a:	5f                   	pop    %edi
  10606b:	5d                   	pop    %ebp
  10606c:	c3                   	ret    

0010606d <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10606d:	55                   	push   %ebp
  10606e:	89 e5                	mov    %esp,%ebp
  106070:	57                   	push   %edi
  106071:	56                   	push   %esi
  106072:	83 ec 20             	sub    $0x20,%esp
  106075:	8b 45 08             	mov    0x8(%ebp),%eax
  106078:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10607b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10607e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106081:	8b 45 10             	mov    0x10(%ebp),%eax
  106084:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106087:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10608a:	c1 e8 02             	shr    $0x2,%eax
  10608d:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10608f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  106092:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106095:	89 d7                	mov    %edx,%edi
  106097:	89 c6                	mov    %eax,%esi
  106099:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10609b:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10609e:	83 e1 03             	and    $0x3,%ecx
  1060a1:	74 02                	je     1060a5 <memcpy+0x38>
  1060a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1060a5:	89 f0                	mov    %esi,%eax
  1060a7:	89 fa                	mov    %edi,%edx
  1060a9:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1060ac:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1060af:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  1060b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1060b5:	83 c4 20             	add    $0x20,%esp
  1060b8:	5e                   	pop    %esi
  1060b9:	5f                   	pop    %edi
  1060ba:	5d                   	pop    %ebp
  1060bb:	c3                   	ret    

001060bc <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1060bc:	55                   	push   %ebp
  1060bd:	89 e5                	mov    %esp,%ebp
  1060bf:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1060c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1060c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1060c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1060ce:	eb 30                	jmp    106100 <memcmp+0x44>
        if (*s1 != *s2) {
  1060d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1060d3:	0f b6 10             	movzbl (%eax),%edx
  1060d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1060d9:	0f b6 00             	movzbl (%eax),%eax
  1060dc:	38 c2                	cmp    %al,%dl
  1060de:	74 18                	je     1060f8 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1060e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1060e3:	0f b6 00             	movzbl (%eax),%eax
  1060e6:	0f b6 d0             	movzbl %al,%edx
  1060e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1060ec:	0f b6 00             	movzbl (%eax),%eax
  1060ef:	0f b6 c0             	movzbl %al,%eax
  1060f2:	29 c2                	sub    %eax,%edx
  1060f4:	89 d0                	mov    %edx,%eax
  1060f6:	eb 1a                	jmp    106112 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  1060f8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1060fc:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  106100:	8b 45 10             	mov    0x10(%ebp),%eax
  106103:	8d 50 ff             	lea    -0x1(%eax),%edx
  106106:	89 55 10             	mov    %edx,0x10(%ebp)
  106109:	85 c0                	test   %eax,%eax
  10610b:	75 c3                	jne    1060d0 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  10610d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  106112:	c9                   	leave  
  106113:	c3                   	ret    
