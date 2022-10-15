
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void
kern_init(void){
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 80 fd 10 00       	mov    $0x10fd80,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 15 34 00 00       	call   103441 <memset>

    cons_init();                // init the console
  10002c:	e8 76 15 00 00       	call   1015a7 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 e0 35 10 00 	movl   $0x1035e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 fc 35 10 00 	movl   $0x1035fc,(%esp)
  100046:	e8 d7 02 00 00       	call   100322 <cprintf>

    print_kerninfo();
  10004b:	e8 06 08 00 00       	call   100856 <print_kerninfo>

    grade_backtrace();
  100050:	e8 8b 00 00 00       	call   1000e0 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 2d 2a 00 00       	call   102a87 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 8b 16 00 00       	call   1016ea <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 03 18 00 00       	call   101867 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 31 0d 00 00       	call   100d9a <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 ea 15 00 00       	call   101658 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 6d 01 00 00       	call   1001e0 <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	55                   	push   %ebp
  100076:	89 e5                	mov    %esp,%ebp
  100078:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100082:	00 
  100083:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008a:	00 
  10008b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100092:	e8 24 0c 00 00       	call   100cbb <mon_backtrace>
}
  100097:	c9                   	leave  
  100098:	c3                   	ret    

00100099 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100099:	55                   	push   %ebp
  10009a:	89 e5                	mov    %esp,%ebp
  10009c:	53                   	push   %ebx
  10009d:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a0:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a6:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000b0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000b4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b8:	89 04 24             	mov    %eax,(%esp)
  1000bb:	e8 b5 ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c0:	83 c4 14             	add    $0x14,%esp
  1000c3:	5b                   	pop    %ebx
  1000c4:	5d                   	pop    %ebp
  1000c5:	c3                   	ret    

001000c6 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c6:	55                   	push   %ebp
  1000c7:	89 e5                	mov    %esp,%ebp
  1000c9:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1000cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d6:	89 04 24             	mov    %eax,(%esp)
  1000d9:	e8 bb ff ff ff       	call   100099 <grade_backtrace1>
}
  1000de:	c9                   	leave  
  1000df:	c3                   	ret    

001000e0 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e0:	55                   	push   %ebp
  1000e1:	89 e5                	mov    %esp,%ebp
  1000e3:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e6:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000eb:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f2:	ff 
  1000f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000fe:	e8 c3 ff ff ff       	call   1000c6 <grade_backtrace0>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010b:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10010e:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100111:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100114:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100117:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011b:	0f b7 c0             	movzwl %ax,%eax
  10011e:	83 e0 03             	and    $0x3,%eax
  100121:	89 c2                	mov    %eax,%edx
  100123:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100128:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100130:	c7 04 24 01 36 10 00 	movl   $0x103601,(%esp)
  100137:	e8 e6 01 00 00       	call   100322 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 d0             	movzwl %ax,%edx
  100143:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 0f 36 10 00 	movl   $0x10360f,(%esp)
  100157:	e8 c6 01 00 00       	call   100322 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	0f b7 d0             	movzwl %ax,%edx
  100163:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100168:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100170:	c7 04 24 1d 36 10 00 	movl   $0x10361d,(%esp)
  100177:	e8 a6 01 00 00       	call   100322 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100180:	0f b7 d0             	movzwl %ax,%edx
  100183:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100188:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100190:	c7 04 24 2b 36 10 00 	movl   $0x10362b,(%esp)
  100197:	e8 86 01 00 00       	call   100322 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a0:	0f b7 d0             	movzwl %ax,%edx
  1001a3:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a8:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b0:	c7 04 24 39 36 10 00 	movl   $0x103639,(%esp)
  1001b7:	e8 66 01 00 00       	call   100322 <cprintf>
    round ++;
  1001bc:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001c1:	83 c0 01             	add    $0x1,%eax
  1001c4:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c9:	c9                   	leave  
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001ce:	83 ec 08             	sub    $0x8,%esp
  1001d1:	cd 78                	int    $0x78
  1001d3:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001d5:	5d                   	pop    %ebp
  1001d6:	c3                   	ret    

001001d7 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d7:	55                   	push   %ebp
  1001d8:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001da:	cd 79                	int    $0x79
  1001dc:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001de:	5d                   	pop    %ebp
  1001df:	c3                   	ret    

001001e0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001e0:	55                   	push   %ebp
  1001e1:	89 e5                	mov    %esp,%ebp
  1001e3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001e6:	e8 1a ff ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001eb:	c7 04 24 48 36 10 00 	movl   $0x103648,(%esp)
  1001f2:	e8 2b 01 00 00       	call   100322 <cprintf>
    lab1_switch_to_user();
  1001f7:	e8 cf ff ff ff       	call   1001cb <lab1_switch_to_user>
    lab1_print_cur_status();
  1001fc:	e8 04 ff ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100201:	c7 04 24 68 36 10 00 	movl   $0x103668,(%esp)
  100208:	e8 15 01 00 00       	call   100322 <cprintf>
    lab1_switch_to_kernel();
  10020d:	e8 c5 ff ff ff       	call   1001d7 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100212:	e8 ee fe ff ff       	call   100105 <lab1_print_cur_status>
}
  100217:	c9                   	leave  
  100218:	c3                   	ret    

00100219 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100219:	55                   	push   %ebp
  10021a:	89 e5                	mov    %esp,%ebp
  10021c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10021f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100223:	74 13                	je     100238 <readline+0x1f>
        cprintf("%s", prompt);
  100225:	8b 45 08             	mov    0x8(%ebp),%eax
  100228:	89 44 24 04          	mov    %eax,0x4(%esp)
  10022c:	c7 04 24 87 36 10 00 	movl   $0x103687,(%esp)
  100233:	e8 ea 00 00 00       	call   100322 <cprintf>
    }
    int i = 0, c;
  100238:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10023f:	e8 66 01 00 00       	call   1003aa <getchar>
  100244:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100247:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10024b:	79 07                	jns    100254 <readline+0x3b>
            return NULL;
  10024d:	b8 00 00 00 00       	mov    $0x0,%eax
  100252:	eb 79                	jmp    1002cd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100254:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100258:	7e 28                	jle    100282 <readline+0x69>
  10025a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100261:	7f 1f                	jg     100282 <readline+0x69>
            cputchar(c);
  100263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100266:	89 04 24             	mov    %eax,(%esp)
  100269:	e8 da 00 00 00       	call   100348 <cputchar>
            buf[i ++] = c;
  10026e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100271:	8d 50 01             	lea    0x1(%eax),%edx
  100274:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100277:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10027a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100280:	eb 46                	jmp    1002c8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100282:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100286:	75 17                	jne    10029f <readline+0x86>
  100288:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10028c:	7e 11                	jle    10029f <readline+0x86>
            cputchar(c);
  10028e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100291:	89 04 24             	mov    %eax,(%esp)
  100294:	e8 af 00 00 00       	call   100348 <cputchar>
            i --;
  100299:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10029d:	eb 29                	jmp    1002c8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10029f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002a3:	74 06                	je     1002ab <readline+0x92>
  1002a5:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002a9:	75 1d                	jne    1002c8 <readline+0xaf>
            cputchar(c);
  1002ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ae:	89 04 24             	mov    %eax,(%esp)
  1002b1:	e8 92 00 00 00       	call   100348 <cputchar>
            buf[i] = '\0';
  1002b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002b9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002be:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002c1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002c6:	eb 05                	jmp    1002cd <readline+0xb4>
        }
    }
  1002c8:	e9 72 ff ff ff       	jmp    10023f <readline+0x26>
}
  1002cd:	c9                   	leave  
  1002ce:	c3                   	ret    

001002cf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002cf:	55                   	push   %ebp
  1002d0:	89 e5                	mov    %esp,%ebp
  1002d2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d8:	89 04 24             	mov    %eax,(%esp)
  1002db:	e8 f3 12 00 00       	call   1015d3 <cons_putc>
    (*cnt) ++;
  1002e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002e3:	8b 00                	mov    (%eax),%eax
  1002e5:	8d 50 01             	lea    0x1(%eax),%edx
  1002e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002eb:	89 10                	mov    %edx,(%eax)
}
  1002ed:	c9                   	leave  
  1002ee:	c3                   	ret    

001002ef <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002ef:	55                   	push   %ebp
  1002f0:	89 e5                	mov    %esp,%ebp
  1002f2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100303:	8b 45 08             	mov    0x8(%ebp),%eax
  100306:	89 44 24 08          	mov    %eax,0x8(%esp)
  10030a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10030d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100311:	c7 04 24 cf 02 10 00 	movl   $0x1002cf,(%esp)
  100318:	e8 3d 29 00 00       	call   102c5a <vprintfmt>
    return cnt;
  10031d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100320:	c9                   	leave  
  100321:	c3                   	ret    

00100322 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100322:	55                   	push   %ebp
  100323:	89 e5                	mov    %esp,%ebp
  100325:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100328:	8d 45 0c             	lea    0xc(%ebp),%eax
  10032b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10032e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100331:	89 44 24 04          	mov    %eax,0x4(%esp)
  100335:	8b 45 08             	mov    0x8(%ebp),%eax
  100338:	89 04 24             	mov    %eax,(%esp)
  10033b:	e8 af ff ff ff       	call   1002ef <vcprintf>
  100340:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100343:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100346:	c9                   	leave  
  100347:	c3                   	ret    

00100348 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100348:	55                   	push   %ebp
  100349:	89 e5                	mov    %esp,%ebp
  10034b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10034e:	8b 45 08             	mov    0x8(%ebp),%eax
  100351:	89 04 24             	mov    %eax,(%esp)
  100354:	e8 7a 12 00 00       	call   1015d3 <cons_putc>
}
  100359:	c9                   	leave  
  10035a:	c3                   	ret    

0010035b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10035b:	55                   	push   %ebp
  10035c:	89 e5                	mov    %esp,%ebp
  10035e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100361:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100368:	eb 13                	jmp    10037d <cputs+0x22>
        cputch(c, &cnt);
  10036a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10036e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100371:	89 54 24 04          	mov    %edx,0x4(%esp)
  100375:	89 04 24             	mov    %eax,(%esp)
  100378:	e8 52 ff ff ff       	call   1002cf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10037d:	8b 45 08             	mov    0x8(%ebp),%eax
  100380:	8d 50 01             	lea    0x1(%eax),%edx
  100383:	89 55 08             	mov    %edx,0x8(%ebp)
  100386:	0f b6 00             	movzbl (%eax),%eax
  100389:	88 45 f7             	mov    %al,-0x9(%ebp)
  10038c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100390:	75 d8                	jne    10036a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100392:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100395:	89 44 24 04          	mov    %eax,0x4(%esp)
  100399:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003a0:	e8 2a ff ff ff       	call   1002cf <cputch>
    return cnt;
  1003a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003a8:	c9                   	leave  
  1003a9:	c3                   	ret    

001003aa <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003aa:	55                   	push   %ebp
  1003ab:	89 e5                	mov    %esp,%ebp
  1003ad:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003b0:	e8 47 12 00 00       	call   1015fc <cons_getc>
  1003b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003bc:	74 f2                	je     1003b0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003c1:	c9                   	leave  
  1003c2:	c3                   	ret    

001003c3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003c3:	55                   	push   %ebp
  1003c4:	89 e5                	mov    %esp,%ebp
  1003c6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003cc:	8b 00                	mov    (%eax),%eax
  1003ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003d4:	8b 00                	mov    (%eax),%eax
  1003d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003e0:	e9 d2 00 00 00       	jmp    1004b7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003eb:	01 d0                	add    %edx,%eax
  1003ed:	89 c2                	mov    %eax,%edx
  1003ef:	c1 ea 1f             	shr    $0x1f,%edx
  1003f2:	01 d0                	add    %edx,%eax
  1003f4:	d1 f8                	sar    %eax
  1003f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ff:	eb 04                	jmp    100405 <stab_binsearch+0x42>
            m --;
  100401:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100408:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10040b:	7c 1f                	jl     10042c <stab_binsearch+0x69>
  10040d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100410:	89 d0                	mov    %edx,%eax
  100412:	01 c0                	add    %eax,%eax
  100414:	01 d0                	add    %edx,%eax
  100416:	c1 e0 02             	shl    $0x2,%eax
  100419:	89 c2                	mov    %eax,%edx
  10041b:	8b 45 08             	mov    0x8(%ebp),%eax
  10041e:	01 d0                	add    %edx,%eax
  100420:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100424:	0f b6 c0             	movzbl %al,%eax
  100427:	3b 45 14             	cmp    0x14(%ebp),%eax
  10042a:	75 d5                	jne    100401 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10042f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100432:	7d 0b                	jge    10043f <stab_binsearch+0x7c>
            l = true_m + 1;
  100434:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100437:	83 c0 01             	add    $0x1,%eax
  10043a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10043d:	eb 78                	jmp    1004b7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10043f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100446:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100449:	89 d0                	mov    %edx,%eax
  10044b:	01 c0                	add    %eax,%eax
  10044d:	01 d0                	add    %edx,%eax
  10044f:	c1 e0 02             	shl    $0x2,%eax
  100452:	89 c2                	mov    %eax,%edx
  100454:	8b 45 08             	mov    0x8(%ebp),%eax
  100457:	01 d0                	add    %edx,%eax
  100459:	8b 40 08             	mov    0x8(%eax),%eax
  10045c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10045f:	73 13                	jae    100474 <stab_binsearch+0xb1>
            *region_left = m;
  100461:	8b 45 0c             	mov    0xc(%ebp),%eax
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100469:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10046c:	83 c0 01             	add    $0x1,%eax
  10046f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100472:	eb 43                	jmp    1004b7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100474:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100477:	89 d0                	mov    %edx,%eax
  100479:	01 c0                	add    %eax,%eax
  10047b:	01 d0                	add    %edx,%eax
  10047d:	c1 e0 02             	shl    $0x2,%eax
  100480:	89 c2                	mov    %eax,%edx
  100482:	8b 45 08             	mov    0x8(%ebp),%eax
  100485:	01 d0                	add    %edx,%eax
  100487:	8b 40 08             	mov    0x8(%eax),%eax
  10048a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10048d:	76 16                	jbe    1004a5 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10048f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100492:	8d 50 ff             	lea    -0x1(%eax),%edx
  100495:	8b 45 10             	mov    0x10(%ebp),%eax
  100498:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10049a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10049d:	83 e8 01             	sub    $0x1,%eax
  1004a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a3:	eb 12                	jmp    1004b7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ab:	89 10                	mov    %edx,(%eax)
            l = m;
  1004ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004b3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004bd:	0f 8e 22 ff ff ff    	jle    1003e5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004c7:	75 0f                	jne    1004d8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004cc:	8b 00                	mov    (%eax),%eax
  1004ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d4:	89 10                	mov    %edx,(%eax)
  1004d6:	eb 3f                	jmp    100517 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004db:	8b 00                	mov    (%eax),%eax
  1004dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004e0:	eb 04                	jmp    1004e6 <stab_binsearch+0x123>
  1004e2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e9:	8b 00                	mov    (%eax),%eax
  1004eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ee:	7d 1f                	jge    10050f <stab_binsearch+0x14c>
  1004f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004f3:	89 d0                	mov    %edx,%eax
  1004f5:	01 c0                	add    %eax,%eax
  1004f7:	01 d0                	add    %edx,%eax
  1004f9:	c1 e0 02             	shl    $0x2,%eax
  1004fc:	89 c2                	mov    %eax,%edx
  1004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  100501:	01 d0                	add    %edx,%eax
  100503:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100507:	0f b6 c0             	movzbl %al,%eax
  10050a:	3b 45 14             	cmp    0x14(%ebp),%eax
  10050d:	75 d3                	jne    1004e2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100515:	89 10                	mov    %edx,(%eax)
    }
}
  100517:	c9                   	leave  
  100518:	c3                   	ret    

00100519 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100519:	55                   	push   %ebp
  10051a:	89 e5                	mov    %esp,%ebp
  10051c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10051f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100522:	c7 00 8c 36 10 00    	movl   $0x10368c,(%eax)
    info->eip_line = 0;
  100528:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100532:	8b 45 0c             	mov    0xc(%ebp),%eax
  100535:	c7 40 08 8c 36 10 00 	movl   $0x10368c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10053c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100546:	8b 45 0c             	mov    0xc(%ebp),%eax
  100549:	8b 55 08             	mov    0x8(%ebp),%edx
  10054c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10054f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100552:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100559:	c7 45 f4 2c 3f 10 00 	movl   $0x103f2c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100560:	c7 45 f0 50 b7 10 00 	movl   $0x10b750,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100567:	c7 45 ec 51 b7 10 00 	movl   $0x10b751,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10056e:	c7 45 e8 94 d7 10 00 	movl   $0x10d794,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100578:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10057b:	76 0d                	jbe    10058a <debuginfo_eip+0x71>
  10057d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100580:	83 e8 01             	sub    $0x1,%eax
  100583:	0f b6 00             	movzbl (%eax),%eax
  100586:	84 c0                	test   %al,%al
  100588:	74 0a                	je     100594 <debuginfo_eip+0x7b>
        return -1;
  10058a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10058f:	e9 c0 02 00 00       	jmp    100854 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100594:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10059b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10059e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005a1:	29 c2                	sub    %eax,%edx
  1005a3:	89 d0                	mov    %edx,%eax
  1005a5:	c1 f8 02             	sar    $0x2,%eax
  1005a8:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005ae:	83 e8 01             	sub    $0x1,%eax
  1005b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005bb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005c2:	00 
  1005c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005d4:	89 04 24             	mov    %eax,(%esp)
  1005d7:	e8 e7 fd ff ff       	call   1003c3 <stab_binsearch>
    if (lfile == 0)
  1005dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005df:	85 c0                	test   %eax,%eax
  1005e1:	75 0a                	jne    1005ed <debuginfo_eip+0xd4>
        return -1;
  1005e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005e8:	e9 67 02 00 00       	jmp    100854 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  100600:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100607:	00 
  100608:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10060b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10060f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100612:	89 44 24 04          	mov    %eax,0x4(%esp)
  100616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100619:	89 04 24             	mov    %eax,(%esp)
  10061c:	e8 a2 fd ff ff       	call   1003c3 <stab_binsearch>

    if (lfun <= rfun) {
  100621:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100624:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100627:	39 c2                	cmp    %eax,%edx
  100629:	7f 7c                	jg     1006a7 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10062b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10062e:	89 c2                	mov    %eax,%edx
  100630:	89 d0                	mov    %edx,%eax
  100632:	01 c0                	add    %eax,%eax
  100634:	01 d0                	add    %edx,%eax
  100636:	c1 e0 02             	shl    $0x2,%eax
  100639:	89 c2                	mov    %eax,%edx
  10063b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10063e:	01 d0                	add    %edx,%eax
  100640:	8b 10                	mov    (%eax),%edx
  100642:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100645:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100648:	29 c1                	sub    %eax,%ecx
  10064a:	89 c8                	mov    %ecx,%eax
  10064c:	39 c2                	cmp    %eax,%edx
  10064e:	73 22                	jae    100672 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100650:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	89 d0                	mov    %edx,%eax
  100657:	01 c0                	add    %eax,%eax
  100659:	01 d0                	add    %edx,%eax
  10065b:	c1 e0 02             	shl    $0x2,%eax
  10065e:	89 c2                	mov    %eax,%edx
  100660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100663:	01 d0                	add    %edx,%eax
  100665:	8b 10                	mov    (%eax),%edx
  100667:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10066a:	01 c2                	add    %eax,%edx
  10066c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100672:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100675:	89 c2                	mov    %eax,%edx
  100677:	89 d0                	mov    %edx,%eax
  100679:	01 c0                	add    %eax,%eax
  10067b:	01 d0                	add    %edx,%eax
  10067d:	c1 e0 02             	shl    $0x2,%eax
  100680:	89 c2                	mov    %eax,%edx
  100682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100685:	01 d0                	add    %edx,%eax
  100687:	8b 50 08             	mov    0x8(%eax),%edx
  10068a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10068d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100690:	8b 45 0c             	mov    0xc(%ebp),%eax
  100693:	8b 40 10             	mov    0x10(%eax),%eax
  100696:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100699:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10069c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10069f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006a5:	eb 15                	jmp    1006bc <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006aa:	8b 55 08             	mov    0x8(%ebp),%edx
  1006ad:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006bf:	8b 40 08             	mov    0x8(%eax),%eax
  1006c2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006c9:	00 
  1006ca:	89 04 24             	mov    %eax,(%esp)
  1006cd:	e8 e3 2b 00 00       	call   1032b5 <strfind>
  1006d2:	89 c2                	mov    %eax,%edx
  1006d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d7:	8b 40 08             	mov    0x8(%eax),%eax
  1006da:	29 c2                	sub    %eax,%edx
  1006dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006df:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006e5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006e9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006f0:	00 
  1006f1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006f8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100702:	89 04 24             	mov    %eax,(%esp)
  100705:	e8 b9 fc ff ff       	call   1003c3 <stab_binsearch>
    if (lline <= rline) {
  10070a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10070d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100710:	39 c2                	cmp    %eax,%edx
  100712:	7f 24                	jg     100738 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100714:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100717:	89 c2                	mov    %eax,%edx
  100719:	89 d0                	mov    %edx,%eax
  10071b:	01 c0                	add    %eax,%eax
  10071d:	01 d0                	add    %edx,%eax
  10071f:	c1 e0 02             	shl    $0x2,%eax
  100722:	89 c2                	mov    %eax,%edx
  100724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100727:	01 d0                	add    %edx,%eax
  100729:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10072d:	0f b7 d0             	movzwl %ax,%edx
  100730:	8b 45 0c             	mov    0xc(%ebp),%eax
  100733:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100736:	eb 13                	jmp    10074b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100738:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10073d:	e9 12 01 00 00       	jmp    100854 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100742:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100745:	83 e8 01             	sub    $0x1,%eax
  100748:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10074b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10074e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100751:	39 c2                	cmp    %eax,%edx
  100753:	7c 56                	jl     1007ab <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100755:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100758:	89 c2                	mov    %eax,%edx
  10075a:	89 d0                	mov    %edx,%eax
  10075c:	01 c0                	add    %eax,%eax
  10075e:	01 d0                	add    %edx,%eax
  100760:	c1 e0 02             	shl    $0x2,%eax
  100763:	89 c2                	mov    %eax,%edx
  100765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100768:	01 d0                	add    %edx,%eax
  10076a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10076e:	3c 84                	cmp    $0x84,%al
  100770:	74 39                	je     1007ab <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100772:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100775:	89 c2                	mov    %eax,%edx
  100777:	89 d0                	mov    %edx,%eax
  100779:	01 c0                	add    %eax,%eax
  10077b:	01 d0                	add    %edx,%eax
  10077d:	c1 e0 02             	shl    $0x2,%eax
  100780:	89 c2                	mov    %eax,%edx
  100782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100785:	01 d0                	add    %edx,%eax
  100787:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10078b:	3c 64                	cmp    $0x64,%al
  10078d:	75 b3                	jne    100742 <debuginfo_eip+0x229>
  10078f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100792:	89 c2                	mov    %eax,%edx
  100794:	89 d0                	mov    %edx,%eax
  100796:	01 c0                	add    %eax,%eax
  100798:	01 d0                	add    %edx,%eax
  10079a:	c1 e0 02             	shl    $0x2,%eax
  10079d:	89 c2                	mov    %eax,%edx
  10079f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a2:	01 d0                	add    %edx,%eax
  1007a4:	8b 40 08             	mov    0x8(%eax),%eax
  1007a7:	85 c0                	test   %eax,%eax
  1007a9:	74 97                	je     100742 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007b1:	39 c2                	cmp    %eax,%edx
  1007b3:	7c 46                	jl     1007fb <debuginfo_eip+0x2e2>
  1007b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b8:	89 c2                	mov    %eax,%edx
  1007ba:	89 d0                	mov    %edx,%eax
  1007bc:	01 c0                	add    %eax,%eax
  1007be:	01 d0                	add    %edx,%eax
  1007c0:	c1 e0 02             	shl    $0x2,%eax
  1007c3:	89 c2                	mov    %eax,%edx
  1007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c8:	01 d0                	add    %edx,%eax
  1007ca:	8b 10                	mov    (%eax),%edx
  1007cc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007d2:	29 c1                	sub    %eax,%ecx
  1007d4:	89 c8                	mov    %ecx,%eax
  1007d6:	39 c2                	cmp    %eax,%edx
  1007d8:	73 21                	jae    1007fb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	89 d0                	mov    %edx,%eax
  1007e1:	01 c0                	add    %eax,%eax
  1007e3:	01 d0                	add    %edx,%eax
  1007e5:	c1 e0 02             	shl    $0x2,%eax
  1007e8:	89 c2                	mov    %eax,%edx
  1007ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ed:	01 d0                	add    %edx,%eax
  1007ef:	8b 10                	mov    (%eax),%edx
  1007f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f4:	01 c2                	add    %eax,%edx
  1007f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100801:	39 c2                	cmp    %eax,%edx
  100803:	7d 4a                	jge    10084f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  100805:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100808:	83 c0 01             	add    $0x1,%eax
  10080b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10080e:	eb 18                	jmp    100828 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	8b 40 14             	mov    0x14(%eax),%eax
  100816:	8d 50 01             	lea    0x1(%eax),%edx
  100819:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10081f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100828:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10082e:	39 c2                	cmp    %eax,%edx
  100830:	7d 1d                	jge    10084f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100835:	89 c2                	mov    %eax,%edx
  100837:	89 d0                	mov    %edx,%eax
  100839:	01 c0                	add    %eax,%eax
  10083b:	01 d0                	add    %edx,%eax
  10083d:	c1 e0 02             	shl    $0x2,%eax
  100840:	89 c2                	mov    %eax,%edx
  100842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100845:	01 d0                	add    %edx,%eax
  100847:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10084b:	3c a0                	cmp    $0xa0,%al
  10084d:	74 c1                	je     100810 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10084f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100854:	c9                   	leave  
  100855:	c3                   	ret    

00100856 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100856:	55                   	push   %ebp
  100857:	89 e5                	mov    %esp,%ebp
  100859:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10085c:	c7 04 24 96 36 10 00 	movl   $0x103696,(%esp)
  100863:	e8 ba fa ff ff       	call   100322 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100868:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10086f:	00 
  100870:	c7 04 24 af 36 10 00 	movl   $0x1036af,(%esp)
  100877:	e8 a6 fa ff ff       	call   100322 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10087c:	c7 44 24 04 ca 35 10 	movl   $0x1035ca,0x4(%esp)
  100883:	00 
  100884:	c7 04 24 c7 36 10 00 	movl   $0x1036c7,(%esp)
  10088b:	e8 92 fa ff ff       	call   100322 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100890:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100897:	00 
  100898:	c7 04 24 df 36 10 00 	movl   $0x1036df,(%esp)
  10089f:	e8 7e fa ff ff       	call   100322 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008a4:	c7 44 24 04 80 fd 10 	movl   $0x10fd80,0x4(%esp)
  1008ab:	00 
  1008ac:	c7 04 24 f7 36 10 00 	movl   $0x1036f7,(%esp)
  1008b3:	e8 6a fa ff ff       	call   100322 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008b8:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  1008bd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008c8:	29 c2                	sub    %eax,%edx
  1008ca:	89 d0                	mov    %edx,%eax
  1008cc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008d2:	85 c0                	test   %eax,%eax
  1008d4:	0f 48 c2             	cmovs  %edx,%eax
  1008d7:	c1 f8 0a             	sar    $0xa,%eax
  1008da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008de:	c7 04 24 10 37 10 00 	movl   $0x103710,(%esp)
  1008e5:	e8 38 fa ff ff       	call   100322 <cprintf>
}
  1008ea:	c9                   	leave  
  1008eb:	c3                   	ret    

001008ec <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008ec:	55                   	push   %ebp
  1008ed:	89 e5                	mov    %esp,%ebp
  1008ef:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ff:	89 04 24             	mov    %eax,(%esp)
  100902:	e8 12 fc ff ff       	call   100519 <debuginfo_eip>
  100907:	85 c0                	test   %eax,%eax
  100909:	74 15                	je     100920 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  10090b:	8b 45 08             	mov    0x8(%ebp),%eax
  10090e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100912:	c7 04 24 3a 37 10 00 	movl   $0x10373a,(%esp)
  100919:	e8 04 fa ff ff       	call   100322 <cprintf>
  10091e:	eb 6d                	jmp    10098d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100920:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100927:	eb 1c                	jmp    100945 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100929:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10092c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10092f:	01 d0                	add    %edx,%eax
  100931:	0f b6 00             	movzbl (%eax),%eax
  100934:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10093a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10093d:	01 ca                	add    %ecx,%edx
  10093f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100941:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100945:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100948:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10094b:	7f dc                	jg     100929 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10094d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100956:	01 d0                	add    %edx,%eax
  100958:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10095b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10095e:	8b 55 08             	mov    0x8(%ebp),%edx
  100961:	89 d1                	mov    %edx,%ecx
  100963:	29 c1                	sub    %eax,%ecx
  100965:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100968:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10096b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10096f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100975:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100979:	89 54 24 08          	mov    %edx,0x8(%esp)
  10097d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100981:	c7 04 24 56 37 10 00 	movl   $0x103756,(%esp)
  100988:	e8 95 f9 ff ff       	call   100322 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10098d:	c9                   	leave  
  10098e:	c3                   	ret    

0010098f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10098f:	55                   	push   %ebp
  100990:	89 e5                	mov    %esp,%ebp
  100992:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100995:	8b 45 04             	mov    0x4(%ebp),%eax
  100998:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10099b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10099e:	c9                   	leave  
  10099f:	c3                   	ret    

001009a0 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009a0:	55                   	push   %ebp
  1009a1:	89 e5                	mov    %esp,%ebp
  1009a3:	53                   	push   %ebx
  1009a4:	83 ec 54             	sub    $0x54,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009a7:	89 e8                	mov    %ebp,%eax
  1009a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  1009ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

    uint32_t ebp_val = read_ebp();
  1009af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip_val = read_eip();
  1009b2:	e8 d8 ff ff ff       	call   10098f <read_eip>
  1009b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i = 0;
  1009ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for(i = 0; i < STACKFRAME_DEPTH && ebp_val != 0; i++){
  1009c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009c8:	e9 9d 00 00 00       	jmp    100a6a <print_stackframe+0xca>
        cprintf("ebp:0x%08x, eip:0x%08x", ebp_val, eip_val);  // 输出八位十六进制（即32位寄存器值）
  1009cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009db:	c7 04 24 68 37 10 00 	movl   $0x103768,(%esp)
  1009e2:	e8 3b f9 ff ff       	call   100322 <cprintf>
        uint32_t* ebp_ptr = (uint32_t*)ebp_val;
  1009e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
        uint32_t args[] = {*(ebp_ptr+2), *(ebp_ptr+3), *(ebp_ptr+4), *(ebp_ptr+5)};
  1009ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009f0:	8b 40 08             	mov    0x8(%eax),%eax
  1009f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1009f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009f9:	8b 40 0c             	mov    0xc(%eax),%eax
  1009fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1009ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a02:	8b 40 10             	mov    0x10(%eax),%eax
  100a05:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100a08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a0b:	8b 40 14             	mov    0x14(%eax),%eax
  100a0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        cprintf(" args:0x%08x 0x%08x 0x%08x 0x%08x", args[0], args[1], args[2], args[3]);
  100a11:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  100a14:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  100a17:	8b 55 d8             	mov    -0x28(%ebp),%edx
  100a1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100a1d:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100a21:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a25:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a29:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a2d:	c7 04 24 80 37 10 00 	movl   $0x103780,(%esp)
  100a34:	e8 e9 f8 ff ff       	call   100322 <cprintf>
        cprintf("\n");
  100a39:	c7 04 24 a2 37 10 00 	movl   $0x1037a2,(%esp)
  100a40:	e8 dd f8 ff ff       	call   100322 <cprintf>
        print_debuginfo(eip_val - 1);
  100a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a48:	83 e8 01             	sub    $0x1,%eax
  100a4b:	89 04 24             	mov    %eax,(%esp)
  100a4e:	e8 99 fe ff ff       	call   1008ec <print_debuginfo>
        eip_val = *(uint32_t*)(ebp_val + 4);
  100a53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a56:	83 c0 04             	add    $0x4,%eax
  100a59:	8b 00                	mov    (%eax),%eax
  100a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp_val = *(uint32_t*)ebp_val;
  100a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a61:	8b 00                	mov    (%eax),%eax
  100a63:	89 45 f4             	mov    %eax,-0xc(%ebp)
      */

    uint32_t ebp_val = read_ebp();
    uint32_t eip_val = read_eip();
    int i = 0;
    for(i = 0; i < STACKFRAME_DEPTH && ebp_val != 0; i++){
  100a66:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a6a:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a6e:	7f 0a                	jg     100a7a <print_stackframe+0xda>
  100a70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a74:	0f 85 53 ff ff ff    	jne    1009cd <print_stackframe+0x2d>
        cprintf("\n");
        print_debuginfo(eip_val - 1);
        eip_val = *(uint32_t*)(ebp_val + 4);
        ebp_val = *(uint32_t*)ebp_val;
    }
}
  100a7a:	83 c4 54             	add    $0x54,%esp
  100a7d:	5b                   	pop    %ebx
  100a7e:	5d                   	pop    %ebp
  100a7f:	c3                   	ret    

00100a80 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a80:	55                   	push   %ebp
  100a81:	89 e5                	mov    %esp,%ebp
  100a83:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a8d:	eb 0c                	jmp    100a9b <parse+0x1b>
            *buf ++ = '\0';
  100a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a92:	8d 50 01             	lea    0x1(%eax),%edx
  100a95:	89 55 08             	mov    %edx,0x8(%ebp)
  100a98:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9e:	0f b6 00             	movzbl (%eax),%eax
  100aa1:	84 c0                	test   %al,%al
  100aa3:	74 1d                	je     100ac2 <parse+0x42>
  100aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa8:	0f b6 00             	movzbl (%eax),%eax
  100aab:	0f be c0             	movsbl %al,%eax
  100aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab2:	c7 04 24 24 38 10 00 	movl   $0x103824,(%esp)
  100ab9:	e8 c4 27 00 00       	call   103282 <strchr>
  100abe:	85 c0                	test   %eax,%eax
  100ac0:	75 cd                	jne    100a8f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac5:	0f b6 00             	movzbl (%eax),%eax
  100ac8:	84 c0                	test   %al,%al
  100aca:	75 02                	jne    100ace <parse+0x4e>
            break;
  100acc:	eb 67                	jmp    100b35 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ace:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad2:	75 14                	jne    100ae8 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100adb:	00 
  100adc:	c7 04 24 29 38 10 00 	movl   $0x103829,(%esp)
  100ae3:	e8 3a f8 ff ff       	call   100322 <cprintf>
        }
        argv[argc ++] = buf;
  100ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aeb:	8d 50 01             	lea    0x1(%eax),%edx
  100aee:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100af1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  100afb:	01 c2                	add    %eax,%edx
  100afd:	8b 45 08             	mov    0x8(%ebp),%eax
  100b00:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b02:	eb 04                	jmp    100b08 <parse+0x88>
            buf ++;
  100b04:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b08:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0b:	0f b6 00             	movzbl (%eax),%eax
  100b0e:	84 c0                	test   %al,%al
  100b10:	74 1d                	je     100b2f <parse+0xaf>
  100b12:	8b 45 08             	mov    0x8(%ebp),%eax
  100b15:	0f b6 00             	movzbl (%eax),%eax
  100b18:	0f be c0             	movsbl %al,%eax
  100b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1f:	c7 04 24 24 38 10 00 	movl   $0x103824,(%esp)
  100b26:	e8 57 27 00 00       	call   103282 <strchr>
  100b2b:	85 c0                	test   %eax,%eax
  100b2d:	74 d5                	je     100b04 <parse+0x84>
            buf ++;
        }
    }
  100b2f:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b30:	e9 66 ff ff ff       	jmp    100a9b <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b38:	c9                   	leave  
  100b39:	c3                   	ret    

00100b3a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b3a:	55                   	push   %ebp
  100b3b:	89 e5                	mov    %esp,%ebp
  100b3d:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b40:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b47:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4a:	89 04 24             	mov    %eax,(%esp)
  100b4d:	e8 2e ff ff ff       	call   100a80 <parse>
  100b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b59:	75 0a                	jne    100b65 <runcmd+0x2b>
        return 0;
  100b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  100b60:	e9 85 00 00 00       	jmp    100bea <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b6c:	eb 5c                	jmp    100bca <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b6e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b74:	89 d0                	mov    %edx,%eax
  100b76:	01 c0                	add    %eax,%eax
  100b78:	01 d0                	add    %edx,%eax
  100b7a:	c1 e0 02             	shl    $0x2,%eax
  100b7d:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b82:	8b 00                	mov    (%eax),%eax
  100b84:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b88:	89 04 24             	mov    %eax,(%esp)
  100b8b:	e8 53 26 00 00       	call   1031e3 <strcmp>
  100b90:	85 c0                	test   %eax,%eax
  100b92:	75 32                	jne    100bc6 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b97:	89 d0                	mov    %edx,%eax
  100b99:	01 c0                	add    %eax,%eax
  100b9b:	01 d0                	add    %edx,%eax
  100b9d:	c1 e0 02             	shl    $0x2,%eax
  100ba0:	05 00 e0 10 00       	add    $0x10e000,%eax
  100ba5:	8b 40 08             	mov    0x8(%eax),%eax
  100ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100bab:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bb1:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bb5:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb8:	83 c2 04             	add    $0x4,%edx
  100bbb:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bbf:	89 0c 24             	mov    %ecx,(%esp)
  100bc2:	ff d0                	call   *%eax
  100bc4:	eb 24                	jmp    100bea <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bc6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bcd:	83 f8 02             	cmp    $0x2,%eax
  100bd0:	76 9c                	jbe    100b6e <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd9:	c7 04 24 47 38 10 00 	movl   $0x103847,(%esp)
  100be0:	e8 3d f7 ff ff       	call   100322 <cprintf>
    return 0;
  100be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bea:	c9                   	leave  
  100beb:	c3                   	ret    

00100bec <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bec:	55                   	push   %ebp
  100bed:	89 e5                	mov    %esp,%ebp
  100bef:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bf2:	c7 04 24 60 38 10 00 	movl   $0x103860,(%esp)
  100bf9:	e8 24 f7 ff ff       	call   100322 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bfe:	c7 04 24 88 38 10 00 	movl   $0x103888,(%esp)
  100c05:	e8 18 f7 ff ff       	call   100322 <cprintf>

    if (tf != NULL) {
  100c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c0e:	74 0b                	je     100c1b <kmonitor+0x2f>
        print_trapframe(tf);
  100c10:	8b 45 08             	mov    0x8(%ebp),%eax
  100c13:	89 04 24             	mov    %eax,(%esp)
  100c16:	e8 04 0e 00 00       	call   101a1f <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c1b:	c7 04 24 ad 38 10 00 	movl   $0x1038ad,(%esp)
  100c22:	e8 f2 f5 ff ff       	call   100219 <readline>
  100c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c2e:	74 18                	je     100c48 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c30:	8b 45 08             	mov    0x8(%ebp),%eax
  100c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3a:	89 04 24             	mov    %eax,(%esp)
  100c3d:	e8 f8 fe ff ff       	call   100b3a <runcmd>
  100c42:	85 c0                	test   %eax,%eax
  100c44:	79 02                	jns    100c48 <kmonitor+0x5c>
                break;
  100c46:	eb 02                	jmp    100c4a <kmonitor+0x5e>
            }
        }
    }
  100c48:	eb d1                	jmp    100c1b <kmonitor+0x2f>
}
  100c4a:	c9                   	leave  
  100c4b:	c3                   	ret    

00100c4c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c4c:	55                   	push   %ebp
  100c4d:	89 e5                	mov    %esp,%ebp
  100c4f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c59:	eb 3f                	jmp    100c9a <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c5e:	89 d0                	mov    %edx,%eax
  100c60:	01 c0                	add    %eax,%eax
  100c62:	01 d0                	add    %edx,%eax
  100c64:	c1 e0 02             	shl    $0x2,%eax
  100c67:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c6c:	8b 48 04             	mov    0x4(%eax),%ecx
  100c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c72:	89 d0                	mov    %edx,%eax
  100c74:	01 c0                	add    %eax,%eax
  100c76:	01 d0                	add    %edx,%eax
  100c78:	c1 e0 02             	shl    $0x2,%eax
  100c7b:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c80:	8b 00                	mov    (%eax),%eax
  100c82:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c86:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c8a:	c7 04 24 b1 38 10 00 	movl   $0x1038b1,(%esp)
  100c91:	e8 8c f6 ff ff       	call   100322 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c96:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c9d:	83 f8 02             	cmp    $0x2,%eax
  100ca0:	76 b9                	jbe    100c5b <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca7:	c9                   	leave  
  100ca8:	c3                   	ret    

00100ca9 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca9:	55                   	push   %ebp
  100caa:	89 e5                	mov    %esp,%ebp
  100cac:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100caf:	e8 a2 fb ff ff       	call   100856 <print_kerninfo>
    return 0;
  100cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb9:	c9                   	leave  
  100cba:	c3                   	ret    

00100cbb <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cbb:	55                   	push   %ebp
  100cbc:	89 e5                	mov    %esp,%ebp
  100cbe:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cc1:	e8 da fc ff ff       	call   1009a0 <print_stackframe>
    return 0;
  100cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ccb:	c9                   	leave  
  100ccc:	c3                   	ret    

00100ccd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ccd:	55                   	push   %ebp
  100cce:	89 e5                	mov    %esp,%ebp
  100cd0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cd3:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100cd8:	85 c0                	test   %eax,%eax
  100cda:	74 02                	je     100cde <__panic+0x11>
        goto panic_dead;
  100cdc:	eb 59                	jmp    100d37 <__panic+0x6a>
    }
    is_panic = 1;
  100cde:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100ce5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ce8:	8d 45 14             	lea    0x14(%ebp),%eax
  100ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cf1:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cfc:	c7 04 24 ba 38 10 00 	movl   $0x1038ba,(%esp)
  100d03:	e8 1a f6 ff ff       	call   100322 <cprintf>
    vcprintf(fmt, ap);
  100d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  100d12:	89 04 24             	mov    %eax,(%esp)
  100d15:	e8 d5 f5 ff ff       	call   1002ef <vcprintf>
    cprintf("\n");
  100d1a:	c7 04 24 d6 38 10 00 	movl   $0x1038d6,(%esp)
  100d21:	e8 fc f5 ff ff       	call   100322 <cprintf>
    
    cprintf("stack trackback:\n");
  100d26:	c7 04 24 d8 38 10 00 	movl   $0x1038d8,(%esp)
  100d2d:	e8 f0 f5 ff ff       	call   100322 <cprintf>
    print_stackframe();
  100d32:	e8 69 fc ff ff       	call   1009a0 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d37:	e8 22 09 00 00       	call   10165e <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d3c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d43:	e8 a4 fe ff ff       	call   100bec <kmonitor>
    }
  100d48:	eb f2                	jmp    100d3c <__panic+0x6f>

00100d4a <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d4a:	55                   	push   %ebp
  100d4b:	89 e5                	mov    %esp,%ebp
  100d4d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d50:	8d 45 14             	lea    0x14(%ebp),%eax
  100d53:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d59:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  100d60:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d64:	c7 04 24 ea 38 10 00 	movl   $0x1038ea,(%esp)
  100d6b:	e8 b2 f5 ff ff       	call   100322 <cprintf>
    vcprintf(fmt, ap);
  100d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d73:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d77:	8b 45 10             	mov    0x10(%ebp),%eax
  100d7a:	89 04 24             	mov    %eax,(%esp)
  100d7d:	e8 6d f5 ff ff       	call   1002ef <vcprintf>
    cprintf("\n");
  100d82:	c7 04 24 d6 38 10 00 	movl   $0x1038d6,(%esp)
  100d89:	e8 94 f5 ff ff       	call   100322 <cprintf>
    va_end(ap);
}
  100d8e:	c9                   	leave  
  100d8f:	c3                   	ret    

00100d90 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d90:	55                   	push   %ebp
  100d91:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d93:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d98:	5d                   	pop    %ebp
  100d99:	c3                   	ret    

00100d9a <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d9a:	55                   	push   %ebp
  100d9b:	89 e5                	mov    %esp,%ebp
  100d9d:	83 ec 28             	sub    $0x28,%esp
  100da0:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100da6:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100daa:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dae:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100db2:	ee                   	out    %al,(%dx)
  100db3:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100db9:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dbd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dc1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dc5:	ee                   	out    %al,(%dx)
  100dc6:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dcc:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dd0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dd4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dd8:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dd9:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100de0:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100de3:	c7 04 24 08 39 10 00 	movl   $0x103908,(%esp)
  100dea:	e8 33 f5 ff ff       	call   100322 <cprintf>
    pic_enable(IRQ_TIMER);
  100def:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100df6:	e8 c1 08 00 00       	call   1016bc <pic_enable>
}
  100dfb:	c9                   	leave  
  100dfc:	c3                   	ret    

00100dfd <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dfd:	55                   	push   %ebp
  100dfe:	89 e5                	mov    %esp,%ebp
  100e00:	83 ec 10             	sub    $0x10,%esp
  100e03:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e09:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e0d:	89 c2                	mov    %eax,%edx
  100e0f:	ec                   	in     (%dx),%al
  100e10:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e13:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e19:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e1d:	89 c2                	mov    %eax,%edx
  100e1f:	ec                   	in     (%dx),%al
  100e20:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e23:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e29:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e2d:	89 c2                	mov    %eax,%edx
  100e2f:	ec                   	in     (%dx),%al
  100e30:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e33:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e39:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e3d:	89 c2                	mov    %eax,%edx
  100e3f:	ec                   	in     (%dx),%al
  100e40:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e43:	c9                   	leave  
  100e44:	c3                   	ret    

00100e45 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e45:	55                   	push   %ebp
  100e46:	89 e5                	mov    %esp,%ebp
  100e48:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100e4b:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e55:	0f b7 00             	movzwl (%eax),%eax
  100e58:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e5f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e67:	0f b7 00             	movzwl (%eax),%eax
  100e6a:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e6e:	74 12                	je     100e82 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e70:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e77:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e7e:	b4 03 
  100e80:	eb 13                	jmp    100e95 <cga_init+0x50>
    } else {
        *cp = was;
  100e82:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e85:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e89:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e8c:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e93:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e95:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e9c:	0f b7 c0             	movzwl %ax,%eax
  100e9f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ea3:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ea7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100eab:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100eaf:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100eb0:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eb7:	83 c0 01             	add    $0x1,%eax
  100eba:	0f b7 c0             	movzwl %ax,%eax
  100ebd:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ec1:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ec5:	89 c2                	mov    %eax,%edx
  100ec7:	ec                   	in     (%dx),%al
  100ec8:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ecb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ecf:	0f b6 c0             	movzbl %al,%eax
  100ed2:	c1 e0 08             	shl    $0x8,%eax
  100ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ed8:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100edf:	0f b7 c0             	movzwl %ax,%eax
  100ee2:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ee6:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eea:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100eee:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ef2:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100ef3:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100efa:	83 c0 01             	add    $0x1,%eax
  100efd:	0f b7 c0             	movzwl %ax,%eax
  100f00:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f04:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f08:	89 c2                	mov    %eax,%edx
  100f0a:	ec                   	in     (%dx),%al
  100f0b:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f0e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f12:	0f b6 c0             	movzbl %al,%eax
  100f15:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f1b:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;
  100f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f23:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100f29:	c9                   	leave  
  100f2a:	c3                   	ret    

00100f2b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f2b:	55                   	push   %ebp
  100f2c:	89 e5                	mov    %esp,%ebp
  100f2e:	83 ec 48             	sub    $0x48,%esp
  100f31:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f37:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f3b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f3f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f43:	ee                   	out    %al,(%dx)
  100f44:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f4a:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f4e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f52:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f56:	ee                   	out    %al,(%dx)
  100f57:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f5d:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f61:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f65:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f69:	ee                   	out    %al,(%dx)
  100f6a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f70:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f74:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f78:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f7c:	ee                   	out    %al,(%dx)
  100f7d:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f83:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f87:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f8b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f8f:	ee                   	out    %al,(%dx)
  100f90:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f96:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f9a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f9e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fa2:	ee                   	out    %al,(%dx)
  100fa3:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fa9:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fad:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fb1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fb5:	ee                   	out    %al,(%dx)
  100fb6:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fbc:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fc0:	89 c2                	mov    %eax,%edx
  100fc2:	ec                   	in     (%dx),%al
  100fc3:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100fc6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fca:	3c ff                	cmp    $0xff,%al
  100fcc:	0f 95 c0             	setne  %al
  100fcf:	0f b6 c0             	movzbl %al,%eax
  100fd2:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fd7:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fdd:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fe1:	89 c2                	mov    %eax,%edx
  100fe3:	ec                   	in     (%dx),%al
  100fe4:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fe7:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fed:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100ff1:	89 c2                	mov    %eax,%edx
  100ff3:	ec                   	in     (%dx),%al
  100ff4:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100ff7:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100ffc:	85 c0                	test   %eax,%eax
  100ffe:	74 0c                	je     10100c <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101000:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101007:	e8 b0 06 00 00       	call   1016bc <pic_enable>
    }
}
  10100c:	c9                   	leave  
  10100d:	c3                   	ret    

0010100e <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10100e:	55                   	push   %ebp
  10100f:	89 e5                	mov    %esp,%ebp
  101011:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101014:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10101b:	eb 09                	jmp    101026 <lpt_putc_sub+0x18>
        delay();
  10101d:	e8 db fd ff ff       	call   100dfd <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101022:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101026:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10102c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101030:	89 c2                	mov    %eax,%edx
  101032:	ec                   	in     (%dx),%al
  101033:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101036:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10103a:	84 c0                	test   %al,%al
  10103c:	78 09                	js     101047 <lpt_putc_sub+0x39>
  10103e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101045:	7e d6                	jle    10101d <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101047:	8b 45 08             	mov    0x8(%ebp),%eax
  10104a:	0f b6 c0             	movzbl %al,%eax
  10104d:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101053:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101056:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10105a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10105e:	ee                   	out    %al,(%dx)
  10105f:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101065:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101069:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10106d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101071:	ee                   	out    %al,(%dx)
  101072:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101078:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10107c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101080:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101084:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101085:	c9                   	leave  
  101086:	c3                   	ret    

00101087 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101087:	55                   	push   %ebp
  101088:	89 e5                	mov    %esp,%ebp
  10108a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10108d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101091:	74 0d                	je     1010a0 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101093:	8b 45 08             	mov    0x8(%ebp),%eax
  101096:	89 04 24             	mov    %eax,(%esp)
  101099:	e8 70 ff ff ff       	call   10100e <lpt_putc_sub>
  10109e:	eb 24                	jmp    1010c4 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010a0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010a7:	e8 62 ff ff ff       	call   10100e <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010ac:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010b3:	e8 56 ff ff ff       	call   10100e <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010b8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010bf:	e8 4a ff ff ff       	call   10100e <lpt_putc_sub>
    }
}
  1010c4:	c9                   	leave  
  1010c5:	c3                   	ret    

001010c6 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010c6:	55                   	push   %ebp
  1010c7:	89 e5                	mov    %esp,%ebp
  1010c9:	53                   	push   %ebx
  1010ca:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d0:	b0 00                	mov    $0x0,%al
  1010d2:	85 c0                	test   %eax,%eax
  1010d4:	75 07                	jne    1010dd <cga_putc+0x17>
        c |= 0x0700;
  1010d6:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e0:	0f b6 c0             	movzbl %al,%eax
  1010e3:	83 f8 0a             	cmp    $0xa,%eax
  1010e6:	74 4c                	je     101134 <cga_putc+0x6e>
  1010e8:	83 f8 0d             	cmp    $0xd,%eax
  1010eb:	74 57                	je     101144 <cga_putc+0x7e>
  1010ed:	83 f8 08             	cmp    $0x8,%eax
  1010f0:	0f 85 88 00 00 00    	jne    10117e <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010f6:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010fd:	66 85 c0             	test   %ax,%ax
  101100:	74 30                	je     101132 <cga_putc+0x6c>
            crt_pos --;
  101102:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101109:	83 e8 01             	sub    $0x1,%eax
  10110c:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101112:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101117:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  10111e:	0f b7 d2             	movzwl %dx,%edx
  101121:	01 d2                	add    %edx,%edx
  101123:	01 c2                	add    %eax,%edx
  101125:	8b 45 08             	mov    0x8(%ebp),%eax
  101128:	b0 00                	mov    $0x0,%al
  10112a:	83 c8 20             	or     $0x20,%eax
  10112d:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101130:	eb 72                	jmp    1011a4 <cga_putc+0xde>
  101132:	eb 70                	jmp    1011a4 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101134:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10113b:	83 c0 50             	add    $0x50,%eax
  10113e:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101144:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  10114b:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101152:	0f b7 c1             	movzwl %cx,%eax
  101155:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10115b:	c1 e8 10             	shr    $0x10,%eax
  10115e:	89 c2                	mov    %eax,%edx
  101160:	66 c1 ea 06          	shr    $0x6,%dx
  101164:	89 d0                	mov    %edx,%eax
  101166:	c1 e0 02             	shl    $0x2,%eax
  101169:	01 d0                	add    %edx,%eax
  10116b:	c1 e0 04             	shl    $0x4,%eax
  10116e:	29 c1                	sub    %eax,%ecx
  101170:	89 ca                	mov    %ecx,%edx
  101172:	89 d8                	mov    %ebx,%eax
  101174:	29 d0                	sub    %edx,%eax
  101176:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10117c:	eb 26                	jmp    1011a4 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10117e:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101184:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10118b:	8d 50 01             	lea    0x1(%eax),%edx
  10118e:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101195:	0f b7 c0             	movzwl %ax,%eax
  101198:	01 c0                	add    %eax,%eax
  10119a:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10119d:	8b 45 08             	mov    0x8(%ebp),%eax
  1011a0:	66 89 02             	mov    %ax,(%edx)
        break;
  1011a3:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011a4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011ab:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011af:	76 5b                	jbe    10120c <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011b1:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011b6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011bc:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011c1:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011c8:	00 
  1011c9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011cd:	89 04 24             	mov    %eax,(%esp)
  1011d0:	e8 ab 22 00 00       	call   103480 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011d5:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011dc:	eb 15                	jmp    1011f3 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011de:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011e6:	01 d2                	add    %edx,%edx
  1011e8:	01 d0                	add    %edx,%eax
  1011ea:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011f3:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011fa:	7e e2                	jle    1011de <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011fc:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101203:	83 e8 50             	sub    $0x50,%eax
  101206:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10120c:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101213:	0f b7 c0             	movzwl %ax,%eax
  101216:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10121a:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10121e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101222:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101226:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101227:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10122e:	66 c1 e8 08          	shr    $0x8,%ax
  101232:	0f b6 c0             	movzbl %al,%eax
  101235:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10123c:	83 c2 01             	add    $0x1,%edx
  10123f:	0f b7 d2             	movzwl %dx,%edx
  101242:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101246:	88 45 ed             	mov    %al,-0x13(%ebp)
  101249:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10124d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101251:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101252:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101259:	0f b7 c0             	movzwl %ax,%eax
  10125c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101260:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101264:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101268:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10126c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10126d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101274:	0f b6 c0             	movzbl %al,%eax
  101277:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10127e:	83 c2 01             	add    $0x1,%edx
  101281:	0f b7 d2             	movzwl %dx,%edx
  101284:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101288:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10128b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10128f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101293:	ee                   	out    %al,(%dx)
}
  101294:	83 c4 34             	add    $0x34,%esp
  101297:	5b                   	pop    %ebx
  101298:	5d                   	pop    %ebp
  101299:	c3                   	ret    

0010129a <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10129a:	55                   	push   %ebp
  10129b:	89 e5                	mov    %esp,%ebp
  10129d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012a7:	eb 09                	jmp    1012b2 <serial_putc_sub+0x18>
        delay();
  1012a9:	e8 4f fb ff ff       	call   100dfd <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012ae:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012b2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012b8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012bc:	89 c2                	mov    %eax,%edx
  1012be:	ec                   	in     (%dx),%al
  1012bf:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012c2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012c6:	0f b6 c0             	movzbl %al,%eax
  1012c9:	83 e0 20             	and    $0x20,%eax
  1012cc:	85 c0                	test   %eax,%eax
  1012ce:	75 09                	jne    1012d9 <serial_putc_sub+0x3f>
  1012d0:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012d7:	7e d0                	jle    1012a9 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1012dc:	0f b6 c0             	movzbl %al,%eax
  1012df:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012e5:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012e8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012ec:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012f0:	ee                   	out    %al,(%dx)
}
  1012f1:	c9                   	leave  
  1012f2:	c3                   	ret    

001012f3 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012f3:	55                   	push   %ebp
  1012f4:	89 e5                	mov    %esp,%ebp
  1012f6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012f9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012fd:	74 0d                	je     10130c <serial_putc+0x19>
        serial_putc_sub(c);
  1012ff:	8b 45 08             	mov    0x8(%ebp),%eax
  101302:	89 04 24             	mov    %eax,(%esp)
  101305:	e8 90 ff ff ff       	call   10129a <serial_putc_sub>
  10130a:	eb 24                	jmp    101330 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  10130c:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101313:	e8 82 ff ff ff       	call   10129a <serial_putc_sub>
        serial_putc_sub(' ');
  101318:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10131f:	e8 76 ff ff ff       	call   10129a <serial_putc_sub>
        serial_putc_sub('\b');
  101324:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10132b:	e8 6a ff ff ff       	call   10129a <serial_putc_sub>
    }
}
  101330:	c9                   	leave  
  101331:	c3                   	ret    

00101332 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101332:	55                   	push   %ebp
  101333:	89 e5                	mov    %esp,%ebp
  101335:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101338:	eb 33                	jmp    10136d <cons_intr+0x3b>
        if (c != 0) {
  10133a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10133e:	74 2d                	je     10136d <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101340:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101345:	8d 50 01             	lea    0x1(%eax),%edx
  101348:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10134e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101351:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101357:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10135c:	3d 00 02 00 00       	cmp    $0x200,%eax
  101361:	75 0a                	jne    10136d <cons_intr+0x3b>
                cons.wpos = 0;
  101363:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10136a:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10136d:	8b 45 08             	mov    0x8(%ebp),%eax
  101370:	ff d0                	call   *%eax
  101372:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101375:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101379:	75 bf                	jne    10133a <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10137b:	c9                   	leave  
  10137c:	c3                   	ret    

0010137d <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10137d:	55                   	push   %ebp
  10137e:	89 e5                	mov    %esp,%ebp
  101380:	83 ec 10             	sub    $0x10,%esp
  101383:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101389:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10138d:	89 c2                	mov    %eax,%edx
  10138f:	ec                   	in     (%dx),%al
  101390:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101393:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101397:	0f b6 c0             	movzbl %al,%eax
  10139a:	83 e0 01             	and    $0x1,%eax
  10139d:	85 c0                	test   %eax,%eax
  10139f:	75 07                	jne    1013a8 <serial_proc_data+0x2b>
        return -1;
  1013a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013a6:	eb 2a                	jmp    1013d2 <serial_proc_data+0x55>
  1013a8:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013ae:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013b2:	89 c2                	mov    %eax,%edx
  1013b4:	ec                   	in     (%dx),%al
  1013b5:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013b8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013bc:	0f b6 c0             	movzbl %al,%eax
  1013bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013c2:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013c6:	75 07                	jne    1013cf <serial_proc_data+0x52>
        c = '\b';
  1013c8:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013d2:	c9                   	leave  
  1013d3:	c3                   	ret    

001013d4 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013d4:	55                   	push   %ebp
  1013d5:	89 e5                	mov    %esp,%ebp
  1013d7:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013da:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013df:	85 c0                	test   %eax,%eax
  1013e1:	74 0c                	je     1013ef <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013e3:	c7 04 24 7d 13 10 00 	movl   $0x10137d,(%esp)
  1013ea:	e8 43 ff ff ff       	call   101332 <cons_intr>
    }
}
  1013ef:	c9                   	leave  
  1013f0:	c3                   	ret    

001013f1 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013f1:	55                   	push   %ebp
  1013f2:	89 e5                	mov    %esp,%ebp
  1013f4:	83 ec 38             	sub    $0x38,%esp
  1013f7:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013fd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101401:	89 c2                	mov    %eax,%edx
  101403:	ec                   	in     (%dx),%al
  101404:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101407:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  10140b:	0f b6 c0             	movzbl %al,%eax
  10140e:	83 e0 01             	and    $0x1,%eax
  101411:	85 c0                	test   %eax,%eax
  101413:	75 0a                	jne    10141f <kbd_proc_data+0x2e>
        return -1;
  101415:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10141a:	e9 59 01 00 00       	jmp    101578 <kbd_proc_data+0x187>
  10141f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101425:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101429:	89 c2                	mov    %eax,%edx
  10142b:	ec                   	in     (%dx),%al
  10142c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10142f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101433:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101436:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10143a:	75 17                	jne    101453 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10143c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101441:	83 c8 40             	or     $0x40,%eax
  101444:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101449:	b8 00 00 00 00       	mov    $0x0,%eax
  10144e:	e9 25 01 00 00       	jmp    101578 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101453:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101457:	84 c0                	test   %al,%al
  101459:	79 47                	jns    1014a2 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10145b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101460:	83 e0 40             	and    $0x40,%eax
  101463:	85 c0                	test   %eax,%eax
  101465:	75 09                	jne    101470 <kbd_proc_data+0x7f>
  101467:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10146b:	83 e0 7f             	and    $0x7f,%eax
  10146e:	eb 04                	jmp    101474 <kbd_proc_data+0x83>
  101470:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101474:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101477:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147b:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101482:	83 c8 40             	or     $0x40,%eax
  101485:	0f b6 c0             	movzbl %al,%eax
  101488:	f7 d0                	not    %eax
  10148a:	89 c2                	mov    %eax,%edx
  10148c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101491:	21 d0                	and    %edx,%eax
  101493:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101498:	b8 00 00 00 00       	mov    $0x0,%eax
  10149d:	e9 d6 00 00 00       	jmp    101578 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014a2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a7:	83 e0 40             	and    $0x40,%eax
  1014aa:	85 c0                	test   %eax,%eax
  1014ac:	74 11                	je     1014bf <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014ae:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014b2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b7:	83 e0 bf             	and    $0xffffffbf,%eax
  1014ba:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  1014bf:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c3:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1014ca:	0f b6 d0             	movzbl %al,%edx
  1014cd:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d2:	09 d0                	or     %edx,%eax
  1014d4:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014d9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014dd:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014e4:	0f b6 d0             	movzbl %al,%edx
  1014e7:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014ec:	31 d0                	xor    %edx,%eax
  1014ee:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014f3:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014f8:	83 e0 03             	and    $0x3,%eax
  1014fb:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  101502:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101506:	01 d0                	add    %edx,%eax
  101508:	0f b6 00             	movzbl (%eax),%eax
  10150b:	0f b6 c0             	movzbl %al,%eax
  10150e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101511:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101516:	83 e0 08             	and    $0x8,%eax
  101519:	85 c0                	test   %eax,%eax
  10151b:	74 22                	je     10153f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10151d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101521:	7e 0c                	jle    10152f <kbd_proc_data+0x13e>
  101523:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101527:	7f 06                	jg     10152f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101529:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10152d:	eb 10                	jmp    10153f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10152f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101533:	7e 0a                	jle    10153f <kbd_proc_data+0x14e>
  101535:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101539:	7f 04                	jg     10153f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10153b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10153f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101544:	f7 d0                	not    %eax
  101546:	83 e0 06             	and    $0x6,%eax
  101549:	85 c0                	test   %eax,%eax
  10154b:	75 28                	jne    101575 <kbd_proc_data+0x184>
  10154d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101554:	75 1f                	jne    101575 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101556:	c7 04 24 23 39 10 00 	movl   $0x103923,(%esp)
  10155d:	e8 c0 ed ff ff       	call   100322 <cprintf>
  101562:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101568:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10156c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101570:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101574:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101575:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101578:	c9                   	leave  
  101579:	c3                   	ret    

0010157a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10157a:	55                   	push   %ebp
  10157b:	89 e5                	mov    %esp,%ebp
  10157d:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101580:	c7 04 24 f1 13 10 00 	movl   $0x1013f1,(%esp)
  101587:	e8 a6 fd ff ff       	call   101332 <cons_intr>
}
  10158c:	c9                   	leave  
  10158d:	c3                   	ret    

0010158e <kbd_init>:

static void
kbd_init(void) {
  10158e:	55                   	push   %ebp
  10158f:	89 e5                	mov    %esp,%ebp
  101591:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101594:	e8 e1 ff ff ff       	call   10157a <kbd_intr>
    pic_enable(IRQ_KBD);
  101599:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015a0:	e8 17 01 00 00       	call   1016bc <pic_enable>
}
  1015a5:	c9                   	leave  
  1015a6:	c3                   	ret    

001015a7 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015a7:	55                   	push   %ebp
  1015a8:	89 e5                	mov    %esp,%ebp
  1015aa:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015ad:	e8 93 f8 ff ff       	call   100e45 <cga_init>
    serial_init();
  1015b2:	e8 74 f9 ff ff       	call   100f2b <serial_init>
    kbd_init();
  1015b7:	e8 d2 ff ff ff       	call   10158e <kbd_init>
    if (!serial_exists) {
  1015bc:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1015c1:	85 c0                	test   %eax,%eax
  1015c3:	75 0c                	jne    1015d1 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015c5:	c7 04 24 2f 39 10 00 	movl   $0x10392f,(%esp)
  1015cc:	e8 51 ed ff ff       	call   100322 <cprintf>
    }
}
  1015d1:	c9                   	leave  
  1015d2:	c3                   	ret    

001015d3 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015d3:	55                   	push   %ebp
  1015d4:	89 e5                	mov    %esp,%ebp
  1015d6:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1015dc:	89 04 24             	mov    %eax,(%esp)
  1015df:	e8 a3 fa ff ff       	call   101087 <lpt_putc>
    cga_putc(c);
  1015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1015e7:	89 04 24             	mov    %eax,(%esp)
  1015ea:	e8 d7 fa ff ff       	call   1010c6 <cga_putc>
    serial_putc(c);
  1015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1015f2:	89 04 24             	mov    %eax,(%esp)
  1015f5:	e8 f9 fc ff ff       	call   1012f3 <serial_putc>
}
  1015fa:	c9                   	leave  
  1015fb:	c3                   	ret    

001015fc <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015fc:	55                   	push   %ebp
  1015fd:	89 e5                	mov    %esp,%ebp
  1015ff:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  101602:	e8 cd fd ff ff       	call   1013d4 <serial_intr>
    kbd_intr();
  101607:	e8 6e ff ff ff       	call   10157a <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  10160c:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  101612:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101617:	39 c2                	cmp    %eax,%edx
  101619:	74 36                	je     101651 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  10161b:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101620:	8d 50 01             	lea    0x1(%eax),%edx
  101623:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  101629:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  101630:	0f b6 c0             	movzbl %al,%eax
  101633:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101636:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10163b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101640:	75 0a                	jne    10164c <cons_getc+0x50>
            cons.rpos = 0;
  101642:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101649:	00 00 00 
        }
        return c;
  10164c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10164f:	eb 05                	jmp    101656 <cons_getc+0x5a>
    }
    return 0;
  101651:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101656:	c9                   	leave  
  101657:	c3                   	ret    

00101658 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101658:	55                   	push   %ebp
  101659:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10165b:	fb                   	sti    
    sti();
}
  10165c:	5d                   	pop    %ebp
  10165d:	c3                   	ret    

0010165e <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10165e:	55                   	push   %ebp
  10165f:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101661:	fa                   	cli    
    cli();
}
  101662:	5d                   	pop    %ebp
  101663:	c3                   	ret    

00101664 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101664:	55                   	push   %ebp
  101665:	89 e5                	mov    %esp,%ebp
  101667:	83 ec 14             	sub    $0x14,%esp
  10166a:	8b 45 08             	mov    0x8(%ebp),%eax
  10166d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101671:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101675:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10167b:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101680:	85 c0                	test   %eax,%eax
  101682:	74 36                	je     1016ba <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101684:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101688:	0f b6 c0             	movzbl %al,%eax
  10168b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101691:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101694:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101698:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10169c:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10169d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016a1:	66 c1 e8 08          	shr    $0x8,%ax
  1016a5:	0f b6 c0             	movzbl %al,%eax
  1016a8:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016ae:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016b1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016b5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016b9:	ee                   	out    %al,(%dx)
    }
}
  1016ba:	c9                   	leave  
  1016bb:	c3                   	ret    

001016bc <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016bc:	55                   	push   %ebp
  1016bd:	89 e5                	mov    %esp,%ebp
  1016bf:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1016c5:	ba 01 00 00 00       	mov    $0x1,%edx
  1016ca:	89 c1                	mov    %eax,%ecx
  1016cc:	d3 e2                	shl    %cl,%edx
  1016ce:	89 d0                	mov    %edx,%eax
  1016d0:	f7 d0                	not    %eax
  1016d2:	89 c2                	mov    %eax,%edx
  1016d4:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016db:	21 d0                	and    %edx,%eax
  1016dd:	0f b7 c0             	movzwl %ax,%eax
  1016e0:	89 04 24             	mov    %eax,(%esp)
  1016e3:	e8 7c ff ff ff       	call   101664 <pic_setmask>
}
  1016e8:	c9                   	leave  
  1016e9:	c3                   	ret    

001016ea <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016ea:	55                   	push   %ebp
  1016eb:	89 e5                	mov    %esp,%ebp
  1016ed:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016f0:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016f7:	00 00 00 
  1016fa:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101700:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101704:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101708:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10170c:	ee                   	out    %al,(%dx)
  10170d:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101713:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101717:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10171b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10171f:	ee                   	out    %al,(%dx)
  101720:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101726:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10172a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10172e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101732:	ee                   	out    %al,(%dx)
  101733:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101739:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10173d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101741:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101745:	ee                   	out    %al,(%dx)
  101746:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10174c:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101750:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101754:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101758:	ee                   	out    %al,(%dx)
  101759:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  10175f:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101763:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101767:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10176b:	ee                   	out    %al,(%dx)
  10176c:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101772:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101776:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10177a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10177e:	ee                   	out    %al,(%dx)
  10177f:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101785:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101789:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10178d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101791:	ee                   	out    %al,(%dx)
  101792:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101798:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10179c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017a0:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017a4:	ee                   	out    %al,(%dx)
  1017a5:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017ab:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1017af:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017b3:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017b7:	ee                   	out    %al,(%dx)
  1017b8:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  1017be:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  1017c2:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017c6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017ca:	ee                   	out    %al,(%dx)
  1017cb:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017d1:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1017d5:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017d9:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017dd:	ee                   	out    %al,(%dx)
  1017de:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017e4:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017e8:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017ec:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017f0:	ee                   	out    %al,(%dx)
  1017f1:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017f7:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017fb:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017ff:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101803:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101804:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10180b:	66 83 f8 ff          	cmp    $0xffff,%ax
  10180f:	74 12                	je     101823 <pic_init+0x139>
        pic_setmask(irq_mask);
  101811:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101818:	0f b7 c0             	movzwl %ax,%eax
  10181b:	89 04 24             	mov    %eax,(%esp)
  10181e:	e8 41 fe ff ff       	call   101664 <pic_setmask>
    }
}
  101823:	c9                   	leave  
  101824:	c3                   	ret    

00101825 <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  101825:	55                   	push   %ebp
  101826:	89 e5                	mov    %esp,%ebp
  101828:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10182b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101832:	00 
  101833:	c7 04 24 60 39 10 00 	movl   $0x103960,(%esp)
  10183a:	e8 e3 ea ff ff       	call   100322 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10183f:	c7 04 24 6a 39 10 00 	movl   $0x10396a,(%esp)
  101846:	e8 d7 ea ff ff       	call   100322 <cprintf>
    panic("EOT: kernel seems ok.");
  10184b:	c7 44 24 08 78 39 10 	movl   $0x103978,0x8(%esp)
  101852:	00 
  101853:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  10185a:	00 
  10185b:	c7 04 24 8e 39 10 00 	movl   $0x10398e,(%esp)
  101862:	e8 66 f4 ff ff       	call   100ccd <__panic>

00101867 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101867:	55                   	push   %ebp
  101868:	89 e5                	mov    %esp,%ebp
  10186a:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10186d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101874:	e9 c3 00 00 00       	jmp    10193c <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101879:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187c:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101883:	89 c2                	mov    %eax,%edx
  101885:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101888:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10188f:	00 
  101890:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101893:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10189a:	00 08 00 
  10189d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a0:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  1018a7:	00 
  1018a8:	83 e2 e0             	and    $0xffffffe0,%edx
  1018ab:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  1018b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b5:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  1018bc:	00 
  1018bd:	83 e2 1f             	and    $0x1f,%edx
  1018c0:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  1018c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ca:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018d1:	00 
  1018d2:	83 e2 f0             	and    $0xfffffff0,%edx
  1018d5:	83 ca 0e             	or     $0xe,%edx
  1018d8:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e2:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018e9:	00 
  1018ea:	83 e2 ef             	and    $0xffffffef,%edx
  1018ed:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f7:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018fe:	00 
  1018ff:	83 e2 9f             	and    $0xffffff9f,%edx
  101902:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101909:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190c:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101913:	00 
  101914:	83 ca 80             	or     $0xffffff80,%edx
  101917:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10191e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101921:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101928:	c1 e8 10             	shr    $0x10,%eax
  10192b:	89 c2                	mov    %eax,%edx
  10192d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101930:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101937:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101938:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10193c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193f:	3d ff 00 00 00       	cmp    $0xff,%eax
  101944:	0f 86 2f ff ff ff    	jbe    101879 <idt_init+0x12>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10194a:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10194f:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101955:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  10195c:	08 00 
  10195e:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101965:	83 e0 e0             	and    $0xffffffe0,%eax
  101968:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10196d:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101974:	83 e0 1f             	and    $0x1f,%eax
  101977:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10197c:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101983:	83 e0 f0             	and    $0xfffffff0,%eax
  101986:	83 c8 0e             	or     $0xe,%eax
  101989:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10198e:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101995:	83 e0 ef             	and    $0xffffffef,%eax
  101998:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10199d:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019a4:	83 c8 60             	or     $0x60,%eax
  1019a7:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019ac:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019b3:	83 c8 80             	or     $0xffffff80,%eax
  1019b6:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019bb:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1019c0:	c1 e8 10             	shr    $0x10,%eax
  1019c3:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  1019c9:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  1019d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019d3:	0f 01 18             	lidtl  (%eax)
	// load the IDT
    lidt(&idt_pd);
}
  1019d6:	c9                   	leave  
  1019d7:	c3                   	ret    

001019d8 <trapname>:

static const char *
trapname(int trapno) {
  1019d8:	55                   	push   %ebp
  1019d9:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019db:	8b 45 08             	mov    0x8(%ebp),%eax
  1019de:	83 f8 13             	cmp    $0x13,%eax
  1019e1:	77 0c                	ja     1019ef <trapname+0x17>
        return excnames[trapno];
  1019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e6:	8b 04 85 e0 3c 10 00 	mov    0x103ce0(,%eax,4),%eax
  1019ed:	eb 18                	jmp    101a07 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019ef:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019f3:	7e 0d                	jle    101a02 <trapname+0x2a>
  1019f5:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019f9:	7f 07                	jg     101a02 <trapname+0x2a>
        return "Hardware Interrupt";
  1019fb:	b8 9f 39 10 00       	mov    $0x10399f,%eax
  101a00:	eb 05                	jmp    101a07 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a02:	b8 b2 39 10 00       	mov    $0x1039b2,%eax
}
  101a07:	5d                   	pop    %ebp
  101a08:	c3                   	ret    

00101a09 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a09:	55                   	push   %ebp
  101a0a:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a13:	66 83 f8 08          	cmp    $0x8,%ax
  101a17:	0f 94 c0             	sete   %al
  101a1a:	0f b6 c0             	movzbl %al,%eax
}
  101a1d:	5d                   	pop    %ebp
  101a1e:	c3                   	ret    

00101a1f <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a1f:	55                   	push   %ebp
  101a20:	89 e5                	mov    %esp,%ebp
  101a22:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a25:	8b 45 08             	mov    0x8(%ebp),%eax
  101a28:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a2c:	c7 04 24 f3 39 10 00 	movl   $0x1039f3,(%esp)
  101a33:	e8 ea e8 ff ff       	call   100322 <cprintf>
    print_regs(&tf->tf_regs);
  101a38:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3b:	89 04 24             	mov    %eax,(%esp)
  101a3e:	e8 a1 01 00 00       	call   101be4 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a43:	8b 45 08             	mov    0x8(%ebp),%eax
  101a46:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a4a:	0f b7 c0             	movzwl %ax,%eax
  101a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a51:	c7 04 24 04 3a 10 00 	movl   $0x103a04,(%esp)
  101a58:	e8 c5 e8 ff ff       	call   100322 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a60:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a64:	0f b7 c0             	movzwl %ax,%eax
  101a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a6b:	c7 04 24 17 3a 10 00 	movl   $0x103a17,(%esp)
  101a72:	e8 ab e8 ff ff       	call   100322 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a77:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7a:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a7e:	0f b7 c0             	movzwl %ax,%eax
  101a81:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a85:	c7 04 24 2a 3a 10 00 	movl   $0x103a2a,(%esp)
  101a8c:	e8 91 e8 ff ff       	call   100322 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a91:	8b 45 08             	mov    0x8(%ebp),%eax
  101a94:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a98:	0f b7 c0             	movzwl %ax,%eax
  101a9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9f:	c7 04 24 3d 3a 10 00 	movl   $0x103a3d,(%esp)
  101aa6:	e8 77 e8 ff ff       	call   100322 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101aab:	8b 45 08             	mov    0x8(%ebp),%eax
  101aae:	8b 40 30             	mov    0x30(%eax),%eax
  101ab1:	89 04 24             	mov    %eax,(%esp)
  101ab4:	e8 1f ff ff ff       	call   1019d8 <trapname>
  101ab9:	8b 55 08             	mov    0x8(%ebp),%edx
  101abc:	8b 52 30             	mov    0x30(%edx),%edx
  101abf:	89 44 24 08          	mov    %eax,0x8(%esp)
  101ac3:	89 54 24 04          	mov    %edx,0x4(%esp)
  101ac7:	c7 04 24 50 3a 10 00 	movl   $0x103a50,(%esp)
  101ace:	e8 4f e8 ff ff       	call   100322 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad6:	8b 40 34             	mov    0x34(%eax),%eax
  101ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101add:	c7 04 24 62 3a 10 00 	movl   $0x103a62,(%esp)
  101ae4:	e8 39 e8 ff ff       	call   100322 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  101aec:	8b 40 38             	mov    0x38(%eax),%eax
  101aef:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af3:	c7 04 24 71 3a 10 00 	movl   $0x103a71,(%esp)
  101afa:	e8 23 e8 ff ff       	call   100322 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101aff:	8b 45 08             	mov    0x8(%ebp),%eax
  101b02:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b06:	0f b7 c0             	movzwl %ax,%eax
  101b09:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b0d:	c7 04 24 80 3a 10 00 	movl   $0x103a80,(%esp)
  101b14:	e8 09 e8 ff ff       	call   100322 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b19:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1c:	8b 40 40             	mov    0x40(%eax),%eax
  101b1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b23:	c7 04 24 93 3a 10 00 	movl   $0x103a93,(%esp)
  101b2a:	e8 f3 e7 ff ff       	call   100322 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b36:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b3d:	eb 3e                	jmp    101b7d <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b42:	8b 50 40             	mov    0x40(%eax),%edx
  101b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b48:	21 d0                	and    %edx,%eax
  101b4a:	85 c0                	test   %eax,%eax
  101b4c:	74 28                	je     101b76 <print_trapframe+0x157>
  101b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b51:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b58:	85 c0                	test   %eax,%eax
  101b5a:	74 1a                	je     101b76 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b5f:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6a:	c7 04 24 a2 3a 10 00 	movl   $0x103aa2,(%esp)
  101b71:	e8 ac e7 ff ff       	call   100322 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b76:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b7a:	d1 65 f0             	shll   -0x10(%ebp)
  101b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b80:	83 f8 17             	cmp    $0x17,%eax
  101b83:	76 ba                	jbe    101b3f <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b85:	8b 45 08             	mov    0x8(%ebp),%eax
  101b88:	8b 40 40             	mov    0x40(%eax),%eax
  101b8b:	25 00 30 00 00       	and    $0x3000,%eax
  101b90:	c1 e8 0c             	shr    $0xc,%eax
  101b93:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b97:	c7 04 24 a6 3a 10 00 	movl   $0x103aa6,(%esp)
  101b9e:	e8 7f e7 ff ff       	call   100322 <cprintf>

    if (!trap_in_kernel(tf)) {
  101ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba6:	89 04 24             	mov    %eax,(%esp)
  101ba9:	e8 5b fe ff ff       	call   101a09 <trap_in_kernel>
  101bae:	85 c0                	test   %eax,%eax
  101bb0:	75 30                	jne    101be2 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb5:	8b 40 44             	mov    0x44(%eax),%eax
  101bb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbc:	c7 04 24 af 3a 10 00 	movl   $0x103aaf,(%esp)
  101bc3:	e8 5a e7 ff ff       	call   100322 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcb:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bcf:	0f b7 c0             	movzwl %ax,%eax
  101bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd6:	c7 04 24 be 3a 10 00 	movl   $0x103abe,(%esp)
  101bdd:	e8 40 e7 ff ff       	call   100322 <cprintf>
    }
}
  101be2:	c9                   	leave  
  101be3:	c3                   	ret    

00101be4 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101be4:	55                   	push   %ebp
  101be5:	89 e5                	mov    %esp,%ebp
  101be7:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bea:	8b 45 08             	mov    0x8(%ebp),%eax
  101bed:	8b 00                	mov    (%eax),%eax
  101bef:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf3:	c7 04 24 d1 3a 10 00 	movl   $0x103ad1,(%esp)
  101bfa:	e8 23 e7 ff ff       	call   100322 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bff:	8b 45 08             	mov    0x8(%ebp),%eax
  101c02:	8b 40 04             	mov    0x4(%eax),%eax
  101c05:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c09:	c7 04 24 e0 3a 10 00 	movl   $0x103ae0,(%esp)
  101c10:	e8 0d e7 ff ff       	call   100322 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c15:	8b 45 08             	mov    0x8(%ebp),%eax
  101c18:	8b 40 08             	mov    0x8(%eax),%eax
  101c1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1f:	c7 04 24 ef 3a 10 00 	movl   $0x103aef,(%esp)
  101c26:	e8 f7 e6 ff ff       	call   100322 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2e:	8b 40 0c             	mov    0xc(%eax),%eax
  101c31:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c35:	c7 04 24 fe 3a 10 00 	movl   $0x103afe,(%esp)
  101c3c:	e8 e1 e6 ff ff       	call   100322 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c41:	8b 45 08             	mov    0x8(%ebp),%eax
  101c44:	8b 40 10             	mov    0x10(%eax),%eax
  101c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4b:	c7 04 24 0d 3b 10 00 	movl   $0x103b0d,(%esp)
  101c52:	e8 cb e6 ff ff       	call   100322 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c57:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5a:	8b 40 14             	mov    0x14(%eax),%eax
  101c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c61:	c7 04 24 1c 3b 10 00 	movl   $0x103b1c,(%esp)
  101c68:	e8 b5 e6 ff ff       	call   100322 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c70:	8b 40 18             	mov    0x18(%eax),%eax
  101c73:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c77:	c7 04 24 2b 3b 10 00 	movl   $0x103b2b,(%esp)
  101c7e:	e8 9f e6 ff ff       	call   100322 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c83:	8b 45 08             	mov    0x8(%ebp),%eax
  101c86:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c89:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c8d:	c7 04 24 3a 3b 10 00 	movl   $0x103b3a,(%esp)
  101c94:	e8 89 e6 ff ff       	call   100322 <cprintf>
}
  101c99:	c9                   	leave  
  101c9a:	c3                   	ret    

00101c9b <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c9b:	55                   	push   %ebp
  101c9c:	89 e5                	mov    %esp,%ebp
  101c9e:	57                   	push   %edi
  101c9f:	56                   	push   %esi
  101ca0:	53                   	push   %ebx
  101ca1:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca7:	8b 40 30             	mov    0x30(%eax),%eax
  101caa:	83 f8 2f             	cmp    $0x2f,%eax
  101cad:	77 21                	ja     101cd0 <trap_dispatch+0x35>
  101caf:	83 f8 2e             	cmp    $0x2e,%eax
  101cb2:	0f 83 ec 01 00 00    	jae    101ea4 <trap_dispatch+0x209>
  101cb8:	83 f8 21             	cmp    $0x21,%eax
  101cbb:	0f 84 8a 00 00 00    	je     101d4b <trap_dispatch+0xb0>
  101cc1:	83 f8 24             	cmp    $0x24,%eax
  101cc4:	74 5c                	je     101d22 <trap_dispatch+0x87>
  101cc6:	83 f8 20             	cmp    $0x20,%eax
  101cc9:	74 1c                	je     101ce7 <trap_dispatch+0x4c>
  101ccb:	e9 9c 01 00 00       	jmp    101e6c <trap_dispatch+0x1d1>
  101cd0:	83 f8 78             	cmp    $0x78,%eax
  101cd3:	0f 84 9b 00 00 00    	je     101d74 <trap_dispatch+0xd9>
  101cd9:	83 f8 79             	cmp    $0x79,%eax
  101cdc:	0f 84 11 01 00 00    	je     101df3 <trap_dispatch+0x158>
  101ce2:	e9 85 01 00 00       	jmp    101e6c <trap_dispatch+0x1d1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101ce7:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101cec:	83 c0 01             	add    $0x1,%eax
  101cef:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if (ticks % TICK_NUM == 0) {
  101cf4:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101cfa:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cff:	89 c8                	mov    %ecx,%eax
  101d01:	f7 e2                	mul    %edx
  101d03:	89 d0                	mov    %edx,%eax
  101d05:	c1 e8 05             	shr    $0x5,%eax
  101d08:	6b c0 64             	imul   $0x64,%eax,%eax
  101d0b:	29 c1                	sub    %eax,%ecx
  101d0d:	89 c8                	mov    %ecx,%eax
  101d0f:	85 c0                	test   %eax,%eax
  101d11:	75 0a                	jne    101d1d <trap_dispatch+0x82>
            print_ticks();
  101d13:	e8 0d fb ff ff       	call   101825 <print_ticks>
        }
        break;
  101d18:	e9 88 01 00 00       	jmp    101ea5 <trap_dispatch+0x20a>
  101d1d:	e9 83 01 00 00       	jmp    101ea5 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d22:	e8 d5 f8 ff ff       	call   1015fc <cons_getc>
  101d27:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d2a:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d2e:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d32:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d36:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d3a:	c7 04 24 49 3b 10 00 	movl   $0x103b49,(%esp)
  101d41:	e8 dc e5 ff ff       	call   100322 <cprintf>
        break;
  101d46:	e9 5a 01 00 00       	jmp    101ea5 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d4b:	e8 ac f8 ff ff       	call   1015fc <cons_getc>
  101d50:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d53:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d57:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d63:	c7 04 24 5b 3b 10 00 	movl   $0x103b5b,(%esp)
  101d6a:	e8 b3 e5 ff ff       	call   100322 <cprintf>
        break;
  101d6f:	e9 31 01 00 00       	jmp    101ea5 <trap_dispatch+0x20a>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101d74:	8b 45 08             	mov    0x8(%ebp),%eax
  101d77:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d7b:	66 83 f8 1b          	cmp    $0x1b,%ax
  101d7f:	74 6d                	je     101dee <trap_dispatch+0x153>
            switchk2u = *tf;
  101d81:	8b 45 08             	mov    0x8(%ebp),%eax
  101d84:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101d89:	89 c3                	mov    %eax,%ebx
  101d8b:	b8 13 00 00 00       	mov    $0x13,%eax
  101d90:	89 d7                	mov    %edx,%edi
  101d92:	89 de                	mov    %ebx,%esi
  101d94:	89 c1                	mov    %eax,%ecx
  101d96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            switchk2u.tf_cs = USER_CS;
  101d98:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101d9f:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101da1:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101da8:	23 00 
  101daa:	0f b7 05 68 f9 10 00 	movzwl 0x10f968,%eax
  101db1:	66 a3 48 f9 10 00    	mov    %ax,0x10f948
  101db7:	0f b7 05 48 f9 10 00 	movzwl 0x10f948,%eax
  101dbe:	66 a3 4c f9 10 00    	mov    %ax,0x10f94c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc7:	83 c0 44             	add    $0x44,%eax
  101dca:	a3 64 f9 10 00       	mov    %eax,0x10f964
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101dcf:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101dd4:	80 cc 30             	or     $0x30,%ah
  101dd7:	a3 60 f9 10 00       	mov    %eax,0x10f960
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  101ddf:	8d 50 fc             	lea    -0x4(%eax),%edx
  101de2:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101de7:	89 02                	mov    %eax,(%edx)
        }
        break;
  101de9:	e9 b7 00 00 00       	jmp    101ea5 <trap_dispatch+0x20a>
  101dee:	e9 b2 00 00 00       	jmp    101ea5 <trap_dispatch+0x20a>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101df3:	8b 45 08             	mov    0x8(%ebp),%eax
  101df6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dfa:	66 83 f8 08          	cmp    $0x8,%ax
  101dfe:	74 6a                	je     101e6a <trap_dispatch+0x1cf>
            tf->tf_cs = KERNEL_CS;
  101e00:	8b 45 08             	mov    0x8(%ebp),%eax
  101e03:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e09:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0c:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e12:	8b 45 08             	mov    0x8(%ebp),%eax
  101e15:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e19:	8b 45 08             	mov    0x8(%ebp),%eax
  101e1c:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101e20:	8b 45 08             	mov    0x8(%ebp),%eax
  101e23:	8b 40 40             	mov    0x40(%eax),%eax
  101e26:	80 e4 cf             	and    $0xcf,%ah
  101e29:	89 c2                	mov    %eax,%edx
  101e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e2e:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101e31:	8b 45 08             	mov    0x8(%ebp),%eax
  101e34:	8b 40 44             	mov    0x44(%eax),%eax
  101e37:	83 e8 44             	sub    $0x44,%eax
  101e3a:	a3 6c f9 10 00       	mov    %eax,0x10f96c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101e3f:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101e44:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101e4b:	00 
  101e4c:	8b 55 08             	mov    0x8(%ebp),%edx
  101e4f:	89 54 24 04          	mov    %edx,0x4(%esp)
  101e53:	89 04 24             	mov    %eax,(%esp)
  101e56:	e8 25 16 00 00       	call   103480 <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5e:	8d 50 fc             	lea    -0x4(%eax),%edx
  101e61:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101e66:	89 02                	mov    %eax,(%edx)
        }
        break;
  101e68:	eb 3b                	jmp    101ea5 <trap_dispatch+0x20a>
  101e6a:	eb 39                	jmp    101ea5 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e73:	0f b7 c0             	movzwl %ax,%eax
  101e76:	83 e0 03             	and    $0x3,%eax
  101e79:	85 c0                	test   %eax,%eax
  101e7b:	75 28                	jne    101ea5 <trap_dispatch+0x20a>
            print_trapframe(tf);
  101e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e80:	89 04 24             	mov    %eax,(%esp)
  101e83:	e8 97 fb ff ff       	call   101a1f <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e88:	c7 44 24 08 6a 3b 10 	movl   $0x103b6a,0x8(%esp)
  101e8f:	00 
  101e90:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  101e97:	00 
  101e98:	c7 04 24 8e 39 10 00 	movl   $0x10398e,(%esp)
  101e9f:	e8 29 ee ff ff       	call   100ccd <__panic>
        }
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101ea4:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101ea5:	83 c4 2c             	add    $0x2c,%esp
  101ea8:	5b                   	pop    %ebx
  101ea9:	5e                   	pop    %esi
  101eaa:	5f                   	pop    %edi
  101eab:	5d                   	pop    %ebp
  101eac:	c3                   	ret    

00101ead <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101ead:	55                   	push   %ebp
  101eae:	89 e5                	mov    %esp,%ebp
  101eb0:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb6:	89 04 24             	mov    %eax,(%esp)
  101eb9:	e8 dd fd ff ff       	call   101c9b <trap_dispatch>
}
  101ebe:	c9                   	leave  
  101ebf:	c3                   	ret    

00101ec0 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101ec0:	1e                   	push   %ds
    pushl %es
  101ec1:	06                   	push   %es
    pushl %fs
  101ec2:	0f a0                	push   %fs
    pushl %gs
  101ec4:	0f a8                	push   %gs
    pushal
  101ec6:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101ec7:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101ecc:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101ece:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101ed0:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101ed1:	e8 d7 ff ff ff       	call   101ead <trap>

    # pop the pushed stack pointer
    popl %esp
  101ed6:	5c                   	pop    %esp

00101ed7 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101ed7:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101ed8:	0f a9                	pop    %gs
    popl %fs
  101eda:	0f a1                	pop    %fs
    popl %es
  101edc:	07                   	pop    %es
    popl %ds
  101edd:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101ede:	83 c4 08             	add    $0x8,%esp
    iret
  101ee1:	cf                   	iret   

00101ee2 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ee2:	6a 00                	push   $0x0
  pushl $0
  101ee4:	6a 00                	push   $0x0
  jmp __alltraps
  101ee6:	e9 d5 ff ff ff       	jmp    101ec0 <__alltraps>

00101eeb <vector1>:
.globl vector1
vector1:
  pushl $0
  101eeb:	6a 00                	push   $0x0
  pushl $1
  101eed:	6a 01                	push   $0x1
  jmp __alltraps
  101eef:	e9 cc ff ff ff       	jmp    101ec0 <__alltraps>

00101ef4 <vector2>:
.globl vector2
vector2:
  pushl $0
  101ef4:	6a 00                	push   $0x0
  pushl $2
  101ef6:	6a 02                	push   $0x2
  jmp __alltraps
  101ef8:	e9 c3 ff ff ff       	jmp    101ec0 <__alltraps>

00101efd <vector3>:
.globl vector3
vector3:
  pushl $0
  101efd:	6a 00                	push   $0x0
  pushl $3
  101eff:	6a 03                	push   $0x3
  jmp __alltraps
  101f01:	e9 ba ff ff ff       	jmp    101ec0 <__alltraps>

00101f06 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f06:	6a 00                	push   $0x0
  pushl $4
  101f08:	6a 04                	push   $0x4
  jmp __alltraps
  101f0a:	e9 b1 ff ff ff       	jmp    101ec0 <__alltraps>

00101f0f <vector5>:
.globl vector5
vector5:
  pushl $0
  101f0f:	6a 00                	push   $0x0
  pushl $5
  101f11:	6a 05                	push   $0x5
  jmp __alltraps
  101f13:	e9 a8 ff ff ff       	jmp    101ec0 <__alltraps>

00101f18 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f18:	6a 00                	push   $0x0
  pushl $6
  101f1a:	6a 06                	push   $0x6
  jmp __alltraps
  101f1c:	e9 9f ff ff ff       	jmp    101ec0 <__alltraps>

00101f21 <vector7>:
.globl vector7
vector7:
  pushl $0
  101f21:	6a 00                	push   $0x0
  pushl $7
  101f23:	6a 07                	push   $0x7
  jmp __alltraps
  101f25:	e9 96 ff ff ff       	jmp    101ec0 <__alltraps>

00101f2a <vector8>:
.globl vector8
vector8:
  pushl $8
  101f2a:	6a 08                	push   $0x8
  jmp __alltraps
  101f2c:	e9 8f ff ff ff       	jmp    101ec0 <__alltraps>

00101f31 <vector9>:
.globl vector9
vector9:
  pushl $9
  101f31:	6a 09                	push   $0x9
  jmp __alltraps
  101f33:	e9 88 ff ff ff       	jmp    101ec0 <__alltraps>

00101f38 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f38:	6a 0a                	push   $0xa
  jmp __alltraps
  101f3a:	e9 81 ff ff ff       	jmp    101ec0 <__alltraps>

00101f3f <vector11>:
.globl vector11
vector11:
  pushl $11
  101f3f:	6a 0b                	push   $0xb
  jmp __alltraps
  101f41:	e9 7a ff ff ff       	jmp    101ec0 <__alltraps>

00101f46 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f46:	6a 0c                	push   $0xc
  jmp __alltraps
  101f48:	e9 73 ff ff ff       	jmp    101ec0 <__alltraps>

00101f4d <vector13>:
.globl vector13
vector13:
  pushl $13
  101f4d:	6a 0d                	push   $0xd
  jmp __alltraps
  101f4f:	e9 6c ff ff ff       	jmp    101ec0 <__alltraps>

00101f54 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f54:	6a 0e                	push   $0xe
  jmp __alltraps
  101f56:	e9 65 ff ff ff       	jmp    101ec0 <__alltraps>

00101f5b <vector15>:
.globl vector15
vector15:
  pushl $0
  101f5b:	6a 00                	push   $0x0
  pushl $15
  101f5d:	6a 0f                	push   $0xf
  jmp __alltraps
  101f5f:	e9 5c ff ff ff       	jmp    101ec0 <__alltraps>

00101f64 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $16
  101f66:	6a 10                	push   $0x10
  jmp __alltraps
  101f68:	e9 53 ff ff ff       	jmp    101ec0 <__alltraps>

00101f6d <vector17>:
.globl vector17
vector17:
  pushl $17
  101f6d:	6a 11                	push   $0x11
  jmp __alltraps
  101f6f:	e9 4c ff ff ff       	jmp    101ec0 <__alltraps>

00101f74 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $18
  101f76:	6a 12                	push   $0x12
  jmp __alltraps
  101f78:	e9 43 ff ff ff       	jmp    101ec0 <__alltraps>

00101f7d <vector19>:
.globl vector19
vector19:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $19
  101f7f:	6a 13                	push   $0x13
  jmp __alltraps
  101f81:	e9 3a ff ff ff       	jmp    101ec0 <__alltraps>

00101f86 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $20
  101f88:	6a 14                	push   $0x14
  jmp __alltraps
  101f8a:	e9 31 ff ff ff       	jmp    101ec0 <__alltraps>

00101f8f <vector21>:
.globl vector21
vector21:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $21
  101f91:	6a 15                	push   $0x15
  jmp __alltraps
  101f93:	e9 28 ff ff ff       	jmp    101ec0 <__alltraps>

00101f98 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f98:	6a 00                	push   $0x0
  pushl $22
  101f9a:	6a 16                	push   $0x16
  jmp __alltraps
  101f9c:	e9 1f ff ff ff       	jmp    101ec0 <__alltraps>

00101fa1 <vector23>:
.globl vector23
vector23:
  pushl $0
  101fa1:	6a 00                	push   $0x0
  pushl $23
  101fa3:	6a 17                	push   $0x17
  jmp __alltraps
  101fa5:	e9 16 ff ff ff       	jmp    101ec0 <__alltraps>

00101faa <vector24>:
.globl vector24
vector24:
  pushl $0
  101faa:	6a 00                	push   $0x0
  pushl $24
  101fac:	6a 18                	push   $0x18
  jmp __alltraps
  101fae:	e9 0d ff ff ff       	jmp    101ec0 <__alltraps>

00101fb3 <vector25>:
.globl vector25
vector25:
  pushl $0
  101fb3:	6a 00                	push   $0x0
  pushl $25
  101fb5:	6a 19                	push   $0x19
  jmp __alltraps
  101fb7:	e9 04 ff ff ff       	jmp    101ec0 <__alltraps>

00101fbc <vector26>:
.globl vector26
vector26:
  pushl $0
  101fbc:	6a 00                	push   $0x0
  pushl $26
  101fbe:	6a 1a                	push   $0x1a
  jmp __alltraps
  101fc0:	e9 fb fe ff ff       	jmp    101ec0 <__alltraps>

00101fc5 <vector27>:
.globl vector27
vector27:
  pushl $0
  101fc5:	6a 00                	push   $0x0
  pushl $27
  101fc7:	6a 1b                	push   $0x1b
  jmp __alltraps
  101fc9:	e9 f2 fe ff ff       	jmp    101ec0 <__alltraps>

00101fce <vector28>:
.globl vector28
vector28:
  pushl $0
  101fce:	6a 00                	push   $0x0
  pushl $28
  101fd0:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fd2:	e9 e9 fe ff ff       	jmp    101ec0 <__alltraps>

00101fd7 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fd7:	6a 00                	push   $0x0
  pushl $29
  101fd9:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fdb:	e9 e0 fe ff ff       	jmp    101ec0 <__alltraps>

00101fe0 <vector30>:
.globl vector30
vector30:
  pushl $0
  101fe0:	6a 00                	push   $0x0
  pushl $30
  101fe2:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fe4:	e9 d7 fe ff ff       	jmp    101ec0 <__alltraps>

00101fe9 <vector31>:
.globl vector31
vector31:
  pushl $0
  101fe9:	6a 00                	push   $0x0
  pushl $31
  101feb:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fed:	e9 ce fe ff ff       	jmp    101ec0 <__alltraps>

00101ff2 <vector32>:
.globl vector32
vector32:
  pushl $0
  101ff2:	6a 00                	push   $0x0
  pushl $32
  101ff4:	6a 20                	push   $0x20
  jmp __alltraps
  101ff6:	e9 c5 fe ff ff       	jmp    101ec0 <__alltraps>

00101ffb <vector33>:
.globl vector33
vector33:
  pushl $0
  101ffb:	6a 00                	push   $0x0
  pushl $33
  101ffd:	6a 21                	push   $0x21
  jmp __alltraps
  101fff:	e9 bc fe ff ff       	jmp    101ec0 <__alltraps>

00102004 <vector34>:
.globl vector34
vector34:
  pushl $0
  102004:	6a 00                	push   $0x0
  pushl $34
  102006:	6a 22                	push   $0x22
  jmp __alltraps
  102008:	e9 b3 fe ff ff       	jmp    101ec0 <__alltraps>

0010200d <vector35>:
.globl vector35
vector35:
  pushl $0
  10200d:	6a 00                	push   $0x0
  pushl $35
  10200f:	6a 23                	push   $0x23
  jmp __alltraps
  102011:	e9 aa fe ff ff       	jmp    101ec0 <__alltraps>

00102016 <vector36>:
.globl vector36
vector36:
  pushl $0
  102016:	6a 00                	push   $0x0
  pushl $36
  102018:	6a 24                	push   $0x24
  jmp __alltraps
  10201a:	e9 a1 fe ff ff       	jmp    101ec0 <__alltraps>

0010201f <vector37>:
.globl vector37
vector37:
  pushl $0
  10201f:	6a 00                	push   $0x0
  pushl $37
  102021:	6a 25                	push   $0x25
  jmp __alltraps
  102023:	e9 98 fe ff ff       	jmp    101ec0 <__alltraps>

00102028 <vector38>:
.globl vector38
vector38:
  pushl $0
  102028:	6a 00                	push   $0x0
  pushl $38
  10202a:	6a 26                	push   $0x26
  jmp __alltraps
  10202c:	e9 8f fe ff ff       	jmp    101ec0 <__alltraps>

00102031 <vector39>:
.globl vector39
vector39:
  pushl $0
  102031:	6a 00                	push   $0x0
  pushl $39
  102033:	6a 27                	push   $0x27
  jmp __alltraps
  102035:	e9 86 fe ff ff       	jmp    101ec0 <__alltraps>

0010203a <vector40>:
.globl vector40
vector40:
  pushl $0
  10203a:	6a 00                	push   $0x0
  pushl $40
  10203c:	6a 28                	push   $0x28
  jmp __alltraps
  10203e:	e9 7d fe ff ff       	jmp    101ec0 <__alltraps>

00102043 <vector41>:
.globl vector41
vector41:
  pushl $0
  102043:	6a 00                	push   $0x0
  pushl $41
  102045:	6a 29                	push   $0x29
  jmp __alltraps
  102047:	e9 74 fe ff ff       	jmp    101ec0 <__alltraps>

0010204c <vector42>:
.globl vector42
vector42:
  pushl $0
  10204c:	6a 00                	push   $0x0
  pushl $42
  10204e:	6a 2a                	push   $0x2a
  jmp __alltraps
  102050:	e9 6b fe ff ff       	jmp    101ec0 <__alltraps>

00102055 <vector43>:
.globl vector43
vector43:
  pushl $0
  102055:	6a 00                	push   $0x0
  pushl $43
  102057:	6a 2b                	push   $0x2b
  jmp __alltraps
  102059:	e9 62 fe ff ff       	jmp    101ec0 <__alltraps>

0010205e <vector44>:
.globl vector44
vector44:
  pushl $0
  10205e:	6a 00                	push   $0x0
  pushl $44
  102060:	6a 2c                	push   $0x2c
  jmp __alltraps
  102062:	e9 59 fe ff ff       	jmp    101ec0 <__alltraps>

00102067 <vector45>:
.globl vector45
vector45:
  pushl $0
  102067:	6a 00                	push   $0x0
  pushl $45
  102069:	6a 2d                	push   $0x2d
  jmp __alltraps
  10206b:	e9 50 fe ff ff       	jmp    101ec0 <__alltraps>

00102070 <vector46>:
.globl vector46
vector46:
  pushl $0
  102070:	6a 00                	push   $0x0
  pushl $46
  102072:	6a 2e                	push   $0x2e
  jmp __alltraps
  102074:	e9 47 fe ff ff       	jmp    101ec0 <__alltraps>

00102079 <vector47>:
.globl vector47
vector47:
  pushl $0
  102079:	6a 00                	push   $0x0
  pushl $47
  10207b:	6a 2f                	push   $0x2f
  jmp __alltraps
  10207d:	e9 3e fe ff ff       	jmp    101ec0 <__alltraps>

00102082 <vector48>:
.globl vector48
vector48:
  pushl $0
  102082:	6a 00                	push   $0x0
  pushl $48
  102084:	6a 30                	push   $0x30
  jmp __alltraps
  102086:	e9 35 fe ff ff       	jmp    101ec0 <__alltraps>

0010208b <vector49>:
.globl vector49
vector49:
  pushl $0
  10208b:	6a 00                	push   $0x0
  pushl $49
  10208d:	6a 31                	push   $0x31
  jmp __alltraps
  10208f:	e9 2c fe ff ff       	jmp    101ec0 <__alltraps>

00102094 <vector50>:
.globl vector50
vector50:
  pushl $0
  102094:	6a 00                	push   $0x0
  pushl $50
  102096:	6a 32                	push   $0x32
  jmp __alltraps
  102098:	e9 23 fe ff ff       	jmp    101ec0 <__alltraps>

0010209d <vector51>:
.globl vector51
vector51:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $51
  10209f:	6a 33                	push   $0x33
  jmp __alltraps
  1020a1:	e9 1a fe ff ff       	jmp    101ec0 <__alltraps>

001020a6 <vector52>:
.globl vector52
vector52:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $52
  1020a8:	6a 34                	push   $0x34
  jmp __alltraps
  1020aa:	e9 11 fe ff ff       	jmp    101ec0 <__alltraps>

001020af <vector53>:
.globl vector53
vector53:
  pushl $0
  1020af:	6a 00                	push   $0x0
  pushl $53
  1020b1:	6a 35                	push   $0x35
  jmp __alltraps
  1020b3:	e9 08 fe ff ff       	jmp    101ec0 <__alltraps>

001020b8 <vector54>:
.globl vector54
vector54:
  pushl $0
  1020b8:	6a 00                	push   $0x0
  pushl $54
  1020ba:	6a 36                	push   $0x36
  jmp __alltraps
  1020bc:	e9 ff fd ff ff       	jmp    101ec0 <__alltraps>

001020c1 <vector55>:
.globl vector55
vector55:
  pushl $0
  1020c1:	6a 00                	push   $0x0
  pushl $55
  1020c3:	6a 37                	push   $0x37
  jmp __alltraps
  1020c5:	e9 f6 fd ff ff       	jmp    101ec0 <__alltraps>

001020ca <vector56>:
.globl vector56
vector56:
  pushl $0
  1020ca:	6a 00                	push   $0x0
  pushl $56
  1020cc:	6a 38                	push   $0x38
  jmp __alltraps
  1020ce:	e9 ed fd ff ff       	jmp    101ec0 <__alltraps>

001020d3 <vector57>:
.globl vector57
vector57:
  pushl $0
  1020d3:	6a 00                	push   $0x0
  pushl $57
  1020d5:	6a 39                	push   $0x39
  jmp __alltraps
  1020d7:	e9 e4 fd ff ff       	jmp    101ec0 <__alltraps>

001020dc <vector58>:
.globl vector58
vector58:
  pushl $0
  1020dc:	6a 00                	push   $0x0
  pushl $58
  1020de:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020e0:	e9 db fd ff ff       	jmp    101ec0 <__alltraps>

001020e5 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020e5:	6a 00                	push   $0x0
  pushl $59
  1020e7:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020e9:	e9 d2 fd ff ff       	jmp    101ec0 <__alltraps>

001020ee <vector60>:
.globl vector60
vector60:
  pushl $0
  1020ee:	6a 00                	push   $0x0
  pushl $60
  1020f0:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020f2:	e9 c9 fd ff ff       	jmp    101ec0 <__alltraps>

001020f7 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020f7:	6a 00                	push   $0x0
  pushl $61
  1020f9:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020fb:	e9 c0 fd ff ff       	jmp    101ec0 <__alltraps>

00102100 <vector62>:
.globl vector62
vector62:
  pushl $0
  102100:	6a 00                	push   $0x0
  pushl $62
  102102:	6a 3e                	push   $0x3e
  jmp __alltraps
  102104:	e9 b7 fd ff ff       	jmp    101ec0 <__alltraps>

00102109 <vector63>:
.globl vector63
vector63:
  pushl $0
  102109:	6a 00                	push   $0x0
  pushl $63
  10210b:	6a 3f                	push   $0x3f
  jmp __alltraps
  10210d:	e9 ae fd ff ff       	jmp    101ec0 <__alltraps>

00102112 <vector64>:
.globl vector64
vector64:
  pushl $0
  102112:	6a 00                	push   $0x0
  pushl $64
  102114:	6a 40                	push   $0x40
  jmp __alltraps
  102116:	e9 a5 fd ff ff       	jmp    101ec0 <__alltraps>

0010211b <vector65>:
.globl vector65
vector65:
  pushl $0
  10211b:	6a 00                	push   $0x0
  pushl $65
  10211d:	6a 41                	push   $0x41
  jmp __alltraps
  10211f:	e9 9c fd ff ff       	jmp    101ec0 <__alltraps>

00102124 <vector66>:
.globl vector66
vector66:
  pushl $0
  102124:	6a 00                	push   $0x0
  pushl $66
  102126:	6a 42                	push   $0x42
  jmp __alltraps
  102128:	e9 93 fd ff ff       	jmp    101ec0 <__alltraps>

0010212d <vector67>:
.globl vector67
vector67:
  pushl $0
  10212d:	6a 00                	push   $0x0
  pushl $67
  10212f:	6a 43                	push   $0x43
  jmp __alltraps
  102131:	e9 8a fd ff ff       	jmp    101ec0 <__alltraps>

00102136 <vector68>:
.globl vector68
vector68:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $68
  102138:	6a 44                	push   $0x44
  jmp __alltraps
  10213a:	e9 81 fd ff ff       	jmp    101ec0 <__alltraps>

0010213f <vector69>:
.globl vector69
vector69:
  pushl $0
  10213f:	6a 00                	push   $0x0
  pushl $69
  102141:	6a 45                	push   $0x45
  jmp __alltraps
  102143:	e9 78 fd ff ff       	jmp    101ec0 <__alltraps>

00102148 <vector70>:
.globl vector70
vector70:
  pushl $0
  102148:	6a 00                	push   $0x0
  pushl $70
  10214a:	6a 46                	push   $0x46
  jmp __alltraps
  10214c:	e9 6f fd ff ff       	jmp    101ec0 <__alltraps>

00102151 <vector71>:
.globl vector71
vector71:
  pushl $0
  102151:	6a 00                	push   $0x0
  pushl $71
  102153:	6a 47                	push   $0x47
  jmp __alltraps
  102155:	e9 66 fd ff ff       	jmp    101ec0 <__alltraps>

0010215a <vector72>:
.globl vector72
vector72:
  pushl $0
  10215a:	6a 00                	push   $0x0
  pushl $72
  10215c:	6a 48                	push   $0x48
  jmp __alltraps
  10215e:	e9 5d fd ff ff       	jmp    101ec0 <__alltraps>

00102163 <vector73>:
.globl vector73
vector73:
  pushl $0
  102163:	6a 00                	push   $0x0
  pushl $73
  102165:	6a 49                	push   $0x49
  jmp __alltraps
  102167:	e9 54 fd ff ff       	jmp    101ec0 <__alltraps>

0010216c <vector74>:
.globl vector74
vector74:
  pushl $0
  10216c:	6a 00                	push   $0x0
  pushl $74
  10216e:	6a 4a                	push   $0x4a
  jmp __alltraps
  102170:	e9 4b fd ff ff       	jmp    101ec0 <__alltraps>

00102175 <vector75>:
.globl vector75
vector75:
  pushl $0
  102175:	6a 00                	push   $0x0
  pushl $75
  102177:	6a 4b                	push   $0x4b
  jmp __alltraps
  102179:	e9 42 fd ff ff       	jmp    101ec0 <__alltraps>

0010217e <vector76>:
.globl vector76
vector76:
  pushl $0
  10217e:	6a 00                	push   $0x0
  pushl $76
  102180:	6a 4c                	push   $0x4c
  jmp __alltraps
  102182:	e9 39 fd ff ff       	jmp    101ec0 <__alltraps>

00102187 <vector77>:
.globl vector77
vector77:
  pushl $0
  102187:	6a 00                	push   $0x0
  pushl $77
  102189:	6a 4d                	push   $0x4d
  jmp __alltraps
  10218b:	e9 30 fd ff ff       	jmp    101ec0 <__alltraps>

00102190 <vector78>:
.globl vector78
vector78:
  pushl $0
  102190:	6a 00                	push   $0x0
  pushl $78
  102192:	6a 4e                	push   $0x4e
  jmp __alltraps
  102194:	e9 27 fd ff ff       	jmp    101ec0 <__alltraps>

00102199 <vector79>:
.globl vector79
vector79:
  pushl $0
  102199:	6a 00                	push   $0x0
  pushl $79
  10219b:	6a 4f                	push   $0x4f
  jmp __alltraps
  10219d:	e9 1e fd ff ff       	jmp    101ec0 <__alltraps>

001021a2 <vector80>:
.globl vector80
vector80:
  pushl $0
  1021a2:	6a 00                	push   $0x0
  pushl $80
  1021a4:	6a 50                	push   $0x50
  jmp __alltraps
  1021a6:	e9 15 fd ff ff       	jmp    101ec0 <__alltraps>

001021ab <vector81>:
.globl vector81
vector81:
  pushl $0
  1021ab:	6a 00                	push   $0x0
  pushl $81
  1021ad:	6a 51                	push   $0x51
  jmp __alltraps
  1021af:	e9 0c fd ff ff       	jmp    101ec0 <__alltraps>

001021b4 <vector82>:
.globl vector82
vector82:
  pushl $0
  1021b4:	6a 00                	push   $0x0
  pushl $82
  1021b6:	6a 52                	push   $0x52
  jmp __alltraps
  1021b8:	e9 03 fd ff ff       	jmp    101ec0 <__alltraps>

001021bd <vector83>:
.globl vector83
vector83:
  pushl $0
  1021bd:	6a 00                	push   $0x0
  pushl $83
  1021bf:	6a 53                	push   $0x53
  jmp __alltraps
  1021c1:	e9 fa fc ff ff       	jmp    101ec0 <__alltraps>

001021c6 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021c6:	6a 00                	push   $0x0
  pushl $84
  1021c8:	6a 54                	push   $0x54
  jmp __alltraps
  1021ca:	e9 f1 fc ff ff       	jmp    101ec0 <__alltraps>

001021cf <vector85>:
.globl vector85
vector85:
  pushl $0
  1021cf:	6a 00                	push   $0x0
  pushl $85
  1021d1:	6a 55                	push   $0x55
  jmp __alltraps
  1021d3:	e9 e8 fc ff ff       	jmp    101ec0 <__alltraps>

001021d8 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021d8:	6a 00                	push   $0x0
  pushl $86
  1021da:	6a 56                	push   $0x56
  jmp __alltraps
  1021dc:	e9 df fc ff ff       	jmp    101ec0 <__alltraps>

001021e1 <vector87>:
.globl vector87
vector87:
  pushl $0
  1021e1:	6a 00                	push   $0x0
  pushl $87
  1021e3:	6a 57                	push   $0x57
  jmp __alltraps
  1021e5:	e9 d6 fc ff ff       	jmp    101ec0 <__alltraps>

001021ea <vector88>:
.globl vector88
vector88:
  pushl $0
  1021ea:	6a 00                	push   $0x0
  pushl $88
  1021ec:	6a 58                	push   $0x58
  jmp __alltraps
  1021ee:	e9 cd fc ff ff       	jmp    101ec0 <__alltraps>

001021f3 <vector89>:
.globl vector89
vector89:
  pushl $0
  1021f3:	6a 00                	push   $0x0
  pushl $89
  1021f5:	6a 59                	push   $0x59
  jmp __alltraps
  1021f7:	e9 c4 fc ff ff       	jmp    101ec0 <__alltraps>

001021fc <vector90>:
.globl vector90
vector90:
  pushl $0
  1021fc:	6a 00                	push   $0x0
  pushl $90
  1021fe:	6a 5a                	push   $0x5a
  jmp __alltraps
  102200:	e9 bb fc ff ff       	jmp    101ec0 <__alltraps>

00102205 <vector91>:
.globl vector91
vector91:
  pushl $0
  102205:	6a 00                	push   $0x0
  pushl $91
  102207:	6a 5b                	push   $0x5b
  jmp __alltraps
  102209:	e9 b2 fc ff ff       	jmp    101ec0 <__alltraps>

0010220e <vector92>:
.globl vector92
vector92:
  pushl $0
  10220e:	6a 00                	push   $0x0
  pushl $92
  102210:	6a 5c                	push   $0x5c
  jmp __alltraps
  102212:	e9 a9 fc ff ff       	jmp    101ec0 <__alltraps>

00102217 <vector93>:
.globl vector93
vector93:
  pushl $0
  102217:	6a 00                	push   $0x0
  pushl $93
  102219:	6a 5d                	push   $0x5d
  jmp __alltraps
  10221b:	e9 a0 fc ff ff       	jmp    101ec0 <__alltraps>

00102220 <vector94>:
.globl vector94
vector94:
  pushl $0
  102220:	6a 00                	push   $0x0
  pushl $94
  102222:	6a 5e                	push   $0x5e
  jmp __alltraps
  102224:	e9 97 fc ff ff       	jmp    101ec0 <__alltraps>

00102229 <vector95>:
.globl vector95
vector95:
  pushl $0
  102229:	6a 00                	push   $0x0
  pushl $95
  10222b:	6a 5f                	push   $0x5f
  jmp __alltraps
  10222d:	e9 8e fc ff ff       	jmp    101ec0 <__alltraps>

00102232 <vector96>:
.globl vector96
vector96:
  pushl $0
  102232:	6a 00                	push   $0x0
  pushl $96
  102234:	6a 60                	push   $0x60
  jmp __alltraps
  102236:	e9 85 fc ff ff       	jmp    101ec0 <__alltraps>

0010223b <vector97>:
.globl vector97
vector97:
  pushl $0
  10223b:	6a 00                	push   $0x0
  pushl $97
  10223d:	6a 61                	push   $0x61
  jmp __alltraps
  10223f:	e9 7c fc ff ff       	jmp    101ec0 <__alltraps>

00102244 <vector98>:
.globl vector98
vector98:
  pushl $0
  102244:	6a 00                	push   $0x0
  pushl $98
  102246:	6a 62                	push   $0x62
  jmp __alltraps
  102248:	e9 73 fc ff ff       	jmp    101ec0 <__alltraps>

0010224d <vector99>:
.globl vector99
vector99:
  pushl $0
  10224d:	6a 00                	push   $0x0
  pushl $99
  10224f:	6a 63                	push   $0x63
  jmp __alltraps
  102251:	e9 6a fc ff ff       	jmp    101ec0 <__alltraps>

00102256 <vector100>:
.globl vector100
vector100:
  pushl $0
  102256:	6a 00                	push   $0x0
  pushl $100
  102258:	6a 64                	push   $0x64
  jmp __alltraps
  10225a:	e9 61 fc ff ff       	jmp    101ec0 <__alltraps>

0010225f <vector101>:
.globl vector101
vector101:
  pushl $0
  10225f:	6a 00                	push   $0x0
  pushl $101
  102261:	6a 65                	push   $0x65
  jmp __alltraps
  102263:	e9 58 fc ff ff       	jmp    101ec0 <__alltraps>

00102268 <vector102>:
.globl vector102
vector102:
  pushl $0
  102268:	6a 00                	push   $0x0
  pushl $102
  10226a:	6a 66                	push   $0x66
  jmp __alltraps
  10226c:	e9 4f fc ff ff       	jmp    101ec0 <__alltraps>

00102271 <vector103>:
.globl vector103
vector103:
  pushl $0
  102271:	6a 00                	push   $0x0
  pushl $103
  102273:	6a 67                	push   $0x67
  jmp __alltraps
  102275:	e9 46 fc ff ff       	jmp    101ec0 <__alltraps>

0010227a <vector104>:
.globl vector104
vector104:
  pushl $0
  10227a:	6a 00                	push   $0x0
  pushl $104
  10227c:	6a 68                	push   $0x68
  jmp __alltraps
  10227e:	e9 3d fc ff ff       	jmp    101ec0 <__alltraps>

00102283 <vector105>:
.globl vector105
vector105:
  pushl $0
  102283:	6a 00                	push   $0x0
  pushl $105
  102285:	6a 69                	push   $0x69
  jmp __alltraps
  102287:	e9 34 fc ff ff       	jmp    101ec0 <__alltraps>

0010228c <vector106>:
.globl vector106
vector106:
  pushl $0
  10228c:	6a 00                	push   $0x0
  pushl $106
  10228e:	6a 6a                	push   $0x6a
  jmp __alltraps
  102290:	e9 2b fc ff ff       	jmp    101ec0 <__alltraps>

00102295 <vector107>:
.globl vector107
vector107:
  pushl $0
  102295:	6a 00                	push   $0x0
  pushl $107
  102297:	6a 6b                	push   $0x6b
  jmp __alltraps
  102299:	e9 22 fc ff ff       	jmp    101ec0 <__alltraps>

0010229e <vector108>:
.globl vector108
vector108:
  pushl $0
  10229e:	6a 00                	push   $0x0
  pushl $108
  1022a0:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022a2:	e9 19 fc ff ff       	jmp    101ec0 <__alltraps>

001022a7 <vector109>:
.globl vector109
vector109:
  pushl $0
  1022a7:	6a 00                	push   $0x0
  pushl $109
  1022a9:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022ab:	e9 10 fc ff ff       	jmp    101ec0 <__alltraps>

001022b0 <vector110>:
.globl vector110
vector110:
  pushl $0
  1022b0:	6a 00                	push   $0x0
  pushl $110
  1022b2:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022b4:	e9 07 fc ff ff       	jmp    101ec0 <__alltraps>

001022b9 <vector111>:
.globl vector111
vector111:
  pushl $0
  1022b9:	6a 00                	push   $0x0
  pushl $111
  1022bb:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022bd:	e9 fe fb ff ff       	jmp    101ec0 <__alltraps>

001022c2 <vector112>:
.globl vector112
vector112:
  pushl $0
  1022c2:	6a 00                	push   $0x0
  pushl $112
  1022c4:	6a 70                	push   $0x70
  jmp __alltraps
  1022c6:	e9 f5 fb ff ff       	jmp    101ec0 <__alltraps>

001022cb <vector113>:
.globl vector113
vector113:
  pushl $0
  1022cb:	6a 00                	push   $0x0
  pushl $113
  1022cd:	6a 71                	push   $0x71
  jmp __alltraps
  1022cf:	e9 ec fb ff ff       	jmp    101ec0 <__alltraps>

001022d4 <vector114>:
.globl vector114
vector114:
  pushl $0
  1022d4:	6a 00                	push   $0x0
  pushl $114
  1022d6:	6a 72                	push   $0x72
  jmp __alltraps
  1022d8:	e9 e3 fb ff ff       	jmp    101ec0 <__alltraps>

001022dd <vector115>:
.globl vector115
vector115:
  pushl $0
  1022dd:	6a 00                	push   $0x0
  pushl $115
  1022df:	6a 73                	push   $0x73
  jmp __alltraps
  1022e1:	e9 da fb ff ff       	jmp    101ec0 <__alltraps>

001022e6 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022e6:	6a 00                	push   $0x0
  pushl $116
  1022e8:	6a 74                	push   $0x74
  jmp __alltraps
  1022ea:	e9 d1 fb ff ff       	jmp    101ec0 <__alltraps>

001022ef <vector117>:
.globl vector117
vector117:
  pushl $0
  1022ef:	6a 00                	push   $0x0
  pushl $117
  1022f1:	6a 75                	push   $0x75
  jmp __alltraps
  1022f3:	e9 c8 fb ff ff       	jmp    101ec0 <__alltraps>

001022f8 <vector118>:
.globl vector118
vector118:
  pushl $0
  1022f8:	6a 00                	push   $0x0
  pushl $118
  1022fa:	6a 76                	push   $0x76
  jmp __alltraps
  1022fc:	e9 bf fb ff ff       	jmp    101ec0 <__alltraps>

00102301 <vector119>:
.globl vector119
vector119:
  pushl $0
  102301:	6a 00                	push   $0x0
  pushl $119
  102303:	6a 77                	push   $0x77
  jmp __alltraps
  102305:	e9 b6 fb ff ff       	jmp    101ec0 <__alltraps>

0010230a <vector120>:
.globl vector120
vector120:
  pushl $0
  10230a:	6a 00                	push   $0x0
  pushl $120
  10230c:	6a 78                	push   $0x78
  jmp __alltraps
  10230e:	e9 ad fb ff ff       	jmp    101ec0 <__alltraps>

00102313 <vector121>:
.globl vector121
vector121:
  pushl $0
  102313:	6a 00                	push   $0x0
  pushl $121
  102315:	6a 79                	push   $0x79
  jmp __alltraps
  102317:	e9 a4 fb ff ff       	jmp    101ec0 <__alltraps>

0010231c <vector122>:
.globl vector122
vector122:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $122
  10231e:	6a 7a                	push   $0x7a
  jmp __alltraps
  102320:	e9 9b fb ff ff       	jmp    101ec0 <__alltraps>

00102325 <vector123>:
.globl vector123
vector123:
  pushl $0
  102325:	6a 00                	push   $0x0
  pushl $123
  102327:	6a 7b                	push   $0x7b
  jmp __alltraps
  102329:	e9 92 fb ff ff       	jmp    101ec0 <__alltraps>

0010232e <vector124>:
.globl vector124
vector124:
  pushl $0
  10232e:	6a 00                	push   $0x0
  pushl $124
  102330:	6a 7c                	push   $0x7c
  jmp __alltraps
  102332:	e9 89 fb ff ff       	jmp    101ec0 <__alltraps>

00102337 <vector125>:
.globl vector125
vector125:
  pushl $0
  102337:	6a 00                	push   $0x0
  pushl $125
  102339:	6a 7d                	push   $0x7d
  jmp __alltraps
  10233b:	e9 80 fb ff ff       	jmp    101ec0 <__alltraps>

00102340 <vector126>:
.globl vector126
vector126:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $126
  102342:	6a 7e                	push   $0x7e
  jmp __alltraps
  102344:	e9 77 fb ff ff       	jmp    101ec0 <__alltraps>

00102349 <vector127>:
.globl vector127
vector127:
  pushl $0
  102349:	6a 00                	push   $0x0
  pushl $127
  10234b:	6a 7f                	push   $0x7f
  jmp __alltraps
  10234d:	e9 6e fb ff ff       	jmp    101ec0 <__alltraps>

00102352 <vector128>:
.globl vector128
vector128:
  pushl $0
  102352:	6a 00                	push   $0x0
  pushl $128
  102354:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102359:	e9 62 fb ff ff       	jmp    101ec0 <__alltraps>

0010235e <vector129>:
.globl vector129
vector129:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $129
  102360:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102365:	e9 56 fb ff ff       	jmp    101ec0 <__alltraps>

0010236a <vector130>:
.globl vector130
vector130:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $130
  10236c:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102371:	e9 4a fb ff ff       	jmp    101ec0 <__alltraps>

00102376 <vector131>:
.globl vector131
vector131:
  pushl $0
  102376:	6a 00                	push   $0x0
  pushl $131
  102378:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10237d:	e9 3e fb ff ff       	jmp    101ec0 <__alltraps>

00102382 <vector132>:
.globl vector132
vector132:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $132
  102384:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102389:	e9 32 fb ff ff       	jmp    101ec0 <__alltraps>

0010238e <vector133>:
.globl vector133
vector133:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $133
  102390:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102395:	e9 26 fb ff ff       	jmp    101ec0 <__alltraps>

0010239a <vector134>:
.globl vector134
vector134:
  pushl $0
  10239a:	6a 00                	push   $0x0
  pushl $134
  10239c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023a1:	e9 1a fb ff ff       	jmp    101ec0 <__alltraps>

001023a6 <vector135>:
.globl vector135
vector135:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $135
  1023a8:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023ad:	e9 0e fb ff ff       	jmp    101ec0 <__alltraps>

001023b2 <vector136>:
.globl vector136
vector136:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $136
  1023b4:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023b9:	e9 02 fb ff ff       	jmp    101ec0 <__alltraps>

001023be <vector137>:
.globl vector137
vector137:
  pushl $0
  1023be:	6a 00                	push   $0x0
  pushl $137
  1023c0:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023c5:	e9 f6 fa ff ff       	jmp    101ec0 <__alltraps>

001023ca <vector138>:
.globl vector138
vector138:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $138
  1023cc:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023d1:	e9 ea fa ff ff       	jmp    101ec0 <__alltraps>

001023d6 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $139
  1023d8:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023dd:	e9 de fa ff ff       	jmp    101ec0 <__alltraps>

001023e2 <vector140>:
.globl vector140
vector140:
  pushl $0
  1023e2:	6a 00                	push   $0x0
  pushl $140
  1023e4:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023e9:	e9 d2 fa ff ff       	jmp    101ec0 <__alltraps>

001023ee <vector141>:
.globl vector141
vector141:
  pushl $0
  1023ee:	6a 00                	push   $0x0
  pushl $141
  1023f0:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023f5:	e9 c6 fa ff ff       	jmp    101ec0 <__alltraps>

001023fa <vector142>:
.globl vector142
vector142:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $142
  1023fc:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102401:	e9 ba fa ff ff       	jmp    101ec0 <__alltraps>

00102406 <vector143>:
.globl vector143
vector143:
  pushl $0
  102406:	6a 00                	push   $0x0
  pushl $143
  102408:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10240d:	e9 ae fa ff ff       	jmp    101ec0 <__alltraps>

00102412 <vector144>:
.globl vector144
vector144:
  pushl $0
  102412:	6a 00                	push   $0x0
  pushl $144
  102414:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102419:	e9 a2 fa ff ff       	jmp    101ec0 <__alltraps>

0010241e <vector145>:
.globl vector145
vector145:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $145
  102420:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102425:	e9 96 fa ff ff       	jmp    101ec0 <__alltraps>

0010242a <vector146>:
.globl vector146
vector146:
  pushl $0
  10242a:	6a 00                	push   $0x0
  pushl $146
  10242c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102431:	e9 8a fa ff ff       	jmp    101ec0 <__alltraps>

00102436 <vector147>:
.globl vector147
vector147:
  pushl $0
  102436:	6a 00                	push   $0x0
  pushl $147
  102438:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10243d:	e9 7e fa ff ff       	jmp    101ec0 <__alltraps>

00102442 <vector148>:
.globl vector148
vector148:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $148
  102444:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102449:	e9 72 fa ff ff       	jmp    101ec0 <__alltraps>

0010244e <vector149>:
.globl vector149
vector149:
  pushl $0
  10244e:	6a 00                	push   $0x0
  pushl $149
  102450:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102455:	e9 66 fa ff ff       	jmp    101ec0 <__alltraps>

0010245a <vector150>:
.globl vector150
vector150:
  pushl $0
  10245a:	6a 00                	push   $0x0
  pushl $150
  10245c:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102461:	e9 5a fa ff ff       	jmp    101ec0 <__alltraps>

00102466 <vector151>:
.globl vector151
vector151:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $151
  102468:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10246d:	e9 4e fa ff ff       	jmp    101ec0 <__alltraps>

00102472 <vector152>:
.globl vector152
vector152:
  pushl $0
  102472:	6a 00                	push   $0x0
  pushl $152
  102474:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102479:	e9 42 fa ff ff       	jmp    101ec0 <__alltraps>

0010247e <vector153>:
.globl vector153
vector153:
  pushl $0
  10247e:	6a 00                	push   $0x0
  pushl $153
  102480:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102485:	e9 36 fa ff ff       	jmp    101ec0 <__alltraps>

0010248a <vector154>:
.globl vector154
vector154:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $154
  10248c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102491:	e9 2a fa ff ff       	jmp    101ec0 <__alltraps>

00102496 <vector155>:
.globl vector155
vector155:
  pushl $0
  102496:	6a 00                	push   $0x0
  pushl $155
  102498:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10249d:	e9 1e fa ff ff       	jmp    101ec0 <__alltraps>

001024a2 <vector156>:
.globl vector156
vector156:
  pushl $0
  1024a2:	6a 00                	push   $0x0
  pushl $156
  1024a4:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024a9:	e9 12 fa ff ff       	jmp    101ec0 <__alltraps>

001024ae <vector157>:
.globl vector157
vector157:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $157
  1024b0:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024b5:	e9 06 fa ff ff       	jmp    101ec0 <__alltraps>

001024ba <vector158>:
.globl vector158
vector158:
  pushl $0
  1024ba:	6a 00                	push   $0x0
  pushl $158
  1024bc:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024c1:	e9 fa f9 ff ff       	jmp    101ec0 <__alltraps>

001024c6 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024c6:	6a 00                	push   $0x0
  pushl $159
  1024c8:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024cd:	e9 ee f9 ff ff       	jmp    101ec0 <__alltraps>

001024d2 <vector160>:
.globl vector160
vector160:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $160
  1024d4:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024d9:	e9 e2 f9 ff ff       	jmp    101ec0 <__alltraps>

001024de <vector161>:
.globl vector161
vector161:
  pushl $0
  1024de:	6a 00                	push   $0x0
  pushl $161
  1024e0:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024e5:	e9 d6 f9 ff ff       	jmp    101ec0 <__alltraps>

001024ea <vector162>:
.globl vector162
vector162:
  pushl $0
  1024ea:	6a 00                	push   $0x0
  pushl $162
  1024ec:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024f1:	e9 ca f9 ff ff       	jmp    101ec0 <__alltraps>

001024f6 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $163
  1024f8:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024fd:	e9 be f9 ff ff       	jmp    101ec0 <__alltraps>

00102502 <vector164>:
.globl vector164
vector164:
  pushl $0
  102502:	6a 00                	push   $0x0
  pushl $164
  102504:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102509:	e9 b2 f9 ff ff       	jmp    101ec0 <__alltraps>

0010250e <vector165>:
.globl vector165
vector165:
  pushl $0
  10250e:	6a 00                	push   $0x0
  pushl $165
  102510:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102515:	e9 a6 f9 ff ff       	jmp    101ec0 <__alltraps>

0010251a <vector166>:
.globl vector166
vector166:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $166
  10251c:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102521:	e9 9a f9 ff ff       	jmp    101ec0 <__alltraps>

00102526 <vector167>:
.globl vector167
vector167:
  pushl $0
  102526:	6a 00                	push   $0x0
  pushl $167
  102528:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10252d:	e9 8e f9 ff ff       	jmp    101ec0 <__alltraps>

00102532 <vector168>:
.globl vector168
vector168:
  pushl $0
  102532:	6a 00                	push   $0x0
  pushl $168
  102534:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102539:	e9 82 f9 ff ff       	jmp    101ec0 <__alltraps>

0010253e <vector169>:
.globl vector169
vector169:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $169
  102540:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102545:	e9 76 f9 ff ff       	jmp    101ec0 <__alltraps>

0010254a <vector170>:
.globl vector170
vector170:
  pushl $0
  10254a:	6a 00                	push   $0x0
  pushl $170
  10254c:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102551:	e9 6a f9 ff ff       	jmp    101ec0 <__alltraps>

00102556 <vector171>:
.globl vector171
vector171:
  pushl $0
  102556:	6a 00                	push   $0x0
  pushl $171
  102558:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10255d:	e9 5e f9 ff ff       	jmp    101ec0 <__alltraps>

00102562 <vector172>:
.globl vector172
vector172:
  pushl $0
  102562:	6a 00                	push   $0x0
  pushl $172
  102564:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102569:	e9 52 f9 ff ff       	jmp    101ec0 <__alltraps>

0010256e <vector173>:
.globl vector173
vector173:
  pushl $0
  10256e:	6a 00                	push   $0x0
  pushl $173
  102570:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102575:	e9 46 f9 ff ff       	jmp    101ec0 <__alltraps>

0010257a <vector174>:
.globl vector174
vector174:
  pushl $0
  10257a:	6a 00                	push   $0x0
  pushl $174
  10257c:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102581:	e9 3a f9 ff ff       	jmp    101ec0 <__alltraps>

00102586 <vector175>:
.globl vector175
vector175:
  pushl $0
  102586:	6a 00                	push   $0x0
  pushl $175
  102588:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10258d:	e9 2e f9 ff ff       	jmp    101ec0 <__alltraps>

00102592 <vector176>:
.globl vector176
vector176:
  pushl $0
  102592:	6a 00                	push   $0x0
  pushl $176
  102594:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102599:	e9 22 f9 ff ff       	jmp    101ec0 <__alltraps>

0010259e <vector177>:
.globl vector177
vector177:
  pushl $0
  10259e:	6a 00                	push   $0x0
  pushl $177
  1025a0:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025a5:	e9 16 f9 ff ff       	jmp    101ec0 <__alltraps>

001025aa <vector178>:
.globl vector178
vector178:
  pushl $0
  1025aa:	6a 00                	push   $0x0
  pushl $178
  1025ac:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025b1:	e9 0a f9 ff ff       	jmp    101ec0 <__alltraps>

001025b6 <vector179>:
.globl vector179
vector179:
  pushl $0
  1025b6:	6a 00                	push   $0x0
  pushl $179
  1025b8:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025bd:	e9 fe f8 ff ff       	jmp    101ec0 <__alltraps>

001025c2 <vector180>:
.globl vector180
vector180:
  pushl $0
  1025c2:	6a 00                	push   $0x0
  pushl $180
  1025c4:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025c9:	e9 f2 f8 ff ff       	jmp    101ec0 <__alltraps>

001025ce <vector181>:
.globl vector181
vector181:
  pushl $0
  1025ce:	6a 00                	push   $0x0
  pushl $181
  1025d0:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025d5:	e9 e6 f8 ff ff       	jmp    101ec0 <__alltraps>

001025da <vector182>:
.globl vector182
vector182:
  pushl $0
  1025da:	6a 00                	push   $0x0
  pushl $182
  1025dc:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025e1:	e9 da f8 ff ff       	jmp    101ec0 <__alltraps>

001025e6 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025e6:	6a 00                	push   $0x0
  pushl $183
  1025e8:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025ed:	e9 ce f8 ff ff       	jmp    101ec0 <__alltraps>

001025f2 <vector184>:
.globl vector184
vector184:
  pushl $0
  1025f2:	6a 00                	push   $0x0
  pushl $184
  1025f4:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025f9:	e9 c2 f8 ff ff       	jmp    101ec0 <__alltraps>

001025fe <vector185>:
.globl vector185
vector185:
  pushl $0
  1025fe:	6a 00                	push   $0x0
  pushl $185
  102600:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102605:	e9 b6 f8 ff ff       	jmp    101ec0 <__alltraps>

0010260a <vector186>:
.globl vector186
vector186:
  pushl $0
  10260a:	6a 00                	push   $0x0
  pushl $186
  10260c:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102611:	e9 aa f8 ff ff       	jmp    101ec0 <__alltraps>

00102616 <vector187>:
.globl vector187
vector187:
  pushl $0
  102616:	6a 00                	push   $0x0
  pushl $187
  102618:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10261d:	e9 9e f8 ff ff       	jmp    101ec0 <__alltraps>

00102622 <vector188>:
.globl vector188
vector188:
  pushl $0
  102622:	6a 00                	push   $0x0
  pushl $188
  102624:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102629:	e9 92 f8 ff ff       	jmp    101ec0 <__alltraps>

0010262e <vector189>:
.globl vector189
vector189:
  pushl $0
  10262e:	6a 00                	push   $0x0
  pushl $189
  102630:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102635:	e9 86 f8 ff ff       	jmp    101ec0 <__alltraps>

0010263a <vector190>:
.globl vector190
vector190:
  pushl $0
  10263a:	6a 00                	push   $0x0
  pushl $190
  10263c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102641:	e9 7a f8 ff ff       	jmp    101ec0 <__alltraps>

00102646 <vector191>:
.globl vector191
vector191:
  pushl $0
  102646:	6a 00                	push   $0x0
  pushl $191
  102648:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10264d:	e9 6e f8 ff ff       	jmp    101ec0 <__alltraps>

00102652 <vector192>:
.globl vector192
vector192:
  pushl $0
  102652:	6a 00                	push   $0x0
  pushl $192
  102654:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102659:	e9 62 f8 ff ff       	jmp    101ec0 <__alltraps>

0010265e <vector193>:
.globl vector193
vector193:
  pushl $0
  10265e:	6a 00                	push   $0x0
  pushl $193
  102660:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102665:	e9 56 f8 ff ff       	jmp    101ec0 <__alltraps>

0010266a <vector194>:
.globl vector194
vector194:
  pushl $0
  10266a:	6a 00                	push   $0x0
  pushl $194
  10266c:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102671:	e9 4a f8 ff ff       	jmp    101ec0 <__alltraps>

00102676 <vector195>:
.globl vector195
vector195:
  pushl $0
  102676:	6a 00                	push   $0x0
  pushl $195
  102678:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10267d:	e9 3e f8 ff ff       	jmp    101ec0 <__alltraps>

00102682 <vector196>:
.globl vector196
vector196:
  pushl $0
  102682:	6a 00                	push   $0x0
  pushl $196
  102684:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102689:	e9 32 f8 ff ff       	jmp    101ec0 <__alltraps>

0010268e <vector197>:
.globl vector197
vector197:
  pushl $0
  10268e:	6a 00                	push   $0x0
  pushl $197
  102690:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102695:	e9 26 f8 ff ff       	jmp    101ec0 <__alltraps>

0010269a <vector198>:
.globl vector198
vector198:
  pushl $0
  10269a:	6a 00                	push   $0x0
  pushl $198
  10269c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026a1:	e9 1a f8 ff ff       	jmp    101ec0 <__alltraps>

001026a6 <vector199>:
.globl vector199
vector199:
  pushl $0
  1026a6:	6a 00                	push   $0x0
  pushl $199
  1026a8:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026ad:	e9 0e f8 ff ff       	jmp    101ec0 <__alltraps>

001026b2 <vector200>:
.globl vector200
vector200:
  pushl $0
  1026b2:	6a 00                	push   $0x0
  pushl $200
  1026b4:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026b9:	e9 02 f8 ff ff       	jmp    101ec0 <__alltraps>

001026be <vector201>:
.globl vector201
vector201:
  pushl $0
  1026be:	6a 00                	push   $0x0
  pushl $201
  1026c0:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026c5:	e9 f6 f7 ff ff       	jmp    101ec0 <__alltraps>

001026ca <vector202>:
.globl vector202
vector202:
  pushl $0
  1026ca:	6a 00                	push   $0x0
  pushl $202
  1026cc:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026d1:	e9 ea f7 ff ff       	jmp    101ec0 <__alltraps>

001026d6 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026d6:	6a 00                	push   $0x0
  pushl $203
  1026d8:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026dd:	e9 de f7 ff ff       	jmp    101ec0 <__alltraps>

001026e2 <vector204>:
.globl vector204
vector204:
  pushl $0
  1026e2:	6a 00                	push   $0x0
  pushl $204
  1026e4:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026e9:	e9 d2 f7 ff ff       	jmp    101ec0 <__alltraps>

001026ee <vector205>:
.globl vector205
vector205:
  pushl $0
  1026ee:	6a 00                	push   $0x0
  pushl $205
  1026f0:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026f5:	e9 c6 f7 ff ff       	jmp    101ec0 <__alltraps>

001026fa <vector206>:
.globl vector206
vector206:
  pushl $0
  1026fa:	6a 00                	push   $0x0
  pushl $206
  1026fc:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102701:	e9 ba f7 ff ff       	jmp    101ec0 <__alltraps>

00102706 <vector207>:
.globl vector207
vector207:
  pushl $0
  102706:	6a 00                	push   $0x0
  pushl $207
  102708:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10270d:	e9 ae f7 ff ff       	jmp    101ec0 <__alltraps>

00102712 <vector208>:
.globl vector208
vector208:
  pushl $0
  102712:	6a 00                	push   $0x0
  pushl $208
  102714:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102719:	e9 a2 f7 ff ff       	jmp    101ec0 <__alltraps>

0010271e <vector209>:
.globl vector209
vector209:
  pushl $0
  10271e:	6a 00                	push   $0x0
  pushl $209
  102720:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102725:	e9 96 f7 ff ff       	jmp    101ec0 <__alltraps>

0010272a <vector210>:
.globl vector210
vector210:
  pushl $0
  10272a:	6a 00                	push   $0x0
  pushl $210
  10272c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102731:	e9 8a f7 ff ff       	jmp    101ec0 <__alltraps>

00102736 <vector211>:
.globl vector211
vector211:
  pushl $0
  102736:	6a 00                	push   $0x0
  pushl $211
  102738:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10273d:	e9 7e f7 ff ff       	jmp    101ec0 <__alltraps>

00102742 <vector212>:
.globl vector212
vector212:
  pushl $0
  102742:	6a 00                	push   $0x0
  pushl $212
  102744:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102749:	e9 72 f7 ff ff       	jmp    101ec0 <__alltraps>

0010274e <vector213>:
.globl vector213
vector213:
  pushl $0
  10274e:	6a 00                	push   $0x0
  pushl $213
  102750:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102755:	e9 66 f7 ff ff       	jmp    101ec0 <__alltraps>

0010275a <vector214>:
.globl vector214
vector214:
  pushl $0
  10275a:	6a 00                	push   $0x0
  pushl $214
  10275c:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102761:	e9 5a f7 ff ff       	jmp    101ec0 <__alltraps>

00102766 <vector215>:
.globl vector215
vector215:
  pushl $0
  102766:	6a 00                	push   $0x0
  pushl $215
  102768:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10276d:	e9 4e f7 ff ff       	jmp    101ec0 <__alltraps>

00102772 <vector216>:
.globl vector216
vector216:
  pushl $0
  102772:	6a 00                	push   $0x0
  pushl $216
  102774:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102779:	e9 42 f7 ff ff       	jmp    101ec0 <__alltraps>

0010277e <vector217>:
.globl vector217
vector217:
  pushl $0
  10277e:	6a 00                	push   $0x0
  pushl $217
  102780:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102785:	e9 36 f7 ff ff       	jmp    101ec0 <__alltraps>

0010278a <vector218>:
.globl vector218
vector218:
  pushl $0
  10278a:	6a 00                	push   $0x0
  pushl $218
  10278c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102791:	e9 2a f7 ff ff       	jmp    101ec0 <__alltraps>

00102796 <vector219>:
.globl vector219
vector219:
  pushl $0
  102796:	6a 00                	push   $0x0
  pushl $219
  102798:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10279d:	e9 1e f7 ff ff       	jmp    101ec0 <__alltraps>

001027a2 <vector220>:
.globl vector220
vector220:
  pushl $0
  1027a2:	6a 00                	push   $0x0
  pushl $220
  1027a4:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027a9:	e9 12 f7 ff ff       	jmp    101ec0 <__alltraps>

001027ae <vector221>:
.globl vector221
vector221:
  pushl $0
  1027ae:	6a 00                	push   $0x0
  pushl $221
  1027b0:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027b5:	e9 06 f7 ff ff       	jmp    101ec0 <__alltraps>

001027ba <vector222>:
.globl vector222
vector222:
  pushl $0
  1027ba:	6a 00                	push   $0x0
  pushl $222
  1027bc:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027c1:	e9 fa f6 ff ff       	jmp    101ec0 <__alltraps>

001027c6 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027c6:	6a 00                	push   $0x0
  pushl $223
  1027c8:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027cd:	e9 ee f6 ff ff       	jmp    101ec0 <__alltraps>

001027d2 <vector224>:
.globl vector224
vector224:
  pushl $0
  1027d2:	6a 00                	push   $0x0
  pushl $224
  1027d4:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027d9:	e9 e2 f6 ff ff       	jmp    101ec0 <__alltraps>

001027de <vector225>:
.globl vector225
vector225:
  pushl $0
  1027de:	6a 00                	push   $0x0
  pushl $225
  1027e0:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027e5:	e9 d6 f6 ff ff       	jmp    101ec0 <__alltraps>

001027ea <vector226>:
.globl vector226
vector226:
  pushl $0
  1027ea:	6a 00                	push   $0x0
  pushl $226
  1027ec:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027f1:	e9 ca f6 ff ff       	jmp    101ec0 <__alltraps>

001027f6 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027f6:	6a 00                	push   $0x0
  pushl $227
  1027f8:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027fd:	e9 be f6 ff ff       	jmp    101ec0 <__alltraps>

00102802 <vector228>:
.globl vector228
vector228:
  pushl $0
  102802:	6a 00                	push   $0x0
  pushl $228
  102804:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102809:	e9 b2 f6 ff ff       	jmp    101ec0 <__alltraps>

0010280e <vector229>:
.globl vector229
vector229:
  pushl $0
  10280e:	6a 00                	push   $0x0
  pushl $229
  102810:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102815:	e9 a6 f6 ff ff       	jmp    101ec0 <__alltraps>

0010281a <vector230>:
.globl vector230
vector230:
  pushl $0
  10281a:	6a 00                	push   $0x0
  pushl $230
  10281c:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102821:	e9 9a f6 ff ff       	jmp    101ec0 <__alltraps>

00102826 <vector231>:
.globl vector231
vector231:
  pushl $0
  102826:	6a 00                	push   $0x0
  pushl $231
  102828:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10282d:	e9 8e f6 ff ff       	jmp    101ec0 <__alltraps>

00102832 <vector232>:
.globl vector232
vector232:
  pushl $0
  102832:	6a 00                	push   $0x0
  pushl $232
  102834:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102839:	e9 82 f6 ff ff       	jmp    101ec0 <__alltraps>

0010283e <vector233>:
.globl vector233
vector233:
  pushl $0
  10283e:	6a 00                	push   $0x0
  pushl $233
  102840:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102845:	e9 76 f6 ff ff       	jmp    101ec0 <__alltraps>

0010284a <vector234>:
.globl vector234
vector234:
  pushl $0
  10284a:	6a 00                	push   $0x0
  pushl $234
  10284c:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102851:	e9 6a f6 ff ff       	jmp    101ec0 <__alltraps>

00102856 <vector235>:
.globl vector235
vector235:
  pushl $0
  102856:	6a 00                	push   $0x0
  pushl $235
  102858:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10285d:	e9 5e f6 ff ff       	jmp    101ec0 <__alltraps>

00102862 <vector236>:
.globl vector236
vector236:
  pushl $0
  102862:	6a 00                	push   $0x0
  pushl $236
  102864:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102869:	e9 52 f6 ff ff       	jmp    101ec0 <__alltraps>

0010286e <vector237>:
.globl vector237
vector237:
  pushl $0
  10286e:	6a 00                	push   $0x0
  pushl $237
  102870:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102875:	e9 46 f6 ff ff       	jmp    101ec0 <__alltraps>

0010287a <vector238>:
.globl vector238
vector238:
  pushl $0
  10287a:	6a 00                	push   $0x0
  pushl $238
  10287c:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102881:	e9 3a f6 ff ff       	jmp    101ec0 <__alltraps>

00102886 <vector239>:
.globl vector239
vector239:
  pushl $0
  102886:	6a 00                	push   $0x0
  pushl $239
  102888:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10288d:	e9 2e f6 ff ff       	jmp    101ec0 <__alltraps>

00102892 <vector240>:
.globl vector240
vector240:
  pushl $0
  102892:	6a 00                	push   $0x0
  pushl $240
  102894:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102899:	e9 22 f6 ff ff       	jmp    101ec0 <__alltraps>

0010289e <vector241>:
.globl vector241
vector241:
  pushl $0
  10289e:	6a 00                	push   $0x0
  pushl $241
  1028a0:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028a5:	e9 16 f6 ff ff       	jmp    101ec0 <__alltraps>

001028aa <vector242>:
.globl vector242
vector242:
  pushl $0
  1028aa:	6a 00                	push   $0x0
  pushl $242
  1028ac:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028b1:	e9 0a f6 ff ff       	jmp    101ec0 <__alltraps>

001028b6 <vector243>:
.globl vector243
vector243:
  pushl $0
  1028b6:	6a 00                	push   $0x0
  pushl $243
  1028b8:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028bd:	e9 fe f5 ff ff       	jmp    101ec0 <__alltraps>

001028c2 <vector244>:
.globl vector244
vector244:
  pushl $0
  1028c2:	6a 00                	push   $0x0
  pushl $244
  1028c4:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028c9:	e9 f2 f5 ff ff       	jmp    101ec0 <__alltraps>

001028ce <vector245>:
.globl vector245
vector245:
  pushl $0
  1028ce:	6a 00                	push   $0x0
  pushl $245
  1028d0:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028d5:	e9 e6 f5 ff ff       	jmp    101ec0 <__alltraps>

001028da <vector246>:
.globl vector246
vector246:
  pushl $0
  1028da:	6a 00                	push   $0x0
  pushl $246
  1028dc:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028e1:	e9 da f5 ff ff       	jmp    101ec0 <__alltraps>

001028e6 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028e6:	6a 00                	push   $0x0
  pushl $247
  1028e8:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028ed:	e9 ce f5 ff ff       	jmp    101ec0 <__alltraps>

001028f2 <vector248>:
.globl vector248
vector248:
  pushl $0
  1028f2:	6a 00                	push   $0x0
  pushl $248
  1028f4:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028f9:	e9 c2 f5 ff ff       	jmp    101ec0 <__alltraps>

001028fe <vector249>:
.globl vector249
vector249:
  pushl $0
  1028fe:	6a 00                	push   $0x0
  pushl $249
  102900:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102905:	e9 b6 f5 ff ff       	jmp    101ec0 <__alltraps>

0010290a <vector250>:
.globl vector250
vector250:
  pushl $0
  10290a:	6a 00                	push   $0x0
  pushl $250
  10290c:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102911:	e9 aa f5 ff ff       	jmp    101ec0 <__alltraps>

00102916 <vector251>:
.globl vector251
vector251:
  pushl $0
  102916:	6a 00                	push   $0x0
  pushl $251
  102918:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10291d:	e9 9e f5 ff ff       	jmp    101ec0 <__alltraps>

00102922 <vector252>:
.globl vector252
vector252:
  pushl $0
  102922:	6a 00                	push   $0x0
  pushl $252
  102924:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102929:	e9 92 f5 ff ff       	jmp    101ec0 <__alltraps>

0010292e <vector253>:
.globl vector253
vector253:
  pushl $0
  10292e:	6a 00                	push   $0x0
  pushl $253
  102930:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102935:	e9 86 f5 ff ff       	jmp    101ec0 <__alltraps>

0010293a <vector254>:
.globl vector254
vector254:
  pushl $0
  10293a:	6a 00                	push   $0x0
  pushl $254
  10293c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102941:	e9 7a f5 ff ff       	jmp    101ec0 <__alltraps>

00102946 <vector255>:
.globl vector255
vector255:
  pushl $0
  102946:	6a 00                	push   $0x0
  pushl $255
  102948:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10294d:	e9 6e f5 ff ff       	jmp    101ec0 <__alltraps>

00102952 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102952:	55                   	push   %ebp
  102953:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102955:	8b 45 08             	mov    0x8(%ebp),%eax
  102958:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10295b:	b8 23 00 00 00       	mov    $0x23,%eax
  102960:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102962:	b8 23 00 00 00       	mov    $0x23,%eax
  102967:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102969:	b8 10 00 00 00       	mov    $0x10,%eax
  10296e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102970:	b8 10 00 00 00       	mov    $0x10,%eax
  102975:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102977:	b8 10 00 00 00       	mov    $0x10,%eax
  10297c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10297e:	ea 85 29 10 00 08 00 	ljmp   $0x8,$0x102985
}
  102985:	5d                   	pop    %ebp
  102986:	c3                   	ret    

00102987 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102987:	55                   	push   %ebp
  102988:	89 e5                	mov    %esp,%ebp
  10298a:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  10298d:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  102992:	05 00 04 00 00       	add    $0x400,%eax
  102997:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  10299c:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1029a3:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1029a5:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1029ac:	68 00 
  1029ae:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029b3:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1029b9:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029be:	c1 e8 10             	shr    $0x10,%eax
  1029c1:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1029c6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029cd:	83 e0 f0             	and    $0xfffffff0,%eax
  1029d0:	83 c8 09             	or     $0x9,%eax
  1029d3:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029d8:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029df:	83 c8 10             	or     $0x10,%eax
  1029e2:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029e7:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029ee:	83 e0 9f             	and    $0xffffff9f,%eax
  1029f1:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029f6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029fd:	83 c8 80             	or     $0xffffff80,%eax
  102a00:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a05:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a0c:	83 e0 f0             	and    $0xfffffff0,%eax
  102a0f:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a14:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a1b:	83 e0 ef             	and    $0xffffffef,%eax
  102a1e:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a23:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a2a:	83 e0 df             	and    $0xffffffdf,%eax
  102a2d:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a32:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a39:	83 c8 40             	or     $0x40,%eax
  102a3c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a41:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a48:	83 e0 7f             	and    $0x7f,%eax
  102a4b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a50:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a55:	c1 e8 18             	shr    $0x18,%eax
  102a58:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102a5d:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a64:	83 e0 ef             	and    $0xffffffef,%eax
  102a67:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a6c:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102a73:	e8 da fe ff ff       	call   102952 <lgdt>
  102a78:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102a7e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102a82:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102a85:	c9                   	leave  
  102a86:	c3                   	ret    

00102a87 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102a87:	55                   	push   %ebp
  102a88:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102a8a:	e8 f8 fe ff ff       	call   102987 <gdt_init>
}
  102a8f:	5d                   	pop    %ebp
  102a90:	c3                   	ret    

00102a91 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102a91:	55                   	push   %ebp
  102a92:	89 e5                	mov    %esp,%ebp
  102a94:	83 ec 58             	sub    $0x58,%esp
  102a97:	8b 45 10             	mov    0x10(%ebp),%eax
  102a9a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a9d:	8b 45 14             	mov    0x14(%ebp),%eax
  102aa0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102aa3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102aa6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102aa9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102aac:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102aaf:	8b 45 18             	mov    0x18(%ebp),%eax
  102ab2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102ab5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ab8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102abb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102abe:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ac4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ac7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102acb:	74 1c                	je     102ae9 <printnum+0x58>
  102acd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ad0:	ba 00 00 00 00       	mov    $0x0,%edx
  102ad5:	f7 75 e4             	divl   -0x1c(%ebp)
  102ad8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ade:	ba 00 00 00 00       	mov    $0x0,%edx
  102ae3:	f7 75 e4             	divl   -0x1c(%ebp)
  102ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ae9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102aec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102aef:	f7 75 e4             	divl   -0x1c(%ebp)
  102af2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102af5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102af8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102afb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102afe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b01:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102b04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b07:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102b0a:	8b 45 18             	mov    0x18(%ebp),%eax
  102b0d:	ba 00 00 00 00       	mov    $0x0,%edx
  102b12:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102b15:	77 56                	ja     102b6d <printnum+0xdc>
  102b17:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102b1a:	72 05                	jb     102b21 <printnum+0x90>
  102b1c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102b1f:	77 4c                	ja     102b6d <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102b21:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102b24:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b27:	8b 45 20             	mov    0x20(%ebp),%eax
  102b2a:	89 44 24 18          	mov    %eax,0x18(%esp)
  102b2e:	89 54 24 14          	mov    %edx,0x14(%esp)
  102b32:	8b 45 18             	mov    0x18(%ebp),%eax
  102b35:	89 44 24 10          	mov    %eax,0x10(%esp)
  102b39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b3f:	89 44 24 08          	mov    %eax,0x8(%esp)
  102b43:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b51:	89 04 24             	mov    %eax,(%esp)
  102b54:	e8 38 ff ff ff       	call   102a91 <printnum>
  102b59:	eb 1c                	jmp    102b77 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b62:	8b 45 20             	mov    0x20(%ebp),%eax
  102b65:	89 04 24             	mov    %eax,(%esp)
  102b68:	8b 45 08             	mov    0x8(%ebp),%eax
  102b6b:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102b6d:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102b71:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102b75:	7f e4                	jg     102b5b <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102b77:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102b7a:	05 b0 3d 10 00       	add    $0x103db0,%eax
  102b7f:	0f b6 00             	movzbl (%eax),%eax
  102b82:	0f be c0             	movsbl %al,%eax
  102b85:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b88:	89 54 24 04          	mov    %edx,0x4(%esp)
  102b8c:	89 04 24             	mov    %eax,(%esp)
  102b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b92:	ff d0                	call   *%eax
}
  102b94:	c9                   	leave  
  102b95:	c3                   	ret    

00102b96 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102b96:	55                   	push   %ebp
  102b97:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102b99:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102b9d:	7e 14                	jle    102bb3 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba2:	8b 00                	mov    (%eax),%eax
  102ba4:	8d 48 08             	lea    0x8(%eax),%ecx
  102ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  102baa:	89 0a                	mov    %ecx,(%edx)
  102bac:	8b 50 04             	mov    0x4(%eax),%edx
  102baf:	8b 00                	mov    (%eax),%eax
  102bb1:	eb 30                	jmp    102be3 <getuint+0x4d>
    }
    else if (lflag) {
  102bb3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102bb7:	74 16                	je     102bcf <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  102bbc:	8b 00                	mov    (%eax),%eax
  102bbe:	8d 48 04             	lea    0x4(%eax),%ecx
  102bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  102bc4:	89 0a                	mov    %ecx,(%edx)
  102bc6:	8b 00                	mov    (%eax),%eax
  102bc8:	ba 00 00 00 00       	mov    $0x0,%edx
  102bcd:	eb 14                	jmp    102be3 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd2:	8b 00                	mov    (%eax),%eax
  102bd4:	8d 48 04             	lea    0x4(%eax),%ecx
  102bd7:	8b 55 08             	mov    0x8(%ebp),%edx
  102bda:	89 0a                	mov    %ecx,(%edx)
  102bdc:	8b 00                	mov    (%eax),%eax
  102bde:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102be3:	5d                   	pop    %ebp
  102be4:	c3                   	ret    

00102be5 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102be5:	55                   	push   %ebp
  102be6:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102be8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102bec:	7e 14                	jle    102c02 <getint+0x1d>
        return va_arg(*ap, long long);
  102bee:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf1:	8b 00                	mov    (%eax),%eax
  102bf3:	8d 48 08             	lea    0x8(%eax),%ecx
  102bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  102bf9:	89 0a                	mov    %ecx,(%edx)
  102bfb:	8b 50 04             	mov    0x4(%eax),%edx
  102bfe:	8b 00                	mov    (%eax),%eax
  102c00:	eb 28                	jmp    102c2a <getint+0x45>
    }
    else if (lflag) {
  102c02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c06:	74 12                	je     102c1a <getint+0x35>
        return va_arg(*ap, long);
  102c08:	8b 45 08             	mov    0x8(%ebp),%eax
  102c0b:	8b 00                	mov    (%eax),%eax
  102c0d:	8d 48 04             	lea    0x4(%eax),%ecx
  102c10:	8b 55 08             	mov    0x8(%ebp),%edx
  102c13:	89 0a                	mov    %ecx,(%edx)
  102c15:	8b 00                	mov    (%eax),%eax
  102c17:	99                   	cltd   
  102c18:	eb 10                	jmp    102c2a <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1d:	8b 00                	mov    (%eax),%eax
  102c1f:	8d 48 04             	lea    0x4(%eax),%ecx
  102c22:	8b 55 08             	mov    0x8(%ebp),%edx
  102c25:	89 0a                	mov    %ecx,(%edx)
  102c27:	8b 00                	mov    (%eax),%eax
  102c29:	99                   	cltd   
    }
}
  102c2a:	5d                   	pop    %ebp
  102c2b:	c3                   	ret    

00102c2c <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102c2c:	55                   	push   %ebp
  102c2d:	89 e5                	mov    %esp,%ebp
  102c2f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102c32:	8d 45 14             	lea    0x14(%ebp),%eax
  102c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102c3f:	8b 45 10             	mov    0x10(%ebp),%eax
  102c42:	89 44 24 08          	mov    %eax,0x8(%esp)
  102c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c49:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102c50:	89 04 24             	mov    %eax,(%esp)
  102c53:	e8 02 00 00 00       	call   102c5a <vprintfmt>
    va_end(ap);
}
  102c58:	c9                   	leave  
  102c59:	c3                   	ret    

00102c5a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102c5a:	55                   	push   %ebp
  102c5b:	89 e5                	mov    %esp,%ebp
  102c5d:	56                   	push   %esi
  102c5e:	53                   	push   %ebx
  102c5f:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c62:	eb 18                	jmp    102c7c <vprintfmt+0x22>
            if (ch == '\0') {
  102c64:	85 db                	test   %ebx,%ebx
  102c66:	75 05                	jne    102c6d <vprintfmt+0x13>
                return;
  102c68:	e9 d1 03 00 00       	jmp    10303e <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c70:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c74:	89 1c 24             	mov    %ebx,(%esp)
  102c77:	8b 45 08             	mov    0x8(%ebp),%eax
  102c7a:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c7c:	8b 45 10             	mov    0x10(%ebp),%eax
  102c7f:	8d 50 01             	lea    0x1(%eax),%edx
  102c82:	89 55 10             	mov    %edx,0x10(%ebp)
  102c85:	0f b6 00             	movzbl (%eax),%eax
  102c88:	0f b6 d8             	movzbl %al,%ebx
  102c8b:	83 fb 25             	cmp    $0x25,%ebx
  102c8e:	75 d4                	jne    102c64 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102c90:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102c94:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102c9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102ca1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102ca8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cab:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102cae:	8b 45 10             	mov    0x10(%ebp),%eax
  102cb1:	8d 50 01             	lea    0x1(%eax),%edx
  102cb4:	89 55 10             	mov    %edx,0x10(%ebp)
  102cb7:	0f b6 00             	movzbl (%eax),%eax
  102cba:	0f b6 d8             	movzbl %al,%ebx
  102cbd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102cc0:	83 f8 55             	cmp    $0x55,%eax
  102cc3:	0f 87 44 03 00 00    	ja     10300d <vprintfmt+0x3b3>
  102cc9:	8b 04 85 d4 3d 10 00 	mov    0x103dd4(,%eax,4),%eax
  102cd0:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102cd2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102cd6:	eb d6                	jmp    102cae <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102cd8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102cdc:	eb d0                	jmp    102cae <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102cde:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102ce5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ce8:	89 d0                	mov    %edx,%eax
  102cea:	c1 e0 02             	shl    $0x2,%eax
  102ced:	01 d0                	add    %edx,%eax
  102cef:	01 c0                	add    %eax,%eax
  102cf1:	01 d8                	add    %ebx,%eax
  102cf3:	83 e8 30             	sub    $0x30,%eax
  102cf6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102cf9:	8b 45 10             	mov    0x10(%ebp),%eax
  102cfc:	0f b6 00             	movzbl (%eax),%eax
  102cff:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102d02:	83 fb 2f             	cmp    $0x2f,%ebx
  102d05:	7e 0b                	jle    102d12 <vprintfmt+0xb8>
  102d07:	83 fb 39             	cmp    $0x39,%ebx
  102d0a:	7f 06                	jg     102d12 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102d0c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102d10:	eb d3                	jmp    102ce5 <vprintfmt+0x8b>
            goto process_precision;
  102d12:	eb 33                	jmp    102d47 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102d14:	8b 45 14             	mov    0x14(%ebp),%eax
  102d17:	8d 50 04             	lea    0x4(%eax),%edx
  102d1a:	89 55 14             	mov    %edx,0x14(%ebp)
  102d1d:	8b 00                	mov    (%eax),%eax
  102d1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102d22:	eb 23                	jmp    102d47 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102d24:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d28:	79 0c                	jns    102d36 <vprintfmt+0xdc>
                width = 0;
  102d2a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102d31:	e9 78 ff ff ff       	jmp    102cae <vprintfmt+0x54>
  102d36:	e9 73 ff ff ff       	jmp    102cae <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102d3b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102d42:	e9 67 ff ff ff       	jmp    102cae <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102d47:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d4b:	79 12                	jns    102d5f <vprintfmt+0x105>
                width = precision, precision = -1;
  102d4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d50:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d53:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102d5a:	e9 4f ff ff ff       	jmp    102cae <vprintfmt+0x54>
  102d5f:	e9 4a ff ff ff       	jmp    102cae <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102d64:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102d68:	e9 41 ff ff ff       	jmp    102cae <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102d6d:	8b 45 14             	mov    0x14(%ebp),%eax
  102d70:	8d 50 04             	lea    0x4(%eax),%edx
  102d73:	89 55 14             	mov    %edx,0x14(%ebp)
  102d76:	8b 00                	mov    (%eax),%eax
  102d78:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d7b:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d7f:	89 04 24             	mov    %eax,(%esp)
  102d82:	8b 45 08             	mov    0x8(%ebp),%eax
  102d85:	ff d0                	call   *%eax
            break;
  102d87:	e9 ac 02 00 00       	jmp    103038 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102d8c:	8b 45 14             	mov    0x14(%ebp),%eax
  102d8f:	8d 50 04             	lea    0x4(%eax),%edx
  102d92:	89 55 14             	mov    %edx,0x14(%ebp)
  102d95:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102d97:	85 db                	test   %ebx,%ebx
  102d99:	79 02                	jns    102d9d <vprintfmt+0x143>
                err = -err;
  102d9b:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102d9d:	83 fb 06             	cmp    $0x6,%ebx
  102da0:	7f 0b                	jg     102dad <vprintfmt+0x153>
  102da2:	8b 34 9d 94 3d 10 00 	mov    0x103d94(,%ebx,4),%esi
  102da9:	85 f6                	test   %esi,%esi
  102dab:	75 23                	jne    102dd0 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102dad:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102db1:	c7 44 24 08 c1 3d 10 	movl   $0x103dc1,0x8(%esp)
  102db8:	00 
  102db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc3:	89 04 24             	mov    %eax,(%esp)
  102dc6:	e8 61 fe ff ff       	call   102c2c <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102dcb:	e9 68 02 00 00       	jmp    103038 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102dd0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102dd4:	c7 44 24 08 ca 3d 10 	movl   $0x103dca,0x8(%esp)
  102ddb:	00 
  102ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ddf:	89 44 24 04          	mov    %eax,0x4(%esp)
  102de3:	8b 45 08             	mov    0x8(%ebp),%eax
  102de6:	89 04 24             	mov    %eax,(%esp)
  102de9:	e8 3e fe ff ff       	call   102c2c <printfmt>
            }
            break;
  102dee:	e9 45 02 00 00       	jmp    103038 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102df3:	8b 45 14             	mov    0x14(%ebp),%eax
  102df6:	8d 50 04             	lea    0x4(%eax),%edx
  102df9:	89 55 14             	mov    %edx,0x14(%ebp)
  102dfc:	8b 30                	mov    (%eax),%esi
  102dfe:	85 f6                	test   %esi,%esi
  102e00:	75 05                	jne    102e07 <vprintfmt+0x1ad>
                p = "(null)";
  102e02:	be cd 3d 10 00       	mov    $0x103dcd,%esi
            }
            if (width > 0 && padc != '-') {
  102e07:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e0b:	7e 3e                	jle    102e4b <vprintfmt+0x1f1>
  102e0d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102e11:	74 38                	je     102e4b <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e13:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e19:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e1d:	89 34 24             	mov    %esi,(%esp)
  102e20:	e8 15 03 00 00       	call   10313a <strnlen>
  102e25:	29 c3                	sub    %eax,%ebx
  102e27:	89 d8                	mov    %ebx,%eax
  102e29:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e2c:	eb 17                	jmp    102e45 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102e2e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e35:	89 54 24 04          	mov    %edx,0x4(%esp)
  102e39:	89 04 24             	mov    %eax,(%esp)
  102e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3f:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e41:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e45:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e49:	7f e3                	jg     102e2e <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e4b:	eb 38                	jmp    102e85 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102e4d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102e51:	74 1f                	je     102e72 <vprintfmt+0x218>
  102e53:	83 fb 1f             	cmp    $0x1f,%ebx
  102e56:	7e 05                	jle    102e5d <vprintfmt+0x203>
  102e58:	83 fb 7e             	cmp    $0x7e,%ebx
  102e5b:	7e 15                	jle    102e72 <vprintfmt+0x218>
                    putch('?', putdat);
  102e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e60:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e64:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6e:	ff d0                	call   *%eax
  102e70:	eb 0f                	jmp    102e81 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e75:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e79:	89 1c 24             	mov    %ebx,(%esp)
  102e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e7f:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e81:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e85:	89 f0                	mov    %esi,%eax
  102e87:	8d 70 01             	lea    0x1(%eax),%esi
  102e8a:	0f b6 00             	movzbl (%eax),%eax
  102e8d:	0f be d8             	movsbl %al,%ebx
  102e90:	85 db                	test   %ebx,%ebx
  102e92:	74 10                	je     102ea4 <vprintfmt+0x24a>
  102e94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102e98:	78 b3                	js     102e4d <vprintfmt+0x1f3>
  102e9a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102e9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102ea2:	79 a9                	jns    102e4d <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102ea4:	eb 17                	jmp    102ebd <vprintfmt+0x263>
                putch(' ', putdat);
  102ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ea9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ead:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb7:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102eb9:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102ebd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102ec1:	7f e3                	jg     102ea6 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102ec3:	e9 70 01 00 00       	jmp    103038 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102ec8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ecb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ecf:	8d 45 14             	lea    0x14(%ebp),%eax
  102ed2:	89 04 24             	mov    %eax,(%esp)
  102ed5:	e8 0b fd ff ff       	call   102be5 <getint>
  102eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102edd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ee6:	85 d2                	test   %edx,%edx
  102ee8:	79 26                	jns    102f10 <vprintfmt+0x2b6>
                putch('-', putdat);
  102eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eed:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ef1:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  102efb:	ff d0                	call   *%eax
                num = -(long long)num;
  102efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f03:	f7 d8                	neg    %eax
  102f05:	83 d2 00             	adc    $0x0,%edx
  102f08:	f7 da                	neg    %edx
  102f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102f10:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f17:	e9 a8 00 00 00       	jmp    102fc4 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102f1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f23:	8d 45 14             	lea    0x14(%ebp),%eax
  102f26:	89 04 24             	mov    %eax,(%esp)
  102f29:	e8 68 fc ff ff       	call   102b96 <getuint>
  102f2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f31:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102f34:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f3b:	e9 84 00 00 00       	jmp    102fc4 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102f40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f43:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f47:	8d 45 14             	lea    0x14(%ebp),%eax
  102f4a:	89 04 24             	mov    %eax,(%esp)
  102f4d:	e8 44 fc ff ff       	call   102b96 <getuint>
  102f52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f55:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102f58:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102f5f:	eb 63                	jmp    102fc4 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f64:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f68:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f72:	ff d0                	call   *%eax
            putch('x', putdat);
  102f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f77:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f7b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102f82:	8b 45 08             	mov    0x8(%ebp),%eax
  102f85:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102f87:	8b 45 14             	mov    0x14(%ebp),%eax
  102f8a:	8d 50 04             	lea    0x4(%eax),%edx
  102f8d:	89 55 14             	mov    %edx,0x14(%ebp)
  102f90:	8b 00                	mov    (%eax),%eax
  102f92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102f9c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102fa3:	eb 1f                	jmp    102fc4 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102fa5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fac:	8d 45 14             	lea    0x14(%ebp),%eax
  102faf:	89 04 24             	mov    %eax,(%esp)
  102fb2:	e8 df fb ff ff       	call   102b96 <getuint>
  102fb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fba:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102fbd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102fc4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102fc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fcb:	89 54 24 18          	mov    %edx,0x18(%esp)
  102fcf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102fd2:	89 54 24 14          	mov    %edx,0x14(%esp)
  102fd6:	89 44 24 10          	mov    %eax,0x10(%esp)
  102fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102fe0:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fe4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102feb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fef:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff2:	89 04 24             	mov    %eax,(%esp)
  102ff5:	e8 97 fa ff ff       	call   102a91 <printnum>
            break;
  102ffa:	eb 3c                	jmp    103038 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fff:	89 44 24 04          	mov    %eax,0x4(%esp)
  103003:	89 1c 24             	mov    %ebx,(%esp)
  103006:	8b 45 08             	mov    0x8(%ebp),%eax
  103009:	ff d0                	call   *%eax
            break;
  10300b:	eb 2b                	jmp    103038 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  10300d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103010:	89 44 24 04          	mov    %eax,0x4(%esp)
  103014:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10301b:	8b 45 08             	mov    0x8(%ebp),%eax
  10301e:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  103020:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103024:	eb 04                	jmp    10302a <vprintfmt+0x3d0>
  103026:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10302a:	8b 45 10             	mov    0x10(%ebp),%eax
  10302d:	83 e8 01             	sub    $0x1,%eax
  103030:	0f b6 00             	movzbl (%eax),%eax
  103033:	3c 25                	cmp    $0x25,%al
  103035:	75 ef                	jne    103026 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  103037:	90                   	nop
        }
    }
  103038:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103039:	e9 3e fc ff ff       	jmp    102c7c <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  10303e:	83 c4 40             	add    $0x40,%esp
  103041:	5b                   	pop    %ebx
  103042:	5e                   	pop    %esi
  103043:	5d                   	pop    %ebp
  103044:	c3                   	ret    

00103045 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103045:	55                   	push   %ebp
  103046:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103048:	8b 45 0c             	mov    0xc(%ebp),%eax
  10304b:	8b 40 08             	mov    0x8(%eax),%eax
  10304e:	8d 50 01             	lea    0x1(%eax),%edx
  103051:	8b 45 0c             	mov    0xc(%ebp),%eax
  103054:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103057:	8b 45 0c             	mov    0xc(%ebp),%eax
  10305a:	8b 10                	mov    (%eax),%edx
  10305c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10305f:	8b 40 04             	mov    0x4(%eax),%eax
  103062:	39 c2                	cmp    %eax,%edx
  103064:	73 12                	jae    103078 <sprintputch+0x33>
        *b->buf ++ = ch;
  103066:	8b 45 0c             	mov    0xc(%ebp),%eax
  103069:	8b 00                	mov    (%eax),%eax
  10306b:	8d 48 01             	lea    0x1(%eax),%ecx
  10306e:	8b 55 0c             	mov    0xc(%ebp),%edx
  103071:	89 0a                	mov    %ecx,(%edx)
  103073:	8b 55 08             	mov    0x8(%ebp),%edx
  103076:	88 10                	mov    %dl,(%eax)
    }
}
  103078:	5d                   	pop    %ebp
  103079:	c3                   	ret    

0010307a <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10307a:	55                   	push   %ebp
  10307b:	89 e5                	mov    %esp,%ebp
  10307d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103080:	8d 45 14             	lea    0x14(%ebp),%eax
  103083:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103086:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103089:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10308d:	8b 45 10             	mov    0x10(%ebp),%eax
  103090:	89 44 24 08          	mov    %eax,0x8(%esp)
  103094:	8b 45 0c             	mov    0xc(%ebp),%eax
  103097:	89 44 24 04          	mov    %eax,0x4(%esp)
  10309b:	8b 45 08             	mov    0x8(%ebp),%eax
  10309e:	89 04 24             	mov    %eax,(%esp)
  1030a1:	e8 08 00 00 00       	call   1030ae <vsnprintf>
  1030a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1030ac:	c9                   	leave  
  1030ad:	c3                   	ret    

001030ae <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1030ae:	55                   	push   %ebp
  1030af:	89 e5                	mov    %esp,%ebp
  1030b1:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030bd:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c3:	01 d0                	add    %edx,%eax
  1030c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1030cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1030d3:	74 0a                	je     1030df <vsnprintf+0x31>
  1030d5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1030d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030db:	39 c2                	cmp    %eax,%edx
  1030dd:	76 07                	jbe    1030e6 <vsnprintf+0x38>
        return -E_INVAL;
  1030df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1030e4:	eb 2a                	jmp    103110 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1030e6:	8b 45 14             	mov    0x14(%ebp),%eax
  1030e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1030ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1030f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1030f4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1030f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030fb:	c7 04 24 45 30 10 00 	movl   $0x103045,(%esp)
  103102:	e8 53 fb ff ff       	call   102c5a <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  103107:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10310a:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10310d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103110:	c9                   	leave  
  103111:	c3                   	ret    

00103112 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  103112:	55                   	push   %ebp
  103113:	89 e5                	mov    %esp,%ebp
  103115:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103118:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  10311f:	eb 04                	jmp    103125 <strlen+0x13>
        cnt ++;
  103121:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  103125:	8b 45 08             	mov    0x8(%ebp),%eax
  103128:	8d 50 01             	lea    0x1(%eax),%edx
  10312b:	89 55 08             	mov    %edx,0x8(%ebp)
  10312e:	0f b6 00             	movzbl (%eax),%eax
  103131:	84 c0                	test   %al,%al
  103133:	75 ec                	jne    103121 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  103135:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103138:	c9                   	leave  
  103139:	c3                   	ret    

0010313a <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10313a:	55                   	push   %ebp
  10313b:	89 e5                	mov    %esp,%ebp
  10313d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103140:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103147:	eb 04                	jmp    10314d <strnlen+0x13>
        cnt ++;
  103149:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  10314d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103150:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103153:	73 10                	jae    103165 <strnlen+0x2b>
  103155:	8b 45 08             	mov    0x8(%ebp),%eax
  103158:	8d 50 01             	lea    0x1(%eax),%edx
  10315b:	89 55 08             	mov    %edx,0x8(%ebp)
  10315e:	0f b6 00             	movzbl (%eax),%eax
  103161:	84 c0                	test   %al,%al
  103163:	75 e4                	jne    103149 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  103165:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103168:	c9                   	leave  
  103169:	c3                   	ret    

0010316a <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10316a:	55                   	push   %ebp
  10316b:	89 e5                	mov    %esp,%ebp
  10316d:	57                   	push   %edi
  10316e:	56                   	push   %esi
  10316f:	83 ec 20             	sub    $0x20,%esp
  103172:	8b 45 08             	mov    0x8(%ebp),%eax
  103175:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103178:	8b 45 0c             	mov    0xc(%ebp),%eax
  10317b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10317e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103184:	89 d1                	mov    %edx,%ecx
  103186:	89 c2                	mov    %eax,%edx
  103188:	89 ce                	mov    %ecx,%esi
  10318a:	89 d7                	mov    %edx,%edi
  10318c:	ac                   	lods   %ds:(%esi),%al
  10318d:	aa                   	stos   %al,%es:(%edi)
  10318e:	84 c0                	test   %al,%al
  103190:	75 fa                	jne    10318c <strcpy+0x22>
  103192:	89 fa                	mov    %edi,%edx
  103194:	89 f1                	mov    %esi,%ecx
  103196:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103199:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10319c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  10319f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1031a2:	83 c4 20             	add    $0x20,%esp
  1031a5:	5e                   	pop    %esi
  1031a6:	5f                   	pop    %edi
  1031a7:	5d                   	pop    %ebp
  1031a8:	c3                   	ret    

001031a9 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1031a9:	55                   	push   %ebp
  1031aa:	89 e5                	mov    %esp,%ebp
  1031ac:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1031af:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1031b5:	eb 21                	jmp    1031d8 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  1031b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031ba:	0f b6 10             	movzbl (%eax),%edx
  1031bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031c0:	88 10                	mov    %dl,(%eax)
  1031c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031c5:	0f b6 00             	movzbl (%eax),%eax
  1031c8:	84 c0                	test   %al,%al
  1031ca:	74 04                	je     1031d0 <strncpy+0x27>
            src ++;
  1031cc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1031d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1031d4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1031d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031dc:	75 d9                	jne    1031b7 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1031de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1031e1:	c9                   	leave  
  1031e2:	c3                   	ret    

001031e3 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1031e3:	55                   	push   %ebp
  1031e4:	89 e5                	mov    %esp,%ebp
  1031e6:	57                   	push   %edi
  1031e7:	56                   	push   %esi
  1031e8:	83 ec 20             	sub    $0x20,%esp
  1031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1031f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031fd:	89 d1                	mov    %edx,%ecx
  1031ff:	89 c2                	mov    %eax,%edx
  103201:	89 ce                	mov    %ecx,%esi
  103203:	89 d7                	mov    %edx,%edi
  103205:	ac                   	lods   %ds:(%esi),%al
  103206:	ae                   	scas   %es:(%edi),%al
  103207:	75 08                	jne    103211 <strcmp+0x2e>
  103209:	84 c0                	test   %al,%al
  10320b:	75 f8                	jne    103205 <strcmp+0x22>
  10320d:	31 c0                	xor    %eax,%eax
  10320f:	eb 04                	jmp    103215 <strcmp+0x32>
  103211:	19 c0                	sbb    %eax,%eax
  103213:	0c 01                	or     $0x1,%al
  103215:	89 fa                	mov    %edi,%edx
  103217:	89 f1                	mov    %esi,%ecx
  103219:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10321c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10321f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  103222:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  103225:	83 c4 20             	add    $0x20,%esp
  103228:	5e                   	pop    %esi
  103229:	5f                   	pop    %edi
  10322a:	5d                   	pop    %ebp
  10322b:	c3                   	ret    

0010322c <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10322c:	55                   	push   %ebp
  10322d:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10322f:	eb 0c                	jmp    10323d <strncmp+0x11>
        n --, s1 ++, s2 ++;
  103231:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103235:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103239:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10323d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103241:	74 1a                	je     10325d <strncmp+0x31>
  103243:	8b 45 08             	mov    0x8(%ebp),%eax
  103246:	0f b6 00             	movzbl (%eax),%eax
  103249:	84 c0                	test   %al,%al
  10324b:	74 10                	je     10325d <strncmp+0x31>
  10324d:	8b 45 08             	mov    0x8(%ebp),%eax
  103250:	0f b6 10             	movzbl (%eax),%edx
  103253:	8b 45 0c             	mov    0xc(%ebp),%eax
  103256:	0f b6 00             	movzbl (%eax),%eax
  103259:	38 c2                	cmp    %al,%dl
  10325b:	74 d4                	je     103231 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10325d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103261:	74 18                	je     10327b <strncmp+0x4f>
  103263:	8b 45 08             	mov    0x8(%ebp),%eax
  103266:	0f b6 00             	movzbl (%eax),%eax
  103269:	0f b6 d0             	movzbl %al,%edx
  10326c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10326f:	0f b6 00             	movzbl (%eax),%eax
  103272:	0f b6 c0             	movzbl %al,%eax
  103275:	29 c2                	sub    %eax,%edx
  103277:	89 d0                	mov    %edx,%eax
  103279:	eb 05                	jmp    103280 <strncmp+0x54>
  10327b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103280:	5d                   	pop    %ebp
  103281:	c3                   	ret    

00103282 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103282:	55                   	push   %ebp
  103283:	89 e5                	mov    %esp,%ebp
  103285:	83 ec 04             	sub    $0x4,%esp
  103288:	8b 45 0c             	mov    0xc(%ebp),%eax
  10328b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10328e:	eb 14                	jmp    1032a4 <strchr+0x22>
        if (*s == c) {
  103290:	8b 45 08             	mov    0x8(%ebp),%eax
  103293:	0f b6 00             	movzbl (%eax),%eax
  103296:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103299:	75 05                	jne    1032a0 <strchr+0x1e>
            return (char *)s;
  10329b:	8b 45 08             	mov    0x8(%ebp),%eax
  10329e:	eb 13                	jmp    1032b3 <strchr+0x31>
        }
        s ++;
  1032a0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  1032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a7:	0f b6 00             	movzbl (%eax),%eax
  1032aa:	84 c0                	test   %al,%al
  1032ac:	75 e2                	jne    103290 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  1032ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032b3:	c9                   	leave  
  1032b4:	c3                   	ret    

001032b5 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1032b5:	55                   	push   %ebp
  1032b6:	89 e5                	mov    %esp,%ebp
  1032b8:	83 ec 04             	sub    $0x4,%esp
  1032bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032be:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1032c1:	eb 11                	jmp    1032d4 <strfind+0x1f>
        if (*s == c) {
  1032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c6:	0f b6 00             	movzbl (%eax),%eax
  1032c9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1032cc:	75 02                	jne    1032d0 <strfind+0x1b>
            break;
  1032ce:	eb 0e                	jmp    1032de <strfind+0x29>
        }
        s ++;
  1032d0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1032d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d7:	0f b6 00             	movzbl (%eax),%eax
  1032da:	84 c0                	test   %al,%al
  1032dc:	75 e5                	jne    1032c3 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  1032de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1032e1:	c9                   	leave  
  1032e2:	c3                   	ret    

001032e3 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1032e3:	55                   	push   %ebp
  1032e4:	89 e5                	mov    %esp,%ebp
  1032e6:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1032e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1032f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1032f7:	eb 04                	jmp    1032fd <strtol+0x1a>
        s ++;
  1032f9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1032fd:	8b 45 08             	mov    0x8(%ebp),%eax
  103300:	0f b6 00             	movzbl (%eax),%eax
  103303:	3c 20                	cmp    $0x20,%al
  103305:	74 f2                	je     1032f9 <strtol+0x16>
  103307:	8b 45 08             	mov    0x8(%ebp),%eax
  10330a:	0f b6 00             	movzbl (%eax),%eax
  10330d:	3c 09                	cmp    $0x9,%al
  10330f:	74 e8                	je     1032f9 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  103311:	8b 45 08             	mov    0x8(%ebp),%eax
  103314:	0f b6 00             	movzbl (%eax),%eax
  103317:	3c 2b                	cmp    $0x2b,%al
  103319:	75 06                	jne    103321 <strtol+0x3e>
        s ++;
  10331b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10331f:	eb 15                	jmp    103336 <strtol+0x53>
    }
    else if (*s == '-') {
  103321:	8b 45 08             	mov    0x8(%ebp),%eax
  103324:	0f b6 00             	movzbl (%eax),%eax
  103327:	3c 2d                	cmp    $0x2d,%al
  103329:	75 0b                	jne    103336 <strtol+0x53>
        s ++, neg = 1;
  10332b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10332f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103336:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10333a:	74 06                	je     103342 <strtol+0x5f>
  10333c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  103340:	75 24                	jne    103366 <strtol+0x83>
  103342:	8b 45 08             	mov    0x8(%ebp),%eax
  103345:	0f b6 00             	movzbl (%eax),%eax
  103348:	3c 30                	cmp    $0x30,%al
  10334a:	75 1a                	jne    103366 <strtol+0x83>
  10334c:	8b 45 08             	mov    0x8(%ebp),%eax
  10334f:	83 c0 01             	add    $0x1,%eax
  103352:	0f b6 00             	movzbl (%eax),%eax
  103355:	3c 78                	cmp    $0x78,%al
  103357:	75 0d                	jne    103366 <strtol+0x83>
        s += 2, base = 16;
  103359:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  10335d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  103364:	eb 2a                	jmp    103390 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  103366:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10336a:	75 17                	jne    103383 <strtol+0xa0>
  10336c:	8b 45 08             	mov    0x8(%ebp),%eax
  10336f:	0f b6 00             	movzbl (%eax),%eax
  103372:	3c 30                	cmp    $0x30,%al
  103374:	75 0d                	jne    103383 <strtol+0xa0>
        s ++, base = 8;
  103376:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10337a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103381:	eb 0d                	jmp    103390 <strtol+0xad>
    }
    else if (base == 0) {
  103383:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103387:	75 07                	jne    103390 <strtol+0xad>
        base = 10;
  103389:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103390:	8b 45 08             	mov    0x8(%ebp),%eax
  103393:	0f b6 00             	movzbl (%eax),%eax
  103396:	3c 2f                	cmp    $0x2f,%al
  103398:	7e 1b                	jle    1033b5 <strtol+0xd2>
  10339a:	8b 45 08             	mov    0x8(%ebp),%eax
  10339d:	0f b6 00             	movzbl (%eax),%eax
  1033a0:	3c 39                	cmp    $0x39,%al
  1033a2:	7f 11                	jg     1033b5 <strtol+0xd2>
            dig = *s - '0';
  1033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a7:	0f b6 00             	movzbl (%eax),%eax
  1033aa:	0f be c0             	movsbl %al,%eax
  1033ad:	83 e8 30             	sub    $0x30,%eax
  1033b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033b3:	eb 48                	jmp    1033fd <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b8:	0f b6 00             	movzbl (%eax),%eax
  1033bb:	3c 60                	cmp    $0x60,%al
  1033bd:	7e 1b                	jle    1033da <strtol+0xf7>
  1033bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c2:	0f b6 00             	movzbl (%eax),%eax
  1033c5:	3c 7a                	cmp    $0x7a,%al
  1033c7:	7f 11                	jg     1033da <strtol+0xf7>
            dig = *s - 'a' + 10;
  1033c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1033cc:	0f b6 00             	movzbl (%eax),%eax
  1033cf:	0f be c0             	movsbl %al,%eax
  1033d2:	83 e8 57             	sub    $0x57,%eax
  1033d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033d8:	eb 23                	jmp    1033fd <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1033da:	8b 45 08             	mov    0x8(%ebp),%eax
  1033dd:	0f b6 00             	movzbl (%eax),%eax
  1033e0:	3c 40                	cmp    $0x40,%al
  1033e2:	7e 3d                	jle    103421 <strtol+0x13e>
  1033e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e7:	0f b6 00             	movzbl (%eax),%eax
  1033ea:	3c 5a                	cmp    $0x5a,%al
  1033ec:	7f 33                	jg     103421 <strtol+0x13e>
            dig = *s - 'A' + 10;
  1033ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f1:	0f b6 00             	movzbl (%eax),%eax
  1033f4:	0f be c0             	movsbl %al,%eax
  1033f7:	83 e8 37             	sub    $0x37,%eax
  1033fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1033fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103400:	3b 45 10             	cmp    0x10(%ebp),%eax
  103403:	7c 02                	jl     103407 <strtol+0x124>
            break;
  103405:	eb 1a                	jmp    103421 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  103407:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10340b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10340e:	0f af 45 10          	imul   0x10(%ebp),%eax
  103412:	89 c2                	mov    %eax,%edx
  103414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103417:	01 d0                	add    %edx,%eax
  103419:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  10341c:	e9 6f ff ff ff       	jmp    103390 <strtol+0xad>

    if (endptr) {
  103421:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103425:	74 08                	je     10342f <strtol+0x14c>
        *endptr = (char *) s;
  103427:	8b 45 0c             	mov    0xc(%ebp),%eax
  10342a:	8b 55 08             	mov    0x8(%ebp),%edx
  10342d:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10342f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103433:	74 07                	je     10343c <strtol+0x159>
  103435:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103438:	f7 d8                	neg    %eax
  10343a:	eb 03                	jmp    10343f <strtol+0x15c>
  10343c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10343f:	c9                   	leave  
  103440:	c3                   	ret    

00103441 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  103441:	55                   	push   %ebp
  103442:	89 e5                	mov    %esp,%ebp
  103444:	57                   	push   %edi
  103445:	83 ec 24             	sub    $0x24,%esp
  103448:	8b 45 0c             	mov    0xc(%ebp),%eax
  10344b:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10344e:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  103452:	8b 55 08             	mov    0x8(%ebp),%edx
  103455:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103458:	88 45 f7             	mov    %al,-0x9(%ebp)
  10345b:	8b 45 10             	mov    0x10(%ebp),%eax
  10345e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103461:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103464:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103468:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10346b:	89 d7                	mov    %edx,%edi
  10346d:	f3 aa                	rep stos %al,%es:(%edi)
  10346f:	89 fa                	mov    %edi,%edx
  103471:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103474:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103477:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10347a:	83 c4 24             	add    $0x24,%esp
  10347d:	5f                   	pop    %edi
  10347e:	5d                   	pop    %ebp
  10347f:	c3                   	ret    

00103480 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103480:	55                   	push   %ebp
  103481:	89 e5                	mov    %esp,%ebp
  103483:	57                   	push   %edi
  103484:	56                   	push   %esi
  103485:	53                   	push   %ebx
  103486:	83 ec 30             	sub    $0x30,%esp
  103489:	8b 45 08             	mov    0x8(%ebp),%eax
  10348c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10348f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103492:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103495:	8b 45 10             	mov    0x10(%ebp),%eax
  103498:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10349b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10349e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1034a1:	73 42                	jae    1034e5 <memmove+0x65>
  1034a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1034af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1034b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1034b8:	c1 e8 02             	shr    $0x2,%eax
  1034bb:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1034bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1034c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1034c3:	89 d7                	mov    %edx,%edi
  1034c5:	89 c6                	mov    %eax,%esi
  1034c7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1034c9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1034cc:	83 e1 03             	and    $0x3,%ecx
  1034cf:	74 02                	je     1034d3 <memmove+0x53>
  1034d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1034d3:	89 f0                	mov    %esi,%eax
  1034d5:	89 fa                	mov    %edi,%edx
  1034d7:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1034da:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1034dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1034e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034e3:	eb 36                	jmp    10351b <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1034e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1034eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034ee:	01 c2                	add    %eax,%edx
  1034f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034f3:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1034f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034f9:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1034fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034ff:	89 c1                	mov    %eax,%ecx
  103501:	89 d8                	mov    %ebx,%eax
  103503:	89 d6                	mov    %edx,%esi
  103505:	89 c7                	mov    %eax,%edi
  103507:	fd                   	std    
  103508:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10350a:	fc                   	cld    
  10350b:	89 f8                	mov    %edi,%eax
  10350d:	89 f2                	mov    %esi,%edx
  10350f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103512:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103515:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  103518:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10351b:	83 c4 30             	add    $0x30,%esp
  10351e:	5b                   	pop    %ebx
  10351f:	5e                   	pop    %esi
  103520:	5f                   	pop    %edi
  103521:	5d                   	pop    %ebp
  103522:	c3                   	ret    

00103523 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103523:	55                   	push   %ebp
  103524:	89 e5                	mov    %esp,%ebp
  103526:	57                   	push   %edi
  103527:	56                   	push   %esi
  103528:	83 ec 20             	sub    $0x20,%esp
  10352b:	8b 45 08             	mov    0x8(%ebp),%eax
  10352e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103531:	8b 45 0c             	mov    0xc(%ebp),%eax
  103534:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103537:	8b 45 10             	mov    0x10(%ebp),%eax
  10353a:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10353d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103540:	c1 e8 02             	shr    $0x2,%eax
  103543:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103545:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10354b:	89 d7                	mov    %edx,%edi
  10354d:	89 c6                	mov    %eax,%esi
  10354f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103551:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103554:	83 e1 03             	and    $0x3,%ecx
  103557:	74 02                	je     10355b <memcpy+0x38>
  103559:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10355b:	89 f0                	mov    %esi,%eax
  10355d:	89 fa                	mov    %edi,%edx
  10355f:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103562:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103565:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103568:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10356b:	83 c4 20             	add    $0x20,%esp
  10356e:	5e                   	pop    %esi
  10356f:	5f                   	pop    %edi
  103570:	5d                   	pop    %ebp
  103571:	c3                   	ret    

00103572 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103572:	55                   	push   %ebp
  103573:	89 e5                	mov    %esp,%ebp
  103575:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103578:	8b 45 08             	mov    0x8(%ebp),%eax
  10357b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10357e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103581:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103584:	eb 30                	jmp    1035b6 <memcmp+0x44>
        if (*s1 != *s2) {
  103586:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103589:	0f b6 10             	movzbl (%eax),%edx
  10358c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10358f:	0f b6 00             	movzbl (%eax),%eax
  103592:	38 c2                	cmp    %al,%dl
  103594:	74 18                	je     1035ae <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103596:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103599:	0f b6 00             	movzbl (%eax),%eax
  10359c:	0f b6 d0             	movzbl %al,%edx
  10359f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1035a2:	0f b6 00             	movzbl (%eax),%eax
  1035a5:	0f b6 c0             	movzbl %al,%eax
  1035a8:	29 c2                	sub    %eax,%edx
  1035aa:	89 d0                	mov    %edx,%eax
  1035ac:	eb 1a                	jmp    1035c8 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  1035ae:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1035b2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  1035b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1035b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1035bc:	89 55 10             	mov    %edx,0x10(%ebp)
  1035bf:	85 c0                	test   %eax,%eax
  1035c1:	75 c3                	jne    103586 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1035c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1035c8:	c9                   	leave  
  1035c9:	c3                   	ret    
