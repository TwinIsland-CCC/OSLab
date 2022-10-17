
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba e0 fd 10 00       	mov    $0x10fde0,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 1c 36 00 00       	call   103648 <memset>

    cons_init();                // init the console
  10002c:	e8 26 16 00 00       	call   101657 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 e0 37 10 00 	movl   $0x1037e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 fc 37 10 00 	movl   $0x1037fc,(%esp)
  100046:	e8 87 03 00 00       	call   1003d2 <cprintf>

    print_kerninfo();
  10004b:	e8 b6 08 00 00       	call   100906 <print_kerninfo>

    grade_backtrace();
  100050:	e8 8b 00 00 00       	call   1000e0 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 34 2c 00 00       	call   102c8e <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 3b 17 00 00       	call   10179a <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 8d 18 00 00       	call   1018f1 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 e1 0d 00 00       	call   100e4a <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 9a 16 00 00       	call   101708 <intr_enable>

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
  100092:	e8 d4 0c 00 00       	call   100d6b <mon_backtrace>
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
  100130:	c7 04 24 01 38 10 00 	movl   $0x103801,(%esp)
  100137:	e8 96 02 00 00       	call   1003d2 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 d0             	movzwl %ax,%edx
  100143:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 0f 38 10 00 	movl   $0x10380f,(%esp)
  100157:	e8 76 02 00 00       	call   1003d2 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	0f b7 d0             	movzwl %ax,%edx
  100163:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100168:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100170:	c7 04 24 1d 38 10 00 	movl   $0x10381d,(%esp)
  100177:	e8 56 02 00 00       	call   1003d2 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100180:	0f b7 d0             	movzwl %ax,%edx
  100183:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100188:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100190:	c7 04 24 2b 38 10 00 	movl   $0x10382b,(%esp)
  100197:	e8 36 02 00 00       	call   1003d2 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a0:	0f b7 d0             	movzwl %ax,%edx
  1001a3:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a8:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b0:	c7 04 24 39 38 10 00 	movl   $0x103839,(%esp)
  1001b7:	e8 16 02 00 00       	call   1003d2 <cprintf>
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
    asm volatile(
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
  1001eb:	c7 04 24 48 38 10 00 	movl   $0x103848,(%esp)
  1001f2:	e8 db 01 00 00       	call   1003d2 <cprintf>
    lab1_switch_to_user();
  1001f7:	e8 cf ff ff ff       	call   1001cb <lab1_switch_to_user>
    lab1_print_cur_status();
  1001fc:	e8 04 ff ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100201:	c7 04 24 68 38 10 00 	movl   $0x103868,(%esp)
  100208:	e8 c5 01 00 00       	call   1003d2 <cprintf>
    lab1_switch_to_kernel();
  10020d:	e8 c5 ff ff ff       	call   1001d7 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100212:	e8 ee fe ff ff       	call   100105 <lab1_print_cur_status>
        cprintf("+++ switch to  user  mode +++\n");
  100217:	c7 04 24 48 38 10 00 	movl   $0x103848,(%esp)
  10021e:	e8 af 01 00 00       	call   1003d2 <cprintf>
    lab1_switch_to_user();
  100223:	e8 a3 ff ff ff       	call   1001cb <lab1_switch_to_user>
    lab1_print_cur_status();
  100228:	e8 d8 fe ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10022d:	c7 04 24 68 38 10 00 	movl   $0x103868,(%esp)
  100234:	e8 99 01 00 00       	call   1003d2 <cprintf>
    lab1_switch_to_kernel();
  100239:	e8 99 ff ff ff       	call   1001d7 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10023e:	e8 c2 fe ff ff       	call   100105 <lab1_print_cur_status>
        cprintf("+++ switch to  user  mode +++\n");
  100243:	c7 04 24 48 38 10 00 	movl   $0x103848,(%esp)
  10024a:	e8 83 01 00 00       	call   1003d2 <cprintf>
    lab1_switch_to_user();
  10024f:	e8 77 ff ff ff       	call   1001cb <lab1_switch_to_user>
    lab1_print_cur_status();
  100254:	e8 ac fe ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100259:	c7 04 24 68 38 10 00 	movl   $0x103868,(%esp)
  100260:	e8 6d 01 00 00       	call   1003d2 <cprintf>
    lab1_switch_to_kernel();
  100265:	e8 6d ff ff ff       	call   1001d7 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10026a:	e8 96 fe ff ff       	call   100105 <lab1_print_cur_status>
        cprintf("+++ switch to  user  mode +++\n");
  10026f:	c7 04 24 48 38 10 00 	movl   $0x103848,(%esp)
  100276:	e8 57 01 00 00       	call   1003d2 <cprintf>
    lab1_switch_to_user();
  10027b:	e8 4b ff ff ff       	call   1001cb <lab1_switch_to_user>
    lab1_print_cur_status();
  100280:	e8 80 fe ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100285:	c7 04 24 68 38 10 00 	movl   $0x103868,(%esp)
  10028c:	e8 41 01 00 00       	call   1003d2 <cprintf>
    lab1_switch_to_kernel();
  100291:	e8 41 ff ff ff       	call   1001d7 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100296:	e8 6a fe ff ff       	call   100105 <lab1_print_cur_status>
        cprintf("+++ switch to  user  mode +++\n");
  10029b:	c7 04 24 48 38 10 00 	movl   $0x103848,(%esp)
  1002a2:	e8 2b 01 00 00       	call   1003d2 <cprintf>
    lab1_switch_to_user();
  1002a7:	e8 1f ff ff ff       	call   1001cb <lab1_switch_to_user>
    lab1_print_cur_status();
  1002ac:	e8 54 fe ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1002b1:	c7 04 24 68 38 10 00 	movl   $0x103868,(%esp)
  1002b8:	e8 15 01 00 00       	call   1003d2 <cprintf>
    lab1_switch_to_kernel();
  1002bd:	e8 15 ff ff ff       	call   1001d7 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  1002c2:	e8 3e fe ff ff       	call   100105 <lab1_print_cur_status>
}
  1002c7:	c9                   	leave  
  1002c8:	c3                   	ret    

001002c9 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002c9:	55                   	push   %ebp
  1002ca:	89 e5                	mov    %esp,%ebp
  1002cc:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  1002cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1002d3:	74 13                	je     1002e8 <readline+0x1f>
        cprintf("%s", prompt);
  1002d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002dc:	c7 04 24 87 38 10 00 	movl   $0x103887,(%esp)
  1002e3:	e8 ea 00 00 00       	call   1003d2 <cprintf>
    }
    int i = 0, c;
  1002e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  1002ef:	e8 66 01 00 00       	call   10045a <getchar>
  1002f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  1002f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1002fb:	79 07                	jns    100304 <readline+0x3b>
            return NULL;
  1002fd:	b8 00 00 00 00       	mov    $0x0,%eax
  100302:	eb 79                	jmp    10037d <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100304:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100308:	7e 28                	jle    100332 <readline+0x69>
  10030a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100311:	7f 1f                	jg     100332 <readline+0x69>
            cputchar(c);
  100313:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100316:	89 04 24             	mov    %eax,(%esp)
  100319:	e8 da 00 00 00       	call   1003f8 <cputchar>
            buf[i ++] = c;
  10031e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100321:	8d 50 01             	lea    0x1(%eax),%edx
  100324:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100327:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10032a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100330:	eb 46                	jmp    100378 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100332:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100336:	75 17                	jne    10034f <readline+0x86>
  100338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10033c:	7e 11                	jle    10034f <readline+0x86>
            cputchar(c);
  10033e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100341:	89 04 24             	mov    %eax,(%esp)
  100344:	e8 af 00 00 00       	call   1003f8 <cputchar>
            i --;
  100349:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10034d:	eb 29                	jmp    100378 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10034f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100353:	74 06                	je     10035b <readline+0x92>
  100355:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100359:	75 1d                	jne    100378 <readline+0xaf>
            cputchar(c);
  10035b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10035e:	89 04 24             	mov    %eax,(%esp)
  100361:	e8 92 00 00 00       	call   1003f8 <cputchar>
            buf[i] = '\0';
  100366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100369:	05 40 ea 10 00       	add    $0x10ea40,%eax
  10036e:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100371:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  100376:	eb 05                	jmp    10037d <readline+0xb4>
        }
    }
  100378:	e9 72 ff ff ff       	jmp    1002ef <readline+0x26>
}
  10037d:	c9                   	leave  
  10037e:	c3                   	ret    

0010037f <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10037f:	55                   	push   %ebp
  100380:	89 e5                	mov    %esp,%ebp
  100382:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100385:	8b 45 08             	mov    0x8(%ebp),%eax
  100388:	89 04 24             	mov    %eax,(%esp)
  10038b:	e8 f3 12 00 00       	call   101683 <cons_putc>
    (*cnt) ++;
  100390:	8b 45 0c             	mov    0xc(%ebp),%eax
  100393:	8b 00                	mov    (%eax),%eax
  100395:	8d 50 01             	lea    0x1(%eax),%edx
  100398:	8b 45 0c             	mov    0xc(%ebp),%eax
  10039b:	89 10                	mov    %edx,(%eax)
}
  10039d:	c9                   	leave  
  10039e:	c3                   	ret    

0010039f <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10039f:	55                   	push   %ebp
  1003a0:	89 e5                	mov    %esp,%ebp
  1003a2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1003a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1003ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1003b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1003b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1003ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1003bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003c1:	c7 04 24 7f 03 10 00 	movl   $0x10037f,(%esp)
  1003c8:	e8 94 2a 00 00       	call   102e61 <vprintfmt>
    return cnt;
  1003cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003d0:	c9                   	leave  
  1003d1:	c3                   	ret    

001003d2 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1003d2:	55                   	push   %ebp
  1003d3:	89 e5                	mov    %esp,%ebp
  1003d5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1003d8:	8d 45 0c             	lea    0xc(%ebp),%eax
  1003db:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1003de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1003e8:	89 04 24             	mov    %eax,(%esp)
  1003eb:	e8 af ff ff ff       	call   10039f <vcprintf>
  1003f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1003f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003f6:	c9                   	leave  
  1003f7:	c3                   	ret    

001003f8 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1003f8:	55                   	push   %ebp
  1003f9:	89 e5                	mov    %esp,%ebp
  1003fb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  100401:	89 04 24             	mov    %eax,(%esp)
  100404:	e8 7a 12 00 00       	call   101683 <cons_putc>
}
  100409:	c9                   	leave  
  10040a:	c3                   	ret    

0010040b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10040b:	55                   	push   %ebp
  10040c:	89 e5                	mov    %esp,%ebp
  10040e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100411:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100418:	eb 13                	jmp    10042d <cputs+0x22>
        cputch(c, &cnt);
  10041a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10041e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100421:	89 54 24 04          	mov    %edx,0x4(%esp)
  100425:	89 04 24             	mov    %eax,(%esp)
  100428:	e8 52 ff ff ff       	call   10037f <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10042d:	8b 45 08             	mov    0x8(%ebp),%eax
  100430:	8d 50 01             	lea    0x1(%eax),%edx
  100433:	89 55 08             	mov    %edx,0x8(%ebp)
  100436:	0f b6 00             	movzbl (%eax),%eax
  100439:	88 45 f7             	mov    %al,-0x9(%ebp)
  10043c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100440:	75 d8                	jne    10041a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100442:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100445:	89 44 24 04          	mov    %eax,0x4(%esp)
  100449:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100450:	e8 2a ff ff ff       	call   10037f <cputch>
    return cnt;
  100455:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100458:	c9                   	leave  
  100459:	c3                   	ret    

0010045a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10045a:	55                   	push   %ebp
  10045b:	89 e5                	mov    %esp,%ebp
  10045d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100460:	e8 47 12 00 00       	call   1016ac <cons_getc>
  100465:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100468:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10046c:	74 f2                	je     100460 <getchar+0x6>
        /* do nothing */;
    return c;
  10046e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100471:	c9                   	leave  
  100472:	c3                   	ret    

00100473 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100473:	55                   	push   %ebp
  100474:	89 e5                	mov    %esp,%ebp
  100476:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100479:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047c:	8b 00                	mov    (%eax),%eax
  10047e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100481:	8b 45 10             	mov    0x10(%ebp),%eax
  100484:	8b 00                	mov    (%eax),%eax
  100486:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100489:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100490:	e9 d2 00 00 00       	jmp    100567 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  100495:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100498:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10049b:	01 d0                	add    %edx,%eax
  10049d:	89 c2                	mov    %eax,%edx
  10049f:	c1 ea 1f             	shr    $0x1f,%edx
  1004a2:	01 d0                	add    %edx,%eax
  1004a4:	d1 f8                	sar    %eax
  1004a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004ac:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004af:	eb 04                	jmp    1004b5 <stab_binsearch+0x42>
            m --;
  1004b1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004bb:	7c 1f                	jl     1004dc <stab_binsearch+0x69>
  1004bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c0:	89 d0                	mov    %edx,%eax
  1004c2:	01 c0                	add    %eax,%eax
  1004c4:	01 d0                	add    %edx,%eax
  1004c6:	c1 e0 02             	shl    $0x2,%eax
  1004c9:	89 c2                	mov    %eax,%edx
  1004cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ce:	01 d0                	add    %edx,%eax
  1004d0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004d4:	0f b6 c0             	movzbl %al,%eax
  1004d7:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004da:	75 d5                	jne    1004b1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  1004dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004df:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004e2:	7d 0b                	jge    1004ef <stab_binsearch+0x7c>
            l = true_m + 1;
  1004e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004e7:	83 c0 01             	add    $0x1,%eax
  1004ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004ed:	eb 78                	jmp    100567 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  1004ef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  1004f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004f9:	89 d0                	mov    %edx,%eax
  1004fb:	01 c0                	add    %eax,%eax
  1004fd:	01 d0                	add    %edx,%eax
  1004ff:	c1 e0 02             	shl    $0x2,%eax
  100502:	89 c2                	mov    %eax,%edx
  100504:	8b 45 08             	mov    0x8(%ebp),%eax
  100507:	01 d0                	add    %edx,%eax
  100509:	8b 40 08             	mov    0x8(%eax),%eax
  10050c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10050f:	73 13                	jae    100524 <stab_binsearch+0xb1>
            *region_left = m;
  100511:	8b 45 0c             	mov    0xc(%ebp),%eax
  100514:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100517:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100519:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10051c:	83 c0 01             	add    $0x1,%eax
  10051f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100522:	eb 43                	jmp    100567 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100524:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100527:	89 d0                	mov    %edx,%eax
  100529:	01 c0                	add    %eax,%eax
  10052b:	01 d0                	add    %edx,%eax
  10052d:	c1 e0 02             	shl    $0x2,%eax
  100530:	89 c2                	mov    %eax,%edx
  100532:	8b 45 08             	mov    0x8(%ebp),%eax
  100535:	01 d0                	add    %edx,%eax
  100537:	8b 40 08             	mov    0x8(%eax),%eax
  10053a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10053d:	76 16                	jbe    100555 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10053f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100542:	8d 50 ff             	lea    -0x1(%eax),%edx
  100545:	8b 45 10             	mov    0x10(%ebp),%eax
  100548:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10054a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054d:	83 e8 01             	sub    $0x1,%eax
  100550:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100553:	eb 12                	jmp    100567 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100555:	8b 45 0c             	mov    0xc(%ebp),%eax
  100558:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10055b:	89 10                	mov    %edx,(%eax)
            l = m;
  10055d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100560:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100563:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  100567:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10056a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10056d:	0f 8e 22 ff ff ff    	jle    100495 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  100573:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100577:	75 0f                	jne    100588 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100579:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057c:	8b 00                	mov    (%eax),%eax
  10057e:	8d 50 ff             	lea    -0x1(%eax),%edx
  100581:	8b 45 10             	mov    0x10(%ebp),%eax
  100584:	89 10                	mov    %edx,(%eax)
  100586:	eb 3f                	jmp    1005c7 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  100588:	8b 45 10             	mov    0x10(%ebp),%eax
  10058b:	8b 00                	mov    (%eax),%eax
  10058d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100590:	eb 04                	jmp    100596 <stab_binsearch+0x123>
  100592:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100596:	8b 45 0c             	mov    0xc(%ebp),%eax
  100599:	8b 00                	mov    (%eax),%eax
  10059b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10059e:	7d 1f                	jge    1005bf <stab_binsearch+0x14c>
  1005a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005a3:	89 d0                	mov    %edx,%eax
  1005a5:	01 c0                	add    %eax,%eax
  1005a7:	01 d0                	add    %edx,%eax
  1005a9:	c1 e0 02             	shl    $0x2,%eax
  1005ac:	89 c2                	mov    %eax,%edx
  1005ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b1:	01 d0                	add    %edx,%eax
  1005b3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005b7:	0f b6 c0             	movzbl %al,%eax
  1005ba:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005bd:	75 d3                	jne    100592 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005c5:	89 10                	mov    %edx,(%eax)
    }
}
  1005c7:	c9                   	leave  
  1005c8:	c3                   	ret    

001005c9 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005c9:	55                   	push   %ebp
  1005ca:	89 e5                	mov    %esp,%ebp
  1005cc:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d2:	c7 00 8c 38 10 00    	movl   $0x10388c,(%eax)
    info->eip_line = 0;
  1005d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e5:	c7 40 08 8c 38 10 00 	movl   $0x10388c,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ef:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  1005f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f9:	8b 55 08             	mov    0x8(%ebp),%edx
  1005fc:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  1005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100602:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100609:	c7 45 f4 4c 41 10 00 	movl   $0x10414c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100610:	c7 45 f0 c8 bb 10 00 	movl   $0x10bbc8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100617:	c7 45 ec c9 bb 10 00 	movl   $0x10bbc9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10061e:	c7 45 e8 fe db 10 00 	movl   $0x10dbfe,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100625:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100628:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10062b:	76 0d                	jbe    10063a <debuginfo_eip+0x71>
  10062d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100630:	83 e8 01             	sub    $0x1,%eax
  100633:	0f b6 00             	movzbl (%eax),%eax
  100636:	84 c0                	test   %al,%al
  100638:	74 0a                	je     100644 <debuginfo_eip+0x7b>
        return -1;
  10063a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10063f:	e9 c0 02 00 00       	jmp    100904 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100644:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10064b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10064e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100651:	29 c2                	sub    %eax,%edx
  100653:	89 d0                	mov    %edx,%eax
  100655:	c1 f8 02             	sar    $0x2,%eax
  100658:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10065e:	83 e8 01             	sub    $0x1,%eax
  100661:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100664:	8b 45 08             	mov    0x8(%ebp),%eax
  100667:	89 44 24 10          	mov    %eax,0x10(%esp)
  10066b:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100672:	00 
  100673:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100676:	89 44 24 08          	mov    %eax,0x8(%esp)
  10067a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10067d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100684:	89 04 24             	mov    %eax,(%esp)
  100687:	e8 e7 fd ff ff       	call   100473 <stab_binsearch>
    if (lfile == 0)
  10068c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10068f:	85 c0                	test   %eax,%eax
  100691:	75 0a                	jne    10069d <debuginfo_eip+0xd4>
        return -1;
  100693:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100698:	e9 67 02 00 00       	jmp    100904 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10069d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006b0:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006b7:	00 
  1006b8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006bf:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006c9:	89 04 24             	mov    %eax,(%esp)
  1006cc:	e8 a2 fd ff ff       	call   100473 <stab_binsearch>

    if (lfun <= rfun) {
  1006d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006d7:	39 c2                	cmp    %eax,%edx
  1006d9:	7f 7c                	jg     100757 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006de:	89 c2                	mov    %eax,%edx
  1006e0:	89 d0                	mov    %edx,%eax
  1006e2:	01 c0                	add    %eax,%eax
  1006e4:	01 d0                	add    %edx,%eax
  1006e6:	c1 e0 02             	shl    $0x2,%eax
  1006e9:	89 c2                	mov    %eax,%edx
  1006eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006ee:	01 d0                	add    %edx,%eax
  1006f0:	8b 10                	mov    (%eax),%edx
  1006f2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1006f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1006f8:	29 c1                	sub    %eax,%ecx
  1006fa:	89 c8                	mov    %ecx,%eax
  1006fc:	39 c2                	cmp    %eax,%edx
  1006fe:	73 22                	jae    100722 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100700:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100703:	89 c2                	mov    %eax,%edx
  100705:	89 d0                	mov    %edx,%eax
  100707:	01 c0                	add    %eax,%eax
  100709:	01 d0                	add    %edx,%eax
  10070b:	c1 e0 02             	shl    $0x2,%eax
  10070e:	89 c2                	mov    %eax,%edx
  100710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100713:	01 d0                	add    %edx,%eax
  100715:	8b 10                	mov    (%eax),%edx
  100717:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10071a:	01 c2                	add    %eax,%edx
  10071c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10071f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100722:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100725:	89 c2                	mov    %eax,%edx
  100727:	89 d0                	mov    %edx,%eax
  100729:	01 c0                	add    %eax,%eax
  10072b:	01 d0                	add    %edx,%eax
  10072d:	c1 e0 02             	shl    $0x2,%eax
  100730:	89 c2                	mov    %eax,%edx
  100732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100735:	01 d0                	add    %edx,%eax
  100737:	8b 50 08             	mov    0x8(%eax),%edx
  10073a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100740:	8b 45 0c             	mov    0xc(%ebp),%eax
  100743:	8b 40 10             	mov    0x10(%eax),%eax
  100746:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100749:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10074c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10074f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100752:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100755:	eb 15                	jmp    10076c <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100757:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075a:	8b 55 08             	mov    0x8(%ebp),%edx
  10075d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100763:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100766:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100769:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10076c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076f:	8b 40 08             	mov    0x8(%eax),%eax
  100772:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  100779:	00 
  10077a:	89 04 24             	mov    %eax,(%esp)
  10077d:	e8 3a 2d 00 00       	call   1034bc <strfind>
  100782:	89 c2                	mov    %eax,%edx
  100784:	8b 45 0c             	mov    0xc(%ebp),%eax
  100787:	8b 40 08             	mov    0x8(%eax),%eax
  10078a:	29 c2                	sub    %eax,%edx
  10078c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078f:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100792:	8b 45 08             	mov    0x8(%ebp),%eax
  100795:	89 44 24 10          	mov    %eax,0x10(%esp)
  100799:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007a0:	00 
  1007a1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007a8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b2:	89 04 24             	mov    %eax,(%esp)
  1007b5:	e8 b9 fc ff ff       	call   100473 <stab_binsearch>
    if (lline <= rline) {
  1007ba:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007c0:	39 c2                	cmp    %eax,%edx
  1007c2:	7f 24                	jg     1007e8 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  1007c4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007c7:	89 c2                	mov    %eax,%edx
  1007c9:	89 d0                	mov    %edx,%eax
  1007cb:	01 c0                	add    %eax,%eax
  1007cd:	01 d0                	add    %edx,%eax
  1007cf:	c1 e0 02             	shl    $0x2,%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007d7:	01 d0                	add    %edx,%eax
  1007d9:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007dd:	0f b7 d0             	movzwl %ax,%edx
  1007e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e3:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007e6:	eb 13                	jmp    1007fb <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  1007e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007ed:	e9 12 01 00 00       	jmp    100904 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f5:	83 e8 01             	sub    $0x1,%eax
  1007f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100801:	39 c2                	cmp    %eax,%edx
  100803:	7c 56                	jl     10085b <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100805:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100808:	89 c2                	mov    %eax,%edx
  10080a:	89 d0                	mov    %edx,%eax
  10080c:	01 c0                	add    %eax,%eax
  10080e:	01 d0                	add    %edx,%eax
  100810:	c1 e0 02             	shl    $0x2,%eax
  100813:	89 c2                	mov    %eax,%edx
  100815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100818:	01 d0                	add    %edx,%eax
  10081a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10081e:	3c 84                	cmp    $0x84,%al
  100820:	74 39                	je     10085b <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c 64                	cmp    $0x64,%al
  10083d:	75 b3                	jne    1007f2 <debuginfo_eip+0x229>
  10083f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100842:	89 c2                	mov    %eax,%edx
  100844:	89 d0                	mov    %edx,%eax
  100846:	01 c0                	add    %eax,%eax
  100848:	01 d0                	add    %edx,%eax
  10084a:	c1 e0 02             	shl    $0x2,%eax
  10084d:	89 c2                	mov    %eax,%edx
  10084f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100852:	01 d0                	add    %edx,%eax
  100854:	8b 40 08             	mov    0x8(%eax),%eax
  100857:	85 c0                	test   %eax,%eax
  100859:	74 97                	je     1007f2 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10085b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10085e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100861:	39 c2                	cmp    %eax,%edx
  100863:	7c 46                	jl     1008ab <debuginfo_eip+0x2e2>
  100865:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100868:	89 c2                	mov    %eax,%edx
  10086a:	89 d0                	mov    %edx,%eax
  10086c:	01 c0                	add    %eax,%eax
  10086e:	01 d0                	add    %edx,%eax
  100870:	c1 e0 02             	shl    $0x2,%eax
  100873:	89 c2                	mov    %eax,%edx
  100875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100878:	01 d0                	add    %edx,%eax
  10087a:	8b 10                	mov    (%eax),%edx
  10087c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10087f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100882:	29 c1                	sub    %eax,%ecx
  100884:	89 c8                	mov    %ecx,%eax
  100886:	39 c2                	cmp    %eax,%edx
  100888:	73 21                	jae    1008ab <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10088a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10088d:	89 c2                	mov    %eax,%edx
  10088f:	89 d0                	mov    %edx,%eax
  100891:	01 c0                	add    %eax,%eax
  100893:	01 d0                	add    %edx,%eax
  100895:	c1 e0 02             	shl    $0x2,%eax
  100898:	89 c2                	mov    %eax,%edx
  10089a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10089d:	01 d0                	add    %edx,%eax
  10089f:	8b 10                	mov    (%eax),%edx
  1008a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008a4:	01 c2                	add    %eax,%edx
  1008a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008a9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008b1:	39 c2                	cmp    %eax,%edx
  1008b3:	7d 4a                	jge    1008ff <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1008b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008b8:	83 c0 01             	add    $0x1,%eax
  1008bb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008be:	eb 18                	jmp    1008d8 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008c3:	8b 40 14             	mov    0x14(%eax),%eax
  1008c6:	8d 50 01             	lea    0x1(%eax),%edx
  1008c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008cc:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  1008cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008d2:	83 c0 01             	add    $0x1,%eax
  1008d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008d8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008db:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  1008de:	39 c2                	cmp    %eax,%edx
  1008e0:	7d 1d                	jge    1008ff <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e5:	89 c2                	mov    %eax,%edx
  1008e7:	89 d0                	mov    %edx,%eax
  1008e9:	01 c0                	add    %eax,%eax
  1008eb:	01 d0                	add    %edx,%eax
  1008ed:	c1 e0 02             	shl    $0x2,%eax
  1008f0:	89 c2                	mov    %eax,%edx
  1008f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008f5:	01 d0                	add    %edx,%eax
  1008f7:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008fb:	3c a0                	cmp    $0xa0,%al
  1008fd:	74 c1                	je     1008c0 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  1008ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10090c:	c7 04 24 96 38 10 00 	movl   $0x103896,(%esp)
  100913:	e8 ba fa ff ff       	call   1003d2 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100918:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10091f:	00 
  100920:	c7 04 24 af 38 10 00 	movl   $0x1038af,(%esp)
  100927:	e8 a6 fa ff ff       	call   1003d2 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10092c:	c7 44 24 04 d1 37 10 	movl   $0x1037d1,0x4(%esp)
  100933:	00 
  100934:	c7 04 24 c7 38 10 00 	movl   $0x1038c7,(%esp)
  10093b:	e8 92 fa ff ff       	call   1003d2 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100940:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100947:	00 
  100948:	c7 04 24 df 38 10 00 	movl   $0x1038df,(%esp)
  10094f:	e8 7e fa ff ff       	call   1003d2 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100954:	c7 44 24 04 e0 fd 10 	movl   $0x10fde0,0x4(%esp)
  10095b:	00 
  10095c:	c7 04 24 f7 38 10 00 	movl   $0x1038f7,(%esp)
  100963:	e8 6a fa ff ff       	call   1003d2 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100968:	b8 e0 fd 10 00       	mov    $0x10fde0,%eax
  10096d:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100973:	b8 00 00 10 00       	mov    $0x100000,%eax
  100978:	29 c2                	sub    %eax,%edx
  10097a:	89 d0                	mov    %edx,%eax
  10097c:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100982:	85 c0                	test   %eax,%eax
  100984:	0f 48 c2             	cmovs  %edx,%eax
  100987:	c1 f8 0a             	sar    $0xa,%eax
  10098a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10098e:	c7 04 24 10 39 10 00 	movl   $0x103910,(%esp)
  100995:	e8 38 fa ff ff       	call   1003d2 <cprintf>
}
  10099a:	c9                   	leave  
  10099b:	c3                   	ret    

0010099c <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  10099c:	55                   	push   %ebp
  10099d:	89 e5                	mov    %esp,%ebp
  10099f:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009a5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1009af:	89 04 24             	mov    %eax,(%esp)
  1009b2:	e8 12 fc ff ff       	call   1005c9 <debuginfo_eip>
  1009b7:	85 c0                	test   %eax,%eax
  1009b9:	74 15                	je     1009d0 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1009be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c2:	c7 04 24 3a 39 10 00 	movl   $0x10393a,(%esp)
  1009c9:	e8 04 fa ff ff       	call   1003d2 <cprintf>
  1009ce:	eb 6d                	jmp    100a3d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009d7:	eb 1c                	jmp    1009f5 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009df:	01 d0                	add    %edx,%eax
  1009e1:	0f b6 00             	movzbl (%eax),%eax
  1009e4:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009ed:	01 ca                	add    %ecx,%edx
  1009ef:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1009f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009f8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1009fb:	7f dc                	jg     1009d9 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  1009fd:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a06:	01 d0                	add    %edx,%eax
  100a08:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100a0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a0e:	8b 55 08             	mov    0x8(%ebp),%edx
  100a11:	89 d1                	mov    %edx,%ecx
  100a13:	29 c1                	sub    %eax,%ecx
  100a15:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a1b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a1f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a25:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a29:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a31:	c7 04 24 56 39 10 00 	movl   $0x103956,(%esp)
  100a38:	e8 95 f9 ff ff       	call   1003d2 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  100a3d:	c9                   	leave  
  100a3e:	c3                   	ret    

00100a3f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a3f:	55                   	push   %ebp
  100a40:	89 e5                	mov    %esp,%ebp
  100a42:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a45:	8b 45 04             	mov    0x4(%ebp),%eax
  100a48:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a4e:	c9                   	leave  
  100a4f:	c3                   	ret    

00100a50 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a50:	55                   	push   %ebp
  100a51:	89 e5                	mov    %esp,%ebp
  100a53:	53                   	push   %ebx
  100a54:	83 ec 54             	sub    $0x54,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a57:	89 e8                	mov    %ebp,%eax
  100a59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  100a5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

    uint32_t ebp_val = read_ebp();
  100a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip_val = read_eip();
  100a62:	e8 d8 ff ff ff       	call   100a3f <read_eip>
  100a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i = 0;
  100a6a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for(i = 0; i < STACKFRAME_DEPTH && ebp_val != 0; i++){
  100a71:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a78:	e9 9d 00 00 00       	jmp    100b1a <print_stackframe+0xca>
        cprintf("ebp:0x%08x, eip:0x%08x", ebp_val, eip_val);  // 输出八位十六进制（即32位寄存器值）
  100a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a80:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a8b:	c7 04 24 68 39 10 00 	movl   $0x103968,(%esp)
  100a92:	e8 3b f9 ff ff       	call   1003d2 <cprintf>
        uint32_t* ebp_ptr = (uint32_t*)ebp_val;
  100a97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        uint32_t args[] = {*(ebp_ptr+2), *(ebp_ptr+3), *(ebp_ptr+4), *(ebp_ptr+5)};
  100a9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100aa0:	8b 40 08             	mov    0x8(%eax),%eax
  100aa3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100aa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100aa9:	8b 40 0c             	mov    0xc(%eax),%eax
  100aac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  100aaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100ab2:	8b 40 10             	mov    0x10(%eax),%eax
  100ab5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100ab8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100abb:	8b 40 14             	mov    0x14(%eax),%eax
  100abe:	89 45 e0             	mov    %eax,-0x20(%ebp)
        cprintf(" args:0x%08x 0x%08x 0x%08x 0x%08x", args[0], args[1], args[2], args[3]);
  100ac1:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  100ac4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  100ac7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  100aca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100acd:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100ad1:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100ad5:	89 54 24 08          	mov    %edx,0x8(%esp)
  100ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100add:	c7 04 24 80 39 10 00 	movl   $0x103980,(%esp)
  100ae4:	e8 e9 f8 ff ff       	call   1003d2 <cprintf>
        cprintf("\n");
  100ae9:	c7 04 24 a2 39 10 00 	movl   $0x1039a2,(%esp)
  100af0:	e8 dd f8 ff ff       	call   1003d2 <cprintf>
        print_debuginfo(eip_val - 1);
  100af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100af8:	83 e8 01             	sub    $0x1,%eax
  100afb:	89 04 24             	mov    %eax,(%esp)
  100afe:	e8 99 fe ff ff       	call   10099c <print_debuginfo>
        eip_val = *(uint32_t*)(ebp_val + 4);
  100b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b06:	83 c0 04             	add    $0x4,%eax
  100b09:	8b 00                	mov    (%eax),%eax
  100b0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp_val = *(uint32_t*)ebp_val;
  100b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b11:	8b 00                	mov    (%eax),%eax
  100b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
      */

    uint32_t ebp_val = read_ebp();
    uint32_t eip_val = read_eip();
    int i = 0;
    for(i = 0; i < STACKFRAME_DEPTH && ebp_val != 0; i++){
  100b16:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100b1a:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b1e:	7f 0a                	jg     100b2a <print_stackframe+0xda>
  100b20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b24:	0f 85 53 ff ff ff    	jne    100a7d <print_stackframe+0x2d>
        cprintf("\n");
        print_debuginfo(eip_val - 1);
        eip_val = *(uint32_t*)(ebp_val + 4);
        ebp_val = *(uint32_t*)ebp_val;
    }
}
  100b2a:	83 c4 54             	add    $0x54,%esp
  100b2d:	5b                   	pop    %ebx
  100b2e:	5d                   	pop    %ebp
  100b2f:	c3                   	ret    

00100b30 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b30:	55                   	push   %ebp
  100b31:	89 e5                	mov    %esp,%ebp
  100b33:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b3d:	eb 0c                	jmp    100b4b <parse+0x1b>
            *buf ++ = '\0';
  100b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b42:	8d 50 01             	lea    0x1(%eax),%edx
  100b45:	89 55 08             	mov    %edx,0x8(%ebp)
  100b48:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4e:	0f b6 00             	movzbl (%eax),%eax
  100b51:	84 c0                	test   %al,%al
  100b53:	74 1d                	je     100b72 <parse+0x42>
  100b55:	8b 45 08             	mov    0x8(%ebp),%eax
  100b58:	0f b6 00             	movzbl (%eax),%eax
  100b5b:	0f be c0             	movsbl %al,%eax
  100b5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b62:	c7 04 24 24 3a 10 00 	movl   $0x103a24,(%esp)
  100b69:	e8 1b 29 00 00       	call   103489 <strchr>
  100b6e:	85 c0                	test   %eax,%eax
  100b70:	75 cd                	jne    100b3f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100b72:	8b 45 08             	mov    0x8(%ebp),%eax
  100b75:	0f b6 00             	movzbl (%eax),%eax
  100b78:	84 c0                	test   %al,%al
  100b7a:	75 02                	jne    100b7e <parse+0x4e>
            break;
  100b7c:	eb 67                	jmp    100be5 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b7e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b82:	75 14                	jne    100b98 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b84:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b8b:	00 
  100b8c:	c7 04 24 29 3a 10 00 	movl   $0x103a29,(%esp)
  100b93:	e8 3a f8 ff ff       	call   1003d2 <cprintf>
        }
        argv[argc ++] = buf;
  100b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b9b:	8d 50 01             	lea    0x1(%eax),%edx
  100b9e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ba1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ba8:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bab:	01 c2                	add    %eax,%edx
  100bad:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb0:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bb2:	eb 04                	jmp    100bb8 <parse+0x88>
            buf ++;
  100bb4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  100bbb:	0f b6 00             	movzbl (%eax),%eax
  100bbe:	84 c0                	test   %al,%al
  100bc0:	74 1d                	je     100bdf <parse+0xaf>
  100bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc5:	0f b6 00             	movzbl (%eax),%eax
  100bc8:	0f be c0             	movsbl %al,%eax
  100bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bcf:	c7 04 24 24 3a 10 00 	movl   $0x103a24,(%esp)
  100bd6:	e8 ae 28 00 00       	call   103489 <strchr>
  100bdb:	85 c0                	test   %eax,%eax
  100bdd:	74 d5                	je     100bb4 <parse+0x84>
            buf ++;
        }
    }
  100bdf:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100be0:	e9 66 ff ff ff       	jmp    100b4b <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100be8:	c9                   	leave  
  100be9:	c3                   	ret    

00100bea <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bea:	55                   	push   %ebp
  100beb:	89 e5                	mov    %esp,%ebp
  100bed:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bf0:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  100bfa:	89 04 24             	mov    %eax,(%esp)
  100bfd:	e8 2e ff ff ff       	call   100b30 <parse>
  100c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c09:	75 0a                	jne    100c15 <runcmd+0x2b>
        return 0;
  100c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  100c10:	e9 85 00 00 00       	jmp    100c9a <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c1c:	eb 5c                	jmp    100c7a <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c1e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c24:	89 d0                	mov    %edx,%eax
  100c26:	01 c0                	add    %eax,%eax
  100c28:	01 d0                	add    %edx,%eax
  100c2a:	c1 e0 02             	shl    $0x2,%eax
  100c2d:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c32:	8b 00                	mov    (%eax),%eax
  100c34:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c38:	89 04 24             	mov    %eax,(%esp)
  100c3b:	e8 aa 27 00 00       	call   1033ea <strcmp>
  100c40:	85 c0                	test   %eax,%eax
  100c42:	75 32                	jne    100c76 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c47:	89 d0                	mov    %edx,%eax
  100c49:	01 c0                	add    %eax,%eax
  100c4b:	01 d0                	add    %edx,%eax
  100c4d:	c1 e0 02             	shl    $0x2,%eax
  100c50:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c55:	8b 40 08             	mov    0x8(%eax),%eax
  100c58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100c5b:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  100c61:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c65:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100c68:	83 c2 04             	add    $0x4,%edx
  100c6b:	89 54 24 04          	mov    %edx,0x4(%esp)
  100c6f:	89 0c 24             	mov    %ecx,(%esp)
  100c72:	ff d0                	call   *%eax
  100c74:	eb 24                	jmp    100c9a <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c76:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c7d:	83 f8 02             	cmp    $0x2,%eax
  100c80:	76 9c                	jbe    100c1e <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c82:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c85:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c89:	c7 04 24 47 3a 10 00 	movl   $0x103a47,(%esp)
  100c90:	e8 3d f7 ff ff       	call   1003d2 <cprintf>
    return 0;
  100c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9a:	c9                   	leave  
  100c9b:	c3                   	ret    

00100c9c <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c9c:	55                   	push   %ebp
  100c9d:	89 e5                	mov    %esp,%ebp
  100c9f:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100ca2:	c7 04 24 60 3a 10 00 	movl   $0x103a60,(%esp)
  100ca9:	e8 24 f7 ff ff       	call   1003d2 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cae:	c7 04 24 88 3a 10 00 	movl   $0x103a88,(%esp)
  100cb5:	e8 18 f7 ff ff       	call   1003d2 <cprintf>

    if (tf != NULL) {
  100cba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cbe:	74 0b                	je     100ccb <kmonitor+0x2f>
        print_trapframe(tf);
  100cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  100cc3:	89 04 24             	mov    %eax,(%esp)
  100cc6:	e8 63 0e 00 00       	call   101b2e <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100ccb:	c7 04 24 ad 3a 10 00 	movl   $0x103aad,(%esp)
  100cd2:	e8 f2 f5 ff ff       	call   1002c9 <readline>
  100cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cde:	74 18                	je     100cf8 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  100ce3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cea:	89 04 24             	mov    %eax,(%esp)
  100ced:	e8 f8 fe ff ff       	call   100bea <runcmd>
  100cf2:	85 c0                	test   %eax,%eax
  100cf4:	79 02                	jns    100cf8 <kmonitor+0x5c>
                break;
  100cf6:	eb 02                	jmp    100cfa <kmonitor+0x5e>
            }
        }
    }
  100cf8:	eb d1                	jmp    100ccb <kmonitor+0x2f>
}
  100cfa:	c9                   	leave  
  100cfb:	c3                   	ret    

00100cfc <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cfc:	55                   	push   %ebp
  100cfd:	89 e5                	mov    %esp,%ebp
  100cff:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d09:	eb 3f                	jmp    100d4a <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d0e:	89 d0                	mov    %edx,%eax
  100d10:	01 c0                	add    %eax,%eax
  100d12:	01 d0                	add    %edx,%eax
  100d14:	c1 e0 02             	shl    $0x2,%eax
  100d17:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d1c:	8b 48 04             	mov    0x4(%eax),%ecx
  100d1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d22:	89 d0                	mov    %edx,%eax
  100d24:	01 c0                	add    %eax,%eax
  100d26:	01 d0                	add    %edx,%eax
  100d28:	c1 e0 02             	shl    $0x2,%eax
  100d2b:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d30:	8b 00                	mov    (%eax),%eax
  100d32:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d36:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d3a:	c7 04 24 b1 3a 10 00 	movl   $0x103ab1,(%esp)
  100d41:	e8 8c f6 ff ff       	call   1003d2 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d46:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d4d:	83 f8 02             	cmp    $0x2,%eax
  100d50:	76 b9                	jbe    100d0b <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100d52:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d57:	c9                   	leave  
  100d58:	c3                   	ret    

00100d59 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d59:	55                   	push   %ebp
  100d5a:	89 e5                	mov    %esp,%ebp
  100d5c:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d5f:	e8 a2 fb ff ff       	call   100906 <print_kerninfo>
    return 0;
  100d64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d69:	c9                   	leave  
  100d6a:	c3                   	ret    

00100d6b <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d6b:	55                   	push   %ebp
  100d6c:	89 e5                	mov    %esp,%ebp
  100d6e:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d71:	e8 da fc ff ff       	call   100a50 <print_stackframe>
    return 0;
  100d76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d7b:	c9                   	leave  
  100d7c:	c3                   	ret    

00100d7d <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100d7d:	55                   	push   %ebp
  100d7e:	89 e5                	mov    %esp,%ebp
  100d80:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100d83:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100d88:	85 c0                	test   %eax,%eax
  100d8a:	74 02                	je     100d8e <__panic+0x11>
        goto panic_dead;
  100d8c:	eb 59                	jmp    100de7 <__panic+0x6a>
    }
    is_panic = 1;
  100d8e:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100d95:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100d98:	8d 45 14             	lea    0x14(%ebp),%eax
  100d9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100da1:	89 44 24 08          	mov    %eax,0x8(%esp)
  100da5:	8b 45 08             	mov    0x8(%ebp),%eax
  100da8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100dac:	c7 04 24 ba 3a 10 00 	movl   $0x103aba,(%esp)
  100db3:	e8 1a f6 ff ff       	call   1003d2 <cprintf>
    vcprintf(fmt, ap);
  100db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100dbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100dbf:	8b 45 10             	mov    0x10(%ebp),%eax
  100dc2:	89 04 24             	mov    %eax,(%esp)
  100dc5:	e8 d5 f5 ff ff       	call   10039f <vcprintf>
    cprintf("\n");
  100dca:	c7 04 24 d6 3a 10 00 	movl   $0x103ad6,(%esp)
  100dd1:	e8 fc f5 ff ff       	call   1003d2 <cprintf>
    
    cprintf("stack trackback:\n");
  100dd6:	c7 04 24 d8 3a 10 00 	movl   $0x103ad8,(%esp)
  100ddd:	e8 f0 f5 ff ff       	call   1003d2 <cprintf>
    print_stackframe();
  100de2:	e8 69 fc ff ff       	call   100a50 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100de7:	e8 22 09 00 00       	call   10170e <intr_disable>
    while (1) {
        kmonitor(NULL);
  100dec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100df3:	e8 a4 fe ff ff       	call   100c9c <kmonitor>
    }
  100df8:	eb f2                	jmp    100dec <__panic+0x6f>

00100dfa <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100dfa:	55                   	push   %ebp
  100dfb:	89 e5                	mov    %esp,%ebp
  100dfd:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100e00:	8d 45 14             	lea    0x14(%ebp),%eax
  100e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  100e09:	89 44 24 08          	mov    %eax,0x8(%esp)
  100e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  100e10:	89 44 24 04          	mov    %eax,0x4(%esp)
  100e14:	c7 04 24 ea 3a 10 00 	movl   $0x103aea,(%esp)
  100e1b:	e8 b2 f5 ff ff       	call   1003d2 <cprintf>
    vcprintf(fmt, ap);
  100e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e23:	89 44 24 04          	mov    %eax,0x4(%esp)
  100e27:	8b 45 10             	mov    0x10(%ebp),%eax
  100e2a:	89 04 24             	mov    %eax,(%esp)
  100e2d:	e8 6d f5 ff ff       	call   10039f <vcprintf>
    cprintf("\n");
  100e32:	c7 04 24 d6 3a 10 00 	movl   $0x103ad6,(%esp)
  100e39:	e8 94 f5 ff ff       	call   1003d2 <cprintf>
    va_end(ap);
}
  100e3e:	c9                   	leave  
  100e3f:	c3                   	ret    

00100e40 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100e40:	55                   	push   %ebp
  100e41:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100e43:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100e48:	5d                   	pop    %ebp
  100e49:	c3                   	ret    

00100e4a <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100e4a:	55                   	push   %ebp
  100e4b:	89 e5                	mov    %esp,%ebp
  100e4d:	83 ec 28             	sub    $0x28,%esp
  100e50:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100e56:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e5a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e5e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e62:	ee                   	out    %al,(%dx)
  100e63:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100e69:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100e6d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e71:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e75:	ee                   	out    %al,(%dx)
  100e76:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100e7c:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100e80:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e84:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e88:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e89:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100e90:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e93:	c7 04 24 08 3b 10 00 	movl   $0x103b08,(%esp)
  100e9a:	e8 33 f5 ff ff       	call   1003d2 <cprintf>
    pic_enable(IRQ_TIMER);
  100e9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100ea6:	e8 c1 08 00 00       	call   10176c <pic_enable>
}
  100eab:	c9                   	leave  
  100eac:	c3                   	ret    

00100ead <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100ead:	55                   	push   %ebp
  100eae:	89 e5                	mov    %esp,%ebp
  100eb0:	83 ec 10             	sub    $0x10,%esp
  100eb3:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eb9:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100ebd:	89 c2                	mov    %eax,%edx
  100ebf:	ec                   	in     (%dx),%al
  100ec0:	88 45 fd             	mov    %al,-0x3(%ebp)
  100ec3:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100ec9:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ecd:	89 c2                	mov    %eax,%edx
  100ecf:	ec                   	in     (%dx),%al
  100ed0:	88 45 f9             	mov    %al,-0x7(%ebp)
  100ed3:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100ed9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100edd:	89 c2                	mov    %eax,%edx
  100edf:	ec                   	in     (%dx),%al
  100ee0:	88 45 f5             	mov    %al,-0xb(%ebp)
  100ee3:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100ee9:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eed:	89 c2                	mov    %eax,%edx
  100eef:	ec                   	in     (%dx),%al
  100ef0:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100ef3:	c9                   	leave  
  100ef4:	c3                   	ret    

00100ef5 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100ef5:	55                   	push   %ebp
  100ef6:	89 e5                	mov    %esp,%ebp
  100ef8:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100efb:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100f02:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f05:	0f b7 00             	movzwl (%eax),%eax
  100f08:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f0f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100f14:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f17:	0f b7 00             	movzwl (%eax),%eax
  100f1a:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100f1e:	74 12                	je     100f32 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100f20:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100f27:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100f2e:	b4 03 
  100f30:	eb 13                	jmp    100f45 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100f32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f35:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100f39:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100f3c:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100f43:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100f45:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100f4c:	0f b7 c0             	movzwl %ax,%eax
  100f4f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100f53:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f57:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f5b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f5f:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100f60:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100f67:	83 c0 01             	add    $0x1,%eax
  100f6a:	0f b7 c0             	movzwl %ax,%eax
  100f6d:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f71:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f75:	89 c2                	mov    %eax,%edx
  100f77:	ec                   	in     (%dx),%al
  100f78:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f7b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f7f:	0f b6 c0             	movzbl %al,%eax
  100f82:	c1 e0 08             	shl    $0x8,%eax
  100f85:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f88:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100f8f:	0f b7 c0             	movzwl %ax,%eax
  100f92:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f96:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f9a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f9e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa2:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100fa3:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100faa:	83 c0 01             	add    $0x1,%eax
  100fad:	0f b7 c0             	movzwl %ax,%eax
  100fb0:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fb4:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100fb8:	89 c2                	mov    %eax,%edx
  100fba:	ec                   	in     (%dx),%al
  100fbb:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100fbe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fc2:	0f b6 c0             	movzbl %al,%eax
  100fc5:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100fc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fcb:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100fd3:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100fd9:	c9                   	leave  
  100fda:	c3                   	ret    

00100fdb <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100fdb:	55                   	push   %ebp
  100fdc:	89 e5                	mov    %esp,%ebp
  100fde:	83 ec 48             	sub    $0x48,%esp
  100fe1:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100fe7:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100feb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100fef:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ff3:	ee                   	out    %al,(%dx)
  100ff4:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100ffa:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100ffe:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101002:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101006:	ee                   	out    %al,(%dx)
  101007:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  10100d:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  101011:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101015:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101019:	ee                   	out    %al,(%dx)
  10101a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  101020:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  101024:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101028:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10102c:	ee                   	out    %al,(%dx)
  10102d:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  101033:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  101037:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10103b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10103f:	ee                   	out    %al,(%dx)
  101040:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  101046:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  10104a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10104e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101052:	ee                   	out    %al,(%dx)
  101053:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  101059:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  10105d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101061:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101065:	ee                   	out    %al,(%dx)
  101066:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10106c:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  101070:	89 c2                	mov    %eax,%edx
  101072:	ec                   	in     (%dx),%al
  101073:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  101076:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10107a:	3c ff                	cmp    $0xff,%al
  10107c:	0f 95 c0             	setne  %al
  10107f:	0f b6 c0             	movzbl %al,%eax
  101082:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  101087:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10108d:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101091:	89 c2                	mov    %eax,%edx
  101093:	ec                   	in     (%dx),%al
  101094:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101097:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  10109d:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  1010a1:	89 c2                	mov    %eax,%edx
  1010a3:	ec                   	in     (%dx),%al
  1010a4:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  1010a7:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1010ac:	85 c0                	test   %eax,%eax
  1010ae:	74 0c                	je     1010bc <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  1010b0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1010b7:	e8 b0 06 00 00       	call   10176c <pic_enable>
    }
}
  1010bc:	c9                   	leave  
  1010bd:	c3                   	ret    

001010be <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  1010be:	55                   	push   %ebp
  1010bf:	89 e5                	mov    %esp,%ebp
  1010c1:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1010cb:	eb 09                	jmp    1010d6 <lpt_putc_sub+0x18>
        delay();
  1010cd:	e8 db fd ff ff       	call   100ead <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010d2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1010d6:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1010dc:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010e0:	89 c2                	mov    %eax,%edx
  1010e2:	ec                   	in     (%dx),%al
  1010e3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010e6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010ea:	84 c0                	test   %al,%al
  1010ec:	78 09                	js     1010f7 <lpt_putc_sub+0x39>
  1010ee:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010f5:	7e d6                	jle    1010cd <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  1010f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fa:	0f b6 c0             	movzbl %al,%eax
  1010fd:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101103:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101106:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10110a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10110e:	ee                   	out    %al,(%dx)
  10110f:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101115:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101119:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10111d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101121:	ee                   	out    %al,(%dx)
  101122:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101128:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10112c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101130:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101134:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101135:	c9                   	leave  
  101136:	c3                   	ret    

00101137 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101137:	55                   	push   %ebp
  101138:	89 e5                	mov    %esp,%ebp
  10113a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10113d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101141:	74 0d                	je     101150 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101143:	8b 45 08             	mov    0x8(%ebp),%eax
  101146:	89 04 24             	mov    %eax,(%esp)
  101149:	e8 70 ff ff ff       	call   1010be <lpt_putc_sub>
  10114e:	eb 24                	jmp    101174 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101150:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101157:	e8 62 ff ff ff       	call   1010be <lpt_putc_sub>
        lpt_putc_sub(' ');
  10115c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101163:	e8 56 ff ff ff       	call   1010be <lpt_putc_sub>
        lpt_putc_sub('\b');
  101168:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10116f:	e8 4a ff ff ff       	call   1010be <lpt_putc_sub>
    }
}
  101174:	c9                   	leave  
  101175:	c3                   	ret    

00101176 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101176:	55                   	push   %ebp
  101177:	89 e5                	mov    %esp,%ebp
  101179:	53                   	push   %ebx
  10117a:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10117d:	8b 45 08             	mov    0x8(%ebp),%eax
  101180:	b0 00                	mov    $0x0,%al
  101182:	85 c0                	test   %eax,%eax
  101184:	75 07                	jne    10118d <cga_putc+0x17>
        c |= 0x0700;
  101186:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10118d:	8b 45 08             	mov    0x8(%ebp),%eax
  101190:	0f b6 c0             	movzbl %al,%eax
  101193:	83 f8 0a             	cmp    $0xa,%eax
  101196:	74 4c                	je     1011e4 <cga_putc+0x6e>
  101198:	83 f8 0d             	cmp    $0xd,%eax
  10119b:	74 57                	je     1011f4 <cga_putc+0x7e>
  10119d:	83 f8 08             	cmp    $0x8,%eax
  1011a0:	0f 85 88 00 00 00    	jne    10122e <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1011a6:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011ad:	66 85 c0             	test   %ax,%ax
  1011b0:	74 30                	je     1011e2 <cga_putc+0x6c>
            crt_pos --;
  1011b2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011b9:	83 e8 01             	sub    $0x1,%eax
  1011bc:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011c2:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011c7:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1011ce:	0f b7 d2             	movzwl %dx,%edx
  1011d1:	01 d2                	add    %edx,%edx
  1011d3:	01 c2                	add    %eax,%edx
  1011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1011d8:	b0 00                	mov    $0x0,%al
  1011da:	83 c8 20             	or     $0x20,%eax
  1011dd:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011e0:	eb 72                	jmp    101254 <cga_putc+0xde>
  1011e2:	eb 70                	jmp    101254 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1011e4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011eb:	83 c0 50             	add    $0x50,%eax
  1011ee:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011f4:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1011fb:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101202:	0f b7 c1             	movzwl %cx,%eax
  101205:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10120b:	c1 e8 10             	shr    $0x10,%eax
  10120e:	89 c2                	mov    %eax,%edx
  101210:	66 c1 ea 06          	shr    $0x6,%dx
  101214:	89 d0                	mov    %edx,%eax
  101216:	c1 e0 02             	shl    $0x2,%eax
  101219:	01 d0                	add    %edx,%eax
  10121b:	c1 e0 04             	shl    $0x4,%eax
  10121e:	29 c1                	sub    %eax,%ecx
  101220:	89 ca                	mov    %ecx,%edx
  101222:	89 d8                	mov    %ebx,%eax
  101224:	29 d0                	sub    %edx,%eax
  101226:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10122c:	eb 26                	jmp    101254 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10122e:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101234:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10123b:	8d 50 01             	lea    0x1(%eax),%edx
  10123e:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101245:	0f b7 c0             	movzwl %ax,%eax
  101248:	01 c0                	add    %eax,%eax
  10124a:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10124d:	8b 45 08             	mov    0x8(%ebp),%eax
  101250:	66 89 02             	mov    %ax,(%edx)
        break;
  101253:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101254:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10125b:	66 3d cf 07          	cmp    $0x7cf,%ax
  10125f:	76 5b                	jbe    1012bc <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101261:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101266:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10126c:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101271:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101278:	00 
  101279:	89 54 24 04          	mov    %edx,0x4(%esp)
  10127d:	89 04 24             	mov    %eax,(%esp)
  101280:	e8 02 24 00 00       	call   103687 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101285:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10128c:	eb 15                	jmp    1012a3 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10128e:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101296:	01 d2                	add    %edx,%edx
  101298:	01 d0                	add    %edx,%eax
  10129a:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10129f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1012a3:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1012aa:	7e e2                	jle    10128e <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1012ac:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1012b3:	83 e8 50             	sub    $0x50,%eax
  1012b6:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012bc:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1012c3:	0f b7 c0             	movzwl %ax,%eax
  1012c6:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1012ca:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1012ce:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012d2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012d6:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1012d7:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1012de:	66 c1 e8 08          	shr    $0x8,%ax
  1012e2:	0f b6 c0             	movzbl %al,%eax
  1012e5:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1012ec:	83 c2 01             	add    $0x1,%edx
  1012ef:	0f b7 d2             	movzwl %dx,%edx
  1012f2:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1012f6:	88 45 ed             	mov    %al,-0x13(%ebp)
  1012f9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012fd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101301:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101302:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101309:	0f b7 c0             	movzwl %ax,%eax
  10130c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101310:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101314:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101318:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10131c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10131d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101324:	0f b6 c0             	movzbl %al,%eax
  101327:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10132e:	83 c2 01             	add    $0x1,%edx
  101331:	0f b7 d2             	movzwl %dx,%edx
  101334:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101338:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10133b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10133f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101343:	ee                   	out    %al,(%dx)
}
  101344:	83 c4 34             	add    $0x34,%esp
  101347:	5b                   	pop    %ebx
  101348:	5d                   	pop    %ebp
  101349:	c3                   	ret    

0010134a <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10134a:	55                   	push   %ebp
  10134b:	89 e5                	mov    %esp,%ebp
  10134d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101350:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101357:	eb 09                	jmp    101362 <serial_putc_sub+0x18>
        delay();
  101359:	e8 4f fb ff ff       	call   100ead <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10135e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101362:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101368:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10136c:	89 c2                	mov    %eax,%edx
  10136e:	ec                   	in     (%dx),%al
  10136f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101372:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101376:	0f b6 c0             	movzbl %al,%eax
  101379:	83 e0 20             	and    $0x20,%eax
  10137c:	85 c0                	test   %eax,%eax
  10137e:	75 09                	jne    101389 <serial_putc_sub+0x3f>
  101380:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101387:	7e d0                	jle    101359 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101389:	8b 45 08             	mov    0x8(%ebp),%eax
  10138c:	0f b6 c0             	movzbl %al,%eax
  10138f:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101395:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101398:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10139c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1013a0:	ee                   	out    %al,(%dx)
}
  1013a1:	c9                   	leave  
  1013a2:	c3                   	ret    

001013a3 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1013a3:	55                   	push   %ebp
  1013a4:	89 e5                	mov    %esp,%ebp
  1013a6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1013a9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013ad:	74 0d                	je     1013bc <serial_putc+0x19>
        serial_putc_sub(c);
  1013af:	8b 45 08             	mov    0x8(%ebp),%eax
  1013b2:	89 04 24             	mov    %eax,(%esp)
  1013b5:	e8 90 ff ff ff       	call   10134a <serial_putc_sub>
  1013ba:	eb 24                	jmp    1013e0 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1013bc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013c3:	e8 82 ff ff ff       	call   10134a <serial_putc_sub>
        serial_putc_sub(' ');
  1013c8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013cf:	e8 76 ff ff ff       	call   10134a <serial_putc_sub>
        serial_putc_sub('\b');
  1013d4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013db:	e8 6a ff ff ff       	call   10134a <serial_putc_sub>
    }
}
  1013e0:	c9                   	leave  
  1013e1:	c3                   	ret    

001013e2 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013e2:	55                   	push   %ebp
  1013e3:	89 e5                	mov    %esp,%ebp
  1013e5:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013e8:	eb 33                	jmp    10141d <cons_intr+0x3b>
        if (c != 0) {
  1013ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013ee:	74 2d                	je     10141d <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1013f0:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1013f5:	8d 50 01             	lea    0x1(%eax),%edx
  1013f8:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  1013fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101401:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101407:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10140c:	3d 00 02 00 00       	cmp    $0x200,%eax
  101411:	75 0a                	jne    10141d <cons_intr+0x3b>
                cons.wpos = 0;
  101413:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10141a:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10141d:	8b 45 08             	mov    0x8(%ebp),%eax
  101420:	ff d0                	call   *%eax
  101422:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101425:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101429:	75 bf                	jne    1013ea <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10142b:	c9                   	leave  
  10142c:	c3                   	ret    

0010142d <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10142d:	55                   	push   %ebp
  10142e:	89 e5                	mov    %esp,%ebp
  101430:	83 ec 10             	sub    $0x10,%esp
  101433:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101439:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10143d:	89 c2                	mov    %eax,%edx
  10143f:	ec                   	in     (%dx),%al
  101440:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101443:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101447:	0f b6 c0             	movzbl %al,%eax
  10144a:	83 e0 01             	and    $0x1,%eax
  10144d:	85 c0                	test   %eax,%eax
  10144f:	75 07                	jne    101458 <serial_proc_data+0x2b>
        return -1;
  101451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101456:	eb 2a                	jmp    101482 <serial_proc_data+0x55>
  101458:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10145e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101462:	89 c2                	mov    %eax,%edx
  101464:	ec                   	in     (%dx),%al
  101465:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101468:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10146c:	0f b6 c0             	movzbl %al,%eax
  10146f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101472:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101476:	75 07                	jne    10147f <serial_proc_data+0x52>
        c = '\b';
  101478:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10147f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101482:	c9                   	leave  
  101483:	c3                   	ret    

00101484 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101484:	55                   	push   %ebp
  101485:	89 e5                	mov    %esp,%ebp
  101487:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10148a:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  10148f:	85 c0                	test   %eax,%eax
  101491:	74 0c                	je     10149f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101493:	c7 04 24 2d 14 10 00 	movl   $0x10142d,(%esp)
  10149a:	e8 43 ff ff ff       	call   1013e2 <cons_intr>
    }
}
  10149f:	c9                   	leave  
  1014a0:	c3                   	ret    

001014a1 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014a1:	55                   	push   %ebp
  1014a2:	89 e5                	mov    %esp,%ebp
  1014a4:	83 ec 38             	sub    $0x38,%esp
  1014a7:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014ad:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1014b1:	89 c2                	mov    %eax,%edx
  1014b3:	ec                   	in     (%dx),%al
  1014b4:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014bb:	0f b6 c0             	movzbl %al,%eax
  1014be:	83 e0 01             	and    $0x1,%eax
  1014c1:	85 c0                	test   %eax,%eax
  1014c3:	75 0a                	jne    1014cf <kbd_proc_data+0x2e>
        return -1;
  1014c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014ca:	e9 59 01 00 00       	jmp    101628 <kbd_proc_data+0x187>
  1014cf:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014d5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1014d9:	89 c2                	mov    %eax,%edx
  1014db:	ec                   	in     (%dx),%al
  1014dc:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014df:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014e3:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014e6:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014ea:	75 17                	jne    101503 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1014ec:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014f1:	83 c8 40             	or     $0x40,%eax
  1014f4:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1014f9:	b8 00 00 00 00       	mov    $0x0,%eax
  1014fe:	e9 25 01 00 00       	jmp    101628 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101503:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101507:	84 c0                	test   %al,%al
  101509:	79 47                	jns    101552 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10150b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101510:	83 e0 40             	and    $0x40,%eax
  101513:	85 c0                	test   %eax,%eax
  101515:	75 09                	jne    101520 <kbd_proc_data+0x7f>
  101517:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10151b:	83 e0 7f             	and    $0x7f,%eax
  10151e:	eb 04                	jmp    101524 <kbd_proc_data+0x83>
  101520:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101524:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101527:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152b:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101532:	83 c8 40             	or     $0x40,%eax
  101535:	0f b6 c0             	movzbl %al,%eax
  101538:	f7 d0                	not    %eax
  10153a:	89 c2                	mov    %eax,%edx
  10153c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101541:	21 d0                	and    %edx,%eax
  101543:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101548:	b8 00 00 00 00       	mov    $0x0,%eax
  10154d:	e9 d6 00 00 00       	jmp    101628 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101552:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101557:	83 e0 40             	and    $0x40,%eax
  10155a:	85 c0                	test   %eax,%eax
  10155c:	74 11                	je     10156f <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10155e:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101562:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101567:	83 e0 bf             	and    $0xffffffbf,%eax
  10156a:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10156f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101573:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10157a:	0f b6 d0             	movzbl %al,%edx
  10157d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101582:	09 d0                	or     %edx,%eax
  101584:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  101589:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10158d:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  101594:	0f b6 d0             	movzbl %al,%edx
  101597:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10159c:	31 d0                	xor    %edx,%eax
  10159e:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1015a3:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1015a8:	83 e0 03             	and    $0x3,%eax
  1015ab:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1015b2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015b6:	01 d0                	add    %edx,%eax
  1015b8:	0f b6 00             	movzbl (%eax),%eax
  1015bb:	0f b6 c0             	movzbl %al,%eax
  1015be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015c1:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1015c6:	83 e0 08             	and    $0x8,%eax
  1015c9:	85 c0                	test   %eax,%eax
  1015cb:	74 22                	je     1015ef <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1015cd:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015d1:	7e 0c                	jle    1015df <kbd_proc_data+0x13e>
  1015d3:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015d7:	7f 06                	jg     1015df <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1015d9:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015dd:	eb 10                	jmp    1015ef <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1015df:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015e3:	7e 0a                	jle    1015ef <kbd_proc_data+0x14e>
  1015e5:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015e9:	7f 04                	jg     1015ef <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1015eb:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015ef:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1015f4:	f7 d0                	not    %eax
  1015f6:	83 e0 06             	and    $0x6,%eax
  1015f9:	85 c0                	test   %eax,%eax
  1015fb:	75 28                	jne    101625 <kbd_proc_data+0x184>
  1015fd:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101604:	75 1f                	jne    101625 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101606:	c7 04 24 23 3b 10 00 	movl   $0x103b23,(%esp)
  10160d:	e8 c0 ed ff ff       	call   1003d2 <cprintf>
  101612:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101618:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10161c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101620:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101624:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101625:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101628:	c9                   	leave  
  101629:	c3                   	ret    

0010162a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10162a:	55                   	push   %ebp
  10162b:	89 e5                	mov    %esp,%ebp
  10162d:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101630:	c7 04 24 a1 14 10 00 	movl   $0x1014a1,(%esp)
  101637:	e8 a6 fd ff ff       	call   1013e2 <cons_intr>
}
  10163c:	c9                   	leave  
  10163d:	c3                   	ret    

0010163e <kbd_init>:

static void
kbd_init(void) {
  10163e:	55                   	push   %ebp
  10163f:	89 e5                	mov    %esp,%ebp
  101641:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101644:	e8 e1 ff ff ff       	call   10162a <kbd_intr>
    pic_enable(IRQ_KBD);
  101649:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101650:	e8 17 01 00 00       	call   10176c <pic_enable>
}
  101655:	c9                   	leave  
  101656:	c3                   	ret    

00101657 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101657:	55                   	push   %ebp
  101658:	89 e5                	mov    %esp,%ebp
  10165a:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10165d:	e8 93 f8 ff ff       	call   100ef5 <cga_init>
    serial_init();
  101662:	e8 74 f9 ff ff       	call   100fdb <serial_init>
    kbd_init();
  101667:	e8 d2 ff ff ff       	call   10163e <kbd_init>
    if (!serial_exists) {
  10166c:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101671:	85 c0                	test   %eax,%eax
  101673:	75 0c                	jne    101681 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101675:	c7 04 24 2f 3b 10 00 	movl   $0x103b2f,(%esp)
  10167c:	e8 51 ed ff ff       	call   1003d2 <cprintf>
    }
}
  101681:	c9                   	leave  
  101682:	c3                   	ret    

00101683 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101683:	55                   	push   %ebp
  101684:	89 e5                	mov    %esp,%ebp
  101686:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  101689:	8b 45 08             	mov    0x8(%ebp),%eax
  10168c:	89 04 24             	mov    %eax,(%esp)
  10168f:	e8 a3 fa ff ff       	call   101137 <lpt_putc>
    cga_putc(c);
  101694:	8b 45 08             	mov    0x8(%ebp),%eax
  101697:	89 04 24             	mov    %eax,(%esp)
  10169a:	e8 d7 fa ff ff       	call   101176 <cga_putc>
    serial_putc(c);
  10169f:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a2:	89 04 24             	mov    %eax,(%esp)
  1016a5:	e8 f9 fc ff ff       	call   1013a3 <serial_putc>
}
  1016aa:	c9                   	leave  
  1016ab:	c3                   	ret    

001016ac <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016ac:	55                   	push   %ebp
  1016ad:	89 e5                	mov    %esp,%ebp
  1016af:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1016b2:	e8 cd fd ff ff       	call   101484 <serial_intr>
    kbd_intr();
  1016b7:	e8 6e ff ff ff       	call   10162a <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1016bc:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1016c2:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1016c7:	39 c2                	cmp    %eax,%edx
  1016c9:	74 36                	je     101701 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1016cb:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1016d0:	8d 50 01             	lea    0x1(%eax),%edx
  1016d3:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1016d9:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1016e0:	0f b6 c0             	movzbl %al,%eax
  1016e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1016e6:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1016eb:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016f0:	75 0a                	jne    1016fc <cons_getc+0x50>
            cons.rpos = 0;
  1016f2:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  1016f9:	00 00 00 
        }
        return c;
  1016fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016ff:	eb 05                	jmp    101706 <cons_getc+0x5a>
    }
    return 0;
  101701:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101706:	c9                   	leave  
  101707:	c3                   	ret    

00101708 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101708:	55                   	push   %ebp
  101709:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10170b:	fb                   	sti    
    sti();
}
  10170c:	5d                   	pop    %ebp
  10170d:	c3                   	ret    

0010170e <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10170e:	55                   	push   %ebp
  10170f:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101711:	fa                   	cli    
    cli();
}
  101712:	5d                   	pop    %ebp
  101713:	c3                   	ret    

00101714 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101714:	55                   	push   %ebp
  101715:	89 e5                	mov    %esp,%ebp
  101717:	83 ec 14             	sub    $0x14,%esp
  10171a:	8b 45 08             	mov    0x8(%ebp),%eax
  10171d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101721:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101725:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10172b:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101730:	85 c0                	test   %eax,%eax
  101732:	74 36                	je     10176a <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101734:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101738:	0f b6 c0             	movzbl %al,%eax
  10173b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101741:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101744:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101748:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10174c:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10174d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101751:	66 c1 e8 08          	shr    $0x8,%ax
  101755:	0f b6 c0             	movzbl %al,%eax
  101758:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10175e:	88 45 f9             	mov    %al,-0x7(%ebp)
  101761:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101765:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101769:	ee                   	out    %al,(%dx)
    }
}
  10176a:	c9                   	leave  
  10176b:	c3                   	ret    

0010176c <pic_enable>:

void
pic_enable(unsigned int irq) {
  10176c:	55                   	push   %ebp
  10176d:	89 e5                	mov    %esp,%ebp
  10176f:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101772:	8b 45 08             	mov    0x8(%ebp),%eax
  101775:	ba 01 00 00 00       	mov    $0x1,%edx
  10177a:	89 c1                	mov    %eax,%ecx
  10177c:	d3 e2                	shl    %cl,%edx
  10177e:	89 d0                	mov    %edx,%eax
  101780:	f7 d0                	not    %eax
  101782:	89 c2                	mov    %eax,%edx
  101784:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10178b:	21 d0                	and    %edx,%eax
  10178d:	0f b7 c0             	movzwl %ax,%eax
  101790:	89 04 24             	mov    %eax,(%esp)
  101793:	e8 7c ff ff ff       	call   101714 <pic_setmask>
}
  101798:	c9                   	leave  
  101799:	c3                   	ret    

0010179a <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10179a:	55                   	push   %ebp
  10179b:	89 e5                	mov    %esp,%ebp
  10179d:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017a0:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1017a7:	00 00 00 
  1017aa:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1017b0:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1017b4:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017b8:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017bc:	ee                   	out    %al,(%dx)
  1017bd:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1017c3:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1017c7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017cb:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017cf:	ee                   	out    %al,(%dx)
  1017d0:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1017d6:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1017da:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1017de:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1017e2:	ee                   	out    %al,(%dx)
  1017e3:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1017e9:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1017ed:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1017f1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017f5:	ee                   	out    %al,(%dx)
  1017f6:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017fc:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101800:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101804:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101808:	ee                   	out    %al,(%dx)
  101809:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  10180f:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101813:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101817:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10181b:	ee                   	out    %al,(%dx)
  10181c:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101822:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101826:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10182a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10182e:	ee                   	out    %al,(%dx)
  10182f:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101835:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101839:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10183d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101841:	ee                   	out    %al,(%dx)
  101842:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101848:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10184c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101850:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101854:	ee                   	out    %al,(%dx)
  101855:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10185b:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  10185f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101863:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101867:	ee                   	out    %al,(%dx)
  101868:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10186e:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101872:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101876:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10187a:	ee                   	out    %al,(%dx)
  10187b:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101881:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101885:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101889:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10188d:	ee                   	out    %al,(%dx)
  10188e:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101894:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101898:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10189c:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1018a0:	ee                   	out    %al,(%dx)
  1018a1:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1018a7:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1018ab:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1018af:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1018b3:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018b4:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1018bb:	66 83 f8 ff          	cmp    $0xffff,%ax
  1018bf:	74 12                	je     1018d3 <pic_init+0x139>
        pic_setmask(irq_mask);
  1018c1:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1018c8:	0f b7 c0             	movzwl %ax,%eax
  1018cb:	89 04 24             	mov    %eax,(%esp)
  1018ce:	e8 41 fe ff ff       	call   101714 <pic_setmask>
    }
}
  1018d3:	c9                   	leave  
  1018d4:	c3                   	ret    

001018d5 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1018d5:	55                   	push   %ebp
  1018d6:	89 e5                	mov    %esp,%ebp
  1018d8:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1018db:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018e2:	00 
  1018e3:	c7 04 24 60 3b 10 00 	movl   $0x103b60,(%esp)
  1018ea:	e8 e3 ea ff ff       	call   1003d2 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1018ef:	c9                   	leave  
  1018f0:	c3                   	ret    

001018f1 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018f1:	55                   	push   %ebp
  1018f2:	89 e5                	mov    %esp,%ebp
  1018f4:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i = 0;
  1018f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    for(i = 0; i < 256; i++) SETGATE(idt[i], 0, GD_KTEXT , __vectors[i], DPL_KERNEL);
  1018fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101905:	e9 c3 00 00 00       	jmp    1019cd <idt_init+0xdc>
  10190a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190d:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101914:	89 c2                	mov    %eax,%edx
  101916:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101919:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101920:	00 
  101921:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101924:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10192b:	00 08 00 
  10192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101931:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101938:	00 
  101939:	83 e2 e0             	and    $0xffffffe0,%edx
  10193c:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101946:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10194d:	00 
  10194e:	83 e2 1f             	and    $0x1f,%edx
  101951:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101958:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195b:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101962:	00 
  101963:	83 e2 f0             	and    $0xfffffff0,%edx
  101966:	83 ca 0e             	or     $0xe,%edx
  101969:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101970:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101973:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10197a:	00 
  10197b:	83 e2 ef             	and    $0xffffffef,%edx
  10197e:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101985:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101988:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10198f:	00 
  101990:	83 e2 9f             	and    $0xffffff9f,%edx
  101993:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10199a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10199d:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1019a4:	00 
  1019a5:	83 ca 80             	or     $0xffffff80,%edx
  1019a8:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1019af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b2:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1019b9:	c1 e8 10             	shr    $0x10,%eax
  1019bc:	89 c2                	mov    %eax,%edx
  1019be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c1:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1019c8:	00 
  1019c9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1019cd:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1019d4:	0f 8e 30 ff ff ff    	jle    10190a <idt_init+0x19>
    SETGATE(idt[T_SYSCALL], 0, GD_KTEXT , __vectors[T_SYSCALL], DPL_USER);
  1019da:	a1 e0 e7 10 00       	mov    0x10e7e0,%eax
  1019df:	66 a3 a0 f4 10 00    	mov    %ax,0x10f4a0
  1019e5:	66 c7 05 a2 f4 10 00 	movw   $0x8,0x10f4a2
  1019ec:	08 00 
  1019ee:	0f b6 05 a4 f4 10 00 	movzbl 0x10f4a4,%eax
  1019f5:	83 e0 e0             	and    $0xffffffe0,%eax
  1019f8:	a2 a4 f4 10 00       	mov    %al,0x10f4a4
  1019fd:	0f b6 05 a4 f4 10 00 	movzbl 0x10f4a4,%eax
  101a04:	83 e0 1f             	and    $0x1f,%eax
  101a07:	a2 a4 f4 10 00       	mov    %al,0x10f4a4
  101a0c:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  101a13:	83 e0 f0             	and    $0xfffffff0,%eax
  101a16:	83 c8 0e             	or     $0xe,%eax
  101a19:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101a1e:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  101a25:	83 e0 ef             	and    $0xffffffef,%eax
  101a28:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101a2d:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  101a34:	83 c8 60             	or     $0x60,%eax
  101a37:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101a3c:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  101a43:	83 c8 80             	or     $0xffffff80,%eax
  101a46:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101a4b:	a1 e0 e7 10 00       	mov    0x10e7e0,%eax
  101a50:	c1 e8 10             	shr    $0x10,%eax
  101a53:	66 a3 a6 f4 10 00    	mov    %ax,0x10f4a6
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101a59:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101a5e:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101a64:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  101a6b:	08 00 
  101a6d:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101a74:	83 e0 e0             	and    $0xffffffe0,%eax
  101a77:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101a7c:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101a83:	83 e0 1f             	and    $0x1f,%eax
  101a86:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101a8b:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101a92:	83 e0 f0             	and    $0xfffffff0,%eax
  101a95:	83 c8 0e             	or     $0xe,%eax
  101a98:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101a9d:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101aa4:	83 e0 ef             	and    $0xffffffef,%eax
  101aa7:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101aac:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101ab3:	83 c8 60             	or     $0x60,%eax
  101ab6:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101abb:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101ac2:	83 c8 80             	or     $0xffffff80,%eax
  101ac5:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101aca:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101acf:	c1 e8 10             	shr    $0x10,%eax
  101ad2:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101ad8:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101adf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101ae2:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd);
}
  101ae5:	c9                   	leave  
  101ae6:	c3                   	ret    

00101ae7 <trapname>:

static const char *
trapname(int trapno) {
  101ae7:	55                   	push   %ebp
  101ae8:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101aea:	8b 45 08             	mov    0x8(%ebp),%eax
  101aed:	83 f8 13             	cmp    $0x13,%eax
  101af0:	77 0c                	ja     101afe <trapname+0x17>
        return excnames[trapno];
  101af2:	8b 45 08             	mov    0x8(%ebp),%eax
  101af5:	8b 04 85 00 3f 10 00 	mov    0x103f00(,%eax,4),%eax
  101afc:	eb 18                	jmp    101b16 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101afe:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b02:	7e 0d                	jle    101b11 <trapname+0x2a>
  101b04:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b08:	7f 07                	jg     101b11 <trapname+0x2a>
        return "Hardware Interrupt";
  101b0a:	b8 6a 3b 10 00       	mov    $0x103b6a,%eax
  101b0f:	eb 05                	jmp    101b16 <trapname+0x2f>
    }
    return "(unknown trap)";
  101b11:	b8 7d 3b 10 00       	mov    $0x103b7d,%eax
}
  101b16:	5d                   	pop    %ebp
  101b17:	c3                   	ret    

00101b18 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b18:	55                   	push   %ebp
  101b19:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b22:	66 83 f8 08          	cmp    $0x8,%ax
  101b26:	0f 94 c0             	sete   %al
  101b29:	0f b6 c0             	movzbl %al,%eax
}
  101b2c:	5d                   	pop    %ebp
  101b2d:	c3                   	ret    

00101b2e <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b2e:	55                   	push   %ebp
  101b2f:	89 e5                	mov    %esp,%ebp
  101b31:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b34:	8b 45 08             	mov    0x8(%ebp),%eax
  101b37:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3b:	c7 04 24 be 3b 10 00 	movl   $0x103bbe,(%esp)
  101b42:	e8 8b e8 ff ff       	call   1003d2 <cprintf>
    print_regs(&tf->tf_regs);
  101b47:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4a:	89 04 24             	mov    %eax,(%esp)
  101b4d:	e8 a1 01 00 00       	call   101cf3 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b52:	8b 45 08             	mov    0x8(%ebp),%eax
  101b55:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b59:	0f b7 c0             	movzwl %ax,%eax
  101b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b60:	c7 04 24 cf 3b 10 00 	movl   $0x103bcf,(%esp)
  101b67:	e8 66 e8 ff ff       	call   1003d2 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6f:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b73:	0f b7 c0             	movzwl %ax,%eax
  101b76:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7a:	c7 04 24 e2 3b 10 00 	movl   $0x103be2,(%esp)
  101b81:	e8 4c e8 ff ff       	call   1003d2 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b86:	8b 45 08             	mov    0x8(%ebp),%eax
  101b89:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b8d:	0f b7 c0             	movzwl %ax,%eax
  101b90:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b94:	c7 04 24 f5 3b 10 00 	movl   $0x103bf5,(%esp)
  101b9b:	e8 32 e8 ff ff       	call   1003d2 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba3:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ba7:	0f b7 c0             	movzwl %ax,%eax
  101baa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bae:	c7 04 24 08 3c 10 00 	movl   $0x103c08,(%esp)
  101bb5:	e8 18 e8 ff ff       	call   1003d2 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101bba:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbd:	8b 40 30             	mov    0x30(%eax),%eax
  101bc0:	89 04 24             	mov    %eax,(%esp)
  101bc3:	e8 1f ff ff ff       	call   101ae7 <trapname>
  101bc8:	8b 55 08             	mov    0x8(%ebp),%edx
  101bcb:	8b 52 30             	mov    0x30(%edx),%edx
  101bce:	89 44 24 08          	mov    %eax,0x8(%esp)
  101bd2:	89 54 24 04          	mov    %edx,0x4(%esp)
  101bd6:	c7 04 24 1b 3c 10 00 	movl   $0x103c1b,(%esp)
  101bdd:	e8 f0 e7 ff ff       	call   1003d2 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101be2:	8b 45 08             	mov    0x8(%ebp),%eax
  101be5:	8b 40 34             	mov    0x34(%eax),%eax
  101be8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bec:	c7 04 24 2d 3c 10 00 	movl   $0x103c2d,(%esp)
  101bf3:	e8 da e7 ff ff       	call   1003d2 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfb:	8b 40 38             	mov    0x38(%eax),%eax
  101bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c02:	c7 04 24 3c 3c 10 00 	movl   $0x103c3c,(%esp)
  101c09:	e8 c4 e7 ff ff       	call   1003d2 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c11:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c15:	0f b7 c0             	movzwl %ax,%eax
  101c18:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1c:	c7 04 24 4b 3c 10 00 	movl   $0x103c4b,(%esp)
  101c23:	e8 aa e7 ff ff       	call   1003d2 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c28:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2b:	8b 40 40             	mov    0x40(%eax),%eax
  101c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c32:	c7 04 24 5e 3c 10 00 	movl   $0x103c5e,(%esp)
  101c39:	e8 94 e7 ff ff       	call   1003d2 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c45:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c4c:	eb 3e                	jmp    101c8c <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c51:	8b 50 40             	mov    0x40(%eax),%edx
  101c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c57:	21 d0                	and    %edx,%eax
  101c59:	85 c0                	test   %eax,%eax
  101c5b:	74 28                	je     101c85 <print_trapframe+0x157>
  101c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c60:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101c67:	85 c0                	test   %eax,%eax
  101c69:	74 1a                	je     101c85 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c6e:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101c75:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c79:	c7 04 24 6d 3c 10 00 	movl   $0x103c6d,(%esp)
  101c80:	e8 4d e7 ff ff       	call   1003d2 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c85:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101c89:	d1 65 f0             	shll   -0x10(%ebp)
  101c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c8f:	83 f8 17             	cmp    $0x17,%eax
  101c92:	76 ba                	jbe    101c4e <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c94:	8b 45 08             	mov    0x8(%ebp),%eax
  101c97:	8b 40 40             	mov    0x40(%eax),%eax
  101c9a:	25 00 30 00 00       	and    $0x3000,%eax
  101c9f:	c1 e8 0c             	shr    $0xc,%eax
  101ca2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca6:	c7 04 24 71 3c 10 00 	movl   $0x103c71,(%esp)
  101cad:	e8 20 e7 ff ff       	call   1003d2 <cprintf>

    if (!trap_in_kernel(tf)) {
  101cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb5:	89 04 24             	mov    %eax,(%esp)
  101cb8:	e8 5b fe ff ff       	call   101b18 <trap_in_kernel>
  101cbd:	85 c0                	test   %eax,%eax
  101cbf:	75 30                	jne    101cf1 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc4:	8b 40 44             	mov    0x44(%eax),%eax
  101cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ccb:	c7 04 24 7a 3c 10 00 	movl   $0x103c7a,(%esp)
  101cd2:	e8 fb e6 ff ff       	call   1003d2 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101cda:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101cde:	0f b7 c0             	movzwl %ax,%eax
  101ce1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce5:	c7 04 24 89 3c 10 00 	movl   $0x103c89,(%esp)
  101cec:	e8 e1 e6 ff ff       	call   1003d2 <cprintf>
    }
}
  101cf1:	c9                   	leave  
  101cf2:	c3                   	ret    

00101cf3 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101cf3:	55                   	push   %ebp
  101cf4:	89 e5                	mov    %esp,%ebp
  101cf6:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cfc:	8b 00                	mov    (%eax),%eax
  101cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d02:	c7 04 24 9c 3c 10 00 	movl   $0x103c9c,(%esp)
  101d09:	e8 c4 e6 ff ff       	call   1003d2 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d11:	8b 40 04             	mov    0x4(%eax),%eax
  101d14:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d18:	c7 04 24 ab 3c 10 00 	movl   $0x103cab,(%esp)
  101d1f:	e8 ae e6 ff ff       	call   1003d2 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d24:	8b 45 08             	mov    0x8(%ebp),%eax
  101d27:	8b 40 08             	mov    0x8(%eax),%eax
  101d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d2e:	c7 04 24 ba 3c 10 00 	movl   $0x103cba,(%esp)
  101d35:	e8 98 e6 ff ff       	call   1003d2 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3d:	8b 40 0c             	mov    0xc(%eax),%eax
  101d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d44:	c7 04 24 c9 3c 10 00 	movl   $0x103cc9,(%esp)
  101d4b:	e8 82 e6 ff ff       	call   1003d2 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d50:	8b 45 08             	mov    0x8(%ebp),%eax
  101d53:	8b 40 10             	mov    0x10(%eax),%eax
  101d56:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d5a:	c7 04 24 d8 3c 10 00 	movl   $0x103cd8,(%esp)
  101d61:	e8 6c e6 ff ff       	call   1003d2 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d66:	8b 45 08             	mov    0x8(%ebp),%eax
  101d69:	8b 40 14             	mov    0x14(%eax),%eax
  101d6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d70:	c7 04 24 e7 3c 10 00 	movl   $0x103ce7,(%esp)
  101d77:	e8 56 e6 ff ff       	call   1003d2 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  101d7f:	8b 40 18             	mov    0x18(%eax),%eax
  101d82:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d86:	c7 04 24 f6 3c 10 00 	movl   $0x103cf6,(%esp)
  101d8d:	e8 40 e6 ff ff       	call   1003d2 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d92:	8b 45 08             	mov    0x8(%ebp),%eax
  101d95:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d98:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d9c:	c7 04 24 05 3d 10 00 	movl   $0x103d05,(%esp)
  101da3:	e8 2a e6 ff ff       	call   1003d2 <cprintf>
}
  101da8:	c9                   	leave  
  101da9:	c3                   	ret    

00101daa <trap_dispatch>:

struct trapframe k2u, u2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101daa:	55                   	push   %ebp
  101dab:	89 e5                	mov    %esp,%ebp
  101dad:	57                   	push   %edi
  101dae:	56                   	push   %esi
  101daf:	53                   	push   %ebx
  101db0:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101db3:	8b 45 08             	mov    0x8(%ebp),%eax
  101db6:	8b 40 30             	mov    0x30(%eax),%eax
  101db9:	83 f8 24             	cmp    $0x24,%eax
  101dbc:	74 6a                	je     101e28 <trap_dispatch+0x7e>
  101dbe:	83 f8 24             	cmp    $0x24,%eax
  101dc1:	77 13                	ja     101dd6 <trap_dispatch+0x2c>
  101dc3:	83 f8 20             	cmp    $0x20,%eax
  101dc6:	74 25                	je     101ded <trap_dispatch+0x43>
  101dc8:	83 f8 21             	cmp    $0x21,%eax
  101dcb:	0f 84 80 00 00 00    	je     101e51 <trap_dispatch+0xa7>
  101dd1:	e9 9c 02 00 00       	jmp    102072 <trap_dispatch+0x2c8>
  101dd6:	83 f8 78             	cmp    $0x78,%eax
  101dd9:	0f 84 ab 01 00 00    	je     101f8a <trap_dispatch+0x1e0>
  101ddf:	83 f8 79             	cmp    $0x79,%eax
  101de2:	0f 84 19 02 00 00    	je     102001 <trap_dispatch+0x257>
  101de8:	e9 85 02 00 00       	jmp    102072 <trap_dispatch+0x2c8>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks++ != 0 ? ticks % TICK_NUM == 0 ? print_ticks() : NULL : NULL;
  101ded:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101df2:	8d 50 01             	lea    0x1(%eax),%edx
  101df5:	89 15 08 f9 10 00    	mov    %edx,0x10f908
  101dfb:	85 c0                	test   %eax,%eax
  101dfd:	74 24                	je     101e23 <trap_dispatch+0x79>
  101dff:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101e05:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e0a:	89 c8                	mov    %ecx,%eax
  101e0c:	f7 e2                	mul    %edx
  101e0e:	89 d0                	mov    %edx,%eax
  101e10:	c1 e8 05             	shr    $0x5,%eax
  101e13:	6b c0 64             	imul   $0x64,%eax,%eax
  101e16:	29 c1                	sub    %eax,%ecx
  101e18:	89 c8                	mov    %ecx,%eax
  101e1a:	85 c0                	test   %eax,%eax
  101e1c:	75 05                	jne    101e23 <trap_dispatch+0x79>
  101e1e:	e8 b2 fa ff ff       	call   1018d5 <print_ticks>
        break;
  101e23:	e9 82 02 00 00       	jmp    1020aa <trap_dispatch+0x300>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e28:	e8 7f f8 ff ff       	call   1016ac <cons_getc>
  101e2d:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e30:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e34:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e38:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e40:	c7 04 24 14 3d 10 00 	movl   $0x103d14,(%esp)
  101e47:	e8 86 e5 ff ff       	call   1003d2 <cprintf>
        break;
  101e4c:	e9 59 02 00 00       	jmp    1020aa <trap_dispatch+0x300>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e51:	e8 56 f8 ff ff       	call   1016ac <cons_getc>
  101e56:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e59:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e5d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e61:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e65:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e69:	c7 04 24 26 3d 10 00 	movl   $0x103d26,(%esp)
  101e70:	e8 5d e5 ff ff       	call   1003d2 <cprintf>
        if(c == '0'){
  101e75:	80 7d e7 30          	cmpb   $0x30,-0x19(%ebp)
  101e79:	0f 85 82 00 00 00    	jne    101f01 <trap_dispatch+0x157>
            if (tf->tf_cs != KERNEL_CS) {
  101e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e82:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e86:	66 83 f8 08          	cmp    $0x8,%ax
  101e8a:	0f 84 f5 00 00 00    	je     101f85 <trap_dispatch+0x1db>
                cprintf("+++ switch to  kernel  mode +++\n");
  101e90:	c7 04 24 38 3d 10 00 	movl   $0x103d38,(%esp)
  101e97:	e8 36 e5 ff ff       	call   1003d2 <cprintf>
                u2k = *tf;
  101e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9f:	ba 80 f9 10 00       	mov    $0x10f980,%edx
  101ea4:	89 c3                	mov    %eax,%ebx
  101ea6:	b8 13 00 00 00       	mov    $0x13,%eax
  101eab:	89 d7                	mov    %edx,%edi
  101ead:	89 de                	mov    %ebx,%esi
  101eaf:	89 c1                	mov    %eax,%ecx
  101eb1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
                u2k.tf_cs = KERNEL_CS;
  101eb3:	66 c7 05 bc f9 10 00 	movw   $0x8,0x10f9bc
  101eba:	08 00 
                u2k.tf_ds = KERNEL_DS;
  101ebc:	66 c7 05 ac f9 10 00 	movw   $0x10,0x10f9ac
  101ec3:	10 00 
                u2k.tf_es = KERNEL_DS;
  101ec5:	66 c7 05 a8 f9 10 00 	movw   $0x10,0x10f9a8
  101ecc:	10 00 
                u2k.tf_ss = KERNEL_DS;
  101ece:	66 c7 05 c8 f9 10 00 	movw   $0x10,0x10f9c8
  101ed5:	10 00 
                u2k.tf_esp = tf->tf_esp;
  101ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  101eda:	8b 40 44             	mov    0x44(%eax),%eax
  101edd:	a3 c4 f9 10 00       	mov    %eax,0x10f9c4
                u2k.tf_eflags &= ~FL_IOPL_MASK;  // 保证printf正常
  101ee2:	a1 c0 f9 10 00       	mov    0x10f9c0,%eax
  101ee7:	80 e4 cf             	and    $0xcf,%ah
  101eea:	a3 c0 f9 10 00       	mov    %eax,0x10f9c0
                
                *((uint32_t *)tf - 1) = (uint32_t)&u2k;
  101eef:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef2:	8d 50 fc             	lea    -0x4(%eax),%edx
  101ef5:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  101efa:	89 02                	mov    %eax,(%edx)
                k2u.tf_esp = tf->tf_esp;
                k2u.tf_eflags |= FL_IOPL_MASK;  // 保证printf正常
                *((uint32_t *)tf - 1) = (uint32_t)&k2u;
            }
        }
        break;
  101efc:	e9 a9 01 00 00       	jmp    1020aa <trap_dispatch+0x300>
                u2k.tf_eflags &= ~FL_IOPL_MASK;  // 保证printf正常
                
                *((uint32_t *)tf - 1) = (uint32_t)&u2k;
            }
        }
        else if(c == '3')
  101f01:	80 7d e7 33          	cmpb   $0x33,-0x19(%ebp)
  101f05:	75 7e                	jne    101f85 <trap_dispatch+0x1db>
        {
            if (tf->tf_cs != USER_CS) {
  101f07:	8b 45 08             	mov    0x8(%ebp),%eax
  101f0a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f0e:	66 83 f8 1b          	cmp    $0x1b,%ax
  101f12:	74 71                	je     101f85 <trap_dispatch+0x1db>
                cprintf("+++ switch to  user  mode +++\n");
  101f14:	c7 04 24 5c 3d 10 00 	movl   $0x103d5c,(%esp)
  101f1b:	e8 b2 e4 ff ff       	call   1003d2 <cprintf>
                k2u = *tf;
  101f20:	8b 45 08             	mov    0x8(%ebp),%eax
  101f23:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101f28:	89 c3                	mov    %eax,%ebx
  101f2a:	b8 13 00 00 00       	mov    $0x13,%eax
  101f2f:	89 d7                	mov    %edx,%edi
  101f31:	89 de                	mov    %ebx,%esi
  101f33:	89 c1                	mov    %eax,%ecx
  101f35:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
                k2u.tf_cs = USER_CS;
  101f37:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101f3e:	1b 00 
                k2u.tf_ds = USER_DS;
  101f40:	66 c7 05 4c f9 10 00 	movw   $0x23,0x10f94c
  101f47:	23 00 
                k2u.tf_es = USER_DS;
  101f49:	66 c7 05 48 f9 10 00 	movw   $0x23,0x10f948
  101f50:	23 00 
                k2u.tf_ss = USER_DS;
  101f52:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101f59:	23 00 
                k2u.tf_esp = tf->tf_esp;
  101f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101f5e:	8b 40 44             	mov    0x44(%eax),%eax
  101f61:	a3 64 f9 10 00       	mov    %eax,0x10f964
                k2u.tf_eflags |= FL_IOPL_MASK;  // 保证printf正常
  101f66:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101f6b:	80 cc 30             	or     $0x30,%ah
  101f6e:	a3 60 f9 10 00       	mov    %eax,0x10f960
                *((uint32_t *)tf - 1) = (uint32_t)&k2u;
  101f73:	8b 45 08             	mov    0x8(%ebp),%eax
  101f76:	8d 50 fc             	lea    -0x4(%eax),%edx
  101f79:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101f7e:	89 02                	mov    %eax,(%edx)
            }
        }
        break;
  101f80:	e9 25 01 00 00       	jmp    1020aa <trap_dispatch+0x300>
  101f85:	e9 20 01 00 00       	jmp    1020aa <trap_dispatch+0x300>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if(tf->tf_cs != USER_CS){  // 不等则切换
  101f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101f8d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f91:	66 83 f8 1b          	cmp    $0x1b,%ax
  101f95:	74 65                	je     101ffc <trap_dispatch+0x252>
            k2u = *tf;
  101f97:	8b 45 08             	mov    0x8(%ebp),%eax
  101f9a:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101f9f:	89 c3                	mov    %eax,%ebx
  101fa1:	b8 13 00 00 00       	mov    $0x13,%eax
  101fa6:	89 d7                	mov    %edx,%edi
  101fa8:	89 de                	mov    %ebx,%esi
  101faa:	89 c1                	mov    %eax,%ecx
  101fac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            k2u.tf_cs = USER_CS;
  101fae:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101fb5:	1b 00 
            k2u.tf_ds = USER_DS;
  101fb7:	66 c7 05 4c f9 10 00 	movw   $0x23,0x10f94c
  101fbe:	23 00 
            k2u.tf_es = USER_DS;
  101fc0:	66 c7 05 48 f9 10 00 	movw   $0x23,0x10f948
  101fc7:	23 00 
            k2u.tf_ss = USER_DS;
  101fc9:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101fd0:	23 00 
            k2u.tf_esp = tf->tf_esp;
  101fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd5:	8b 40 44             	mov    0x44(%eax),%eax
  101fd8:	a3 64 f9 10 00       	mov    %eax,0x10f964
            k2u.tf_eflags |= FL_IOPL_MASK;  // 保证printf正常
  101fdd:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101fe2:	80 cc 30             	or     $0x30,%ah
  101fe5:	a3 60 f9 10 00       	mov    %eax,0x10f960
            
            *((uint32_t *)tf - 1) = (uint32_t)&k2u;
  101fea:	8b 45 08             	mov    0x8(%ebp),%eax
  101fed:	8d 50 fc             	lea    -0x4(%eax),%edx
  101ff0:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101ff5:	89 02                	mov    %eax,(%edx)
        }

        break;
  101ff7:	e9 ae 00 00 00       	jmp    1020aa <trap_dispatch+0x300>
  101ffc:	e9 a9 00 00 00       	jmp    1020aa <trap_dispatch+0x300>
    case T_SWITCH_TOK:
        if(tf->tf_cs != KERNEL_CS){  // 不等则切换
  102001:	8b 45 08             	mov    0x8(%ebp),%eax
  102004:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102008:	66 83 f8 08          	cmp    $0x8,%ax
  10200c:	74 62                	je     102070 <trap_dispatch+0x2c6>
            // tf->tf_eflags &= ~FL_IOPL_MASK;
            // switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
            // memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
            // *((uint32_t *)tf - 1) = (uint32_t)switchu2k;

            u2k = *tf;
  10200e:	8b 45 08             	mov    0x8(%ebp),%eax
  102011:	ba 80 f9 10 00       	mov    $0x10f980,%edx
  102016:	89 c3                	mov    %eax,%ebx
  102018:	b8 13 00 00 00       	mov    $0x13,%eax
  10201d:	89 d7                	mov    %edx,%edi
  10201f:	89 de                	mov    %ebx,%esi
  102021:	89 c1                	mov    %eax,%ecx
  102023:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
            u2k.tf_cs = KERNEL_CS;
  102025:	66 c7 05 bc f9 10 00 	movw   $0x8,0x10f9bc
  10202c:	08 00 
            u2k.tf_ds = KERNEL_DS;
  10202e:	66 c7 05 ac f9 10 00 	movw   $0x10,0x10f9ac
  102035:	10 00 
            u2k.tf_es = KERNEL_DS;
  102037:	66 c7 05 a8 f9 10 00 	movw   $0x10,0x10f9a8
  10203e:	10 00 
            u2k.tf_ss = KERNEL_DS;
  102040:	66 c7 05 c8 f9 10 00 	movw   $0x10,0x10f9c8
  102047:	10 00 
            u2k.tf_esp = tf->tf_esp;
  102049:	8b 45 08             	mov    0x8(%ebp),%eax
  10204c:	8b 40 44             	mov    0x44(%eax),%eax
  10204f:	a3 c4 f9 10 00       	mov    %eax,0x10f9c4
            u2k.tf_eflags &= ~FL_IOPL_MASK;  // 保证printf正常
  102054:	a1 c0 f9 10 00       	mov    0x10f9c0,%eax
  102059:	80 e4 cf             	and    $0xcf,%ah
  10205c:	a3 c0 f9 10 00       	mov    %eax,0x10f9c0
            
            *((uint32_t *)tf - 1) = (uint32_t)&u2k;
  102061:	8b 45 08             	mov    0x8(%ebp),%eax
  102064:	8d 50 fc             	lea    -0x4(%eax),%edx
  102067:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  10206c:	89 02                	mov    %eax,(%edx)

        }
        //panic("T_SWITCH_** ??\n");
        break;
  10206e:	eb 3a                	jmp    1020aa <trap_dispatch+0x300>
  102070:	eb 38                	jmp    1020aa <trap_dispatch+0x300>
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  102072:	8b 45 08             	mov    0x8(%ebp),%eax
  102075:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  102079:	0f b7 c0             	movzwl %ax,%eax
  10207c:	83 e0 03             	and    $0x3,%eax
  10207f:	85 c0                	test   %eax,%eax
  102081:	75 27                	jne    1020aa <trap_dispatch+0x300>
            print_trapframe(tf);
  102083:	8b 45 08             	mov    0x8(%ebp),%eax
  102086:	89 04 24             	mov    %eax,(%esp)
  102089:	e8 a0 fa ff ff       	call   101b2e <print_trapframe>
            panic("unexpected trap in kernel.\n");
  10208e:	c7 44 24 08 7b 3d 10 	movl   $0x103d7b,0x8(%esp)
  102095:	00 
  102096:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  10209d:	00 
  10209e:	c7 04 24 97 3d 10 00 	movl   $0x103d97,(%esp)
  1020a5:	e8 d3 ec ff ff       	call   100d7d <__panic>
        }
    }
}
  1020aa:	83 c4 2c             	add    $0x2c,%esp
  1020ad:	5b                   	pop    %ebx
  1020ae:	5e                   	pop    %esi
  1020af:	5f                   	pop    %edi
  1020b0:	5d                   	pop    %ebp
  1020b1:	c3                   	ret    

001020b2 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  1020b2:	55                   	push   %ebp
  1020b3:	89 e5                	mov    %esp,%ebp
  1020b5:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  1020b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1020bb:	89 04 24             	mov    %eax,(%esp)
  1020be:	e8 e7 fc ff ff       	call   101daa <trap_dispatch>
}
  1020c3:	c9                   	leave  
  1020c4:	c3                   	ret    

001020c5 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1020c5:	1e                   	push   %ds
    pushl %es
  1020c6:	06                   	push   %es
    pushl %fs
  1020c7:	0f a0                	push   %fs
    pushl %gs
  1020c9:	0f a8                	push   %gs
    pushal
  1020cb:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1020cc:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1020d1:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1020d3:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1020d5:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1020d6:	e8 d7 ff ff ff       	call   1020b2 <trap>

    # pop the pushed stack pointer
    popl %esp
  1020db:	5c                   	pop    %esp

001020dc <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1020dc:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1020dd:	0f a9                	pop    %gs
    popl %fs
  1020df:	0f a1                	pop    %fs
    popl %es
  1020e1:	07                   	pop    %es
    popl %ds
  1020e2:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1020e3:	83 c4 08             	add    $0x8,%esp
    iret
  1020e6:	cf                   	iret   

001020e7 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $0
  1020e9:	6a 00                	push   $0x0
  jmp __alltraps
  1020eb:	e9 d5 ff ff ff       	jmp    1020c5 <__alltraps>

001020f0 <vector1>:
.globl vector1
vector1:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $1
  1020f2:	6a 01                	push   $0x1
  jmp __alltraps
  1020f4:	e9 cc ff ff ff       	jmp    1020c5 <__alltraps>

001020f9 <vector2>:
.globl vector2
vector2:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $2
  1020fb:	6a 02                	push   $0x2
  jmp __alltraps
  1020fd:	e9 c3 ff ff ff       	jmp    1020c5 <__alltraps>

00102102 <vector3>:
.globl vector3
vector3:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $3
  102104:	6a 03                	push   $0x3
  jmp __alltraps
  102106:	e9 ba ff ff ff       	jmp    1020c5 <__alltraps>

0010210b <vector4>:
.globl vector4
vector4:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $4
  10210d:	6a 04                	push   $0x4
  jmp __alltraps
  10210f:	e9 b1 ff ff ff       	jmp    1020c5 <__alltraps>

00102114 <vector5>:
.globl vector5
vector5:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $5
  102116:	6a 05                	push   $0x5
  jmp __alltraps
  102118:	e9 a8 ff ff ff       	jmp    1020c5 <__alltraps>

0010211d <vector6>:
.globl vector6
vector6:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $6
  10211f:	6a 06                	push   $0x6
  jmp __alltraps
  102121:	e9 9f ff ff ff       	jmp    1020c5 <__alltraps>

00102126 <vector7>:
.globl vector7
vector7:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $7
  102128:	6a 07                	push   $0x7
  jmp __alltraps
  10212a:	e9 96 ff ff ff       	jmp    1020c5 <__alltraps>

0010212f <vector8>:
.globl vector8
vector8:
  pushl $8
  10212f:	6a 08                	push   $0x8
  jmp __alltraps
  102131:	e9 8f ff ff ff       	jmp    1020c5 <__alltraps>

00102136 <vector9>:
.globl vector9
vector9:
  pushl $0
  102136:	6a 00                	push   $0x0
  pushl $9
  102138:	6a 09                	push   $0x9
  jmp __alltraps
  10213a:	e9 86 ff ff ff       	jmp    1020c5 <__alltraps>

0010213f <vector10>:
.globl vector10
vector10:
  pushl $10
  10213f:	6a 0a                	push   $0xa
  jmp __alltraps
  102141:	e9 7f ff ff ff       	jmp    1020c5 <__alltraps>

00102146 <vector11>:
.globl vector11
vector11:
  pushl $11
  102146:	6a 0b                	push   $0xb
  jmp __alltraps
  102148:	e9 78 ff ff ff       	jmp    1020c5 <__alltraps>

0010214d <vector12>:
.globl vector12
vector12:
  pushl $12
  10214d:	6a 0c                	push   $0xc
  jmp __alltraps
  10214f:	e9 71 ff ff ff       	jmp    1020c5 <__alltraps>

00102154 <vector13>:
.globl vector13
vector13:
  pushl $13
  102154:	6a 0d                	push   $0xd
  jmp __alltraps
  102156:	e9 6a ff ff ff       	jmp    1020c5 <__alltraps>

0010215b <vector14>:
.globl vector14
vector14:
  pushl $14
  10215b:	6a 0e                	push   $0xe
  jmp __alltraps
  10215d:	e9 63 ff ff ff       	jmp    1020c5 <__alltraps>

00102162 <vector15>:
.globl vector15
vector15:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $15
  102164:	6a 0f                	push   $0xf
  jmp __alltraps
  102166:	e9 5a ff ff ff       	jmp    1020c5 <__alltraps>

0010216b <vector16>:
.globl vector16
vector16:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $16
  10216d:	6a 10                	push   $0x10
  jmp __alltraps
  10216f:	e9 51 ff ff ff       	jmp    1020c5 <__alltraps>

00102174 <vector17>:
.globl vector17
vector17:
  pushl $17
  102174:	6a 11                	push   $0x11
  jmp __alltraps
  102176:	e9 4a ff ff ff       	jmp    1020c5 <__alltraps>

0010217b <vector18>:
.globl vector18
vector18:
  pushl $0
  10217b:	6a 00                	push   $0x0
  pushl $18
  10217d:	6a 12                	push   $0x12
  jmp __alltraps
  10217f:	e9 41 ff ff ff       	jmp    1020c5 <__alltraps>

00102184 <vector19>:
.globl vector19
vector19:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $19
  102186:	6a 13                	push   $0x13
  jmp __alltraps
  102188:	e9 38 ff ff ff       	jmp    1020c5 <__alltraps>

0010218d <vector20>:
.globl vector20
vector20:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $20
  10218f:	6a 14                	push   $0x14
  jmp __alltraps
  102191:	e9 2f ff ff ff       	jmp    1020c5 <__alltraps>

00102196 <vector21>:
.globl vector21
vector21:
  pushl $0
  102196:	6a 00                	push   $0x0
  pushl $21
  102198:	6a 15                	push   $0x15
  jmp __alltraps
  10219a:	e9 26 ff ff ff       	jmp    1020c5 <__alltraps>

0010219f <vector22>:
.globl vector22
vector22:
  pushl $0
  10219f:	6a 00                	push   $0x0
  pushl $22
  1021a1:	6a 16                	push   $0x16
  jmp __alltraps
  1021a3:	e9 1d ff ff ff       	jmp    1020c5 <__alltraps>

001021a8 <vector23>:
.globl vector23
vector23:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $23
  1021aa:	6a 17                	push   $0x17
  jmp __alltraps
  1021ac:	e9 14 ff ff ff       	jmp    1020c5 <__alltraps>

001021b1 <vector24>:
.globl vector24
vector24:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $24
  1021b3:	6a 18                	push   $0x18
  jmp __alltraps
  1021b5:	e9 0b ff ff ff       	jmp    1020c5 <__alltraps>

001021ba <vector25>:
.globl vector25
vector25:
  pushl $0
  1021ba:	6a 00                	push   $0x0
  pushl $25
  1021bc:	6a 19                	push   $0x19
  jmp __alltraps
  1021be:	e9 02 ff ff ff       	jmp    1020c5 <__alltraps>

001021c3 <vector26>:
.globl vector26
vector26:
  pushl $0
  1021c3:	6a 00                	push   $0x0
  pushl $26
  1021c5:	6a 1a                	push   $0x1a
  jmp __alltraps
  1021c7:	e9 f9 fe ff ff       	jmp    1020c5 <__alltraps>

001021cc <vector27>:
.globl vector27
vector27:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $27
  1021ce:	6a 1b                	push   $0x1b
  jmp __alltraps
  1021d0:	e9 f0 fe ff ff       	jmp    1020c5 <__alltraps>

001021d5 <vector28>:
.globl vector28
vector28:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $28
  1021d7:	6a 1c                	push   $0x1c
  jmp __alltraps
  1021d9:	e9 e7 fe ff ff       	jmp    1020c5 <__alltraps>

001021de <vector29>:
.globl vector29
vector29:
  pushl $0
  1021de:	6a 00                	push   $0x0
  pushl $29
  1021e0:	6a 1d                	push   $0x1d
  jmp __alltraps
  1021e2:	e9 de fe ff ff       	jmp    1020c5 <__alltraps>

001021e7 <vector30>:
.globl vector30
vector30:
  pushl $0
  1021e7:	6a 00                	push   $0x0
  pushl $30
  1021e9:	6a 1e                	push   $0x1e
  jmp __alltraps
  1021eb:	e9 d5 fe ff ff       	jmp    1020c5 <__alltraps>

001021f0 <vector31>:
.globl vector31
vector31:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $31
  1021f2:	6a 1f                	push   $0x1f
  jmp __alltraps
  1021f4:	e9 cc fe ff ff       	jmp    1020c5 <__alltraps>

001021f9 <vector32>:
.globl vector32
vector32:
  pushl $0
  1021f9:	6a 00                	push   $0x0
  pushl $32
  1021fb:	6a 20                	push   $0x20
  jmp __alltraps
  1021fd:	e9 c3 fe ff ff       	jmp    1020c5 <__alltraps>

00102202 <vector33>:
.globl vector33
vector33:
  pushl $0
  102202:	6a 00                	push   $0x0
  pushl $33
  102204:	6a 21                	push   $0x21
  jmp __alltraps
  102206:	e9 ba fe ff ff       	jmp    1020c5 <__alltraps>

0010220b <vector34>:
.globl vector34
vector34:
  pushl $0
  10220b:	6a 00                	push   $0x0
  pushl $34
  10220d:	6a 22                	push   $0x22
  jmp __alltraps
  10220f:	e9 b1 fe ff ff       	jmp    1020c5 <__alltraps>

00102214 <vector35>:
.globl vector35
vector35:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $35
  102216:	6a 23                	push   $0x23
  jmp __alltraps
  102218:	e9 a8 fe ff ff       	jmp    1020c5 <__alltraps>

0010221d <vector36>:
.globl vector36
vector36:
  pushl $0
  10221d:	6a 00                	push   $0x0
  pushl $36
  10221f:	6a 24                	push   $0x24
  jmp __alltraps
  102221:	e9 9f fe ff ff       	jmp    1020c5 <__alltraps>

00102226 <vector37>:
.globl vector37
vector37:
  pushl $0
  102226:	6a 00                	push   $0x0
  pushl $37
  102228:	6a 25                	push   $0x25
  jmp __alltraps
  10222a:	e9 96 fe ff ff       	jmp    1020c5 <__alltraps>

0010222f <vector38>:
.globl vector38
vector38:
  pushl $0
  10222f:	6a 00                	push   $0x0
  pushl $38
  102231:	6a 26                	push   $0x26
  jmp __alltraps
  102233:	e9 8d fe ff ff       	jmp    1020c5 <__alltraps>

00102238 <vector39>:
.globl vector39
vector39:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $39
  10223a:	6a 27                	push   $0x27
  jmp __alltraps
  10223c:	e9 84 fe ff ff       	jmp    1020c5 <__alltraps>

00102241 <vector40>:
.globl vector40
vector40:
  pushl $0
  102241:	6a 00                	push   $0x0
  pushl $40
  102243:	6a 28                	push   $0x28
  jmp __alltraps
  102245:	e9 7b fe ff ff       	jmp    1020c5 <__alltraps>

0010224a <vector41>:
.globl vector41
vector41:
  pushl $0
  10224a:	6a 00                	push   $0x0
  pushl $41
  10224c:	6a 29                	push   $0x29
  jmp __alltraps
  10224e:	e9 72 fe ff ff       	jmp    1020c5 <__alltraps>

00102253 <vector42>:
.globl vector42
vector42:
  pushl $0
  102253:	6a 00                	push   $0x0
  pushl $42
  102255:	6a 2a                	push   $0x2a
  jmp __alltraps
  102257:	e9 69 fe ff ff       	jmp    1020c5 <__alltraps>

0010225c <vector43>:
.globl vector43
vector43:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $43
  10225e:	6a 2b                	push   $0x2b
  jmp __alltraps
  102260:	e9 60 fe ff ff       	jmp    1020c5 <__alltraps>

00102265 <vector44>:
.globl vector44
vector44:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $44
  102267:	6a 2c                	push   $0x2c
  jmp __alltraps
  102269:	e9 57 fe ff ff       	jmp    1020c5 <__alltraps>

0010226e <vector45>:
.globl vector45
vector45:
  pushl $0
  10226e:	6a 00                	push   $0x0
  pushl $45
  102270:	6a 2d                	push   $0x2d
  jmp __alltraps
  102272:	e9 4e fe ff ff       	jmp    1020c5 <__alltraps>

00102277 <vector46>:
.globl vector46
vector46:
  pushl $0
  102277:	6a 00                	push   $0x0
  pushl $46
  102279:	6a 2e                	push   $0x2e
  jmp __alltraps
  10227b:	e9 45 fe ff ff       	jmp    1020c5 <__alltraps>

00102280 <vector47>:
.globl vector47
vector47:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $47
  102282:	6a 2f                	push   $0x2f
  jmp __alltraps
  102284:	e9 3c fe ff ff       	jmp    1020c5 <__alltraps>

00102289 <vector48>:
.globl vector48
vector48:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $48
  10228b:	6a 30                	push   $0x30
  jmp __alltraps
  10228d:	e9 33 fe ff ff       	jmp    1020c5 <__alltraps>

00102292 <vector49>:
.globl vector49
vector49:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $49
  102294:	6a 31                	push   $0x31
  jmp __alltraps
  102296:	e9 2a fe ff ff       	jmp    1020c5 <__alltraps>

0010229b <vector50>:
.globl vector50
vector50:
  pushl $0
  10229b:	6a 00                	push   $0x0
  pushl $50
  10229d:	6a 32                	push   $0x32
  jmp __alltraps
  10229f:	e9 21 fe ff ff       	jmp    1020c5 <__alltraps>

001022a4 <vector51>:
.globl vector51
vector51:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $51
  1022a6:	6a 33                	push   $0x33
  jmp __alltraps
  1022a8:	e9 18 fe ff ff       	jmp    1020c5 <__alltraps>

001022ad <vector52>:
.globl vector52
vector52:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $52
  1022af:	6a 34                	push   $0x34
  jmp __alltraps
  1022b1:	e9 0f fe ff ff       	jmp    1020c5 <__alltraps>

001022b6 <vector53>:
.globl vector53
vector53:
  pushl $0
  1022b6:	6a 00                	push   $0x0
  pushl $53
  1022b8:	6a 35                	push   $0x35
  jmp __alltraps
  1022ba:	e9 06 fe ff ff       	jmp    1020c5 <__alltraps>

001022bf <vector54>:
.globl vector54
vector54:
  pushl $0
  1022bf:	6a 00                	push   $0x0
  pushl $54
  1022c1:	6a 36                	push   $0x36
  jmp __alltraps
  1022c3:	e9 fd fd ff ff       	jmp    1020c5 <__alltraps>

001022c8 <vector55>:
.globl vector55
vector55:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $55
  1022ca:	6a 37                	push   $0x37
  jmp __alltraps
  1022cc:	e9 f4 fd ff ff       	jmp    1020c5 <__alltraps>

001022d1 <vector56>:
.globl vector56
vector56:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $56
  1022d3:	6a 38                	push   $0x38
  jmp __alltraps
  1022d5:	e9 eb fd ff ff       	jmp    1020c5 <__alltraps>

001022da <vector57>:
.globl vector57
vector57:
  pushl $0
  1022da:	6a 00                	push   $0x0
  pushl $57
  1022dc:	6a 39                	push   $0x39
  jmp __alltraps
  1022de:	e9 e2 fd ff ff       	jmp    1020c5 <__alltraps>

001022e3 <vector58>:
.globl vector58
vector58:
  pushl $0
  1022e3:	6a 00                	push   $0x0
  pushl $58
  1022e5:	6a 3a                	push   $0x3a
  jmp __alltraps
  1022e7:	e9 d9 fd ff ff       	jmp    1020c5 <__alltraps>

001022ec <vector59>:
.globl vector59
vector59:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $59
  1022ee:	6a 3b                	push   $0x3b
  jmp __alltraps
  1022f0:	e9 d0 fd ff ff       	jmp    1020c5 <__alltraps>

001022f5 <vector60>:
.globl vector60
vector60:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $60
  1022f7:	6a 3c                	push   $0x3c
  jmp __alltraps
  1022f9:	e9 c7 fd ff ff       	jmp    1020c5 <__alltraps>

001022fe <vector61>:
.globl vector61
vector61:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $61
  102300:	6a 3d                	push   $0x3d
  jmp __alltraps
  102302:	e9 be fd ff ff       	jmp    1020c5 <__alltraps>

00102307 <vector62>:
.globl vector62
vector62:
  pushl $0
  102307:	6a 00                	push   $0x0
  pushl $62
  102309:	6a 3e                	push   $0x3e
  jmp __alltraps
  10230b:	e9 b5 fd ff ff       	jmp    1020c5 <__alltraps>

00102310 <vector63>:
.globl vector63
vector63:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $63
  102312:	6a 3f                	push   $0x3f
  jmp __alltraps
  102314:	e9 ac fd ff ff       	jmp    1020c5 <__alltraps>

00102319 <vector64>:
.globl vector64
vector64:
  pushl $0
  102319:	6a 00                	push   $0x0
  pushl $64
  10231b:	6a 40                	push   $0x40
  jmp __alltraps
  10231d:	e9 a3 fd ff ff       	jmp    1020c5 <__alltraps>

00102322 <vector65>:
.globl vector65
vector65:
  pushl $0
  102322:	6a 00                	push   $0x0
  pushl $65
  102324:	6a 41                	push   $0x41
  jmp __alltraps
  102326:	e9 9a fd ff ff       	jmp    1020c5 <__alltraps>

0010232b <vector66>:
.globl vector66
vector66:
  pushl $0
  10232b:	6a 00                	push   $0x0
  pushl $66
  10232d:	6a 42                	push   $0x42
  jmp __alltraps
  10232f:	e9 91 fd ff ff       	jmp    1020c5 <__alltraps>

00102334 <vector67>:
.globl vector67
vector67:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $67
  102336:	6a 43                	push   $0x43
  jmp __alltraps
  102338:	e9 88 fd ff ff       	jmp    1020c5 <__alltraps>

0010233d <vector68>:
.globl vector68
vector68:
  pushl $0
  10233d:	6a 00                	push   $0x0
  pushl $68
  10233f:	6a 44                	push   $0x44
  jmp __alltraps
  102341:	e9 7f fd ff ff       	jmp    1020c5 <__alltraps>

00102346 <vector69>:
.globl vector69
vector69:
  pushl $0
  102346:	6a 00                	push   $0x0
  pushl $69
  102348:	6a 45                	push   $0x45
  jmp __alltraps
  10234a:	e9 76 fd ff ff       	jmp    1020c5 <__alltraps>

0010234f <vector70>:
.globl vector70
vector70:
  pushl $0
  10234f:	6a 00                	push   $0x0
  pushl $70
  102351:	6a 46                	push   $0x46
  jmp __alltraps
  102353:	e9 6d fd ff ff       	jmp    1020c5 <__alltraps>

00102358 <vector71>:
.globl vector71
vector71:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $71
  10235a:	6a 47                	push   $0x47
  jmp __alltraps
  10235c:	e9 64 fd ff ff       	jmp    1020c5 <__alltraps>

00102361 <vector72>:
.globl vector72
vector72:
  pushl $0
  102361:	6a 00                	push   $0x0
  pushl $72
  102363:	6a 48                	push   $0x48
  jmp __alltraps
  102365:	e9 5b fd ff ff       	jmp    1020c5 <__alltraps>

0010236a <vector73>:
.globl vector73
vector73:
  pushl $0
  10236a:	6a 00                	push   $0x0
  pushl $73
  10236c:	6a 49                	push   $0x49
  jmp __alltraps
  10236e:	e9 52 fd ff ff       	jmp    1020c5 <__alltraps>

00102373 <vector74>:
.globl vector74
vector74:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $74
  102375:	6a 4a                	push   $0x4a
  jmp __alltraps
  102377:	e9 49 fd ff ff       	jmp    1020c5 <__alltraps>

0010237c <vector75>:
.globl vector75
vector75:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $75
  10237e:	6a 4b                	push   $0x4b
  jmp __alltraps
  102380:	e9 40 fd ff ff       	jmp    1020c5 <__alltraps>

00102385 <vector76>:
.globl vector76
vector76:
  pushl $0
  102385:	6a 00                	push   $0x0
  pushl $76
  102387:	6a 4c                	push   $0x4c
  jmp __alltraps
  102389:	e9 37 fd ff ff       	jmp    1020c5 <__alltraps>

0010238e <vector77>:
.globl vector77
vector77:
  pushl $0
  10238e:	6a 00                	push   $0x0
  pushl $77
  102390:	6a 4d                	push   $0x4d
  jmp __alltraps
  102392:	e9 2e fd ff ff       	jmp    1020c5 <__alltraps>

00102397 <vector78>:
.globl vector78
vector78:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $78
  102399:	6a 4e                	push   $0x4e
  jmp __alltraps
  10239b:	e9 25 fd ff ff       	jmp    1020c5 <__alltraps>

001023a0 <vector79>:
.globl vector79
vector79:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $79
  1023a2:	6a 4f                	push   $0x4f
  jmp __alltraps
  1023a4:	e9 1c fd ff ff       	jmp    1020c5 <__alltraps>

001023a9 <vector80>:
.globl vector80
vector80:
  pushl $0
  1023a9:	6a 00                	push   $0x0
  pushl $80
  1023ab:	6a 50                	push   $0x50
  jmp __alltraps
  1023ad:	e9 13 fd ff ff       	jmp    1020c5 <__alltraps>

001023b2 <vector81>:
.globl vector81
vector81:
  pushl $0
  1023b2:	6a 00                	push   $0x0
  pushl $81
  1023b4:	6a 51                	push   $0x51
  jmp __alltraps
  1023b6:	e9 0a fd ff ff       	jmp    1020c5 <__alltraps>

001023bb <vector82>:
.globl vector82
vector82:
  pushl $0
  1023bb:	6a 00                	push   $0x0
  pushl $82
  1023bd:	6a 52                	push   $0x52
  jmp __alltraps
  1023bf:	e9 01 fd ff ff       	jmp    1020c5 <__alltraps>

001023c4 <vector83>:
.globl vector83
vector83:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $83
  1023c6:	6a 53                	push   $0x53
  jmp __alltraps
  1023c8:	e9 f8 fc ff ff       	jmp    1020c5 <__alltraps>

001023cd <vector84>:
.globl vector84
vector84:
  pushl $0
  1023cd:	6a 00                	push   $0x0
  pushl $84
  1023cf:	6a 54                	push   $0x54
  jmp __alltraps
  1023d1:	e9 ef fc ff ff       	jmp    1020c5 <__alltraps>

001023d6 <vector85>:
.globl vector85
vector85:
  pushl $0
  1023d6:	6a 00                	push   $0x0
  pushl $85
  1023d8:	6a 55                	push   $0x55
  jmp __alltraps
  1023da:	e9 e6 fc ff ff       	jmp    1020c5 <__alltraps>

001023df <vector86>:
.globl vector86
vector86:
  pushl $0
  1023df:	6a 00                	push   $0x0
  pushl $86
  1023e1:	6a 56                	push   $0x56
  jmp __alltraps
  1023e3:	e9 dd fc ff ff       	jmp    1020c5 <__alltraps>

001023e8 <vector87>:
.globl vector87
vector87:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $87
  1023ea:	6a 57                	push   $0x57
  jmp __alltraps
  1023ec:	e9 d4 fc ff ff       	jmp    1020c5 <__alltraps>

001023f1 <vector88>:
.globl vector88
vector88:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $88
  1023f3:	6a 58                	push   $0x58
  jmp __alltraps
  1023f5:	e9 cb fc ff ff       	jmp    1020c5 <__alltraps>

001023fa <vector89>:
.globl vector89
vector89:
  pushl $0
  1023fa:	6a 00                	push   $0x0
  pushl $89
  1023fc:	6a 59                	push   $0x59
  jmp __alltraps
  1023fe:	e9 c2 fc ff ff       	jmp    1020c5 <__alltraps>

00102403 <vector90>:
.globl vector90
vector90:
  pushl $0
  102403:	6a 00                	push   $0x0
  pushl $90
  102405:	6a 5a                	push   $0x5a
  jmp __alltraps
  102407:	e9 b9 fc ff ff       	jmp    1020c5 <__alltraps>

0010240c <vector91>:
.globl vector91
vector91:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $91
  10240e:	6a 5b                	push   $0x5b
  jmp __alltraps
  102410:	e9 b0 fc ff ff       	jmp    1020c5 <__alltraps>

00102415 <vector92>:
.globl vector92
vector92:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $92
  102417:	6a 5c                	push   $0x5c
  jmp __alltraps
  102419:	e9 a7 fc ff ff       	jmp    1020c5 <__alltraps>

0010241e <vector93>:
.globl vector93
vector93:
  pushl $0
  10241e:	6a 00                	push   $0x0
  pushl $93
  102420:	6a 5d                	push   $0x5d
  jmp __alltraps
  102422:	e9 9e fc ff ff       	jmp    1020c5 <__alltraps>

00102427 <vector94>:
.globl vector94
vector94:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $94
  102429:	6a 5e                	push   $0x5e
  jmp __alltraps
  10242b:	e9 95 fc ff ff       	jmp    1020c5 <__alltraps>

00102430 <vector95>:
.globl vector95
vector95:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $95
  102432:	6a 5f                	push   $0x5f
  jmp __alltraps
  102434:	e9 8c fc ff ff       	jmp    1020c5 <__alltraps>

00102439 <vector96>:
.globl vector96
vector96:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $96
  10243b:	6a 60                	push   $0x60
  jmp __alltraps
  10243d:	e9 83 fc ff ff       	jmp    1020c5 <__alltraps>

00102442 <vector97>:
.globl vector97
vector97:
  pushl $0
  102442:	6a 00                	push   $0x0
  pushl $97
  102444:	6a 61                	push   $0x61
  jmp __alltraps
  102446:	e9 7a fc ff ff       	jmp    1020c5 <__alltraps>

0010244b <vector98>:
.globl vector98
vector98:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $98
  10244d:	6a 62                	push   $0x62
  jmp __alltraps
  10244f:	e9 71 fc ff ff       	jmp    1020c5 <__alltraps>

00102454 <vector99>:
.globl vector99
vector99:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $99
  102456:	6a 63                	push   $0x63
  jmp __alltraps
  102458:	e9 68 fc ff ff       	jmp    1020c5 <__alltraps>

0010245d <vector100>:
.globl vector100
vector100:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $100
  10245f:	6a 64                	push   $0x64
  jmp __alltraps
  102461:	e9 5f fc ff ff       	jmp    1020c5 <__alltraps>

00102466 <vector101>:
.globl vector101
vector101:
  pushl $0
  102466:	6a 00                	push   $0x0
  pushl $101
  102468:	6a 65                	push   $0x65
  jmp __alltraps
  10246a:	e9 56 fc ff ff       	jmp    1020c5 <__alltraps>

0010246f <vector102>:
.globl vector102
vector102:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $102
  102471:	6a 66                	push   $0x66
  jmp __alltraps
  102473:	e9 4d fc ff ff       	jmp    1020c5 <__alltraps>

00102478 <vector103>:
.globl vector103
vector103:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $103
  10247a:	6a 67                	push   $0x67
  jmp __alltraps
  10247c:	e9 44 fc ff ff       	jmp    1020c5 <__alltraps>

00102481 <vector104>:
.globl vector104
vector104:
  pushl $0
  102481:	6a 00                	push   $0x0
  pushl $104
  102483:	6a 68                	push   $0x68
  jmp __alltraps
  102485:	e9 3b fc ff ff       	jmp    1020c5 <__alltraps>

0010248a <vector105>:
.globl vector105
vector105:
  pushl $0
  10248a:	6a 00                	push   $0x0
  pushl $105
  10248c:	6a 69                	push   $0x69
  jmp __alltraps
  10248e:	e9 32 fc ff ff       	jmp    1020c5 <__alltraps>

00102493 <vector106>:
.globl vector106
vector106:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $106
  102495:	6a 6a                	push   $0x6a
  jmp __alltraps
  102497:	e9 29 fc ff ff       	jmp    1020c5 <__alltraps>

0010249c <vector107>:
.globl vector107
vector107:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $107
  10249e:	6a 6b                	push   $0x6b
  jmp __alltraps
  1024a0:	e9 20 fc ff ff       	jmp    1020c5 <__alltraps>

001024a5 <vector108>:
.globl vector108
vector108:
  pushl $0
  1024a5:	6a 00                	push   $0x0
  pushl $108
  1024a7:	6a 6c                	push   $0x6c
  jmp __alltraps
  1024a9:	e9 17 fc ff ff       	jmp    1020c5 <__alltraps>

001024ae <vector109>:
.globl vector109
vector109:
  pushl $0
  1024ae:	6a 00                	push   $0x0
  pushl $109
  1024b0:	6a 6d                	push   $0x6d
  jmp __alltraps
  1024b2:	e9 0e fc ff ff       	jmp    1020c5 <__alltraps>

001024b7 <vector110>:
.globl vector110
vector110:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $110
  1024b9:	6a 6e                	push   $0x6e
  jmp __alltraps
  1024bb:	e9 05 fc ff ff       	jmp    1020c5 <__alltraps>

001024c0 <vector111>:
.globl vector111
vector111:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $111
  1024c2:	6a 6f                	push   $0x6f
  jmp __alltraps
  1024c4:	e9 fc fb ff ff       	jmp    1020c5 <__alltraps>

001024c9 <vector112>:
.globl vector112
vector112:
  pushl $0
  1024c9:	6a 00                	push   $0x0
  pushl $112
  1024cb:	6a 70                	push   $0x70
  jmp __alltraps
  1024cd:	e9 f3 fb ff ff       	jmp    1020c5 <__alltraps>

001024d2 <vector113>:
.globl vector113
vector113:
  pushl $0
  1024d2:	6a 00                	push   $0x0
  pushl $113
  1024d4:	6a 71                	push   $0x71
  jmp __alltraps
  1024d6:	e9 ea fb ff ff       	jmp    1020c5 <__alltraps>

001024db <vector114>:
.globl vector114
vector114:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $114
  1024dd:	6a 72                	push   $0x72
  jmp __alltraps
  1024df:	e9 e1 fb ff ff       	jmp    1020c5 <__alltraps>

001024e4 <vector115>:
.globl vector115
vector115:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $115
  1024e6:	6a 73                	push   $0x73
  jmp __alltraps
  1024e8:	e9 d8 fb ff ff       	jmp    1020c5 <__alltraps>

001024ed <vector116>:
.globl vector116
vector116:
  pushl $0
  1024ed:	6a 00                	push   $0x0
  pushl $116
  1024ef:	6a 74                	push   $0x74
  jmp __alltraps
  1024f1:	e9 cf fb ff ff       	jmp    1020c5 <__alltraps>

001024f6 <vector117>:
.globl vector117
vector117:
  pushl $0
  1024f6:	6a 00                	push   $0x0
  pushl $117
  1024f8:	6a 75                	push   $0x75
  jmp __alltraps
  1024fa:	e9 c6 fb ff ff       	jmp    1020c5 <__alltraps>

001024ff <vector118>:
.globl vector118
vector118:
  pushl $0
  1024ff:	6a 00                	push   $0x0
  pushl $118
  102501:	6a 76                	push   $0x76
  jmp __alltraps
  102503:	e9 bd fb ff ff       	jmp    1020c5 <__alltraps>

00102508 <vector119>:
.globl vector119
vector119:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $119
  10250a:	6a 77                	push   $0x77
  jmp __alltraps
  10250c:	e9 b4 fb ff ff       	jmp    1020c5 <__alltraps>

00102511 <vector120>:
.globl vector120
vector120:
  pushl $0
  102511:	6a 00                	push   $0x0
  pushl $120
  102513:	6a 78                	push   $0x78
  jmp __alltraps
  102515:	e9 ab fb ff ff       	jmp    1020c5 <__alltraps>

0010251a <vector121>:
.globl vector121
vector121:
  pushl $0
  10251a:	6a 00                	push   $0x0
  pushl $121
  10251c:	6a 79                	push   $0x79
  jmp __alltraps
  10251e:	e9 a2 fb ff ff       	jmp    1020c5 <__alltraps>

00102523 <vector122>:
.globl vector122
vector122:
  pushl $0
  102523:	6a 00                	push   $0x0
  pushl $122
  102525:	6a 7a                	push   $0x7a
  jmp __alltraps
  102527:	e9 99 fb ff ff       	jmp    1020c5 <__alltraps>

0010252c <vector123>:
.globl vector123
vector123:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $123
  10252e:	6a 7b                	push   $0x7b
  jmp __alltraps
  102530:	e9 90 fb ff ff       	jmp    1020c5 <__alltraps>

00102535 <vector124>:
.globl vector124
vector124:
  pushl $0
  102535:	6a 00                	push   $0x0
  pushl $124
  102537:	6a 7c                	push   $0x7c
  jmp __alltraps
  102539:	e9 87 fb ff ff       	jmp    1020c5 <__alltraps>

0010253e <vector125>:
.globl vector125
vector125:
  pushl $0
  10253e:	6a 00                	push   $0x0
  pushl $125
  102540:	6a 7d                	push   $0x7d
  jmp __alltraps
  102542:	e9 7e fb ff ff       	jmp    1020c5 <__alltraps>

00102547 <vector126>:
.globl vector126
vector126:
  pushl $0
  102547:	6a 00                	push   $0x0
  pushl $126
  102549:	6a 7e                	push   $0x7e
  jmp __alltraps
  10254b:	e9 75 fb ff ff       	jmp    1020c5 <__alltraps>

00102550 <vector127>:
.globl vector127
vector127:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $127
  102552:	6a 7f                	push   $0x7f
  jmp __alltraps
  102554:	e9 6c fb ff ff       	jmp    1020c5 <__alltraps>

00102559 <vector128>:
.globl vector128
vector128:
  pushl $0
  102559:	6a 00                	push   $0x0
  pushl $128
  10255b:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102560:	e9 60 fb ff ff       	jmp    1020c5 <__alltraps>

00102565 <vector129>:
.globl vector129
vector129:
  pushl $0
  102565:	6a 00                	push   $0x0
  pushl $129
  102567:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10256c:	e9 54 fb ff ff       	jmp    1020c5 <__alltraps>

00102571 <vector130>:
.globl vector130
vector130:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $130
  102573:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102578:	e9 48 fb ff ff       	jmp    1020c5 <__alltraps>

0010257d <vector131>:
.globl vector131
vector131:
  pushl $0
  10257d:	6a 00                	push   $0x0
  pushl $131
  10257f:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102584:	e9 3c fb ff ff       	jmp    1020c5 <__alltraps>

00102589 <vector132>:
.globl vector132
vector132:
  pushl $0
  102589:	6a 00                	push   $0x0
  pushl $132
  10258b:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102590:	e9 30 fb ff ff       	jmp    1020c5 <__alltraps>

00102595 <vector133>:
.globl vector133
vector133:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $133
  102597:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10259c:	e9 24 fb ff ff       	jmp    1020c5 <__alltraps>

001025a1 <vector134>:
.globl vector134
vector134:
  pushl $0
  1025a1:	6a 00                	push   $0x0
  pushl $134
  1025a3:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1025a8:	e9 18 fb ff ff       	jmp    1020c5 <__alltraps>

001025ad <vector135>:
.globl vector135
vector135:
  pushl $0
  1025ad:	6a 00                	push   $0x0
  pushl $135
  1025af:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1025b4:	e9 0c fb ff ff       	jmp    1020c5 <__alltraps>

001025b9 <vector136>:
.globl vector136
vector136:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $136
  1025bb:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1025c0:	e9 00 fb ff ff       	jmp    1020c5 <__alltraps>

001025c5 <vector137>:
.globl vector137
vector137:
  pushl $0
  1025c5:	6a 00                	push   $0x0
  pushl $137
  1025c7:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1025cc:	e9 f4 fa ff ff       	jmp    1020c5 <__alltraps>

001025d1 <vector138>:
.globl vector138
vector138:
  pushl $0
  1025d1:	6a 00                	push   $0x0
  pushl $138
  1025d3:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1025d8:	e9 e8 fa ff ff       	jmp    1020c5 <__alltraps>

001025dd <vector139>:
.globl vector139
vector139:
  pushl $0
  1025dd:	6a 00                	push   $0x0
  pushl $139
  1025df:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1025e4:	e9 dc fa ff ff       	jmp    1020c5 <__alltraps>

001025e9 <vector140>:
.globl vector140
vector140:
  pushl $0
  1025e9:	6a 00                	push   $0x0
  pushl $140
  1025eb:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1025f0:	e9 d0 fa ff ff       	jmp    1020c5 <__alltraps>

001025f5 <vector141>:
.globl vector141
vector141:
  pushl $0
  1025f5:	6a 00                	push   $0x0
  pushl $141
  1025f7:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1025fc:	e9 c4 fa ff ff       	jmp    1020c5 <__alltraps>

00102601 <vector142>:
.globl vector142
vector142:
  pushl $0
  102601:	6a 00                	push   $0x0
  pushl $142
  102603:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102608:	e9 b8 fa ff ff       	jmp    1020c5 <__alltraps>

0010260d <vector143>:
.globl vector143
vector143:
  pushl $0
  10260d:	6a 00                	push   $0x0
  pushl $143
  10260f:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102614:	e9 ac fa ff ff       	jmp    1020c5 <__alltraps>

00102619 <vector144>:
.globl vector144
vector144:
  pushl $0
  102619:	6a 00                	push   $0x0
  pushl $144
  10261b:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102620:	e9 a0 fa ff ff       	jmp    1020c5 <__alltraps>

00102625 <vector145>:
.globl vector145
vector145:
  pushl $0
  102625:	6a 00                	push   $0x0
  pushl $145
  102627:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10262c:	e9 94 fa ff ff       	jmp    1020c5 <__alltraps>

00102631 <vector146>:
.globl vector146
vector146:
  pushl $0
  102631:	6a 00                	push   $0x0
  pushl $146
  102633:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102638:	e9 88 fa ff ff       	jmp    1020c5 <__alltraps>

0010263d <vector147>:
.globl vector147
vector147:
  pushl $0
  10263d:	6a 00                	push   $0x0
  pushl $147
  10263f:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102644:	e9 7c fa ff ff       	jmp    1020c5 <__alltraps>

00102649 <vector148>:
.globl vector148
vector148:
  pushl $0
  102649:	6a 00                	push   $0x0
  pushl $148
  10264b:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102650:	e9 70 fa ff ff       	jmp    1020c5 <__alltraps>

00102655 <vector149>:
.globl vector149
vector149:
  pushl $0
  102655:	6a 00                	push   $0x0
  pushl $149
  102657:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10265c:	e9 64 fa ff ff       	jmp    1020c5 <__alltraps>

00102661 <vector150>:
.globl vector150
vector150:
  pushl $0
  102661:	6a 00                	push   $0x0
  pushl $150
  102663:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102668:	e9 58 fa ff ff       	jmp    1020c5 <__alltraps>

0010266d <vector151>:
.globl vector151
vector151:
  pushl $0
  10266d:	6a 00                	push   $0x0
  pushl $151
  10266f:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102674:	e9 4c fa ff ff       	jmp    1020c5 <__alltraps>

00102679 <vector152>:
.globl vector152
vector152:
  pushl $0
  102679:	6a 00                	push   $0x0
  pushl $152
  10267b:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102680:	e9 40 fa ff ff       	jmp    1020c5 <__alltraps>

00102685 <vector153>:
.globl vector153
vector153:
  pushl $0
  102685:	6a 00                	push   $0x0
  pushl $153
  102687:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10268c:	e9 34 fa ff ff       	jmp    1020c5 <__alltraps>

00102691 <vector154>:
.globl vector154
vector154:
  pushl $0
  102691:	6a 00                	push   $0x0
  pushl $154
  102693:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102698:	e9 28 fa ff ff       	jmp    1020c5 <__alltraps>

0010269d <vector155>:
.globl vector155
vector155:
  pushl $0
  10269d:	6a 00                	push   $0x0
  pushl $155
  10269f:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1026a4:	e9 1c fa ff ff       	jmp    1020c5 <__alltraps>

001026a9 <vector156>:
.globl vector156
vector156:
  pushl $0
  1026a9:	6a 00                	push   $0x0
  pushl $156
  1026ab:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1026b0:	e9 10 fa ff ff       	jmp    1020c5 <__alltraps>

001026b5 <vector157>:
.globl vector157
vector157:
  pushl $0
  1026b5:	6a 00                	push   $0x0
  pushl $157
  1026b7:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1026bc:	e9 04 fa ff ff       	jmp    1020c5 <__alltraps>

001026c1 <vector158>:
.globl vector158
vector158:
  pushl $0
  1026c1:	6a 00                	push   $0x0
  pushl $158
  1026c3:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1026c8:	e9 f8 f9 ff ff       	jmp    1020c5 <__alltraps>

001026cd <vector159>:
.globl vector159
vector159:
  pushl $0
  1026cd:	6a 00                	push   $0x0
  pushl $159
  1026cf:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1026d4:	e9 ec f9 ff ff       	jmp    1020c5 <__alltraps>

001026d9 <vector160>:
.globl vector160
vector160:
  pushl $0
  1026d9:	6a 00                	push   $0x0
  pushl $160
  1026db:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1026e0:	e9 e0 f9 ff ff       	jmp    1020c5 <__alltraps>

001026e5 <vector161>:
.globl vector161
vector161:
  pushl $0
  1026e5:	6a 00                	push   $0x0
  pushl $161
  1026e7:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1026ec:	e9 d4 f9 ff ff       	jmp    1020c5 <__alltraps>

001026f1 <vector162>:
.globl vector162
vector162:
  pushl $0
  1026f1:	6a 00                	push   $0x0
  pushl $162
  1026f3:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1026f8:	e9 c8 f9 ff ff       	jmp    1020c5 <__alltraps>

001026fd <vector163>:
.globl vector163
vector163:
  pushl $0
  1026fd:	6a 00                	push   $0x0
  pushl $163
  1026ff:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102704:	e9 bc f9 ff ff       	jmp    1020c5 <__alltraps>

00102709 <vector164>:
.globl vector164
vector164:
  pushl $0
  102709:	6a 00                	push   $0x0
  pushl $164
  10270b:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102710:	e9 b0 f9 ff ff       	jmp    1020c5 <__alltraps>

00102715 <vector165>:
.globl vector165
vector165:
  pushl $0
  102715:	6a 00                	push   $0x0
  pushl $165
  102717:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  10271c:	e9 a4 f9 ff ff       	jmp    1020c5 <__alltraps>

00102721 <vector166>:
.globl vector166
vector166:
  pushl $0
  102721:	6a 00                	push   $0x0
  pushl $166
  102723:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102728:	e9 98 f9 ff ff       	jmp    1020c5 <__alltraps>

0010272d <vector167>:
.globl vector167
vector167:
  pushl $0
  10272d:	6a 00                	push   $0x0
  pushl $167
  10272f:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102734:	e9 8c f9 ff ff       	jmp    1020c5 <__alltraps>

00102739 <vector168>:
.globl vector168
vector168:
  pushl $0
  102739:	6a 00                	push   $0x0
  pushl $168
  10273b:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102740:	e9 80 f9 ff ff       	jmp    1020c5 <__alltraps>

00102745 <vector169>:
.globl vector169
vector169:
  pushl $0
  102745:	6a 00                	push   $0x0
  pushl $169
  102747:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10274c:	e9 74 f9 ff ff       	jmp    1020c5 <__alltraps>

00102751 <vector170>:
.globl vector170
vector170:
  pushl $0
  102751:	6a 00                	push   $0x0
  pushl $170
  102753:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102758:	e9 68 f9 ff ff       	jmp    1020c5 <__alltraps>

0010275d <vector171>:
.globl vector171
vector171:
  pushl $0
  10275d:	6a 00                	push   $0x0
  pushl $171
  10275f:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102764:	e9 5c f9 ff ff       	jmp    1020c5 <__alltraps>

00102769 <vector172>:
.globl vector172
vector172:
  pushl $0
  102769:	6a 00                	push   $0x0
  pushl $172
  10276b:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102770:	e9 50 f9 ff ff       	jmp    1020c5 <__alltraps>

00102775 <vector173>:
.globl vector173
vector173:
  pushl $0
  102775:	6a 00                	push   $0x0
  pushl $173
  102777:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10277c:	e9 44 f9 ff ff       	jmp    1020c5 <__alltraps>

00102781 <vector174>:
.globl vector174
vector174:
  pushl $0
  102781:	6a 00                	push   $0x0
  pushl $174
  102783:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102788:	e9 38 f9 ff ff       	jmp    1020c5 <__alltraps>

0010278d <vector175>:
.globl vector175
vector175:
  pushl $0
  10278d:	6a 00                	push   $0x0
  pushl $175
  10278f:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102794:	e9 2c f9 ff ff       	jmp    1020c5 <__alltraps>

00102799 <vector176>:
.globl vector176
vector176:
  pushl $0
  102799:	6a 00                	push   $0x0
  pushl $176
  10279b:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1027a0:	e9 20 f9 ff ff       	jmp    1020c5 <__alltraps>

001027a5 <vector177>:
.globl vector177
vector177:
  pushl $0
  1027a5:	6a 00                	push   $0x0
  pushl $177
  1027a7:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1027ac:	e9 14 f9 ff ff       	jmp    1020c5 <__alltraps>

001027b1 <vector178>:
.globl vector178
vector178:
  pushl $0
  1027b1:	6a 00                	push   $0x0
  pushl $178
  1027b3:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1027b8:	e9 08 f9 ff ff       	jmp    1020c5 <__alltraps>

001027bd <vector179>:
.globl vector179
vector179:
  pushl $0
  1027bd:	6a 00                	push   $0x0
  pushl $179
  1027bf:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1027c4:	e9 fc f8 ff ff       	jmp    1020c5 <__alltraps>

001027c9 <vector180>:
.globl vector180
vector180:
  pushl $0
  1027c9:	6a 00                	push   $0x0
  pushl $180
  1027cb:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1027d0:	e9 f0 f8 ff ff       	jmp    1020c5 <__alltraps>

001027d5 <vector181>:
.globl vector181
vector181:
  pushl $0
  1027d5:	6a 00                	push   $0x0
  pushl $181
  1027d7:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1027dc:	e9 e4 f8 ff ff       	jmp    1020c5 <__alltraps>

001027e1 <vector182>:
.globl vector182
vector182:
  pushl $0
  1027e1:	6a 00                	push   $0x0
  pushl $182
  1027e3:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1027e8:	e9 d8 f8 ff ff       	jmp    1020c5 <__alltraps>

001027ed <vector183>:
.globl vector183
vector183:
  pushl $0
  1027ed:	6a 00                	push   $0x0
  pushl $183
  1027ef:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1027f4:	e9 cc f8 ff ff       	jmp    1020c5 <__alltraps>

001027f9 <vector184>:
.globl vector184
vector184:
  pushl $0
  1027f9:	6a 00                	push   $0x0
  pushl $184
  1027fb:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102800:	e9 c0 f8 ff ff       	jmp    1020c5 <__alltraps>

00102805 <vector185>:
.globl vector185
vector185:
  pushl $0
  102805:	6a 00                	push   $0x0
  pushl $185
  102807:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  10280c:	e9 b4 f8 ff ff       	jmp    1020c5 <__alltraps>

00102811 <vector186>:
.globl vector186
vector186:
  pushl $0
  102811:	6a 00                	push   $0x0
  pushl $186
  102813:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102818:	e9 a8 f8 ff ff       	jmp    1020c5 <__alltraps>

0010281d <vector187>:
.globl vector187
vector187:
  pushl $0
  10281d:	6a 00                	push   $0x0
  pushl $187
  10281f:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102824:	e9 9c f8 ff ff       	jmp    1020c5 <__alltraps>

00102829 <vector188>:
.globl vector188
vector188:
  pushl $0
  102829:	6a 00                	push   $0x0
  pushl $188
  10282b:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102830:	e9 90 f8 ff ff       	jmp    1020c5 <__alltraps>

00102835 <vector189>:
.globl vector189
vector189:
  pushl $0
  102835:	6a 00                	push   $0x0
  pushl $189
  102837:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10283c:	e9 84 f8 ff ff       	jmp    1020c5 <__alltraps>

00102841 <vector190>:
.globl vector190
vector190:
  pushl $0
  102841:	6a 00                	push   $0x0
  pushl $190
  102843:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102848:	e9 78 f8 ff ff       	jmp    1020c5 <__alltraps>

0010284d <vector191>:
.globl vector191
vector191:
  pushl $0
  10284d:	6a 00                	push   $0x0
  pushl $191
  10284f:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102854:	e9 6c f8 ff ff       	jmp    1020c5 <__alltraps>

00102859 <vector192>:
.globl vector192
vector192:
  pushl $0
  102859:	6a 00                	push   $0x0
  pushl $192
  10285b:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102860:	e9 60 f8 ff ff       	jmp    1020c5 <__alltraps>

00102865 <vector193>:
.globl vector193
vector193:
  pushl $0
  102865:	6a 00                	push   $0x0
  pushl $193
  102867:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10286c:	e9 54 f8 ff ff       	jmp    1020c5 <__alltraps>

00102871 <vector194>:
.globl vector194
vector194:
  pushl $0
  102871:	6a 00                	push   $0x0
  pushl $194
  102873:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102878:	e9 48 f8 ff ff       	jmp    1020c5 <__alltraps>

0010287d <vector195>:
.globl vector195
vector195:
  pushl $0
  10287d:	6a 00                	push   $0x0
  pushl $195
  10287f:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102884:	e9 3c f8 ff ff       	jmp    1020c5 <__alltraps>

00102889 <vector196>:
.globl vector196
vector196:
  pushl $0
  102889:	6a 00                	push   $0x0
  pushl $196
  10288b:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102890:	e9 30 f8 ff ff       	jmp    1020c5 <__alltraps>

00102895 <vector197>:
.globl vector197
vector197:
  pushl $0
  102895:	6a 00                	push   $0x0
  pushl $197
  102897:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10289c:	e9 24 f8 ff ff       	jmp    1020c5 <__alltraps>

001028a1 <vector198>:
.globl vector198
vector198:
  pushl $0
  1028a1:	6a 00                	push   $0x0
  pushl $198
  1028a3:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1028a8:	e9 18 f8 ff ff       	jmp    1020c5 <__alltraps>

001028ad <vector199>:
.globl vector199
vector199:
  pushl $0
  1028ad:	6a 00                	push   $0x0
  pushl $199
  1028af:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1028b4:	e9 0c f8 ff ff       	jmp    1020c5 <__alltraps>

001028b9 <vector200>:
.globl vector200
vector200:
  pushl $0
  1028b9:	6a 00                	push   $0x0
  pushl $200
  1028bb:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1028c0:	e9 00 f8 ff ff       	jmp    1020c5 <__alltraps>

001028c5 <vector201>:
.globl vector201
vector201:
  pushl $0
  1028c5:	6a 00                	push   $0x0
  pushl $201
  1028c7:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1028cc:	e9 f4 f7 ff ff       	jmp    1020c5 <__alltraps>

001028d1 <vector202>:
.globl vector202
vector202:
  pushl $0
  1028d1:	6a 00                	push   $0x0
  pushl $202
  1028d3:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1028d8:	e9 e8 f7 ff ff       	jmp    1020c5 <__alltraps>

001028dd <vector203>:
.globl vector203
vector203:
  pushl $0
  1028dd:	6a 00                	push   $0x0
  pushl $203
  1028df:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1028e4:	e9 dc f7 ff ff       	jmp    1020c5 <__alltraps>

001028e9 <vector204>:
.globl vector204
vector204:
  pushl $0
  1028e9:	6a 00                	push   $0x0
  pushl $204
  1028eb:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1028f0:	e9 d0 f7 ff ff       	jmp    1020c5 <__alltraps>

001028f5 <vector205>:
.globl vector205
vector205:
  pushl $0
  1028f5:	6a 00                	push   $0x0
  pushl $205
  1028f7:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1028fc:	e9 c4 f7 ff ff       	jmp    1020c5 <__alltraps>

00102901 <vector206>:
.globl vector206
vector206:
  pushl $0
  102901:	6a 00                	push   $0x0
  pushl $206
  102903:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102908:	e9 b8 f7 ff ff       	jmp    1020c5 <__alltraps>

0010290d <vector207>:
.globl vector207
vector207:
  pushl $0
  10290d:	6a 00                	push   $0x0
  pushl $207
  10290f:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102914:	e9 ac f7 ff ff       	jmp    1020c5 <__alltraps>

00102919 <vector208>:
.globl vector208
vector208:
  pushl $0
  102919:	6a 00                	push   $0x0
  pushl $208
  10291b:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102920:	e9 a0 f7 ff ff       	jmp    1020c5 <__alltraps>

00102925 <vector209>:
.globl vector209
vector209:
  pushl $0
  102925:	6a 00                	push   $0x0
  pushl $209
  102927:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10292c:	e9 94 f7 ff ff       	jmp    1020c5 <__alltraps>

00102931 <vector210>:
.globl vector210
vector210:
  pushl $0
  102931:	6a 00                	push   $0x0
  pushl $210
  102933:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102938:	e9 88 f7 ff ff       	jmp    1020c5 <__alltraps>

0010293d <vector211>:
.globl vector211
vector211:
  pushl $0
  10293d:	6a 00                	push   $0x0
  pushl $211
  10293f:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102944:	e9 7c f7 ff ff       	jmp    1020c5 <__alltraps>

00102949 <vector212>:
.globl vector212
vector212:
  pushl $0
  102949:	6a 00                	push   $0x0
  pushl $212
  10294b:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102950:	e9 70 f7 ff ff       	jmp    1020c5 <__alltraps>

00102955 <vector213>:
.globl vector213
vector213:
  pushl $0
  102955:	6a 00                	push   $0x0
  pushl $213
  102957:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10295c:	e9 64 f7 ff ff       	jmp    1020c5 <__alltraps>

00102961 <vector214>:
.globl vector214
vector214:
  pushl $0
  102961:	6a 00                	push   $0x0
  pushl $214
  102963:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102968:	e9 58 f7 ff ff       	jmp    1020c5 <__alltraps>

0010296d <vector215>:
.globl vector215
vector215:
  pushl $0
  10296d:	6a 00                	push   $0x0
  pushl $215
  10296f:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102974:	e9 4c f7 ff ff       	jmp    1020c5 <__alltraps>

00102979 <vector216>:
.globl vector216
vector216:
  pushl $0
  102979:	6a 00                	push   $0x0
  pushl $216
  10297b:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102980:	e9 40 f7 ff ff       	jmp    1020c5 <__alltraps>

00102985 <vector217>:
.globl vector217
vector217:
  pushl $0
  102985:	6a 00                	push   $0x0
  pushl $217
  102987:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10298c:	e9 34 f7 ff ff       	jmp    1020c5 <__alltraps>

00102991 <vector218>:
.globl vector218
vector218:
  pushl $0
  102991:	6a 00                	push   $0x0
  pushl $218
  102993:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102998:	e9 28 f7 ff ff       	jmp    1020c5 <__alltraps>

0010299d <vector219>:
.globl vector219
vector219:
  pushl $0
  10299d:	6a 00                	push   $0x0
  pushl $219
  10299f:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1029a4:	e9 1c f7 ff ff       	jmp    1020c5 <__alltraps>

001029a9 <vector220>:
.globl vector220
vector220:
  pushl $0
  1029a9:	6a 00                	push   $0x0
  pushl $220
  1029ab:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1029b0:	e9 10 f7 ff ff       	jmp    1020c5 <__alltraps>

001029b5 <vector221>:
.globl vector221
vector221:
  pushl $0
  1029b5:	6a 00                	push   $0x0
  pushl $221
  1029b7:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1029bc:	e9 04 f7 ff ff       	jmp    1020c5 <__alltraps>

001029c1 <vector222>:
.globl vector222
vector222:
  pushl $0
  1029c1:	6a 00                	push   $0x0
  pushl $222
  1029c3:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1029c8:	e9 f8 f6 ff ff       	jmp    1020c5 <__alltraps>

001029cd <vector223>:
.globl vector223
vector223:
  pushl $0
  1029cd:	6a 00                	push   $0x0
  pushl $223
  1029cf:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1029d4:	e9 ec f6 ff ff       	jmp    1020c5 <__alltraps>

001029d9 <vector224>:
.globl vector224
vector224:
  pushl $0
  1029d9:	6a 00                	push   $0x0
  pushl $224
  1029db:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1029e0:	e9 e0 f6 ff ff       	jmp    1020c5 <__alltraps>

001029e5 <vector225>:
.globl vector225
vector225:
  pushl $0
  1029e5:	6a 00                	push   $0x0
  pushl $225
  1029e7:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1029ec:	e9 d4 f6 ff ff       	jmp    1020c5 <__alltraps>

001029f1 <vector226>:
.globl vector226
vector226:
  pushl $0
  1029f1:	6a 00                	push   $0x0
  pushl $226
  1029f3:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1029f8:	e9 c8 f6 ff ff       	jmp    1020c5 <__alltraps>

001029fd <vector227>:
.globl vector227
vector227:
  pushl $0
  1029fd:	6a 00                	push   $0x0
  pushl $227
  1029ff:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102a04:	e9 bc f6 ff ff       	jmp    1020c5 <__alltraps>

00102a09 <vector228>:
.globl vector228
vector228:
  pushl $0
  102a09:	6a 00                	push   $0x0
  pushl $228
  102a0b:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102a10:	e9 b0 f6 ff ff       	jmp    1020c5 <__alltraps>

00102a15 <vector229>:
.globl vector229
vector229:
  pushl $0
  102a15:	6a 00                	push   $0x0
  pushl $229
  102a17:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102a1c:	e9 a4 f6 ff ff       	jmp    1020c5 <__alltraps>

00102a21 <vector230>:
.globl vector230
vector230:
  pushl $0
  102a21:	6a 00                	push   $0x0
  pushl $230
  102a23:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102a28:	e9 98 f6 ff ff       	jmp    1020c5 <__alltraps>

00102a2d <vector231>:
.globl vector231
vector231:
  pushl $0
  102a2d:	6a 00                	push   $0x0
  pushl $231
  102a2f:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102a34:	e9 8c f6 ff ff       	jmp    1020c5 <__alltraps>

00102a39 <vector232>:
.globl vector232
vector232:
  pushl $0
  102a39:	6a 00                	push   $0x0
  pushl $232
  102a3b:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102a40:	e9 80 f6 ff ff       	jmp    1020c5 <__alltraps>

00102a45 <vector233>:
.globl vector233
vector233:
  pushl $0
  102a45:	6a 00                	push   $0x0
  pushl $233
  102a47:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102a4c:	e9 74 f6 ff ff       	jmp    1020c5 <__alltraps>

00102a51 <vector234>:
.globl vector234
vector234:
  pushl $0
  102a51:	6a 00                	push   $0x0
  pushl $234
  102a53:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102a58:	e9 68 f6 ff ff       	jmp    1020c5 <__alltraps>

00102a5d <vector235>:
.globl vector235
vector235:
  pushl $0
  102a5d:	6a 00                	push   $0x0
  pushl $235
  102a5f:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102a64:	e9 5c f6 ff ff       	jmp    1020c5 <__alltraps>

00102a69 <vector236>:
.globl vector236
vector236:
  pushl $0
  102a69:	6a 00                	push   $0x0
  pushl $236
  102a6b:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102a70:	e9 50 f6 ff ff       	jmp    1020c5 <__alltraps>

00102a75 <vector237>:
.globl vector237
vector237:
  pushl $0
  102a75:	6a 00                	push   $0x0
  pushl $237
  102a77:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102a7c:	e9 44 f6 ff ff       	jmp    1020c5 <__alltraps>

00102a81 <vector238>:
.globl vector238
vector238:
  pushl $0
  102a81:	6a 00                	push   $0x0
  pushl $238
  102a83:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102a88:	e9 38 f6 ff ff       	jmp    1020c5 <__alltraps>

00102a8d <vector239>:
.globl vector239
vector239:
  pushl $0
  102a8d:	6a 00                	push   $0x0
  pushl $239
  102a8f:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102a94:	e9 2c f6 ff ff       	jmp    1020c5 <__alltraps>

00102a99 <vector240>:
.globl vector240
vector240:
  pushl $0
  102a99:	6a 00                	push   $0x0
  pushl $240
  102a9b:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102aa0:	e9 20 f6 ff ff       	jmp    1020c5 <__alltraps>

00102aa5 <vector241>:
.globl vector241
vector241:
  pushl $0
  102aa5:	6a 00                	push   $0x0
  pushl $241
  102aa7:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102aac:	e9 14 f6 ff ff       	jmp    1020c5 <__alltraps>

00102ab1 <vector242>:
.globl vector242
vector242:
  pushl $0
  102ab1:	6a 00                	push   $0x0
  pushl $242
  102ab3:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102ab8:	e9 08 f6 ff ff       	jmp    1020c5 <__alltraps>

00102abd <vector243>:
.globl vector243
vector243:
  pushl $0
  102abd:	6a 00                	push   $0x0
  pushl $243
  102abf:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102ac4:	e9 fc f5 ff ff       	jmp    1020c5 <__alltraps>

00102ac9 <vector244>:
.globl vector244
vector244:
  pushl $0
  102ac9:	6a 00                	push   $0x0
  pushl $244
  102acb:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102ad0:	e9 f0 f5 ff ff       	jmp    1020c5 <__alltraps>

00102ad5 <vector245>:
.globl vector245
vector245:
  pushl $0
  102ad5:	6a 00                	push   $0x0
  pushl $245
  102ad7:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102adc:	e9 e4 f5 ff ff       	jmp    1020c5 <__alltraps>

00102ae1 <vector246>:
.globl vector246
vector246:
  pushl $0
  102ae1:	6a 00                	push   $0x0
  pushl $246
  102ae3:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102ae8:	e9 d8 f5 ff ff       	jmp    1020c5 <__alltraps>

00102aed <vector247>:
.globl vector247
vector247:
  pushl $0
  102aed:	6a 00                	push   $0x0
  pushl $247
  102aef:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102af4:	e9 cc f5 ff ff       	jmp    1020c5 <__alltraps>

00102af9 <vector248>:
.globl vector248
vector248:
  pushl $0
  102af9:	6a 00                	push   $0x0
  pushl $248
  102afb:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102b00:	e9 c0 f5 ff ff       	jmp    1020c5 <__alltraps>

00102b05 <vector249>:
.globl vector249
vector249:
  pushl $0
  102b05:	6a 00                	push   $0x0
  pushl $249
  102b07:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102b0c:	e9 b4 f5 ff ff       	jmp    1020c5 <__alltraps>

00102b11 <vector250>:
.globl vector250
vector250:
  pushl $0
  102b11:	6a 00                	push   $0x0
  pushl $250
  102b13:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102b18:	e9 a8 f5 ff ff       	jmp    1020c5 <__alltraps>

00102b1d <vector251>:
.globl vector251
vector251:
  pushl $0
  102b1d:	6a 00                	push   $0x0
  pushl $251
  102b1f:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102b24:	e9 9c f5 ff ff       	jmp    1020c5 <__alltraps>

00102b29 <vector252>:
.globl vector252
vector252:
  pushl $0
  102b29:	6a 00                	push   $0x0
  pushl $252
  102b2b:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102b30:	e9 90 f5 ff ff       	jmp    1020c5 <__alltraps>

00102b35 <vector253>:
.globl vector253
vector253:
  pushl $0
  102b35:	6a 00                	push   $0x0
  pushl $253
  102b37:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102b3c:	e9 84 f5 ff ff       	jmp    1020c5 <__alltraps>

00102b41 <vector254>:
.globl vector254
vector254:
  pushl $0
  102b41:	6a 00                	push   $0x0
  pushl $254
  102b43:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102b48:	e9 78 f5 ff ff       	jmp    1020c5 <__alltraps>

00102b4d <vector255>:
.globl vector255
vector255:
  pushl $0
  102b4d:	6a 00                	push   $0x0
  pushl $255
  102b4f:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102b54:	e9 6c f5 ff ff       	jmp    1020c5 <__alltraps>

00102b59 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102b59:	55                   	push   %ebp
  102b5a:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b5f:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102b62:	b8 23 00 00 00       	mov    $0x23,%eax
  102b67:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102b69:	b8 23 00 00 00       	mov    $0x23,%eax
  102b6e:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102b70:	b8 10 00 00 00       	mov    $0x10,%eax
  102b75:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102b77:	b8 10 00 00 00       	mov    $0x10,%eax
  102b7c:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102b7e:	b8 10 00 00 00       	mov    $0x10,%eax
  102b83:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102b85:	ea 8c 2b 10 00 08 00 	ljmp   $0x8,$0x102b8c
}
  102b8c:	5d                   	pop    %ebp
  102b8d:	c3                   	ret    

00102b8e <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102b8e:	55                   	push   %ebp
  102b8f:	89 e5                	mov    %esp,%ebp
  102b91:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102b94:	b8 e0 f9 10 00       	mov    $0x10f9e0,%eax
  102b99:	05 00 04 00 00       	add    $0x400,%eax
  102b9e:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102ba3:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102baa:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102bac:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102bb3:	68 00 
  102bb5:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102bba:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102bc0:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102bc5:	c1 e8 10             	shr    $0x10,%eax
  102bc8:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102bcd:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102bd4:	83 e0 f0             	and    $0xfffffff0,%eax
  102bd7:	83 c8 09             	or     $0x9,%eax
  102bda:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102bdf:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102be6:	83 c8 10             	or     $0x10,%eax
  102be9:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102bee:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102bf5:	83 e0 9f             	and    $0xffffff9f,%eax
  102bf8:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102bfd:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102c04:	83 c8 80             	or     $0xffffff80,%eax
  102c07:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102c0c:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102c13:	83 e0 f0             	and    $0xfffffff0,%eax
  102c16:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102c1b:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102c22:	83 e0 ef             	and    $0xffffffef,%eax
  102c25:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102c2a:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102c31:	83 e0 df             	and    $0xffffffdf,%eax
  102c34:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102c39:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102c40:	83 c8 40             	or     $0x40,%eax
  102c43:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102c48:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102c4f:	83 e0 7f             	and    $0x7f,%eax
  102c52:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102c57:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102c5c:	c1 e8 18             	shr    $0x18,%eax
  102c5f:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102c64:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102c6b:	83 e0 ef             	and    $0xffffffef,%eax
  102c6e:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102c73:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102c7a:	e8 da fe ff ff       	call   102b59 <lgdt>
  102c7f:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102c85:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102c89:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102c8c:	c9                   	leave  
  102c8d:	c3                   	ret    

00102c8e <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102c8e:	55                   	push   %ebp
  102c8f:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102c91:	e8 f8 fe ff ff       	call   102b8e <gdt_init>
}
  102c96:	5d                   	pop    %ebp
  102c97:	c3                   	ret    

00102c98 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102c98:	55                   	push   %ebp
  102c99:	89 e5                	mov    %esp,%ebp
  102c9b:	83 ec 58             	sub    $0x58,%esp
  102c9e:	8b 45 10             	mov    0x10(%ebp),%eax
  102ca1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ca4:	8b 45 14             	mov    0x14(%ebp),%eax
  102ca7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102caa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102cad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102cb0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102cb3:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102cb6:	8b 45 18             	mov    0x18(%ebp),%eax
  102cb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102cbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102cbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102cc2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102cc5:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ccb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102cd2:	74 1c                	je     102cf0 <printnum+0x58>
  102cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cd7:	ba 00 00 00 00       	mov    $0x0,%edx
  102cdc:	f7 75 e4             	divl   -0x1c(%ebp)
  102cdf:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ce5:	ba 00 00 00 00       	mov    $0x0,%edx
  102cea:	f7 75 e4             	divl   -0x1c(%ebp)
  102ced:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cf0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cf3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cf6:	f7 75 e4             	divl   -0x1c(%ebp)
  102cf9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102cfc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102cff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d02:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102d05:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d08:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102d0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d0e:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102d11:	8b 45 18             	mov    0x18(%ebp),%eax
  102d14:	ba 00 00 00 00       	mov    $0x0,%edx
  102d19:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102d1c:	77 56                	ja     102d74 <printnum+0xdc>
  102d1e:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102d21:	72 05                	jb     102d28 <printnum+0x90>
  102d23:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102d26:	77 4c                	ja     102d74 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102d28:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102d2b:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d2e:	8b 45 20             	mov    0x20(%ebp),%eax
  102d31:	89 44 24 18          	mov    %eax,0x18(%esp)
  102d35:	89 54 24 14          	mov    %edx,0x14(%esp)
  102d39:	8b 45 18             	mov    0x18(%ebp),%eax
  102d3c:	89 44 24 10          	mov    %eax,0x10(%esp)
  102d40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d43:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102d46:	89 44 24 08          	mov    %eax,0x8(%esp)
  102d4a:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d51:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d55:	8b 45 08             	mov    0x8(%ebp),%eax
  102d58:	89 04 24             	mov    %eax,(%esp)
  102d5b:	e8 38 ff ff ff       	call   102c98 <printnum>
  102d60:	eb 1c                	jmp    102d7e <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102d62:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d69:	8b 45 20             	mov    0x20(%ebp),%eax
  102d6c:	89 04 24             	mov    %eax,(%esp)
  102d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d72:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102d74:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102d78:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102d7c:	7f e4                	jg     102d62 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102d7e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102d81:	05 d0 3f 10 00       	add    $0x103fd0,%eax
  102d86:	0f b6 00             	movzbl (%eax),%eax
  102d89:	0f be c0             	movsbl %al,%eax
  102d8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d8f:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d93:	89 04 24             	mov    %eax,(%esp)
  102d96:	8b 45 08             	mov    0x8(%ebp),%eax
  102d99:	ff d0                	call   *%eax
}
  102d9b:	c9                   	leave  
  102d9c:	c3                   	ret    

00102d9d <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102d9d:	55                   	push   %ebp
  102d9e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102da0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102da4:	7e 14                	jle    102dba <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102da6:	8b 45 08             	mov    0x8(%ebp),%eax
  102da9:	8b 00                	mov    (%eax),%eax
  102dab:	8d 48 08             	lea    0x8(%eax),%ecx
  102dae:	8b 55 08             	mov    0x8(%ebp),%edx
  102db1:	89 0a                	mov    %ecx,(%edx)
  102db3:	8b 50 04             	mov    0x4(%eax),%edx
  102db6:	8b 00                	mov    (%eax),%eax
  102db8:	eb 30                	jmp    102dea <getuint+0x4d>
    }
    else if (lflag) {
  102dba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102dbe:	74 16                	je     102dd6 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc3:	8b 00                	mov    (%eax),%eax
  102dc5:	8d 48 04             	lea    0x4(%eax),%ecx
  102dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  102dcb:	89 0a                	mov    %ecx,(%edx)
  102dcd:	8b 00                	mov    (%eax),%eax
  102dcf:	ba 00 00 00 00       	mov    $0x0,%edx
  102dd4:	eb 14                	jmp    102dea <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd9:	8b 00                	mov    (%eax),%eax
  102ddb:	8d 48 04             	lea    0x4(%eax),%ecx
  102dde:	8b 55 08             	mov    0x8(%ebp),%edx
  102de1:	89 0a                	mov    %ecx,(%edx)
  102de3:	8b 00                	mov    (%eax),%eax
  102de5:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102dea:	5d                   	pop    %ebp
  102deb:	c3                   	ret    

00102dec <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102dec:	55                   	push   %ebp
  102ded:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102def:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102df3:	7e 14                	jle    102e09 <getint+0x1d>
        return va_arg(*ap, long long);
  102df5:	8b 45 08             	mov    0x8(%ebp),%eax
  102df8:	8b 00                	mov    (%eax),%eax
  102dfa:	8d 48 08             	lea    0x8(%eax),%ecx
  102dfd:	8b 55 08             	mov    0x8(%ebp),%edx
  102e00:	89 0a                	mov    %ecx,(%edx)
  102e02:	8b 50 04             	mov    0x4(%eax),%edx
  102e05:	8b 00                	mov    (%eax),%eax
  102e07:	eb 28                	jmp    102e31 <getint+0x45>
    }
    else if (lflag) {
  102e09:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102e0d:	74 12                	je     102e21 <getint+0x35>
        return va_arg(*ap, long);
  102e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e12:	8b 00                	mov    (%eax),%eax
  102e14:	8d 48 04             	lea    0x4(%eax),%ecx
  102e17:	8b 55 08             	mov    0x8(%ebp),%edx
  102e1a:	89 0a                	mov    %ecx,(%edx)
  102e1c:	8b 00                	mov    (%eax),%eax
  102e1e:	99                   	cltd   
  102e1f:	eb 10                	jmp    102e31 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102e21:	8b 45 08             	mov    0x8(%ebp),%eax
  102e24:	8b 00                	mov    (%eax),%eax
  102e26:	8d 48 04             	lea    0x4(%eax),%ecx
  102e29:	8b 55 08             	mov    0x8(%ebp),%edx
  102e2c:	89 0a                	mov    %ecx,(%edx)
  102e2e:	8b 00                	mov    (%eax),%eax
  102e30:	99                   	cltd   
    }
}
  102e31:	5d                   	pop    %ebp
  102e32:	c3                   	ret    

00102e33 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102e33:	55                   	push   %ebp
  102e34:	89 e5                	mov    %esp,%ebp
  102e36:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102e39:	8d 45 14             	lea    0x14(%ebp),%eax
  102e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e42:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e46:	8b 45 10             	mov    0x10(%ebp),%eax
  102e49:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e50:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e54:	8b 45 08             	mov    0x8(%ebp),%eax
  102e57:	89 04 24             	mov    %eax,(%esp)
  102e5a:	e8 02 00 00 00       	call   102e61 <vprintfmt>
    va_end(ap);
}
  102e5f:	c9                   	leave  
  102e60:	c3                   	ret    

00102e61 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102e61:	55                   	push   %ebp
  102e62:	89 e5                	mov    %esp,%ebp
  102e64:	56                   	push   %esi
  102e65:	53                   	push   %ebx
  102e66:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102e69:	eb 18                	jmp    102e83 <vprintfmt+0x22>
            if (ch == '\0') {
  102e6b:	85 db                	test   %ebx,%ebx
  102e6d:	75 05                	jne    102e74 <vprintfmt+0x13>
                return;
  102e6f:	e9 d1 03 00 00       	jmp    103245 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e77:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e7b:	89 1c 24             	mov    %ebx,(%esp)
  102e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e81:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102e83:	8b 45 10             	mov    0x10(%ebp),%eax
  102e86:	8d 50 01             	lea    0x1(%eax),%edx
  102e89:	89 55 10             	mov    %edx,0x10(%ebp)
  102e8c:	0f b6 00             	movzbl (%eax),%eax
  102e8f:	0f b6 d8             	movzbl %al,%ebx
  102e92:	83 fb 25             	cmp    $0x25,%ebx
  102e95:	75 d4                	jne    102e6b <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102e97:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102e9b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102ea2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ea5:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102ea8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102eaf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102eb2:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  102eb8:	8d 50 01             	lea    0x1(%eax),%edx
  102ebb:	89 55 10             	mov    %edx,0x10(%ebp)
  102ebe:	0f b6 00             	movzbl (%eax),%eax
  102ec1:	0f b6 d8             	movzbl %al,%ebx
  102ec4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102ec7:	83 f8 55             	cmp    $0x55,%eax
  102eca:	0f 87 44 03 00 00    	ja     103214 <vprintfmt+0x3b3>
  102ed0:	8b 04 85 f4 3f 10 00 	mov    0x103ff4(,%eax,4),%eax
  102ed7:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102ed9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102edd:	eb d6                	jmp    102eb5 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102edf:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102ee3:	eb d0                	jmp    102eb5 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102ee5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102eec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102eef:	89 d0                	mov    %edx,%eax
  102ef1:	c1 e0 02             	shl    $0x2,%eax
  102ef4:	01 d0                	add    %edx,%eax
  102ef6:	01 c0                	add    %eax,%eax
  102ef8:	01 d8                	add    %ebx,%eax
  102efa:	83 e8 30             	sub    $0x30,%eax
  102efd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102f00:	8b 45 10             	mov    0x10(%ebp),%eax
  102f03:	0f b6 00             	movzbl (%eax),%eax
  102f06:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102f09:	83 fb 2f             	cmp    $0x2f,%ebx
  102f0c:	7e 0b                	jle    102f19 <vprintfmt+0xb8>
  102f0e:	83 fb 39             	cmp    $0x39,%ebx
  102f11:	7f 06                	jg     102f19 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102f13:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102f17:	eb d3                	jmp    102eec <vprintfmt+0x8b>
            goto process_precision;
  102f19:	eb 33                	jmp    102f4e <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102f1b:	8b 45 14             	mov    0x14(%ebp),%eax
  102f1e:	8d 50 04             	lea    0x4(%eax),%edx
  102f21:	89 55 14             	mov    %edx,0x14(%ebp)
  102f24:	8b 00                	mov    (%eax),%eax
  102f26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102f29:	eb 23                	jmp    102f4e <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102f2b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f2f:	79 0c                	jns    102f3d <vprintfmt+0xdc>
                width = 0;
  102f31:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102f38:	e9 78 ff ff ff       	jmp    102eb5 <vprintfmt+0x54>
  102f3d:	e9 73 ff ff ff       	jmp    102eb5 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102f42:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102f49:	e9 67 ff ff ff       	jmp    102eb5 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102f4e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f52:	79 12                	jns    102f66 <vprintfmt+0x105>
                width = precision, precision = -1;
  102f54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102f57:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f5a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102f61:	e9 4f ff ff ff       	jmp    102eb5 <vprintfmt+0x54>
  102f66:	e9 4a ff ff ff       	jmp    102eb5 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102f6b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102f6f:	e9 41 ff ff ff       	jmp    102eb5 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102f74:	8b 45 14             	mov    0x14(%ebp),%eax
  102f77:	8d 50 04             	lea    0x4(%eax),%edx
  102f7a:	89 55 14             	mov    %edx,0x14(%ebp)
  102f7d:	8b 00                	mov    (%eax),%eax
  102f7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f82:	89 54 24 04          	mov    %edx,0x4(%esp)
  102f86:	89 04 24             	mov    %eax,(%esp)
  102f89:	8b 45 08             	mov    0x8(%ebp),%eax
  102f8c:	ff d0                	call   *%eax
            break;
  102f8e:	e9 ac 02 00 00       	jmp    10323f <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102f93:	8b 45 14             	mov    0x14(%ebp),%eax
  102f96:	8d 50 04             	lea    0x4(%eax),%edx
  102f99:	89 55 14             	mov    %edx,0x14(%ebp)
  102f9c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102f9e:	85 db                	test   %ebx,%ebx
  102fa0:	79 02                	jns    102fa4 <vprintfmt+0x143>
                err = -err;
  102fa2:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102fa4:	83 fb 06             	cmp    $0x6,%ebx
  102fa7:	7f 0b                	jg     102fb4 <vprintfmt+0x153>
  102fa9:	8b 34 9d b4 3f 10 00 	mov    0x103fb4(,%ebx,4),%esi
  102fb0:	85 f6                	test   %esi,%esi
  102fb2:	75 23                	jne    102fd7 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102fb4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102fb8:	c7 44 24 08 e1 3f 10 	movl   $0x103fe1,0x8(%esp)
  102fbf:	00 
  102fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  102fca:	89 04 24             	mov    %eax,(%esp)
  102fcd:	e8 61 fe ff ff       	call   102e33 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102fd2:	e9 68 02 00 00       	jmp    10323f <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102fd7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102fdb:	c7 44 24 08 ea 3f 10 	movl   $0x103fea,0x8(%esp)
  102fe2:	00 
  102fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fe6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fea:	8b 45 08             	mov    0x8(%ebp),%eax
  102fed:	89 04 24             	mov    %eax,(%esp)
  102ff0:	e8 3e fe ff ff       	call   102e33 <printfmt>
            }
            break;
  102ff5:	e9 45 02 00 00       	jmp    10323f <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102ffa:	8b 45 14             	mov    0x14(%ebp),%eax
  102ffd:	8d 50 04             	lea    0x4(%eax),%edx
  103000:	89 55 14             	mov    %edx,0x14(%ebp)
  103003:	8b 30                	mov    (%eax),%esi
  103005:	85 f6                	test   %esi,%esi
  103007:	75 05                	jne    10300e <vprintfmt+0x1ad>
                p = "(null)";
  103009:	be ed 3f 10 00       	mov    $0x103fed,%esi
            }
            if (width > 0 && padc != '-') {
  10300e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103012:	7e 3e                	jle    103052 <vprintfmt+0x1f1>
  103014:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103018:	74 38                	je     103052 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10301a:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  10301d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103020:	89 44 24 04          	mov    %eax,0x4(%esp)
  103024:	89 34 24             	mov    %esi,(%esp)
  103027:	e8 15 03 00 00       	call   103341 <strnlen>
  10302c:	29 c3                	sub    %eax,%ebx
  10302e:	89 d8                	mov    %ebx,%eax
  103030:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103033:	eb 17                	jmp    10304c <vprintfmt+0x1eb>
                    putch(padc, putdat);
  103035:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  103039:	8b 55 0c             	mov    0xc(%ebp),%edx
  10303c:	89 54 24 04          	mov    %edx,0x4(%esp)
  103040:	89 04 24             	mov    %eax,(%esp)
  103043:	8b 45 08             	mov    0x8(%ebp),%eax
  103046:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  103048:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10304c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103050:	7f e3                	jg     103035 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103052:	eb 38                	jmp    10308c <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  103054:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103058:	74 1f                	je     103079 <vprintfmt+0x218>
  10305a:	83 fb 1f             	cmp    $0x1f,%ebx
  10305d:	7e 05                	jle    103064 <vprintfmt+0x203>
  10305f:	83 fb 7e             	cmp    $0x7e,%ebx
  103062:	7e 15                	jle    103079 <vprintfmt+0x218>
                    putch('?', putdat);
  103064:	8b 45 0c             	mov    0xc(%ebp),%eax
  103067:	89 44 24 04          	mov    %eax,0x4(%esp)
  10306b:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  103072:	8b 45 08             	mov    0x8(%ebp),%eax
  103075:	ff d0                	call   *%eax
  103077:	eb 0f                	jmp    103088 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  103079:	8b 45 0c             	mov    0xc(%ebp),%eax
  10307c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103080:	89 1c 24             	mov    %ebx,(%esp)
  103083:	8b 45 08             	mov    0x8(%ebp),%eax
  103086:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103088:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10308c:	89 f0                	mov    %esi,%eax
  10308e:	8d 70 01             	lea    0x1(%eax),%esi
  103091:	0f b6 00             	movzbl (%eax),%eax
  103094:	0f be d8             	movsbl %al,%ebx
  103097:	85 db                	test   %ebx,%ebx
  103099:	74 10                	je     1030ab <vprintfmt+0x24a>
  10309b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10309f:	78 b3                	js     103054 <vprintfmt+0x1f3>
  1030a1:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  1030a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1030a9:	79 a9                	jns    103054 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1030ab:	eb 17                	jmp    1030c4 <vprintfmt+0x263>
                putch(' ', putdat);
  1030ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030b4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1030be:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  1030c0:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1030c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1030c8:	7f e3                	jg     1030ad <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  1030ca:	e9 70 01 00 00       	jmp    10323f <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1030cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030d6:	8d 45 14             	lea    0x14(%ebp),%eax
  1030d9:	89 04 24             	mov    %eax,(%esp)
  1030dc:	e8 0b fd ff ff       	call   102dec <getint>
  1030e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1030e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030ed:	85 d2                	test   %edx,%edx
  1030ef:	79 26                	jns    103117 <vprintfmt+0x2b6>
                putch('-', putdat);
  1030f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030f8:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1030ff:	8b 45 08             	mov    0x8(%ebp),%eax
  103102:	ff d0                	call   *%eax
                num = -(long long)num;
  103104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103107:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10310a:	f7 d8                	neg    %eax
  10310c:	83 d2 00             	adc    $0x0,%edx
  10310f:	f7 da                	neg    %edx
  103111:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103114:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  103117:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10311e:	e9 a8 00 00 00       	jmp    1031cb <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103123:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103126:	89 44 24 04          	mov    %eax,0x4(%esp)
  10312a:	8d 45 14             	lea    0x14(%ebp),%eax
  10312d:	89 04 24             	mov    %eax,(%esp)
  103130:	e8 68 fc ff ff       	call   102d9d <getuint>
  103135:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103138:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10313b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103142:	e9 84 00 00 00       	jmp    1031cb <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103147:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10314a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10314e:	8d 45 14             	lea    0x14(%ebp),%eax
  103151:	89 04 24             	mov    %eax,(%esp)
  103154:	e8 44 fc ff ff       	call   102d9d <getuint>
  103159:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10315c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10315f:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103166:	eb 63                	jmp    1031cb <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  103168:	8b 45 0c             	mov    0xc(%ebp),%eax
  10316b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10316f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103176:	8b 45 08             	mov    0x8(%ebp),%eax
  103179:	ff d0                	call   *%eax
            putch('x', putdat);
  10317b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10317e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103182:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103189:	8b 45 08             	mov    0x8(%ebp),%eax
  10318c:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10318e:	8b 45 14             	mov    0x14(%ebp),%eax
  103191:	8d 50 04             	lea    0x4(%eax),%edx
  103194:	89 55 14             	mov    %edx,0x14(%ebp)
  103197:	8b 00                	mov    (%eax),%eax
  103199:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10319c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1031a3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1031aa:	eb 1f                	jmp    1031cb <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1031ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031b3:	8d 45 14             	lea    0x14(%ebp),%eax
  1031b6:	89 04 24             	mov    %eax,(%esp)
  1031b9:	e8 df fb ff ff       	call   102d9d <getuint>
  1031be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1031c4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1031cb:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1031cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031d2:	89 54 24 18          	mov    %edx,0x18(%esp)
  1031d6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1031d9:	89 54 24 14          	mov    %edx,0x14(%esp)
  1031dd:	89 44 24 10          	mov    %eax,0x10(%esp)
  1031e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1031eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1031ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031f9:	89 04 24             	mov    %eax,(%esp)
  1031fc:	e8 97 fa ff ff       	call   102c98 <printnum>
            break;
  103201:	eb 3c                	jmp    10323f <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103203:	8b 45 0c             	mov    0xc(%ebp),%eax
  103206:	89 44 24 04          	mov    %eax,0x4(%esp)
  10320a:	89 1c 24             	mov    %ebx,(%esp)
  10320d:	8b 45 08             	mov    0x8(%ebp),%eax
  103210:	ff d0                	call   *%eax
            break;
  103212:	eb 2b                	jmp    10323f <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103214:	8b 45 0c             	mov    0xc(%ebp),%eax
  103217:	89 44 24 04          	mov    %eax,0x4(%esp)
  10321b:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  103222:	8b 45 08             	mov    0x8(%ebp),%eax
  103225:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  103227:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10322b:	eb 04                	jmp    103231 <vprintfmt+0x3d0>
  10322d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103231:	8b 45 10             	mov    0x10(%ebp),%eax
  103234:	83 e8 01             	sub    $0x1,%eax
  103237:	0f b6 00             	movzbl (%eax),%eax
  10323a:	3c 25                	cmp    $0x25,%al
  10323c:	75 ef                	jne    10322d <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  10323e:	90                   	nop
        }
    }
  10323f:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103240:	e9 3e fc ff ff       	jmp    102e83 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  103245:	83 c4 40             	add    $0x40,%esp
  103248:	5b                   	pop    %ebx
  103249:	5e                   	pop    %esi
  10324a:	5d                   	pop    %ebp
  10324b:	c3                   	ret    

0010324c <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10324c:	55                   	push   %ebp
  10324d:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10324f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103252:	8b 40 08             	mov    0x8(%eax),%eax
  103255:	8d 50 01             	lea    0x1(%eax),%edx
  103258:	8b 45 0c             	mov    0xc(%ebp),%eax
  10325b:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10325e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103261:	8b 10                	mov    (%eax),%edx
  103263:	8b 45 0c             	mov    0xc(%ebp),%eax
  103266:	8b 40 04             	mov    0x4(%eax),%eax
  103269:	39 c2                	cmp    %eax,%edx
  10326b:	73 12                	jae    10327f <sprintputch+0x33>
        *b->buf ++ = ch;
  10326d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103270:	8b 00                	mov    (%eax),%eax
  103272:	8d 48 01             	lea    0x1(%eax),%ecx
  103275:	8b 55 0c             	mov    0xc(%ebp),%edx
  103278:	89 0a                	mov    %ecx,(%edx)
  10327a:	8b 55 08             	mov    0x8(%ebp),%edx
  10327d:	88 10                	mov    %dl,(%eax)
    }
}
  10327f:	5d                   	pop    %ebp
  103280:	c3                   	ret    

00103281 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103281:	55                   	push   %ebp
  103282:	89 e5                	mov    %esp,%ebp
  103284:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103287:	8d 45 14             	lea    0x14(%ebp),%eax
  10328a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10328d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103290:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103294:	8b 45 10             	mov    0x10(%ebp),%eax
  103297:	89 44 24 08          	mov    %eax,0x8(%esp)
  10329b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10329e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a5:	89 04 24             	mov    %eax,(%esp)
  1032a8:	e8 08 00 00 00       	call   1032b5 <vsnprintf>
  1032ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1032b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1032b3:	c9                   	leave  
  1032b4:	c3                   	ret    

001032b5 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1032b5:	55                   	push   %ebp
  1032b6:	89 e5                	mov    %esp,%ebp
  1032b8:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1032be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1032c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  1032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ca:	01 d0                	add    %edx,%eax
  1032cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1032d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1032da:	74 0a                	je     1032e6 <vsnprintf+0x31>
  1032dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1032df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032e2:	39 c2                	cmp    %eax,%edx
  1032e4:	76 07                	jbe    1032ed <vsnprintf+0x38>
        return -E_INVAL;
  1032e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1032eb:	eb 2a                	jmp    103317 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1032ed:	8b 45 14             	mov    0x14(%ebp),%eax
  1032f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032f4:	8b 45 10             	mov    0x10(%ebp),%eax
  1032f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1032fb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1032fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  103302:	c7 04 24 4c 32 10 00 	movl   $0x10324c,(%esp)
  103309:	e8 53 fb ff ff       	call   102e61 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10330e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103311:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103314:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103317:	c9                   	leave  
  103318:	c3                   	ret    

00103319 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  103319:	55                   	push   %ebp
  10331a:	89 e5                	mov    %esp,%ebp
  10331c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10331f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  103326:	eb 04                	jmp    10332c <strlen+0x13>
        cnt ++;
  103328:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  10332c:	8b 45 08             	mov    0x8(%ebp),%eax
  10332f:	8d 50 01             	lea    0x1(%eax),%edx
  103332:	89 55 08             	mov    %edx,0x8(%ebp)
  103335:	0f b6 00             	movzbl (%eax),%eax
  103338:	84 c0                	test   %al,%al
  10333a:	75 ec                	jne    103328 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  10333c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10333f:	c9                   	leave  
  103340:	c3                   	ret    

00103341 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  103341:	55                   	push   %ebp
  103342:	89 e5                	mov    %esp,%ebp
  103344:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103347:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10334e:	eb 04                	jmp    103354 <strnlen+0x13>
        cnt ++;
  103350:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  103354:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103357:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10335a:	73 10                	jae    10336c <strnlen+0x2b>
  10335c:	8b 45 08             	mov    0x8(%ebp),%eax
  10335f:	8d 50 01             	lea    0x1(%eax),%edx
  103362:	89 55 08             	mov    %edx,0x8(%ebp)
  103365:	0f b6 00             	movzbl (%eax),%eax
  103368:	84 c0                	test   %al,%al
  10336a:	75 e4                	jne    103350 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  10336c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10336f:	c9                   	leave  
  103370:	c3                   	ret    

00103371 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103371:	55                   	push   %ebp
  103372:	89 e5                	mov    %esp,%ebp
  103374:	57                   	push   %edi
  103375:	56                   	push   %esi
  103376:	83 ec 20             	sub    $0x20,%esp
  103379:	8b 45 08             	mov    0x8(%ebp),%eax
  10337c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10337f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103382:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103385:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10338b:	89 d1                	mov    %edx,%ecx
  10338d:	89 c2                	mov    %eax,%edx
  10338f:	89 ce                	mov    %ecx,%esi
  103391:	89 d7                	mov    %edx,%edi
  103393:	ac                   	lods   %ds:(%esi),%al
  103394:	aa                   	stos   %al,%es:(%edi)
  103395:	84 c0                	test   %al,%al
  103397:	75 fa                	jne    103393 <strcpy+0x22>
  103399:	89 fa                	mov    %edi,%edx
  10339b:	89 f1                	mov    %esi,%ecx
  10339d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1033a0:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1033a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  1033a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1033a9:	83 c4 20             	add    $0x20,%esp
  1033ac:	5e                   	pop    %esi
  1033ad:	5f                   	pop    %edi
  1033ae:	5d                   	pop    %ebp
  1033af:	c3                   	ret    

001033b0 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1033b0:	55                   	push   %ebp
  1033b1:	89 e5                	mov    %esp,%ebp
  1033b3:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1033b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1033bc:	eb 21                	jmp    1033df <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  1033be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033c1:	0f b6 10             	movzbl (%eax),%edx
  1033c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1033c7:	88 10                	mov    %dl,(%eax)
  1033c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1033cc:	0f b6 00             	movzbl (%eax),%eax
  1033cf:	84 c0                	test   %al,%al
  1033d1:	74 04                	je     1033d7 <strncpy+0x27>
            src ++;
  1033d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1033d7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1033db:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1033df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033e3:	75 d9                	jne    1033be <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1033e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1033e8:	c9                   	leave  
  1033e9:	c3                   	ret    

001033ea <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1033ea:	55                   	push   %ebp
  1033eb:	89 e5                	mov    %esp,%ebp
  1033ed:	57                   	push   %edi
  1033ee:	56                   	push   %esi
  1033ef:	83 ec 20             	sub    $0x20,%esp
  1033f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1033fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103404:	89 d1                	mov    %edx,%ecx
  103406:	89 c2                	mov    %eax,%edx
  103408:	89 ce                	mov    %ecx,%esi
  10340a:	89 d7                	mov    %edx,%edi
  10340c:	ac                   	lods   %ds:(%esi),%al
  10340d:	ae                   	scas   %es:(%edi),%al
  10340e:	75 08                	jne    103418 <strcmp+0x2e>
  103410:	84 c0                	test   %al,%al
  103412:	75 f8                	jne    10340c <strcmp+0x22>
  103414:	31 c0                	xor    %eax,%eax
  103416:	eb 04                	jmp    10341c <strcmp+0x32>
  103418:	19 c0                	sbb    %eax,%eax
  10341a:	0c 01                	or     $0x1,%al
  10341c:	89 fa                	mov    %edi,%edx
  10341e:	89 f1                	mov    %esi,%ecx
  103420:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103423:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103426:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  103429:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  10342c:	83 c4 20             	add    $0x20,%esp
  10342f:	5e                   	pop    %esi
  103430:	5f                   	pop    %edi
  103431:	5d                   	pop    %ebp
  103432:	c3                   	ret    

00103433 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  103433:	55                   	push   %ebp
  103434:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103436:	eb 0c                	jmp    103444 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  103438:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10343c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103440:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103444:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103448:	74 1a                	je     103464 <strncmp+0x31>
  10344a:	8b 45 08             	mov    0x8(%ebp),%eax
  10344d:	0f b6 00             	movzbl (%eax),%eax
  103450:	84 c0                	test   %al,%al
  103452:	74 10                	je     103464 <strncmp+0x31>
  103454:	8b 45 08             	mov    0x8(%ebp),%eax
  103457:	0f b6 10             	movzbl (%eax),%edx
  10345a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10345d:	0f b6 00             	movzbl (%eax),%eax
  103460:	38 c2                	cmp    %al,%dl
  103462:	74 d4                	je     103438 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103464:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103468:	74 18                	je     103482 <strncmp+0x4f>
  10346a:	8b 45 08             	mov    0x8(%ebp),%eax
  10346d:	0f b6 00             	movzbl (%eax),%eax
  103470:	0f b6 d0             	movzbl %al,%edx
  103473:	8b 45 0c             	mov    0xc(%ebp),%eax
  103476:	0f b6 00             	movzbl (%eax),%eax
  103479:	0f b6 c0             	movzbl %al,%eax
  10347c:	29 c2                	sub    %eax,%edx
  10347e:	89 d0                	mov    %edx,%eax
  103480:	eb 05                	jmp    103487 <strncmp+0x54>
  103482:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103487:	5d                   	pop    %ebp
  103488:	c3                   	ret    

00103489 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103489:	55                   	push   %ebp
  10348a:	89 e5                	mov    %esp,%ebp
  10348c:	83 ec 04             	sub    $0x4,%esp
  10348f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103492:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103495:	eb 14                	jmp    1034ab <strchr+0x22>
        if (*s == c) {
  103497:	8b 45 08             	mov    0x8(%ebp),%eax
  10349a:	0f b6 00             	movzbl (%eax),%eax
  10349d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1034a0:	75 05                	jne    1034a7 <strchr+0x1e>
            return (char *)s;
  1034a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1034a5:	eb 13                	jmp    1034ba <strchr+0x31>
        }
        s ++;
  1034a7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  1034ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1034ae:	0f b6 00             	movzbl (%eax),%eax
  1034b1:	84 c0                	test   %al,%al
  1034b3:	75 e2                	jne    103497 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  1034b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1034ba:	c9                   	leave  
  1034bb:	c3                   	ret    

001034bc <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1034bc:	55                   	push   %ebp
  1034bd:	89 e5                	mov    %esp,%ebp
  1034bf:	83 ec 04             	sub    $0x4,%esp
  1034c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034c5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1034c8:	eb 11                	jmp    1034db <strfind+0x1f>
        if (*s == c) {
  1034ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1034cd:	0f b6 00             	movzbl (%eax),%eax
  1034d0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1034d3:	75 02                	jne    1034d7 <strfind+0x1b>
            break;
  1034d5:	eb 0e                	jmp    1034e5 <strfind+0x29>
        }
        s ++;
  1034d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1034db:	8b 45 08             	mov    0x8(%ebp),%eax
  1034de:	0f b6 00             	movzbl (%eax),%eax
  1034e1:	84 c0                	test   %al,%al
  1034e3:	75 e5                	jne    1034ca <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  1034e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1034e8:	c9                   	leave  
  1034e9:	c3                   	ret    

001034ea <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1034ea:	55                   	push   %ebp
  1034eb:	89 e5                	mov    %esp,%ebp
  1034ed:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1034f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1034f7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1034fe:	eb 04                	jmp    103504 <strtol+0x1a>
        s ++;
  103500:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103504:	8b 45 08             	mov    0x8(%ebp),%eax
  103507:	0f b6 00             	movzbl (%eax),%eax
  10350a:	3c 20                	cmp    $0x20,%al
  10350c:	74 f2                	je     103500 <strtol+0x16>
  10350e:	8b 45 08             	mov    0x8(%ebp),%eax
  103511:	0f b6 00             	movzbl (%eax),%eax
  103514:	3c 09                	cmp    $0x9,%al
  103516:	74 e8                	je     103500 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  103518:	8b 45 08             	mov    0x8(%ebp),%eax
  10351b:	0f b6 00             	movzbl (%eax),%eax
  10351e:	3c 2b                	cmp    $0x2b,%al
  103520:	75 06                	jne    103528 <strtol+0x3e>
        s ++;
  103522:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103526:	eb 15                	jmp    10353d <strtol+0x53>
    }
    else if (*s == '-') {
  103528:	8b 45 08             	mov    0x8(%ebp),%eax
  10352b:	0f b6 00             	movzbl (%eax),%eax
  10352e:	3c 2d                	cmp    $0x2d,%al
  103530:	75 0b                	jne    10353d <strtol+0x53>
        s ++, neg = 1;
  103532:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103536:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  10353d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103541:	74 06                	je     103549 <strtol+0x5f>
  103543:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  103547:	75 24                	jne    10356d <strtol+0x83>
  103549:	8b 45 08             	mov    0x8(%ebp),%eax
  10354c:	0f b6 00             	movzbl (%eax),%eax
  10354f:	3c 30                	cmp    $0x30,%al
  103551:	75 1a                	jne    10356d <strtol+0x83>
  103553:	8b 45 08             	mov    0x8(%ebp),%eax
  103556:	83 c0 01             	add    $0x1,%eax
  103559:	0f b6 00             	movzbl (%eax),%eax
  10355c:	3c 78                	cmp    $0x78,%al
  10355e:	75 0d                	jne    10356d <strtol+0x83>
        s += 2, base = 16;
  103560:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103564:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10356b:	eb 2a                	jmp    103597 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  10356d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103571:	75 17                	jne    10358a <strtol+0xa0>
  103573:	8b 45 08             	mov    0x8(%ebp),%eax
  103576:	0f b6 00             	movzbl (%eax),%eax
  103579:	3c 30                	cmp    $0x30,%al
  10357b:	75 0d                	jne    10358a <strtol+0xa0>
        s ++, base = 8;
  10357d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103581:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103588:	eb 0d                	jmp    103597 <strtol+0xad>
    }
    else if (base == 0) {
  10358a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10358e:	75 07                	jne    103597 <strtol+0xad>
        base = 10;
  103590:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103597:	8b 45 08             	mov    0x8(%ebp),%eax
  10359a:	0f b6 00             	movzbl (%eax),%eax
  10359d:	3c 2f                	cmp    $0x2f,%al
  10359f:	7e 1b                	jle    1035bc <strtol+0xd2>
  1035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1035a4:	0f b6 00             	movzbl (%eax),%eax
  1035a7:	3c 39                	cmp    $0x39,%al
  1035a9:	7f 11                	jg     1035bc <strtol+0xd2>
            dig = *s - '0';
  1035ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1035ae:	0f b6 00             	movzbl (%eax),%eax
  1035b1:	0f be c0             	movsbl %al,%eax
  1035b4:	83 e8 30             	sub    $0x30,%eax
  1035b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1035ba:	eb 48                	jmp    103604 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1035bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1035bf:	0f b6 00             	movzbl (%eax),%eax
  1035c2:	3c 60                	cmp    $0x60,%al
  1035c4:	7e 1b                	jle    1035e1 <strtol+0xf7>
  1035c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1035c9:	0f b6 00             	movzbl (%eax),%eax
  1035cc:	3c 7a                	cmp    $0x7a,%al
  1035ce:	7f 11                	jg     1035e1 <strtol+0xf7>
            dig = *s - 'a' + 10;
  1035d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1035d3:	0f b6 00             	movzbl (%eax),%eax
  1035d6:	0f be c0             	movsbl %al,%eax
  1035d9:	83 e8 57             	sub    $0x57,%eax
  1035dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1035df:	eb 23                	jmp    103604 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1035e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1035e4:	0f b6 00             	movzbl (%eax),%eax
  1035e7:	3c 40                	cmp    $0x40,%al
  1035e9:	7e 3d                	jle    103628 <strtol+0x13e>
  1035eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1035ee:	0f b6 00             	movzbl (%eax),%eax
  1035f1:	3c 5a                	cmp    $0x5a,%al
  1035f3:	7f 33                	jg     103628 <strtol+0x13e>
            dig = *s - 'A' + 10;
  1035f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1035f8:	0f b6 00             	movzbl (%eax),%eax
  1035fb:	0f be c0             	movsbl %al,%eax
  1035fe:	83 e8 37             	sub    $0x37,%eax
  103601:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  103604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103607:	3b 45 10             	cmp    0x10(%ebp),%eax
  10360a:	7c 02                	jl     10360e <strtol+0x124>
            break;
  10360c:	eb 1a                	jmp    103628 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  10360e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103612:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103615:	0f af 45 10          	imul   0x10(%ebp),%eax
  103619:	89 c2                	mov    %eax,%edx
  10361b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10361e:	01 d0                	add    %edx,%eax
  103620:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  103623:	e9 6f ff ff ff       	jmp    103597 <strtol+0xad>

    if (endptr) {
  103628:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10362c:	74 08                	je     103636 <strtol+0x14c>
        *endptr = (char *) s;
  10362e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103631:	8b 55 08             	mov    0x8(%ebp),%edx
  103634:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  103636:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10363a:	74 07                	je     103643 <strtol+0x159>
  10363c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10363f:	f7 d8                	neg    %eax
  103641:	eb 03                	jmp    103646 <strtol+0x15c>
  103643:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  103646:	c9                   	leave  
  103647:	c3                   	ret    

00103648 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  103648:	55                   	push   %ebp
  103649:	89 e5                	mov    %esp,%ebp
  10364b:	57                   	push   %edi
  10364c:	83 ec 24             	sub    $0x24,%esp
  10364f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103652:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103655:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  103659:	8b 55 08             	mov    0x8(%ebp),%edx
  10365c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10365f:	88 45 f7             	mov    %al,-0x9(%ebp)
  103662:	8b 45 10             	mov    0x10(%ebp),%eax
  103665:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103668:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10366b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10366f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103672:	89 d7                	mov    %edx,%edi
  103674:	f3 aa                	rep stos %al,%es:(%edi)
  103676:	89 fa                	mov    %edi,%edx
  103678:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10367b:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  10367e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103681:	83 c4 24             	add    $0x24,%esp
  103684:	5f                   	pop    %edi
  103685:	5d                   	pop    %ebp
  103686:	c3                   	ret    

00103687 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103687:	55                   	push   %ebp
  103688:	89 e5                	mov    %esp,%ebp
  10368a:	57                   	push   %edi
  10368b:	56                   	push   %esi
  10368c:	53                   	push   %ebx
  10368d:	83 ec 30             	sub    $0x30,%esp
  103690:	8b 45 08             	mov    0x8(%ebp),%eax
  103693:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103696:	8b 45 0c             	mov    0xc(%ebp),%eax
  103699:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10369c:	8b 45 10             	mov    0x10(%ebp),%eax
  10369f:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1036a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036a5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1036a8:	73 42                	jae    1036ec <memmove+0x65>
  1036aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1036b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1036b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1036b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1036bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1036bf:	c1 e8 02             	shr    $0x2,%eax
  1036c2:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1036c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1036c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1036ca:	89 d7                	mov    %edx,%edi
  1036cc:	89 c6                	mov    %eax,%esi
  1036ce:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1036d0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1036d3:	83 e1 03             	and    $0x3,%ecx
  1036d6:	74 02                	je     1036da <memmove+0x53>
  1036d8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1036da:	89 f0                	mov    %esi,%eax
  1036dc:	89 fa                	mov    %edi,%edx
  1036de:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1036e1:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1036e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1036e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036ea:	eb 36                	jmp    103722 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1036ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1036ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  1036f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036f5:	01 c2                	add    %eax,%edx
  1036f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1036fa:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1036fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103700:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  103703:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103706:	89 c1                	mov    %eax,%ecx
  103708:	89 d8                	mov    %ebx,%eax
  10370a:	89 d6                	mov    %edx,%esi
  10370c:	89 c7                	mov    %eax,%edi
  10370e:	fd                   	std    
  10370f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103711:	fc                   	cld    
  103712:	89 f8                	mov    %edi,%eax
  103714:	89 f2                	mov    %esi,%edx
  103716:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103719:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10371c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  10371f:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103722:	83 c4 30             	add    $0x30,%esp
  103725:	5b                   	pop    %ebx
  103726:	5e                   	pop    %esi
  103727:	5f                   	pop    %edi
  103728:	5d                   	pop    %ebp
  103729:	c3                   	ret    

0010372a <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10372a:	55                   	push   %ebp
  10372b:	89 e5                	mov    %esp,%ebp
  10372d:	57                   	push   %edi
  10372e:	56                   	push   %esi
  10372f:	83 ec 20             	sub    $0x20,%esp
  103732:	8b 45 08             	mov    0x8(%ebp),%eax
  103735:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103738:	8b 45 0c             	mov    0xc(%ebp),%eax
  10373b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10373e:	8b 45 10             	mov    0x10(%ebp),%eax
  103741:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103744:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103747:	c1 e8 02             	shr    $0x2,%eax
  10374a:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10374c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10374f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103752:	89 d7                	mov    %edx,%edi
  103754:	89 c6                	mov    %eax,%esi
  103756:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103758:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10375b:	83 e1 03             	and    $0x3,%ecx
  10375e:	74 02                	je     103762 <memcpy+0x38>
  103760:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103762:	89 f0                	mov    %esi,%eax
  103764:	89 fa                	mov    %edi,%edx
  103766:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103769:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10376c:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  10376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103772:	83 c4 20             	add    $0x20,%esp
  103775:	5e                   	pop    %esi
  103776:	5f                   	pop    %edi
  103777:	5d                   	pop    %ebp
  103778:	c3                   	ret    

00103779 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103779:	55                   	push   %ebp
  10377a:	89 e5                	mov    %esp,%ebp
  10377c:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10377f:	8b 45 08             	mov    0x8(%ebp),%eax
  103782:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103785:	8b 45 0c             	mov    0xc(%ebp),%eax
  103788:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10378b:	eb 30                	jmp    1037bd <memcmp+0x44>
        if (*s1 != *s2) {
  10378d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103790:	0f b6 10             	movzbl (%eax),%edx
  103793:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103796:	0f b6 00             	movzbl (%eax),%eax
  103799:	38 c2                	cmp    %al,%dl
  10379b:	74 18                	je     1037b5 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10379d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1037a0:	0f b6 00             	movzbl (%eax),%eax
  1037a3:	0f b6 d0             	movzbl %al,%edx
  1037a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1037a9:	0f b6 00             	movzbl (%eax),%eax
  1037ac:	0f b6 c0             	movzbl %al,%eax
  1037af:	29 c2                	sub    %eax,%edx
  1037b1:	89 d0                	mov    %edx,%eax
  1037b3:	eb 1a                	jmp    1037cf <memcmp+0x56>
        }
        s1 ++, s2 ++;
  1037b5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1037b9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  1037bd:	8b 45 10             	mov    0x10(%ebp),%eax
  1037c0:	8d 50 ff             	lea    -0x1(%eax),%edx
  1037c3:	89 55 10             	mov    %edx,0x10(%ebp)
  1037c6:	85 c0                	test   %eax,%eax
  1037c8:	75 c3                	jne    10378d <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1037ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1037cf:	c9                   	leave  
  1037d0:	c3                   	ret    
