
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
  100006:	ba 40 fd 10 00       	mov    $0x10fd40,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 fd 32 00 00       	call   103329 <memset>

    cons_init();                // init the console
  10002c:	e8 66 15 00 00       	call   101597 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 c0 34 10 00 	movl   $0x1034c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 dc 34 10 00 	movl   $0x1034dc,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 15 29 00 00       	call   10296f <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 7b 16 00 00       	call   1016da <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 cd 17 00 00       	call   101831 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 21 0d 00 00       	call   100d8a <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 da 15 00 00       	call   101648 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 19 0c 00 00       	call   100cab <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 e1 34 10 00 	movl   $0x1034e1,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 ef 34 10 00 	movl   $0x1034ef,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 fd 34 10 00 	movl   $0x1034fd,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 0b 35 10 00 	movl   $0x10350b,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 19 35 10 00 	movl   $0x103519,(%esp)
  1001b2:	e8 5b 01 00 00       	call   100312 <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 28 35 10 00 	movl   $0x103528,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 48 35 10 00 	movl   $0x103548,(%esp)
  1001f8:	e8 15 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10020f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100213:	74 13                	je     100228 <readline+0x1f>
        cprintf("%s", prompt);
  100215:	8b 45 08             	mov    0x8(%ebp),%eax
  100218:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021c:	c7 04 24 67 35 10 00 	movl   $0x103567,(%esp)
  100223:	e8 ea 00 00 00       	call   100312 <cprintf>
    }
    int i = 0, c;
  100228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10022f:	e8 66 01 00 00       	call   10039a <getchar>
  100234:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10023b:	79 07                	jns    100244 <readline+0x3b>
            return NULL;
  10023d:	b8 00 00 00 00       	mov    $0x0,%eax
  100242:	eb 79                	jmp    1002bd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100244:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100248:	7e 28                	jle    100272 <readline+0x69>
  10024a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100251:	7f 1f                	jg     100272 <readline+0x69>
            cputchar(c);
  100253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100256:	89 04 24             	mov    %eax,(%esp)
  100259:	e8 da 00 00 00       	call   100338 <cputchar>
            buf[i ++] = c;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100261:	8d 50 01             	lea    0x1(%eax),%edx
  100264:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100270:	eb 46                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100272:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100276:	75 17                	jne    10028f <readline+0x86>
  100278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10027c:	7e 11                	jle    10028f <readline+0x86>
            cputchar(c);
  10027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100281:	89 04 24             	mov    %eax,(%esp)
  100284:	e8 af 00 00 00       	call   100338 <cputchar>
            i --;
  100289:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10028d:	eb 29                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10028f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100293:	74 06                	je     10029b <readline+0x92>
  100295:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100299:	75 1d                	jne    1002b8 <readline+0xaf>
            cputchar(c);
  10029b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 92 00 00 00       	call   100338 <cputchar>
            buf[i] = '\0';
  1002a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002ae:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002b6:	eb 05                	jmp    1002bd <readline+0xb4>
        }
    }
  1002b8:	e9 72 ff ff ff       	jmp    10022f <readline+0x26>
}
  1002bd:	c9                   	leave  
  1002be:	c3                   	ret    

001002bf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002bf:	55                   	push   %ebp
  1002c0:	89 e5                	mov    %esp,%ebp
  1002c2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 f3 12 00 00       	call   1015c3 <cons_putc>
    (*cnt) ++;
  1002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d3:	8b 00                	mov    (%eax),%eax
  1002d5:	8d 50 01             	lea    0x1(%eax),%edx
  1002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002db:	89 10                	mov    %edx,(%eax)
}
  1002dd:	c9                   	leave  
  1002de:	c3                   	ret    

001002df <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002df:	55                   	push   %ebp
  1002e0:	89 e5                	mov    %esp,%ebp
  1002e2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100301:	c7 04 24 bf 02 10 00 	movl   $0x1002bf,(%esp)
  100308:	e8 35 28 00 00       	call   102b42 <vprintfmt>
    return cnt;
  10030d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100310:	c9                   	leave  
  100311:	c3                   	ret    

00100312 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100312:	55                   	push   %ebp
  100313:	89 e5                	mov    %esp,%ebp
  100315:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100318:	8d 45 0c             	lea    0xc(%ebp),%eax
  10031b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100321:	89 44 24 04          	mov    %eax,0x4(%esp)
  100325:	8b 45 08             	mov    0x8(%ebp),%eax
  100328:	89 04 24             	mov    %eax,(%esp)
  10032b:	e8 af ff ff ff       	call   1002df <vcprintf>
  100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100333:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100338:	55                   	push   %ebp
  100339:	89 e5                	mov    %esp,%ebp
  10033b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 04 24             	mov    %eax,(%esp)
  100344:	e8 7a 12 00 00       	call   1015c3 <cons_putc>
}
  100349:	c9                   	leave  
  10034a:	c3                   	ret    

0010034b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100358:	eb 13                	jmp    10036d <cputs+0x22>
        cputch(c, &cnt);
  10035a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	89 54 24 04          	mov    %edx,0x4(%esp)
  100365:	89 04 24             	mov    %eax,(%esp)
  100368:	e8 52 ff ff ff       	call   1002bf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10036d:	8b 45 08             	mov    0x8(%ebp),%eax
  100370:	8d 50 01             	lea    0x1(%eax),%edx
  100373:	89 55 08             	mov    %edx,0x8(%ebp)
  100376:	0f b6 00             	movzbl (%eax),%eax
  100379:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100380:	75 d8                	jne    10035a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100382:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100385:	89 44 24 04          	mov    %eax,0x4(%esp)
  100389:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100390:	e8 2a ff ff ff       	call   1002bf <cputch>
    return cnt;
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100398:	c9                   	leave  
  100399:	c3                   	ret    

0010039a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039a:	55                   	push   %ebp
  10039b:	89 e5                	mov    %esp,%ebp
  10039d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a0:	e8 47 12 00 00       	call   1015ec <cons_getc>
  1003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ac:	74 f2                	je     1003a0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003bc:	8b 00                	mov    (%eax),%eax
  1003be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c4:	8b 00                	mov    (%eax),%eax
  1003c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d0:	e9 d2 00 00 00       	jmp    1004a7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003db:	01 d0                	add    %edx,%eax
  1003dd:	89 c2                	mov    %eax,%edx
  1003df:	c1 ea 1f             	shr    $0x1f,%edx
  1003e2:	01 d0                	add    %edx,%eax
  1003e4:	d1 f8                	sar    %eax
  1003e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ef:	eb 04                	jmp    1003f5 <stab_binsearch+0x42>
            m --;
  1003f1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003fb:	7c 1f                	jl     10041c <stab_binsearch+0x69>
  1003fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100400:	89 d0                	mov    %edx,%eax
  100402:	01 c0                	add    %eax,%eax
  100404:	01 d0                	add    %edx,%eax
  100406:	c1 e0 02             	shl    $0x2,%eax
  100409:	89 c2                	mov    %eax,%edx
  10040b:	8b 45 08             	mov    0x8(%ebp),%eax
  10040e:	01 d0                	add    %edx,%eax
  100410:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100414:	0f b6 c0             	movzbl %al,%eax
  100417:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041a:	75 d5                	jne    1003f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7d 0b                	jge    10042f <stab_binsearch+0x7c>
            l = true_m + 1;
  100424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100427:	83 c0 01             	add    $0x1,%eax
  10042a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042d:	eb 78                	jmp    1004a7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100439:	89 d0                	mov    %edx,%eax
  10043b:	01 c0                	add    %eax,%eax
  10043d:	01 d0                	add    %edx,%eax
  10043f:	c1 e0 02             	shl    $0x2,%eax
  100442:	89 c2                	mov    %eax,%edx
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	01 d0                	add    %edx,%eax
  100449:	8b 40 08             	mov    0x8(%eax),%eax
  10044c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10044f:	73 13                	jae    100464 <stab_binsearch+0xb1>
            *region_left = m;
  100451:	8b 45 0c             	mov    0xc(%ebp),%eax
  100454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100457:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100462:	eb 43                	jmp    1004a7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 d0                	mov    %edx,%eax
  100469:	01 c0                	add    %eax,%eax
  10046b:	01 d0                	add    %edx,%eax
  10046d:	c1 e0 02             	shl    $0x2,%eax
  100470:	89 c2                	mov    %eax,%edx
  100472:	8b 45 08             	mov    0x8(%ebp),%eax
  100475:	01 d0                	add    %edx,%eax
  100477:	8b 40 08             	mov    0x8(%eax),%eax
  10047a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10047d:	76 16                	jbe    100495 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100482:	8d 50 ff             	lea    -0x1(%eax),%edx
  100485:	8b 45 10             	mov    0x10(%ebp),%eax
  100488:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048d:	83 e8 01             	sub    $0x1,%eax
  100490:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100493:	eb 12                	jmp    1004a7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100495:	8b 45 0c             	mov    0xc(%ebp),%eax
  100498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049b:	89 10                	mov    %edx,(%eax)
            l = m;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004ad:	0f 8e 22 ff ff ff    	jle    1003d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b7:	75 0f                	jne    1004c8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bc:	8b 00                	mov    (%eax),%eax
  1004be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	89 10                	mov    %edx,(%eax)
  1004c6:	eb 3f                	jmp    100507 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cb:	8b 00                	mov    (%eax),%eax
  1004cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d0:	eb 04                	jmp    1004d6 <stab_binsearch+0x123>
  1004d2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004de:	7d 1f                	jge    1004ff <stab_binsearch+0x14c>
  1004e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e3:	89 d0                	mov    %edx,%eax
  1004e5:	01 c0                	add    %eax,%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	c1 e0 02             	shl    $0x2,%eax
  1004ec:	89 c2                	mov    %eax,%edx
  1004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f1:	01 d0                	add    %edx,%eax
  1004f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f7:	0f b6 c0             	movzbl %al,%eax
  1004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fd:	75 d3                	jne    1004d2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100505:	89 10                	mov    %edx,(%eax)
    }
}
  100507:	c9                   	leave  
  100508:	c3                   	ret    

00100509 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	c7 00 6c 35 10 00    	movl   $0x10356c,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 6c 35 10 00 	movl   $0x10356c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100536:	8b 45 0c             	mov    0xc(%ebp),%eax
  100539:	8b 55 08             	mov    0x8(%ebp),%edx
  10053c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100542:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100549:	c7 45 f4 ec 3d 10 00 	movl   $0x103dec,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 20 b5 10 00 	movl   $0x10b520,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec 21 b5 10 00 	movl   $0x10b521,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 4f d5 10 00 	movl   $0x10d54f,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100568:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10056b:	76 0d                	jbe    10057a <debuginfo_eip+0x71>
  10056d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100570:	83 e8 01             	sub    $0x1,%eax
  100573:	0f b6 00             	movzbl (%eax),%eax
  100576:	84 c0                	test   %al,%al
  100578:	74 0a                	je     100584 <debuginfo_eip+0x7b>
        return -1;
  10057a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057f:	e9 c0 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100584:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100591:	29 c2                	sub    %eax,%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	c1 f8 02             	sar    $0x2,%eax
  100598:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005ab:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b2:	00 
  1005b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c4:	89 04 24             	mov    %eax,(%esp)
  1005c7:	e8 e7 fd ff ff       	call   1003b3 <stab_binsearch>
    if (lfile == 0)
  1005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005cf:	85 c0                	test   %eax,%eax
  1005d1:	75 0a                	jne    1005dd <debuginfo_eip+0xd4>
        return -1;
  1005d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d8:	e9 67 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f0:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005f7:	00 
  1005f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100602:	89 44 24 04          	mov    %eax,0x4(%esp)
  100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100609:	89 04 24             	mov    %eax,(%esp)
  10060c:	e8 a2 fd ff ff       	call   1003b3 <stab_binsearch>

    if (lfun <= rfun) {
  100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100617:	39 c2                	cmp    %eax,%edx
  100619:	7f 7c                	jg     100697 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10061e:	89 c2                	mov    %eax,%edx
  100620:	89 d0                	mov    %edx,%eax
  100622:	01 c0                	add    %eax,%eax
  100624:	01 d0                	add    %edx,%eax
  100626:	c1 e0 02             	shl    $0x2,%eax
  100629:	89 c2                	mov    %eax,%edx
  10062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	8b 10                	mov    (%eax),%edx
  100632:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100638:	29 c1                	sub    %eax,%ecx
  10063a:	89 c8                	mov    %ecx,%eax
  10063c:	39 c2                	cmp    %eax,%edx
  10063e:	73 22                	jae    100662 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	89 d0                	mov    %edx,%eax
  100647:	01 c0                	add    %eax,%eax
  100649:	01 d0                	add    %edx,%eax
  10064b:	c1 e0 02             	shl    $0x2,%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100653:	01 d0                	add    %edx,%eax
  100655:	8b 10                	mov    (%eax),%edx
  100657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065a:	01 c2                	add    %eax,%edx
  10065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100665:	89 c2                	mov    %eax,%edx
  100667:	89 d0                	mov    %edx,%eax
  100669:	01 c0                	add    %eax,%eax
  10066b:	01 d0                	add    %edx,%eax
  10066d:	c1 e0 02             	shl    $0x2,%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100675:	01 d0                	add    %edx,%eax
  100677:	8b 50 08             	mov    0x8(%eax),%edx
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	8b 40 10             	mov    0x10(%eax),%eax
  100686:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10068f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100692:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100695:	eb 15                	jmp    1006ac <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100697:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069a:	8b 55 08             	mov    0x8(%ebp),%edx
  10069d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	8b 40 08             	mov    0x8(%eax),%eax
  1006b2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006b9:	00 
  1006ba:	89 04 24             	mov    %eax,(%esp)
  1006bd:	e8 db 2a 00 00       	call   10319d <strfind>
  1006c2:	89 c2                	mov    %eax,%edx
  1006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c7:	8b 40 08             	mov    0x8(%eax),%eax
  1006ca:	29 c2                	sub    %eax,%edx
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e0:	00 
  1006e1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 b9 fc ff ff       	call   1003b3 <stab_binsearch>
    if (lline <= rline) {
  1006fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100700:	39 c2                	cmp    %eax,%edx
  100702:	7f 24                	jg     100728 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100704:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100707:	89 c2                	mov    %eax,%edx
  100709:	89 d0                	mov    %edx,%eax
  10070b:	01 c0                	add    %eax,%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	c1 e0 02             	shl    $0x2,%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10071d:	0f b7 d0             	movzwl %ax,%edx
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100726:	eb 13                	jmp    10073b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072d:	e9 12 01 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100735:	83 e8 01             	sub    $0x1,%eax
  100738:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10073e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100741:	39 c2                	cmp    %eax,%edx
  100743:	7c 56                	jl     10079b <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	89 d0                	mov    %edx,%eax
  10074c:	01 c0                	add    %eax,%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	c1 e0 02             	shl    $0x2,%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100758:	01 d0                	add    %edx,%eax
  10075a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10075e:	3c 84                	cmp    $0x84,%al
  100760:	74 39                	je     10079b <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	89 d0                	mov    %edx,%eax
  100769:	01 c0                	add    %eax,%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	c1 e0 02             	shl    $0x2,%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077b:	3c 64                	cmp    $0x64,%al
  10077d:	75 b3                	jne    100732 <debuginfo_eip+0x229>
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	85 c0                	test   %eax,%eax
  100799:	74 97                	je     100732 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10079e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a1:	39 c2                	cmp    %eax,%edx
  1007a3:	7c 46                	jl     1007eb <debuginfo_eip+0x2e2>
  1007a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a8:	89 c2                	mov    %eax,%edx
  1007aa:	89 d0                	mov    %edx,%eax
  1007ac:	01 c0                	add    %eax,%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	c1 e0 02             	shl    $0x2,%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	8b 10                	mov    (%eax),%edx
  1007bc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c2:	29 c1                	sub    %eax,%ecx
  1007c4:	89 c8                	mov    %ecx,%eax
  1007c6:	39 c2                	cmp    %eax,%edx
  1007c8:	73 21                	jae    1007eb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cd:	89 c2                	mov    %eax,%edx
  1007cf:	89 d0                	mov    %edx,%eax
  1007d1:	01 c0                	add    %eax,%eax
  1007d3:	01 d0                	add    %edx,%eax
  1007d5:	c1 e0 02             	shl    $0x2,%eax
  1007d8:	89 c2                	mov    %eax,%edx
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	01 d0                	add    %edx,%eax
  1007df:	8b 10                	mov    (%eax),%edx
  1007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e4:	01 c2                	add    %eax,%edx
  1007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7d 4a                	jge    10083f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f8:	83 c0 01             	add    $0x1,%eax
  1007fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fe:	eb 18                	jmp    100818 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100800:	8b 45 0c             	mov    0xc(%ebp),%eax
  100803:	8b 40 14             	mov    0x14(%eax),%eax
  100806:	8d 50 01             	lea    0x1(%eax),%edx
  100809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100812:	83 c0 01             	add    $0x1,%eax
  100815:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10081e:	39 c2                	cmp    %eax,%edx
  100820:	7d 1d                	jge    10083f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
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
  10083b:	3c a0                	cmp    $0xa0,%al
  10083d:	74 c1                	je     100800 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10083f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100844:	c9                   	leave  
  100845:	c3                   	ret    

00100846 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100846:	55                   	push   %ebp
  100847:	89 e5                	mov    %esp,%ebp
  100849:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10084c:	c7 04 24 76 35 10 00 	movl   $0x103576,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 8f 35 10 00 	movl   $0x10358f,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 b2 34 10 	movl   $0x1034b2,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 a7 35 10 00 	movl   $0x1035a7,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 bf 35 10 00 	movl   $0x1035bf,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 40 fd 10 	movl   $0x10fd40,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 d7 35 10 00 	movl   $0x1035d7,(%esp)
  1008a3:	e8 6a fa ff ff       	call   100312 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a8:	b8 40 fd 10 00       	mov    $0x10fd40,%eax
  1008ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008b8:	29 c2                	sub    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c2:	85 c0                	test   %eax,%eax
  1008c4:	0f 48 c2             	cmovs  %edx,%eax
  1008c7:	c1 f8 0a             	sar    $0xa,%eax
  1008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ce:	c7 04 24 f0 35 10 00 	movl   $0x1035f0,(%esp)
  1008d5:	e8 38 fa ff ff       	call   100312 <cprintf>
}
  1008da:	c9                   	leave  
  1008db:	c3                   	ret    

001008dc <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008dc:	55                   	push   %ebp
  1008dd:	89 e5                	mov    %esp,%ebp
  1008df:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ef:	89 04 24             	mov    %eax,(%esp)
  1008f2:	e8 12 fc ff ff       	call   100509 <debuginfo_eip>
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	74 15                	je     100910 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100902:	c7 04 24 1a 36 10 00 	movl   $0x10361a,(%esp)
  100909:	e8 04 fa ff ff       	call   100312 <cprintf>
  10090e:	eb 6d                	jmp    10097d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100917:	eb 1c                	jmp    100935 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091f:	01 d0                	add    %edx,%eax
  100921:	0f b6 00             	movzbl (%eax),%eax
  100924:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10092d:	01 ca                	add    %ecx,%edx
  10092f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10093b:	7f dc                	jg     100919 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10093d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10094b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10094e:	8b 55 08             	mov    0x8(%ebp),%edx
  100951:	89 d1                	mov    %edx,%ecx
  100953:	29 c1                	sub    %eax,%ecx
  100955:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100958:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10095b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10095f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100965:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100969:	89 54 24 08          	mov    %edx,0x8(%esp)
  10096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100971:	c7 04 24 36 36 10 00 	movl   $0x103636,(%esp)
  100978:	e8 95 f9 ff ff       	call   100312 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10097d:	c9                   	leave  
  10097e:	c3                   	ret    

0010097f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097f:	55                   	push   %ebp
  100980:	89 e5                	mov    %esp,%ebp
  100982:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100985:	8b 45 04             	mov    0x4(%ebp),%eax
  100988:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098e:	c9                   	leave  
  10098f:	c3                   	ret    

00100990 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	53                   	push   %ebx
  100994:	83 ec 54             	sub    $0x54,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100997:	89 e8                	mov    %ebp,%eax
  100999:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  10099c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

    uint32_t ebp_val = read_ebp();
  10099f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip_val = read_eip();
  1009a2:	e8 d8 ff ff ff       	call   10097f <read_eip>
  1009a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i = 0;
  1009aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for(i = 0; i < STACKFRAME_DEPTH && ebp_val != 0; i++){
  1009b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009b8:	e9 9d 00 00 00       	jmp    100a5a <print_stackframe+0xca>
        cprintf("ebp:0x%08x, eip:0x%08x", ebp_val, eip_val);  // 输出八位十六进制（即32位寄存器值）
  1009bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009c0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009cb:	c7 04 24 48 36 10 00 	movl   $0x103648,(%esp)
  1009d2:	e8 3b f9 ff ff       	call   100312 <cprintf>
        uint32_t* ebp_ptr = (uint32_t*)ebp_val;
  1009d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009da:	89 45 e8             	mov    %eax,-0x18(%ebp)
        uint32_t args[] = {*(ebp_ptr+2), *(ebp_ptr+3), *(ebp_ptr+4), *(ebp_ptr+5)};
  1009dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009e0:	8b 40 08             	mov    0x8(%eax),%eax
  1009e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1009e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009e9:	8b 40 0c             	mov    0xc(%eax),%eax
  1009ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1009ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009f2:	8b 40 10             	mov    0x10(%eax),%eax
  1009f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1009f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009fb:	8b 40 14             	mov    0x14(%eax),%eax
  1009fe:	89 45 e0             	mov    %eax,-0x20(%ebp)
        cprintf(" args:0x%08x 0x%08x 0x%08x 0x%08x", args[0], args[1], args[2], args[3]);
  100a01:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  100a04:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  100a07:	8b 55 d8             	mov    -0x28(%ebp),%edx
  100a0a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100a0d:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100a11:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a15:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a19:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a1d:	c7 04 24 60 36 10 00 	movl   $0x103660,(%esp)
  100a24:	e8 e9 f8 ff ff       	call   100312 <cprintf>
        cprintf("\n");
  100a29:	c7 04 24 82 36 10 00 	movl   $0x103682,(%esp)
  100a30:	e8 dd f8 ff ff       	call   100312 <cprintf>
        print_debuginfo(eip_val - 1);
  100a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a38:	83 e8 01             	sub    $0x1,%eax
  100a3b:	89 04 24             	mov    %eax,(%esp)
  100a3e:	e8 99 fe ff ff       	call   1008dc <print_debuginfo>
        eip_val = *(uint32_t*)(ebp_val + 4);
  100a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a46:	83 c0 04             	add    $0x4,%eax
  100a49:	8b 00                	mov    (%eax),%eax
  100a4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp_val = *(uint32_t*)ebp_val;
  100a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a51:	8b 00                	mov    (%eax),%eax
  100a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
      */

    uint32_t ebp_val = read_ebp();
    uint32_t eip_val = read_eip();
    int i = 0;
    for(i = 0; i < STACKFRAME_DEPTH && ebp_val != 0; i++){
  100a56:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a5a:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a5e:	7f 0a                	jg     100a6a <print_stackframe+0xda>
  100a60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a64:	0f 85 53 ff ff ff    	jne    1009bd <print_stackframe+0x2d>
        cprintf("\n");
        print_debuginfo(eip_val - 1);
        eip_val = *(uint32_t*)(ebp_val + 4);
        ebp_val = *(uint32_t*)ebp_val;
    }
}
  100a6a:	83 c4 54             	add    $0x54,%esp
  100a6d:	5b                   	pop    %ebx
  100a6e:	5d                   	pop    %ebp
  100a6f:	c3                   	ret    

00100a70 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a70:	55                   	push   %ebp
  100a71:	89 e5                	mov    %esp,%ebp
  100a73:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a7d:	eb 0c                	jmp    100a8b <parse+0x1b>
            *buf ++ = '\0';
  100a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a82:	8d 50 01             	lea    0x1(%eax),%edx
  100a85:	89 55 08             	mov    %edx,0x8(%ebp)
  100a88:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8e:	0f b6 00             	movzbl (%eax),%eax
  100a91:	84 c0                	test   %al,%al
  100a93:	74 1d                	je     100ab2 <parse+0x42>
  100a95:	8b 45 08             	mov    0x8(%ebp),%eax
  100a98:	0f b6 00             	movzbl (%eax),%eax
  100a9b:	0f be c0             	movsbl %al,%eax
  100a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aa2:	c7 04 24 04 37 10 00 	movl   $0x103704,(%esp)
  100aa9:	e8 bc 26 00 00       	call   10316a <strchr>
  100aae:	85 c0                	test   %eax,%eax
  100ab0:	75 cd                	jne    100a7f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ab5:	0f b6 00             	movzbl (%eax),%eax
  100ab8:	84 c0                	test   %al,%al
  100aba:	75 02                	jne    100abe <parse+0x4e>
            break;
  100abc:	eb 67                	jmp    100b25 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100abe:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ac2:	75 14                	jne    100ad8 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ac4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100acb:	00 
  100acc:	c7 04 24 09 37 10 00 	movl   $0x103709,(%esp)
  100ad3:	e8 3a f8 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  100ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100adb:	8d 50 01             	lea    0x1(%eax),%edx
  100ade:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ae1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  100aeb:	01 c2                	add    %eax,%edx
  100aed:	8b 45 08             	mov    0x8(%ebp),%eax
  100af0:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100af2:	eb 04                	jmp    100af8 <parse+0x88>
            buf ++;
  100af4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100af8:	8b 45 08             	mov    0x8(%ebp),%eax
  100afb:	0f b6 00             	movzbl (%eax),%eax
  100afe:	84 c0                	test   %al,%al
  100b00:	74 1d                	je     100b1f <parse+0xaf>
  100b02:	8b 45 08             	mov    0x8(%ebp),%eax
  100b05:	0f b6 00             	movzbl (%eax),%eax
  100b08:	0f be c0             	movsbl %al,%eax
  100b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b0f:	c7 04 24 04 37 10 00 	movl   $0x103704,(%esp)
  100b16:	e8 4f 26 00 00       	call   10316a <strchr>
  100b1b:	85 c0                	test   %eax,%eax
  100b1d:	74 d5                	je     100af4 <parse+0x84>
            buf ++;
        }
    }
  100b1f:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b20:	e9 66 ff ff ff       	jmp    100a8b <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b28:	c9                   	leave  
  100b29:	c3                   	ret    

00100b2a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b2a:	55                   	push   %ebp
  100b2b:	89 e5                	mov    %esp,%ebp
  100b2d:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b30:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b37:	8b 45 08             	mov    0x8(%ebp),%eax
  100b3a:	89 04 24             	mov    %eax,(%esp)
  100b3d:	e8 2e ff ff ff       	call   100a70 <parse>
  100b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b49:	75 0a                	jne    100b55 <runcmd+0x2b>
        return 0;
  100b4b:	b8 00 00 00 00       	mov    $0x0,%eax
  100b50:	e9 85 00 00 00       	jmp    100bda <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b5c:	eb 5c                	jmp    100bba <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b5e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b64:	89 d0                	mov    %edx,%eax
  100b66:	01 c0                	add    %eax,%eax
  100b68:	01 d0                	add    %edx,%eax
  100b6a:	c1 e0 02             	shl    $0x2,%eax
  100b6d:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b72:	8b 00                	mov    (%eax),%eax
  100b74:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b78:	89 04 24             	mov    %eax,(%esp)
  100b7b:	e8 4b 25 00 00       	call   1030cb <strcmp>
  100b80:	85 c0                	test   %eax,%eax
  100b82:	75 32                	jne    100bb6 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b87:	89 d0                	mov    %edx,%eax
  100b89:	01 c0                	add    %eax,%eax
  100b8b:	01 d0                	add    %edx,%eax
  100b8d:	c1 e0 02             	shl    $0x2,%eax
  100b90:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b95:	8b 40 08             	mov    0x8(%eax),%eax
  100b98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b9b:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  100ba1:	89 54 24 08          	mov    %edx,0x8(%esp)
  100ba5:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100ba8:	83 c2 04             	add    $0x4,%edx
  100bab:	89 54 24 04          	mov    %edx,0x4(%esp)
  100baf:	89 0c 24             	mov    %ecx,(%esp)
  100bb2:	ff d0                	call   *%eax
  100bb4:	eb 24                	jmp    100bda <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bb6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bbd:	83 f8 02             	cmp    $0x2,%eax
  100bc0:	76 9c                	jbe    100b5e <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bc2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc9:	c7 04 24 27 37 10 00 	movl   $0x103727,(%esp)
  100bd0:	e8 3d f7 ff ff       	call   100312 <cprintf>
    return 0;
  100bd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bda:	c9                   	leave  
  100bdb:	c3                   	ret    

00100bdc <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bdc:	55                   	push   %ebp
  100bdd:	89 e5                	mov    %esp,%ebp
  100bdf:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100be2:	c7 04 24 40 37 10 00 	movl   $0x103740,(%esp)
  100be9:	e8 24 f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bee:	c7 04 24 68 37 10 00 	movl   $0x103768,(%esp)
  100bf5:	e8 18 f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100bfa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bfe:	74 0b                	je     100c0b <kmonitor+0x2f>
        print_trapframe(tf);
  100c00:	8b 45 08             	mov    0x8(%ebp),%eax
  100c03:	89 04 24             	mov    %eax,(%esp)
  100c06:	e8 e4 0d 00 00       	call   1019ef <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c0b:	c7 04 24 8d 37 10 00 	movl   $0x10378d,(%esp)
  100c12:	e8 f2 f5 ff ff       	call   100209 <readline>
  100c17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c1e:	74 18                	je     100c38 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c20:	8b 45 08             	mov    0x8(%ebp),%eax
  100c23:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c2a:	89 04 24             	mov    %eax,(%esp)
  100c2d:	e8 f8 fe ff ff       	call   100b2a <runcmd>
  100c32:	85 c0                	test   %eax,%eax
  100c34:	79 02                	jns    100c38 <kmonitor+0x5c>
                break;
  100c36:	eb 02                	jmp    100c3a <kmonitor+0x5e>
            }
        }
    }
  100c38:	eb d1                	jmp    100c0b <kmonitor+0x2f>
}
  100c3a:	c9                   	leave  
  100c3b:	c3                   	ret    

00100c3c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c3c:	55                   	push   %ebp
  100c3d:	89 e5                	mov    %esp,%ebp
  100c3f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c49:	eb 3f                	jmp    100c8a <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c4e:	89 d0                	mov    %edx,%eax
  100c50:	01 c0                	add    %eax,%eax
  100c52:	01 d0                	add    %edx,%eax
  100c54:	c1 e0 02             	shl    $0x2,%eax
  100c57:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c5c:	8b 48 04             	mov    0x4(%eax),%ecx
  100c5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c62:	89 d0                	mov    %edx,%eax
  100c64:	01 c0                	add    %eax,%eax
  100c66:	01 d0                	add    %edx,%eax
  100c68:	c1 e0 02             	shl    $0x2,%eax
  100c6b:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c70:	8b 00                	mov    (%eax),%eax
  100c72:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c76:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c7a:	c7 04 24 91 37 10 00 	movl   $0x103791,(%esp)
  100c81:	e8 8c f6 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c86:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c8d:	83 f8 02             	cmp    $0x2,%eax
  100c90:	76 b9                	jbe    100c4b <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c97:	c9                   	leave  
  100c98:	c3                   	ret    

00100c99 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c99:	55                   	push   %ebp
  100c9a:	89 e5                	mov    %esp,%ebp
  100c9c:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c9f:	e8 a2 fb ff ff       	call   100846 <print_kerninfo>
    return 0;
  100ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca9:	c9                   	leave  
  100caa:	c3                   	ret    

00100cab <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cab:	55                   	push   %ebp
  100cac:	89 e5                	mov    %esp,%ebp
  100cae:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cb1:	e8 da fc ff ff       	call   100990 <print_stackframe>
    return 0;
  100cb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cbb:	c9                   	leave  
  100cbc:	c3                   	ret    

00100cbd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cbd:	55                   	push   %ebp
  100cbe:	89 e5                	mov    %esp,%ebp
  100cc0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cc3:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100cc8:	85 c0                	test   %eax,%eax
  100cca:	74 02                	je     100cce <__panic+0x11>
        goto panic_dead;
  100ccc:	eb 59                	jmp    100d27 <__panic+0x6a>
    }
    is_panic = 1;
  100cce:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cd5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cd8:	8d 45 14             	lea    0x14(%ebp),%eax
  100cdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cde:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ce1:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  100ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cec:	c7 04 24 9a 37 10 00 	movl   $0x10379a,(%esp)
  100cf3:	e8 1a f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cff:	8b 45 10             	mov    0x10(%ebp),%eax
  100d02:	89 04 24             	mov    %eax,(%esp)
  100d05:	e8 d5 f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d0a:	c7 04 24 b6 37 10 00 	movl   $0x1037b6,(%esp)
  100d11:	e8 fc f5 ff ff       	call   100312 <cprintf>
    
    cprintf("stack trackback:\n");
  100d16:	c7 04 24 b8 37 10 00 	movl   $0x1037b8,(%esp)
  100d1d:	e8 f0 f5 ff ff       	call   100312 <cprintf>
    print_stackframe();
  100d22:	e8 69 fc ff ff       	call   100990 <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  100d27:	e8 22 09 00 00       	call   10164e <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d2c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d33:	e8 a4 fe ff ff       	call   100bdc <kmonitor>
    }
  100d38:	eb f2                	jmp    100d2c <__panic+0x6f>

00100d3a <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d3a:	55                   	push   %ebp
  100d3b:	89 e5                	mov    %esp,%ebp
  100d3d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d40:	8d 45 14             	lea    0x14(%ebp),%eax
  100d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d49:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  100d50:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d54:	c7 04 24 ca 37 10 00 	movl   $0x1037ca,(%esp)
  100d5b:	e8 b2 f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d63:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d67:	8b 45 10             	mov    0x10(%ebp),%eax
  100d6a:	89 04 24             	mov    %eax,(%esp)
  100d6d:	e8 6d f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d72:	c7 04 24 b6 37 10 00 	movl   $0x1037b6,(%esp)
  100d79:	e8 94 f5 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100d7e:	c9                   	leave  
  100d7f:	c3                   	ret    

00100d80 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d80:	55                   	push   %ebp
  100d81:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d83:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d88:	5d                   	pop    %ebp
  100d89:	c3                   	ret    

00100d8a <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d8a:	55                   	push   %ebp
  100d8b:	89 e5                	mov    %esp,%ebp
  100d8d:	83 ec 28             	sub    $0x28,%esp
  100d90:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d96:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d9a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d9e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100da2:	ee                   	out    %al,(%dx)
  100da3:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da9:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dad:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100db1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db5:	ee                   	out    %al,(%dx)
  100db6:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dbc:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dc0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dc4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc8:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc9:	c7 05 28 f9 10 00 00 	movl   $0x0,0x10f928
  100dd0:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dd3:	c7 04 24 e8 37 10 00 	movl   $0x1037e8,(%esp)
  100dda:	e8 33 f5 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100ddf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de6:	e8 c1 08 00 00       	call   1016ac <pic_enable>
}
  100deb:	c9                   	leave  
  100dec:	c3                   	ret    

00100ded <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100ded:	55                   	push   %ebp
  100dee:	89 e5                	mov    %esp,%ebp
  100df0:	83 ec 10             	sub    $0x10,%esp
  100df3:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100df9:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dfd:	89 c2                	mov    %eax,%edx
  100dff:	ec                   	in     (%dx),%al
  100e00:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e03:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e09:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e0d:	89 c2                	mov    %eax,%edx
  100e0f:	ec                   	in     (%dx),%al
  100e10:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e13:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e19:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e1d:	89 c2                	mov    %eax,%edx
  100e1f:	ec                   	in     (%dx),%al
  100e20:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e23:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e29:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e2d:	89 c2                	mov    %eax,%edx
  100e2f:	ec                   	in     (%dx),%al
  100e30:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e33:	c9                   	leave  
  100e34:	c3                   	ret    

00100e35 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e35:	55                   	push   %ebp
  100e36:	89 e5                	mov    %esp,%ebp
  100e38:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e3b:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e45:	0f b7 00             	movzwl (%eax),%eax
  100e48:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e4f:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e57:	0f b7 00             	movzwl (%eax),%eax
  100e5a:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e5e:	74 12                	je     100e72 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e60:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e67:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e6e:	b4 03 
  100e70:	eb 13                	jmp    100e85 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e75:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e79:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e7c:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e83:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e85:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e8c:	0f b7 c0             	movzwl %ax,%eax
  100e8f:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e93:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e97:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e9b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e9f:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100ea0:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ea7:	83 c0 01             	add    $0x1,%eax
  100eaa:	0f b7 c0             	movzwl %ax,%eax
  100ead:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eb1:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eb5:	89 c2                	mov    %eax,%edx
  100eb7:	ec                   	in     (%dx),%al
  100eb8:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ebb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ebf:	0f b6 c0             	movzbl %al,%eax
  100ec2:	c1 e0 08             	shl    $0x8,%eax
  100ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ec8:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ecf:	0f b7 c0             	movzwl %ax,%eax
  100ed2:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ed6:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eda:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ede:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ee2:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ee3:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eea:	83 c0 01             	add    $0x1,%eax
  100eed:	0f b7 c0             	movzwl %ax,%eax
  100ef0:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ef4:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ef8:	89 c2                	mov    %eax,%edx
  100efa:	ec                   	in     (%dx),%al
  100efb:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100efe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f02:	0f b6 c0             	movzbl %al,%eax
  100f05:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f0b:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f13:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100f19:	c9                   	leave  
  100f1a:	c3                   	ret    

00100f1b <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f1b:	55                   	push   %ebp
  100f1c:	89 e5                	mov    %esp,%ebp
  100f1e:	83 ec 48             	sub    $0x48,%esp
  100f21:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f27:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f2b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f2f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f33:	ee                   	out    %al,(%dx)
  100f34:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f3a:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f3e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f42:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f46:	ee                   	out    %al,(%dx)
  100f47:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f4d:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f51:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f55:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f59:	ee                   	out    %al,(%dx)
  100f5a:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f60:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f64:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f68:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f6c:	ee                   	out    %al,(%dx)
  100f6d:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f73:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f77:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f7b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f7f:	ee                   	out    %al,(%dx)
  100f80:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f86:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f8a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f8e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f92:	ee                   	out    %al,(%dx)
  100f93:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f99:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f9d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fa1:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fa5:	ee                   	out    %al,(%dx)
  100fa6:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fac:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fb0:	89 c2                	mov    %eax,%edx
  100fb2:	ec                   	in     (%dx),%al
  100fb3:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100fb6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fba:	3c ff                	cmp    $0xff,%al
  100fbc:	0f 95 c0             	setne  %al
  100fbf:	0f b6 c0             	movzbl %al,%eax
  100fc2:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fc7:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fcd:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fd1:	89 c2                	mov    %eax,%edx
  100fd3:	ec                   	in     (%dx),%al
  100fd4:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fd7:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fdd:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fe1:	89 c2                	mov    %eax,%edx
  100fe3:	ec                   	in     (%dx),%al
  100fe4:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fe7:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fec:	85 c0                	test   %eax,%eax
  100fee:	74 0c                	je     100ffc <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100ff0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100ff7:	e8 b0 06 00 00       	call   1016ac <pic_enable>
    }
}
  100ffc:	c9                   	leave  
  100ffd:	c3                   	ret    

00100ffe <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100ffe:	55                   	push   %ebp
  100fff:	89 e5                	mov    %esp,%ebp
  101001:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101004:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10100b:	eb 09                	jmp    101016 <lpt_putc_sub+0x18>
        delay();
  10100d:	e8 db fd ff ff       	call   100ded <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101012:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101016:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10101c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101020:	89 c2                	mov    %eax,%edx
  101022:	ec                   	in     (%dx),%al
  101023:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101026:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10102a:	84 c0                	test   %al,%al
  10102c:	78 09                	js     101037 <lpt_putc_sub+0x39>
  10102e:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101035:	7e d6                	jle    10100d <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101037:	8b 45 08             	mov    0x8(%ebp),%eax
  10103a:	0f b6 c0             	movzbl %al,%eax
  10103d:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101043:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101046:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10104a:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10104e:	ee                   	out    %al,(%dx)
  10104f:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101055:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101059:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10105d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101061:	ee                   	out    %al,(%dx)
  101062:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101068:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10106c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101070:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101074:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101075:	c9                   	leave  
  101076:	c3                   	ret    

00101077 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101077:	55                   	push   %ebp
  101078:	89 e5                	mov    %esp,%ebp
  10107a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10107d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101081:	74 0d                	je     101090 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101083:	8b 45 08             	mov    0x8(%ebp),%eax
  101086:	89 04 24             	mov    %eax,(%esp)
  101089:	e8 70 ff ff ff       	call   100ffe <lpt_putc_sub>
  10108e:	eb 24                	jmp    1010b4 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101090:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101097:	e8 62 ff ff ff       	call   100ffe <lpt_putc_sub>
        lpt_putc_sub(' ');
  10109c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010a3:	e8 56 ff ff ff       	call   100ffe <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010a8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010af:	e8 4a ff ff ff       	call   100ffe <lpt_putc_sub>
    }
}
  1010b4:	c9                   	leave  
  1010b5:	c3                   	ret    

001010b6 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010b6:	55                   	push   %ebp
  1010b7:	89 e5                	mov    %esp,%ebp
  1010b9:	53                   	push   %ebx
  1010ba:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c0:	b0 00                	mov    $0x0,%al
  1010c2:	85 c0                	test   %eax,%eax
  1010c4:	75 07                	jne    1010cd <cga_putc+0x17>
        c |= 0x0700;
  1010c6:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1010d0:	0f b6 c0             	movzbl %al,%eax
  1010d3:	83 f8 0a             	cmp    $0xa,%eax
  1010d6:	74 4c                	je     101124 <cga_putc+0x6e>
  1010d8:	83 f8 0d             	cmp    $0xd,%eax
  1010db:	74 57                	je     101134 <cga_putc+0x7e>
  1010dd:	83 f8 08             	cmp    $0x8,%eax
  1010e0:	0f 85 88 00 00 00    	jne    10116e <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010e6:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010ed:	66 85 c0             	test   %ax,%ax
  1010f0:	74 30                	je     101122 <cga_putc+0x6c>
            crt_pos --;
  1010f2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010f9:	83 e8 01             	sub    $0x1,%eax
  1010fc:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101102:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101107:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  10110e:	0f b7 d2             	movzwl %dx,%edx
  101111:	01 d2                	add    %edx,%edx
  101113:	01 c2                	add    %eax,%edx
  101115:	8b 45 08             	mov    0x8(%ebp),%eax
  101118:	b0 00                	mov    $0x0,%al
  10111a:	83 c8 20             	or     $0x20,%eax
  10111d:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101120:	eb 72                	jmp    101194 <cga_putc+0xde>
  101122:	eb 70                	jmp    101194 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101124:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10112b:	83 c0 50             	add    $0x50,%eax
  10112e:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101134:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  10113b:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101142:	0f b7 c1             	movzwl %cx,%eax
  101145:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10114b:	c1 e8 10             	shr    $0x10,%eax
  10114e:	89 c2                	mov    %eax,%edx
  101150:	66 c1 ea 06          	shr    $0x6,%dx
  101154:	89 d0                	mov    %edx,%eax
  101156:	c1 e0 02             	shl    $0x2,%eax
  101159:	01 d0                	add    %edx,%eax
  10115b:	c1 e0 04             	shl    $0x4,%eax
  10115e:	29 c1                	sub    %eax,%ecx
  101160:	89 ca                	mov    %ecx,%edx
  101162:	89 d8                	mov    %ebx,%eax
  101164:	29 d0                	sub    %edx,%eax
  101166:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10116c:	eb 26                	jmp    101194 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10116e:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101174:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10117b:	8d 50 01             	lea    0x1(%eax),%edx
  10117e:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101185:	0f b7 c0             	movzwl %ax,%eax
  101188:	01 c0                	add    %eax,%eax
  10118a:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10118d:	8b 45 08             	mov    0x8(%ebp),%eax
  101190:	66 89 02             	mov    %ax,(%edx)
        break;
  101193:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101194:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10119b:	66 3d cf 07          	cmp    $0x7cf,%ax
  10119f:	76 5b                	jbe    1011fc <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011a1:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011a6:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011ac:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011b1:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011b8:	00 
  1011b9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011bd:	89 04 24             	mov    %eax,(%esp)
  1011c0:	e8 a3 21 00 00       	call   103368 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011c5:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011cc:	eb 15                	jmp    1011e3 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011ce:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011d6:	01 d2                	add    %edx,%edx
  1011d8:	01 d0                	add    %edx,%eax
  1011da:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011df:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011e3:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011ea:	7e e2                	jle    1011ce <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011ec:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011f3:	83 e8 50             	sub    $0x50,%eax
  1011f6:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011fc:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101203:	0f b7 c0             	movzwl %ax,%eax
  101206:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10120a:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10120e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101212:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101216:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101217:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10121e:	66 c1 e8 08          	shr    $0x8,%ax
  101222:	0f b6 c0             	movzbl %al,%eax
  101225:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10122c:	83 c2 01             	add    $0x1,%edx
  10122f:	0f b7 d2             	movzwl %dx,%edx
  101232:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101236:	88 45 ed             	mov    %al,-0x13(%ebp)
  101239:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10123d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101241:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101242:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101249:	0f b7 c0             	movzwl %ax,%eax
  10124c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101250:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101254:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101258:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10125c:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10125d:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101264:	0f b6 c0             	movzbl %al,%eax
  101267:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10126e:	83 c2 01             	add    $0x1,%edx
  101271:	0f b7 d2             	movzwl %dx,%edx
  101274:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101278:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10127b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10127f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101283:	ee                   	out    %al,(%dx)
}
  101284:	83 c4 34             	add    $0x34,%esp
  101287:	5b                   	pop    %ebx
  101288:	5d                   	pop    %ebp
  101289:	c3                   	ret    

0010128a <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10128a:	55                   	push   %ebp
  10128b:	89 e5                	mov    %esp,%ebp
  10128d:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101290:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101297:	eb 09                	jmp    1012a2 <serial_putc_sub+0x18>
        delay();
  101299:	e8 4f fb ff ff       	call   100ded <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10129e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012a2:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012a8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012ac:	89 c2                	mov    %eax,%edx
  1012ae:	ec                   	in     (%dx),%al
  1012af:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012b2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012b6:	0f b6 c0             	movzbl %al,%eax
  1012b9:	83 e0 20             	and    $0x20,%eax
  1012bc:	85 c0                	test   %eax,%eax
  1012be:	75 09                	jne    1012c9 <serial_putc_sub+0x3f>
  1012c0:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012c7:	7e d0                	jle    101299 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1012cc:	0f b6 c0             	movzbl %al,%eax
  1012cf:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012d5:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012d8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012dc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012e0:	ee                   	out    %al,(%dx)
}
  1012e1:	c9                   	leave  
  1012e2:	c3                   	ret    

001012e3 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012e3:	55                   	push   %ebp
  1012e4:	89 e5                	mov    %esp,%ebp
  1012e6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012e9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012ed:	74 0d                	je     1012fc <serial_putc+0x19>
        serial_putc_sub(c);
  1012ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1012f2:	89 04 24             	mov    %eax,(%esp)
  1012f5:	e8 90 ff ff ff       	call   10128a <serial_putc_sub>
  1012fa:	eb 24                	jmp    101320 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012fc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101303:	e8 82 ff ff ff       	call   10128a <serial_putc_sub>
        serial_putc_sub(' ');
  101308:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10130f:	e8 76 ff ff ff       	call   10128a <serial_putc_sub>
        serial_putc_sub('\b');
  101314:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10131b:	e8 6a ff ff ff       	call   10128a <serial_putc_sub>
    }
}
  101320:	c9                   	leave  
  101321:	c3                   	ret    

00101322 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101322:	55                   	push   %ebp
  101323:	89 e5                	mov    %esp,%ebp
  101325:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101328:	eb 33                	jmp    10135d <cons_intr+0x3b>
        if (c != 0) {
  10132a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10132e:	74 2d                	je     10135d <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101330:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101335:	8d 50 01             	lea    0x1(%eax),%edx
  101338:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10133e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101341:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101347:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10134c:	3d 00 02 00 00       	cmp    $0x200,%eax
  101351:	75 0a                	jne    10135d <cons_intr+0x3b>
                cons.wpos = 0;
  101353:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10135a:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  10135d:	8b 45 08             	mov    0x8(%ebp),%eax
  101360:	ff d0                	call   *%eax
  101362:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101365:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101369:	75 bf                	jne    10132a <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10136b:	c9                   	leave  
  10136c:	c3                   	ret    

0010136d <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10136d:	55                   	push   %ebp
  10136e:	89 e5                	mov    %esp,%ebp
  101370:	83 ec 10             	sub    $0x10,%esp
  101373:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101379:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10137d:	89 c2                	mov    %eax,%edx
  10137f:	ec                   	in     (%dx),%al
  101380:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101383:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101387:	0f b6 c0             	movzbl %al,%eax
  10138a:	83 e0 01             	and    $0x1,%eax
  10138d:	85 c0                	test   %eax,%eax
  10138f:	75 07                	jne    101398 <serial_proc_data+0x2b>
        return -1;
  101391:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101396:	eb 2a                	jmp    1013c2 <serial_proc_data+0x55>
  101398:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10139e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013a2:	89 c2                	mov    %eax,%edx
  1013a4:	ec                   	in     (%dx),%al
  1013a5:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013a8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013ac:	0f b6 c0             	movzbl %al,%eax
  1013af:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013b2:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013b6:	75 07                	jne    1013bf <serial_proc_data+0x52>
        c = '\b';
  1013b8:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013c2:	c9                   	leave  
  1013c3:	c3                   	ret    

001013c4 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013c4:	55                   	push   %ebp
  1013c5:	89 e5                	mov    %esp,%ebp
  1013c7:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013ca:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013cf:	85 c0                	test   %eax,%eax
  1013d1:	74 0c                	je     1013df <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013d3:	c7 04 24 6d 13 10 00 	movl   $0x10136d,(%esp)
  1013da:	e8 43 ff ff ff       	call   101322 <cons_intr>
    }
}
  1013df:	c9                   	leave  
  1013e0:	c3                   	ret    

001013e1 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013e1:	55                   	push   %ebp
  1013e2:	89 e5                	mov    %esp,%ebp
  1013e4:	83 ec 38             	sub    $0x38,%esp
  1013e7:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013ed:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013f1:	89 c2                	mov    %eax,%edx
  1013f3:	ec                   	in     (%dx),%al
  1013f4:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013f7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013fb:	0f b6 c0             	movzbl %al,%eax
  1013fe:	83 e0 01             	and    $0x1,%eax
  101401:	85 c0                	test   %eax,%eax
  101403:	75 0a                	jne    10140f <kbd_proc_data+0x2e>
        return -1;
  101405:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10140a:	e9 59 01 00 00       	jmp    101568 <kbd_proc_data+0x187>
  10140f:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101415:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101419:	89 c2                	mov    %eax,%edx
  10141b:	ec                   	in     (%dx),%al
  10141c:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10141f:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101423:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101426:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10142a:	75 17                	jne    101443 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10142c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101431:	83 c8 40             	or     $0x40,%eax
  101434:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101439:	b8 00 00 00 00       	mov    $0x0,%eax
  10143e:	e9 25 01 00 00       	jmp    101568 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101443:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101447:	84 c0                	test   %al,%al
  101449:	79 47                	jns    101492 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10144b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101450:	83 e0 40             	and    $0x40,%eax
  101453:	85 c0                	test   %eax,%eax
  101455:	75 09                	jne    101460 <kbd_proc_data+0x7f>
  101457:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10145b:	83 e0 7f             	and    $0x7f,%eax
  10145e:	eb 04                	jmp    101464 <kbd_proc_data+0x83>
  101460:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101464:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101467:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10146b:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101472:	83 c8 40             	or     $0x40,%eax
  101475:	0f b6 c0             	movzbl %al,%eax
  101478:	f7 d0                	not    %eax
  10147a:	89 c2                	mov    %eax,%edx
  10147c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101481:	21 d0                	and    %edx,%eax
  101483:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101488:	b8 00 00 00 00       	mov    $0x0,%eax
  10148d:	e9 d6 00 00 00       	jmp    101568 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101492:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101497:	83 e0 40             	and    $0x40,%eax
  10149a:	85 c0                	test   %eax,%eax
  10149c:	74 11                	je     1014af <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10149e:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014a2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a7:	83 e0 bf             	and    $0xffffffbf,%eax
  1014aa:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  1014af:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b3:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1014ba:	0f b6 d0             	movzbl %al,%edx
  1014bd:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c2:	09 d0                	or     %edx,%eax
  1014c4:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014c9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014cd:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014d4:	0f b6 d0             	movzbl %al,%edx
  1014d7:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014dc:	31 d0                	xor    %edx,%eax
  1014de:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014e3:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014e8:	83 e0 03             	and    $0x3,%eax
  1014eb:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014f2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f6:	01 d0                	add    %edx,%eax
  1014f8:	0f b6 00             	movzbl (%eax),%eax
  1014fb:	0f b6 c0             	movzbl %al,%eax
  1014fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101501:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101506:	83 e0 08             	and    $0x8,%eax
  101509:	85 c0                	test   %eax,%eax
  10150b:	74 22                	je     10152f <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10150d:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101511:	7e 0c                	jle    10151f <kbd_proc_data+0x13e>
  101513:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101517:	7f 06                	jg     10151f <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101519:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10151d:	eb 10                	jmp    10152f <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10151f:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101523:	7e 0a                	jle    10152f <kbd_proc_data+0x14e>
  101525:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101529:	7f 04                	jg     10152f <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10152b:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10152f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101534:	f7 d0                	not    %eax
  101536:	83 e0 06             	and    $0x6,%eax
  101539:	85 c0                	test   %eax,%eax
  10153b:	75 28                	jne    101565 <kbd_proc_data+0x184>
  10153d:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101544:	75 1f                	jne    101565 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101546:	c7 04 24 03 38 10 00 	movl   $0x103803,(%esp)
  10154d:	e8 c0 ed ff ff       	call   100312 <cprintf>
  101552:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101558:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10155c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101560:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101564:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101565:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101568:	c9                   	leave  
  101569:	c3                   	ret    

0010156a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10156a:	55                   	push   %ebp
  10156b:	89 e5                	mov    %esp,%ebp
  10156d:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101570:	c7 04 24 e1 13 10 00 	movl   $0x1013e1,(%esp)
  101577:	e8 a6 fd ff ff       	call   101322 <cons_intr>
}
  10157c:	c9                   	leave  
  10157d:	c3                   	ret    

0010157e <kbd_init>:

static void
kbd_init(void) {
  10157e:	55                   	push   %ebp
  10157f:	89 e5                	mov    %esp,%ebp
  101581:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101584:	e8 e1 ff ff ff       	call   10156a <kbd_intr>
    pic_enable(IRQ_KBD);
  101589:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101590:	e8 17 01 00 00       	call   1016ac <pic_enable>
}
  101595:	c9                   	leave  
  101596:	c3                   	ret    

00101597 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101597:	55                   	push   %ebp
  101598:	89 e5                	mov    %esp,%ebp
  10159a:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10159d:	e8 93 f8 ff ff       	call   100e35 <cga_init>
    serial_init();
  1015a2:	e8 74 f9 ff ff       	call   100f1b <serial_init>
    kbd_init();
  1015a7:	e8 d2 ff ff ff       	call   10157e <kbd_init>
    if (!serial_exists) {
  1015ac:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1015b1:	85 c0                	test   %eax,%eax
  1015b3:	75 0c                	jne    1015c1 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015b5:	c7 04 24 0f 38 10 00 	movl   $0x10380f,(%esp)
  1015bc:	e8 51 ed ff ff       	call   100312 <cprintf>
    }
}
  1015c1:	c9                   	leave  
  1015c2:	c3                   	ret    

001015c3 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015c3:	55                   	push   %ebp
  1015c4:	89 e5                	mov    %esp,%ebp
  1015c6:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1015cc:	89 04 24             	mov    %eax,(%esp)
  1015cf:	e8 a3 fa ff ff       	call   101077 <lpt_putc>
    cga_putc(c);
  1015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1015d7:	89 04 24             	mov    %eax,(%esp)
  1015da:	e8 d7 fa ff ff       	call   1010b6 <cga_putc>
    serial_putc(c);
  1015df:	8b 45 08             	mov    0x8(%ebp),%eax
  1015e2:	89 04 24             	mov    %eax,(%esp)
  1015e5:	e8 f9 fc ff ff       	call   1012e3 <serial_putc>
}
  1015ea:	c9                   	leave  
  1015eb:	c3                   	ret    

001015ec <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015ec:	55                   	push   %ebp
  1015ed:	89 e5                	mov    %esp,%ebp
  1015ef:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015f2:	e8 cd fd ff ff       	call   1013c4 <serial_intr>
    kbd_intr();
  1015f7:	e8 6e ff ff ff       	call   10156a <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015fc:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  101602:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101607:	39 c2                	cmp    %eax,%edx
  101609:	74 36                	je     101641 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  10160b:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101610:	8d 50 01             	lea    0x1(%eax),%edx
  101613:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  101619:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  101620:	0f b6 c0             	movzbl %al,%eax
  101623:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101626:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10162b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101630:	75 0a                	jne    10163c <cons_getc+0x50>
            cons.rpos = 0;
  101632:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101639:	00 00 00 
        }
        return c;
  10163c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10163f:	eb 05                	jmp    101646 <cons_getc+0x5a>
    }
    return 0;
  101641:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101646:	c9                   	leave  
  101647:	c3                   	ret    

00101648 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101648:	55                   	push   %ebp
  101649:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10164b:	fb                   	sti    
    sti();
}
  10164c:	5d                   	pop    %ebp
  10164d:	c3                   	ret    

0010164e <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10164e:	55                   	push   %ebp
  10164f:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101651:	fa                   	cli    
    cli();
}
  101652:	5d                   	pop    %ebp
  101653:	c3                   	ret    

00101654 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101654:	55                   	push   %ebp
  101655:	89 e5                	mov    %esp,%ebp
  101657:	83 ec 14             	sub    $0x14,%esp
  10165a:	8b 45 08             	mov    0x8(%ebp),%eax
  10165d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101661:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101665:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10166b:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101670:	85 c0                	test   %eax,%eax
  101672:	74 36                	je     1016aa <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101674:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101678:	0f b6 c0             	movzbl %al,%eax
  10167b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101681:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101684:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101688:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10168c:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10168d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101691:	66 c1 e8 08          	shr    $0x8,%ax
  101695:	0f b6 c0             	movzbl %al,%eax
  101698:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10169e:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016a1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016a5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016a9:	ee                   	out    %al,(%dx)
    }
}
  1016aa:	c9                   	leave  
  1016ab:	c3                   	ret    

001016ac <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016ac:	55                   	push   %ebp
  1016ad:	89 e5                	mov    %esp,%ebp
  1016af:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1016b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b5:	ba 01 00 00 00       	mov    $0x1,%edx
  1016ba:	89 c1                	mov    %eax,%ecx
  1016bc:	d3 e2                	shl    %cl,%edx
  1016be:	89 d0                	mov    %edx,%eax
  1016c0:	f7 d0                	not    %eax
  1016c2:	89 c2                	mov    %eax,%edx
  1016c4:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016cb:	21 d0                	and    %edx,%eax
  1016cd:	0f b7 c0             	movzwl %ax,%eax
  1016d0:	89 04 24             	mov    %eax,(%esp)
  1016d3:	e8 7c ff ff ff       	call   101654 <pic_setmask>
}
  1016d8:	c9                   	leave  
  1016d9:	c3                   	ret    

001016da <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016da:	55                   	push   %ebp
  1016db:	89 e5                	mov    %esp,%ebp
  1016dd:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016e0:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016e7:	00 00 00 
  1016ea:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016f0:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016f4:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016f8:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016fc:	ee                   	out    %al,(%dx)
  1016fd:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101703:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101707:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10170b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10170f:	ee                   	out    %al,(%dx)
  101710:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101716:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10171a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10171e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101722:	ee                   	out    %al,(%dx)
  101723:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101729:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10172d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101731:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101735:	ee                   	out    %al,(%dx)
  101736:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10173c:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101740:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101744:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101748:	ee                   	out    %al,(%dx)
  101749:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  10174f:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101753:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101757:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10175b:	ee                   	out    %al,(%dx)
  10175c:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101762:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101766:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10176a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10176e:	ee                   	out    %al,(%dx)
  10176f:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101775:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101779:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10177d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101781:	ee                   	out    %al,(%dx)
  101782:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101788:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10178c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101790:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101794:	ee                   	out    %al,(%dx)
  101795:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10179b:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  10179f:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017a3:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017a7:	ee                   	out    %al,(%dx)
  1017a8:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  1017ae:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  1017b2:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017b6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017ba:	ee                   	out    %al,(%dx)
  1017bb:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017c1:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1017c5:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017c9:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017cd:	ee                   	out    %al,(%dx)
  1017ce:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017d4:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017d8:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017dc:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017e0:	ee                   	out    %al,(%dx)
  1017e1:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017e7:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017eb:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017ef:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017f3:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017f4:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017fb:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017ff:	74 12                	je     101813 <pic_init+0x139>
        pic_setmask(irq_mask);
  101801:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101808:	0f b7 c0             	movzwl %ax,%eax
  10180b:	89 04 24             	mov    %eax,(%esp)
  10180e:	e8 41 fe ff ff       	call   101654 <pic_setmask>
    }
}
  101813:	c9                   	leave  
  101814:	c3                   	ret    

00101815 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101815:	55                   	push   %ebp
  101816:	89 e5                	mov    %esp,%ebp
  101818:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10181b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101822:	00 
  101823:	c7 04 24 40 38 10 00 	movl   $0x103840,(%esp)
  10182a:	e8 e3 ea ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10182f:	c9                   	leave  
  101830:	c3                   	ret    

00101831 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101831:	55                   	push   %ebp
  101832:	89 e5                	mov    %esp,%ebp
  101834:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i = 0;
  101837:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    for(i = 0; i < 256; i++) SETGATE(idt[i], 0, GD_KTEXT , __vectors[i], DPL_KERNEL);
  10183e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101845:	e9 c3 00 00 00       	jmp    10190d <idt_init+0xdc>
  10184a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184d:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101854:	89 c2                	mov    %eax,%edx
  101856:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101859:	66 89 14 c5 c0 f0 10 	mov    %dx,0x10f0c0(,%eax,8)
  101860:	00 
  101861:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101864:	66 c7 04 c5 c2 f0 10 	movw   $0x8,0x10f0c2(,%eax,8)
  10186b:	00 08 00 
  10186e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101871:	0f b6 14 c5 c4 f0 10 	movzbl 0x10f0c4(,%eax,8),%edx
  101878:	00 
  101879:	83 e2 e0             	and    $0xffffffe0,%edx
  10187c:	88 14 c5 c4 f0 10 00 	mov    %dl,0x10f0c4(,%eax,8)
  101883:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101886:	0f b6 14 c5 c4 f0 10 	movzbl 0x10f0c4(,%eax,8),%edx
  10188d:	00 
  10188e:	83 e2 1f             	and    $0x1f,%edx
  101891:	88 14 c5 c4 f0 10 00 	mov    %dl,0x10f0c4(,%eax,8)
  101898:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189b:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  1018a2:	00 
  1018a3:	83 e2 f0             	and    $0xfffffff0,%edx
  1018a6:	83 ca 0e             	or     $0xe,%edx
  1018a9:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  1018b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b3:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  1018ba:	00 
  1018bb:	83 e2 ef             	and    $0xffffffef,%edx
  1018be:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  1018c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c8:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  1018cf:	00 
  1018d0:	83 e2 9f             	and    $0xffffff9f,%edx
  1018d3:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  1018da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018dd:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  1018e4:	00 
  1018e5:	83 ca 80             	or     $0xffffff80,%edx
  1018e8:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  1018ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f2:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018f9:	c1 e8 10             	shr    $0x10,%eax
  1018fc:	89 c2                	mov    %eax,%edx
  1018fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101901:	66 89 14 c5 c6 f0 10 	mov    %dx,0x10f0c6(,%eax,8)
  101908:	00 
  101909:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10190d:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101914:	0f 8e 30 ff ff ff    	jle    10184a <idt_init+0x19>
    SETGATE(idt[T_SYSCALL], 0, GD_KTEXT , __vectors[T_SYSCALL], DPL_USER);
  10191a:	a1 e0 e7 10 00       	mov    0x10e7e0,%eax
  10191f:	66 a3 c0 f4 10 00    	mov    %ax,0x10f4c0
  101925:	66 c7 05 c2 f4 10 00 	movw   $0x8,0x10f4c2
  10192c:	08 00 
  10192e:	0f b6 05 c4 f4 10 00 	movzbl 0x10f4c4,%eax
  101935:	83 e0 e0             	and    $0xffffffe0,%eax
  101938:	a2 c4 f4 10 00       	mov    %al,0x10f4c4
  10193d:	0f b6 05 c4 f4 10 00 	movzbl 0x10f4c4,%eax
  101944:	83 e0 1f             	and    $0x1f,%eax
  101947:	a2 c4 f4 10 00       	mov    %al,0x10f4c4
  10194c:	0f b6 05 c5 f4 10 00 	movzbl 0x10f4c5,%eax
  101953:	83 e0 f0             	and    $0xfffffff0,%eax
  101956:	83 c8 0e             	or     $0xe,%eax
  101959:	a2 c5 f4 10 00       	mov    %al,0x10f4c5
  10195e:	0f b6 05 c5 f4 10 00 	movzbl 0x10f4c5,%eax
  101965:	83 e0 ef             	and    $0xffffffef,%eax
  101968:	a2 c5 f4 10 00       	mov    %al,0x10f4c5
  10196d:	0f b6 05 c5 f4 10 00 	movzbl 0x10f4c5,%eax
  101974:	83 c8 60             	or     $0x60,%eax
  101977:	a2 c5 f4 10 00       	mov    %al,0x10f4c5
  10197c:	0f b6 05 c5 f4 10 00 	movzbl 0x10f4c5,%eax
  101983:	83 c8 80             	or     $0xffffff80,%eax
  101986:	a2 c5 f4 10 00       	mov    %al,0x10f4c5
  10198b:	a1 e0 e7 10 00       	mov    0x10e7e0,%eax
  101990:	c1 e8 10             	shr    $0x10,%eax
  101993:	66 a3 c6 f4 10 00    	mov    %ax,0x10f4c6
  101999:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  1019a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019a3:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd);
}
  1019a6:	c9                   	leave  
  1019a7:	c3                   	ret    

001019a8 <trapname>:

static const char *
trapname(int trapno) {
  1019a8:	55                   	push   %ebp
  1019a9:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ae:	83 f8 13             	cmp    $0x13,%eax
  1019b1:	77 0c                	ja     1019bf <trapname+0x17>
        return excnames[trapno];
  1019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b6:	8b 04 85 a0 3b 10 00 	mov    0x103ba0(,%eax,4),%eax
  1019bd:	eb 18                	jmp    1019d7 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019bf:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019c3:	7e 0d                	jle    1019d2 <trapname+0x2a>
  1019c5:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019c9:	7f 07                	jg     1019d2 <trapname+0x2a>
        return "Hardware Interrupt";
  1019cb:	b8 4a 38 10 00       	mov    $0x10384a,%eax
  1019d0:	eb 05                	jmp    1019d7 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019d2:	b8 5d 38 10 00       	mov    $0x10385d,%eax
}
  1019d7:	5d                   	pop    %ebp
  1019d8:	c3                   	ret    

001019d9 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019d9:	55                   	push   %ebp
  1019da:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1019df:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019e3:	66 83 f8 08          	cmp    $0x8,%ax
  1019e7:	0f 94 c0             	sete   %al
  1019ea:	0f b6 c0             	movzbl %al,%eax
}
  1019ed:	5d                   	pop    %ebp
  1019ee:	c3                   	ret    

001019ef <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019ef:	55                   	push   %ebp
  1019f0:	89 e5                	mov    %esp,%ebp
  1019f2:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019fc:	c7 04 24 9e 38 10 00 	movl   $0x10389e,(%esp)
  101a03:	e8 0a e9 ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  101a08:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0b:	89 04 24             	mov    %eax,(%esp)
  101a0e:	e8 a1 01 00 00       	call   101bb4 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a13:	8b 45 08             	mov    0x8(%ebp),%eax
  101a16:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a1a:	0f b7 c0             	movzwl %ax,%eax
  101a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a21:	c7 04 24 af 38 10 00 	movl   $0x1038af,(%esp)
  101a28:	e8 e5 e8 ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a30:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a34:	0f b7 c0             	movzwl %ax,%eax
  101a37:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a3b:	c7 04 24 c2 38 10 00 	movl   $0x1038c2,(%esp)
  101a42:	e8 cb e8 ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a47:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4a:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a4e:	0f b7 c0             	movzwl %ax,%eax
  101a51:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a55:	c7 04 24 d5 38 10 00 	movl   $0x1038d5,(%esp)
  101a5c:	e8 b1 e8 ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a61:	8b 45 08             	mov    0x8(%ebp),%eax
  101a64:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a68:	0f b7 c0             	movzwl %ax,%eax
  101a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a6f:	c7 04 24 e8 38 10 00 	movl   $0x1038e8,(%esp)
  101a76:	e8 97 e8 ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7e:	8b 40 30             	mov    0x30(%eax),%eax
  101a81:	89 04 24             	mov    %eax,(%esp)
  101a84:	e8 1f ff ff ff       	call   1019a8 <trapname>
  101a89:	8b 55 08             	mov    0x8(%ebp),%edx
  101a8c:	8b 52 30             	mov    0x30(%edx),%edx
  101a8f:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a93:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a97:	c7 04 24 fb 38 10 00 	movl   $0x1038fb,(%esp)
  101a9e:	e8 6f e8 ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa6:	8b 40 34             	mov    0x34(%eax),%eax
  101aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aad:	c7 04 24 0d 39 10 00 	movl   $0x10390d,(%esp)
  101ab4:	e8 59 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  101abc:	8b 40 38             	mov    0x38(%eax),%eax
  101abf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac3:	c7 04 24 1c 39 10 00 	movl   $0x10391c,(%esp)
  101aca:	e8 43 e8 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101acf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad2:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ad6:	0f b7 c0             	movzwl %ax,%eax
  101ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101add:	c7 04 24 2b 39 10 00 	movl   $0x10392b,(%esp)
  101ae4:	e8 29 e8 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  101aec:	8b 40 40             	mov    0x40(%eax),%eax
  101aef:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af3:	c7 04 24 3e 39 10 00 	movl   $0x10393e,(%esp)
  101afa:	e8 13 e8 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101aff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b06:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b0d:	eb 3e                	jmp    101b4d <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b12:	8b 50 40             	mov    0x40(%eax),%edx
  101b15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b18:	21 d0                	and    %edx,%eax
  101b1a:	85 c0                	test   %eax,%eax
  101b1c:	74 28                	je     101b46 <print_trapframe+0x157>
  101b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b21:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b28:	85 c0                	test   %eax,%eax
  101b2a:	74 1a                	je     101b46 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b2f:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b36:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3a:	c7 04 24 4d 39 10 00 	movl   $0x10394d,(%esp)
  101b41:	e8 cc e7 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b46:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b4a:	d1 65 f0             	shll   -0x10(%ebp)
  101b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b50:	83 f8 17             	cmp    $0x17,%eax
  101b53:	76 ba                	jbe    101b0f <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b55:	8b 45 08             	mov    0x8(%ebp),%eax
  101b58:	8b 40 40             	mov    0x40(%eax),%eax
  101b5b:	25 00 30 00 00       	and    $0x3000,%eax
  101b60:	c1 e8 0c             	shr    $0xc,%eax
  101b63:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b67:	c7 04 24 51 39 10 00 	movl   $0x103951,(%esp)
  101b6e:	e8 9f e7 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b73:	8b 45 08             	mov    0x8(%ebp),%eax
  101b76:	89 04 24             	mov    %eax,(%esp)
  101b79:	e8 5b fe ff ff       	call   1019d9 <trap_in_kernel>
  101b7e:	85 c0                	test   %eax,%eax
  101b80:	75 30                	jne    101bb2 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b82:	8b 45 08             	mov    0x8(%ebp),%eax
  101b85:	8b 40 44             	mov    0x44(%eax),%eax
  101b88:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8c:	c7 04 24 5a 39 10 00 	movl   $0x10395a,(%esp)
  101b93:	e8 7a e7 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b98:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9b:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b9f:	0f b7 c0             	movzwl %ax,%eax
  101ba2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba6:	c7 04 24 69 39 10 00 	movl   $0x103969,(%esp)
  101bad:	e8 60 e7 ff ff       	call   100312 <cprintf>
    }
}
  101bb2:	c9                   	leave  
  101bb3:	c3                   	ret    

00101bb4 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bb4:	55                   	push   %ebp
  101bb5:	89 e5                	mov    %esp,%ebp
  101bb7:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bba:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbd:	8b 00                	mov    (%eax),%eax
  101bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc3:	c7 04 24 7c 39 10 00 	movl   $0x10397c,(%esp)
  101bca:	e8 43 e7 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd2:	8b 40 04             	mov    0x4(%eax),%eax
  101bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd9:	c7 04 24 8b 39 10 00 	movl   $0x10398b,(%esp)
  101be0:	e8 2d e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101be5:	8b 45 08             	mov    0x8(%ebp),%eax
  101be8:	8b 40 08             	mov    0x8(%eax),%eax
  101beb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bef:	c7 04 24 9a 39 10 00 	movl   $0x10399a,(%esp)
  101bf6:	e8 17 e7 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfe:	8b 40 0c             	mov    0xc(%eax),%eax
  101c01:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c05:	c7 04 24 a9 39 10 00 	movl   $0x1039a9,(%esp)
  101c0c:	e8 01 e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c11:	8b 45 08             	mov    0x8(%ebp),%eax
  101c14:	8b 40 10             	mov    0x10(%eax),%eax
  101c17:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1b:	c7 04 24 b8 39 10 00 	movl   $0x1039b8,(%esp)
  101c22:	e8 eb e6 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c27:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2a:	8b 40 14             	mov    0x14(%eax),%eax
  101c2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c31:	c7 04 24 c7 39 10 00 	movl   $0x1039c7,(%esp)
  101c38:	e8 d5 e6 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c40:	8b 40 18             	mov    0x18(%eax),%eax
  101c43:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c47:	c7 04 24 d6 39 10 00 	movl   $0x1039d6,(%esp)
  101c4e:	e8 bf e6 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c53:	8b 45 08             	mov    0x8(%ebp),%eax
  101c56:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c59:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5d:	c7 04 24 e5 39 10 00 	movl   $0x1039e5,(%esp)
  101c64:	e8 a9 e6 ff ff       	call   100312 <cprintf>
}
  101c69:	c9                   	leave  
  101c6a:	c3                   	ret    

00101c6b <trap_dispatch>:

int e_count = 0;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c6b:	55                   	push   %ebp
  101c6c:	89 e5                	mov    %esp,%ebp
  101c6e:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c71:	8b 45 08             	mov    0x8(%ebp),%eax
  101c74:	8b 40 30             	mov    0x30(%eax),%eax
  101c77:	83 f8 2f             	cmp    $0x2f,%eax
  101c7a:	77 21                	ja     101c9d <trap_dispatch+0x32>
  101c7c:	83 f8 2e             	cmp    $0x2e,%eax
  101c7f:	0f 83 0b 01 00 00    	jae    101d90 <trap_dispatch+0x125>
  101c85:	83 f8 21             	cmp    $0x21,%eax
  101c88:	0f 84 88 00 00 00    	je     101d16 <trap_dispatch+0xab>
  101c8e:	83 f8 24             	cmp    $0x24,%eax
  101c91:	74 5d                	je     101cf0 <trap_dispatch+0x85>
  101c93:	83 f8 20             	cmp    $0x20,%eax
  101c96:	74 16                	je     101cae <trap_dispatch+0x43>
  101c98:	e9 bb 00 00 00       	jmp    101d58 <trap_dispatch+0xed>
  101c9d:	83 e8 78             	sub    $0x78,%eax
  101ca0:	83 f8 01             	cmp    $0x1,%eax
  101ca3:	0f 87 af 00 00 00    	ja     101d58 <trap_dispatch+0xed>
  101ca9:	e9 8e 00 00 00       	jmp    101d3c <trap_dispatch+0xd1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        e_count++ != 0 ? e_count % TICK_NUM == 0 ? print_ticks() : NULL : NULL;
  101cae:	a1 a0 f0 10 00       	mov    0x10f0a0,%eax
  101cb3:	8d 50 01             	lea    0x1(%eax),%edx
  101cb6:	89 15 a0 f0 10 00    	mov    %edx,0x10f0a0
  101cbc:	85 c0                	test   %eax,%eax
  101cbe:	74 2b                	je     101ceb <trap_dispatch+0x80>
  101cc0:	8b 0d a0 f0 10 00    	mov    0x10f0a0,%ecx
  101cc6:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101ccb:	89 c8                	mov    %ecx,%eax
  101ccd:	f7 ea                	imul   %edx
  101ccf:	c1 fa 05             	sar    $0x5,%edx
  101cd2:	89 c8                	mov    %ecx,%eax
  101cd4:	c1 f8 1f             	sar    $0x1f,%eax
  101cd7:	29 c2                	sub    %eax,%edx
  101cd9:	89 d0                	mov    %edx,%eax
  101cdb:	6b c0 64             	imul   $0x64,%eax,%eax
  101cde:	29 c1                	sub    %eax,%ecx
  101ce0:	89 c8                	mov    %ecx,%eax
  101ce2:	85 c0                	test   %eax,%eax
  101ce4:	75 05                	jne    101ceb <trap_dispatch+0x80>
  101ce6:	e8 2a fb ff ff       	call   101815 <print_ticks>
        break;
  101ceb:	e9 a1 00 00 00       	jmp    101d91 <trap_dispatch+0x126>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cf0:	e8 f7 f8 ff ff       	call   1015ec <cons_getc>
  101cf5:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cf8:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cfc:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d00:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d08:	c7 04 24 f4 39 10 00 	movl   $0x1039f4,(%esp)
  101d0f:	e8 fe e5 ff ff       	call   100312 <cprintf>
        break;
  101d14:	eb 7b                	jmp    101d91 <trap_dispatch+0x126>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d16:	e8 d1 f8 ff ff       	call   1015ec <cons_getc>
  101d1b:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d1e:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d22:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d26:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d2e:	c7 04 24 06 3a 10 00 	movl   $0x103a06,(%esp)
  101d35:	e8 d8 e5 ff ff       	call   100312 <cprintf>
        break;
  101d3a:	eb 55                	jmp    101d91 <trap_dispatch+0x126>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d3c:	c7 44 24 08 15 3a 10 	movl   $0x103a15,0x8(%esp)
  101d43:	00 
  101d44:	c7 44 24 04 aa 00 00 	movl   $0xaa,0x4(%esp)
  101d4b:	00 
  101d4c:	c7 04 24 25 3a 10 00 	movl   $0x103a25,(%esp)
  101d53:	e8 65 ef ff ff       	call   100cbd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d58:	8b 45 08             	mov    0x8(%ebp),%eax
  101d5b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d5f:	0f b7 c0             	movzwl %ax,%eax
  101d62:	83 e0 03             	and    $0x3,%eax
  101d65:	85 c0                	test   %eax,%eax
  101d67:	75 28                	jne    101d91 <trap_dispatch+0x126>
            print_trapframe(tf);
  101d69:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6c:	89 04 24             	mov    %eax,(%esp)
  101d6f:	e8 7b fc ff ff       	call   1019ef <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d74:	c7 44 24 08 36 3a 10 	movl   $0x103a36,0x8(%esp)
  101d7b:	00 
  101d7c:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  101d83:	00 
  101d84:	c7 04 24 25 3a 10 00 	movl   $0x103a25,(%esp)
  101d8b:	e8 2d ef ff ff       	call   100cbd <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d90:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d91:	c9                   	leave  
  101d92:	c3                   	ret    

00101d93 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d93:	55                   	push   %ebp
  101d94:	89 e5                	mov    %esp,%ebp
  101d96:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d99:	8b 45 08             	mov    0x8(%ebp),%eax
  101d9c:	89 04 24             	mov    %eax,(%esp)
  101d9f:	e8 c7 fe ff ff       	call   101c6b <trap_dispatch>
}
  101da4:	c9                   	leave  
  101da5:	c3                   	ret    

00101da6 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101da6:	1e                   	push   %ds
    pushl %es
  101da7:	06                   	push   %es
    pushl %fs
  101da8:	0f a0                	push   %fs
    pushl %gs
  101daa:	0f a8                	push   %gs
    pushal
  101dac:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101dad:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101db2:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101db4:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101db6:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101db7:	e8 d7 ff ff ff       	call   101d93 <trap>

    # pop the pushed stack pointer
    popl %esp
  101dbc:	5c                   	pop    %esp

00101dbd <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101dbd:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101dbe:	0f a9                	pop    %gs
    popl %fs
  101dc0:	0f a1                	pop    %fs
    popl %es
  101dc2:	07                   	pop    %es
    popl %ds
  101dc3:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101dc4:	83 c4 08             	add    $0x8,%esp
    iret
  101dc7:	cf                   	iret   

00101dc8 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101dc8:	6a 00                	push   $0x0
  pushl $0
  101dca:	6a 00                	push   $0x0
  jmp __alltraps
  101dcc:	e9 d5 ff ff ff       	jmp    101da6 <__alltraps>

00101dd1 <vector1>:
.globl vector1
vector1:
  pushl $0
  101dd1:	6a 00                	push   $0x0
  pushl $1
  101dd3:	6a 01                	push   $0x1
  jmp __alltraps
  101dd5:	e9 cc ff ff ff       	jmp    101da6 <__alltraps>

00101dda <vector2>:
.globl vector2
vector2:
  pushl $0
  101dda:	6a 00                	push   $0x0
  pushl $2
  101ddc:	6a 02                	push   $0x2
  jmp __alltraps
  101dde:	e9 c3 ff ff ff       	jmp    101da6 <__alltraps>

00101de3 <vector3>:
.globl vector3
vector3:
  pushl $0
  101de3:	6a 00                	push   $0x0
  pushl $3
  101de5:	6a 03                	push   $0x3
  jmp __alltraps
  101de7:	e9 ba ff ff ff       	jmp    101da6 <__alltraps>

00101dec <vector4>:
.globl vector4
vector4:
  pushl $0
  101dec:	6a 00                	push   $0x0
  pushl $4
  101dee:	6a 04                	push   $0x4
  jmp __alltraps
  101df0:	e9 b1 ff ff ff       	jmp    101da6 <__alltraps>

00101df5 <vector5>:
.globl vector5
vector5:
  pushl $0
  101df5:	6a 00                	push   $0x0
  pushl $5
  101df7:	6a 05                	push   $0x5
  jmp __alltraps
  101df9:	e9 a8 ff ff ff       	jmp    101da6 <__alltraps>

00101dfe <vector6>:
.globl vector6
vector6:
  pushl $0
  101dfe:	6a 00                	push   $0x0
  pushl $6
  101e00:	6a 06                	push   $0x6
  jmp __alltraps
  101e02:	e9 9f ff ff ff       	jmp    101da6 <__alltraps>

00101e07 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e07:	6a 00                	push   $0x0
  pushl $7
  101e09:	6a 07                	push   $0x7
  jmp __alltraps
  101e0b:	e9 96 ff ff ff       	jmp    101da6 <__alltraps>

00101e10 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e10:	6a 08                	push   $0x8
  jmp __alltraps
  101e12:	e9 8f ff ff ff       	jmp    101da6 <__alltraps>

00101e17 <vector9>:
.globl vector9
vector9:
  pushl $0
  101e17:	6a 00                	push   $0x0
  pushl $9
  101e19:	6a 09                	push   $0x9
  jmp __alltraps
  101e1b:	e9 86 ff ff ff       	jmp    101da6 <__alltraps>

00101e20 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e20:	6a 0a                	push   $0xa
  jmp __alltraps
  101e22:	e9 7f ff ff ff       	jmp    101da6 <__alltraps>

00101e27 <vector11>:
.globl vector11
vector11:
  pushl $11
  101e27:	6a 0b                	push   $0xb
  jmp __alltraps
  101e29:	e9 78 ff ff ff       	jmp    101da6 <__alltraps>

00101e2e <vector12>:
.globl vector12
vector12:
  pushl $12
  101e2e:	6a 0c                	push   $0xc
  jmp __alltraps
  101e30:	e9 71 ff ff ff       	jmp    101da6 <__alltraps>

00101e35 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e35:	6a 0d                	push   $0xd
  jmp __alltraps
  101e37:	e9 6a ff ff ff       	jmp    101da6 <__alltraps>

00101e3c <vector14>:
.globl vector14
vector14:
  pushl $14
  101e3c:	6a 0e                	push   $0xe
  jmp __alltraps
  101e3e:	e9 63 ff ff ff       	jmp    101da6 <__alltraps>

00101e43 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e43:	6a 00                	push   $0x0
  pushl $15
  101e45:	6a 0f                	push   $0xf
  jmp __alltraps
  101e47:	e9 5a ff ff ff       	jmp    101da6 <__alltraps>

00101e4c <vector16>:
.globl vector16
vector16:
  pushl $0
  101e4c:	6a 00                	push   $0x0
  pushl $16
  101e4e:	6a 10                	push   $0x10
  jmp __alltraps
  101e50:	e9 51 ff ff ff       	jmp    101da6 <__alltraps>

00101e55 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e55:	6a 11                	push   $0x11
  jmp __alltraps
  101e57:	e9 4a ff ff ff       	jmp    101da6 <__alltraps>

00101e5c <vector18>:
.globl vector18
vector18:
  pushl $0
  101e5c:	6a 00                	push   $0x0
  pushl $18
  101e5e:	6a 12                	push   $0x12
  jmp __alltraps
  101e60:	e9 41 ff ff ff       	jmp    101da6 <__alltraps>

00101e65 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e65:	6a 00                	push   $0x0
  pushl $19
  101e67:	6a 13                	push   $0x13
  jmp __alltraps
  101e69:	e9 38 ff ff ff       	jmp    101da6 <__alltraps>

00101e6e <vector20>:
.globl vector20
vector20:
  pushl $0
  101e6e:	6a 00                	push   $0x0
  pushl $20
  101e70:	6a 14                	push   $0x14
  jmp __alltraps
  101e72:	e9 2f ff ff ff       	jmp    101da6 <__alltraps>

00101e77 <vector21>:
.globl vector21
vector21:
  pushl $0
  101e77:	6a 00                	push   $0x0
  pushl $21
  101e79:	6a 15                	push   $0x15
  jmp __alltraps
  101e7b:	e9 26 ff ff ff       	jmp    101da6 <__alltraps>

00101e80 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e80:	6a 00                	push   $0x0
  pushl $22
  101e82:	6a 16                	push   $0x16
  jmp __alltraps
  101e84:	e9 1d ff ff ff       	jmp    101da6 <__alltraps>

00101e89 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e89:	6a 00                	push   $0x0
  pushl $23
  101e8b:	6a 17                	push   $0x17
  jmp __alltraps
  101e8d:	e9 14 ff ff ff       	jmp    101da6 <__alltraps>

00101e92 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e92:	6a 00                	push   $0x0
  pushl $24
  101e94:	6a 18                	push   $0x18
  jmp __alltraps
  101e96:	e9 0b ff ff ff       	jmp    101da6 <__alltraps>

00101e9b <vector25>:
.globl vector25
vector25:
  pushl $0
  101e9b:	6a 00                	push   $0x0
  pushl $25
  101e9d:	6a 19                	push   $0x19
  jmp __alltraps
  101e9f:	e9 02 ff ff ff       	jmp    101da6 <__alltraps>

00101ea4 <vector26>:
.globl vector26
vector26:
  pushl $0
  101ea4:	6a 00                	push   $0x0
  pushl $26
  101ea6:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ea8:	e9 f9 fe ff ff       	jmp    101da6 <__alltraps>

00101ead <vector27>:
.globl vector27
vector27:
  pushl $0
  101ead:	6a 00                	push   $0x0
  pushl $27
  101eaf:	6a 1b                	push   $0x1b
  jmp __alltraps
  101eb1:	e9 f0 fe ff ff       	jmp    101da6 <__alltraps>

00101eb6 <vector28>:
.globl vector28
vector28:
  pushl $0
  101eb6:	6a 00                	push   $0x0
  pushl $28
  101eb8:	6a 1c                	push   $0x1c
  jmp __alltraps
  101eba:	e9 e7 fe ff ff       	jmp    101da6 <__alltraps>

00101ebf <vector29>:
.globl vector29
vector29:
  pushl $0
  101ebf:	6a 00                	push   $0x0
  pushl $29
  101ec1:	6a 1d                	push   $0x1d
  jmp __alltraps
  101ec3:	e9 de fe ff ff       	jmp    101da6 <__alltraps>

00101ec8 <vector30>:
.globl vector30
vector30:
  pushl $0
  101ec8:	6a 00                	push   $0x0
  pushl $30
  101eca:	6a 1e                	push   $0x1e
  jmp __alltraps
  101ecc:	e9 d5 fe ff ff       	jmp    101da6 <__alltraps>

00101ed1 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ed1:	6a 00                	push   $0x0
  pushl $31
  101ed3:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ed5:	e9 cc fe ff ff       	jmp    101da6 <__alltraps>

00101eda <vector32>:
.globl vector32
vector32:
  pushl $0
  101eda:	6a 00                	push   $0x0
  pushl $32
  101edc:	6a 20                	push   $0x20
  jmp __alltraps
  101ede:	e9 c3 fe ff ff       	jmp    101da6 <__alltraps>

00101ee3 <vector33>:
.globl vector33
vector33:
  pushl $0
  101ee3:	6a 00                	push   $0x0
  pushl $33
  101ee5:	6a 21                	push   $0x21
  jmp __alltraps
  101ee7:	e9 ba fe ff ff       	jmp    101da6 <__alltraps>

00101eec <vector34>:
.globl vector34
vector34:
  pushl $0
  101eec:	6a 00                	push   $0x0
  pushl $34
  101eee:	6a 22                	push   $0x22
  jmp __alltraps
  101ef0:	e9 b1 fe ff ff       	jmp    101da6 <__alltraps>

00101ef5 <vector35>:
.globl vector35
vector35:
  pushl $0
  101ef5:	6a 00                	push   $0x0
  pushl $35
  101ef7:	6a 23                	push   $0x23
  jmp __alltraps
  101ef9:	e9 a8 fe ff ff       	jmp    101da6 <__alltraps>

00101efe <vector36>:
.globl vector36
vector36:
  pushl $0
  101efe:	6a 00                	push   $0x0
  pushl $36
  101f00:	6a 24                	push   $0x24
  jmp __alltraps
  101f02:	e9 9f fe ff ff       	jmp    101da6 <__alltraps>

00101f07 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f07:	6a 00                	push   $0x0
  pushl $37
  101f09:	6a 25                	push   $0x25
  jmp __alltraps
  101f0b:	e9 96 fe ff ff       	jmp    101da6 <__alltraps>

00101f10 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f10:	6a 00                	push   $0x0
  pushl $38
  101f12:	6a 26                	push   $0x26
  jmp __alltraps
  101f14:	e9 8d fe ff ff       	jmp    101da6 <__alltraps>

00101f19 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f19:	6a 00                	push   $0x0
  pushl $39
  101f1b:	6a 27                	push   $0x27
  jmp __alltraps
  101f1d:	e9 84 fe ff ff       	jmp    101da6 <__alltraps>

00101f22 <vector40>:
.globl vector40
vector40:
  pushl $0
  101f22:	6a 00                	push   $0x0
  pushl $40
  101f24:	6a 28                	push   $0x28
  jmp __alltraps
  101f26:	e9 7b fe ff ff       	jmp    101da6 <__alltraps>

00101f2b <vector41>:
.globl vector41
vector41:
  pushl $0
  101f2b:	6a 00                	push   $0x0
  pushl $41
  101f2d:	6a 29                	push   $0x29
  jmp __alltraps
  101f2f:	e9 72 fe ff ff       	jmp    101da6 <__alltraps>

00101f34 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f34:	6a 00                	push   $0x0
  pushl $42
  101f36:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f38:	e9 69 fe ff ff       	jmp    101da6 <__alltraps>

00101f3d <vector43>:
.globl vector43
vector43:
  pushl $0
  101f3d:	6a 00                	push   $0x0
  pushl $43
  101f3f:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f41:	e9 60 fe ff ff       	jmp    101da6 <__alltraps>

00101f46 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f46:	6a 00                	push   $0x0
  pushl $44
  101f48:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f4a:	e9 57 fe ff ff       	jmp    101da6 <__alltraps>

00101f4f <vector45>:
.globl vector45
vector45:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $45
  101f51:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f53:	e9 4e fe ff ff       	jmp    101da6 <__alltraps>

00101f58 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $46
  101f5a:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f5c:	e9 45 fe ff ff       	jmp    101da6 <__alltraps>

00101f61 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $47
  101f63:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f65:	e9 3c fe ff ff       	jmp    101da6 <__alltraps>

00101f6a <vector48>:
.globl vector48
vector48:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $48
  101f6c:	6a 30                	push   $0x30
  jmp __alltraps
  101f6e:	e9 33 fe ff ff       	jmp    101da6 <__alltraps>

00101f73 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $49
  101f75:	6a 31                	push   $0x31
  jmp __alltraps
  101f77:	e9 2a fe ff ff       	jmp    101da6 <__alltraps>

00101f7c <vector50>:
.globl vector50
vector50:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $50
  101f7e:	6a 32                	push   $0x32
  jmp __alltraps
  101f80:	e9 21 fe ff ff       	jmp    101da6 <__alltraps>

00101f85 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $51
  101f87:	6a 33                	push   $0x33
  jmp __alltraps
  101f89:	e9 18 fe ff ff       	jmp    101da6 <__alltraps>

00101f8e <vector52>:
.globl vector52
vector52:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $52
  101f90:	6a 34                	push   $0x34
  jmp __alltraps
  101f92:	e9 0f fe ff ff       	jmp    101da6 <__alltraps>

00101f97 <vector53>:
.globl vector53
vector53:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $53
  101f99:	6a 35                	push   $0x35
  jmp __alltraps
  101f9b:	e9 06 fe ff ff       	jmp    101da6 <__alltraps>

00101fa0 <vector54>:
.globl vector54
vector54:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $54
  101fa2:	6a 36                	push   $0x36
  jmp __alltraps
  101fa4:	e9 fd fd ff ff       	jmp    101da6 <__alltraps>

00101fa9 <vector55>:
.globl vector55
vector55:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $55
  101fab:	6a 37                	push   $0x37
  jmp __alltraps
  101fad:	e9 f4 fd ff ff       	jmp    101da6 <__alltraps>

00101fb2 <vector56>:
.globl vector56
vector56:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $56
  101fb4:	6a 38                	push   $0x38
  jmp __alltraps
  101fb6:	e9 eb fd ff ff       	jmp    101da6 <__alltraps>

00101fbb <vector57>:
.globl vector57
vector57:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $57
  101fbd:	6a 39                	push   $0x39
  jmp __alltraps
  101fbf:	e9 e2 fd ff ff       	jmp    101da6 <__alltraps>

00101fc4 <vector58>:
.globl vector58
vector58:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $58
  101fc6:	6a 3a                	push   $0x3a
  jmp __alltraps
  101fc8:	e9 d9 fd ff ff       	jmp    101da6 <__alltraps>

00101fcd <vector59>:
.globl vector59
vector59:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $59
  101fcf:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fd1:	e9 d0 fd ff ff       	jmp    101da6 <__alltraps>

00101fd6 <vector60>:
.globl vector60
vector60:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $60
  101fd8:	6a 3c                	push   $0x3c
  jmp __alltraps
  101fda:	e9 c7 fd ff ff       	jmp    101da6 <__alltraps>

00101fdf <vector61>:
.globl vector61
vector61:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $61
  101fe1:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fe3:	e9 be fd ff ff       	jmp    101da6 <__alltraps>

00101fe8 <vector62>:
.globl vector62
vector62:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $62
  101fea:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fec:	e9 b5 fd ff ff       	jmp    101da6 <__alltraps>

00101ff1 <vector63>:
.globl vector63
vector63:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $63
  101ff3:	6a 3f                	push   $0x3f
  jmp __alltraps
  101ff5:	e9 ac fd ff ff       	jmp    101da6 <__alltraps>

00101ffa <vector64>:
.globl vector64
vector64:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $64
  101ffc:	6a 40                	push   $0x40
  jmp __alltraps
  101ffe:	e9 a3 fd ff ff       	jmp    101da6 <__alltraps>

00102003 <vector65>:
.globl vector65
vector65:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $65
  102005:	6a 41                	push   $0x41
  jmp __alltraps
  102007:	e9 9a fd ff ff       	jmp    101da6 <__alltraps>

0010200c <vector66>:
.globl vector66
vector66:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $66
  10200e:	6a 42                	push   $0x42
  jmp __alltraps
  102010:	e9 91 fd ff ff       	jmp    101da6 <__alltraps>

00102015 <vector67>:
.globl vector67
vector67:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $67
  102017:	6a 43                	push   $0x43
  jmp __alltraps
  102019:	e9 88 fd ff ff       	jmp    101da6 <__alltraps>

0010201e <vector68>:
.globl vector68
vector68:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $68
  102020:	6a 44                	push   $0x44
  jmp __alltraps
  102022:	e9 7f fd ff ff       	jmp    101da6 <__alltraps>

00102027 <vector69>:
.globl vector69
vector69:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $69
  102029:	6a 45                	push   $0x45
  jmp __alltraps
  10202b:	e9 76 fd ff ff       	jmp    101da6 <__alltraps>

00102030 <vector70>:
.globl vector70
vector70:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $70
  102032:	6a 46                	push   $0x46
  jmp __alltraps
  102034:	e9 6d fd ff ff       	jmp    101da6 <__alltraps>

00102039 <vector71>:
.globl vector71
vector71:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $71
  10203b:	6a 47                	push   $0x47
  jmp __alltraps
  10203d:	e9 64 fd ff ff       	jmp    101da6 <__alltraps>

00102042 <vector72>:
.globl vector72
vector72:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $72
  102044:	6a 48                	push   $0x48
  jmp __alltraps
  102046:	e9 5b fd ff ff       	jmp    101da6 <__alltraps>

0010204b <vector73>:
.globl vector73
vector73:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $73
  10204d:	6a 49                	push   $0x49
  jmp __alltraps
  10204f:	e9 52 fd ff ff       	jmp    101da6 <__alltraps>

00102054 <vector74>:
.globl vector74
vector74:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $74
  102056:	6a 4a                	push   $0x4a
  jmp __alltraps
  102058:	e9 49 fd ff ff       	jmp    101da6 <__alltraps>

0010205d <vector75>:
.globl vector75
vector75:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $75
  10205f:	6a 4b                	push   $0x4b
  jmp __alltraps
  102061:	e9 40 fd ff ff       	jmp    101da6 <__alltraps>

00102066 <vector76>:
.globl vector76
vector76:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $76
  102068:	6a 4c                	push   $0x4c
  jmp __alltraps
  10206a:	e9 37 fd ff ff       	jmp    101da6 <__alltraps>

0010206f <vector77>:
.globl vector77
vector77:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $77
  102071:	6a 4d                	push   $0x4d
  jmp __alltraps
  102073:	e9 2e fd ff ff       	jmp    101da6 <__alltraps>

00102078 <vector78>:
.globl vector78
vector78:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $78
  10207a:	6a 4e                	push   $0x4e
  jmp __alltraps
  10207c:	e9 25 fd ff ff       	jmp    101da6 <__alltraps>

00102081 <vector79>:
.globl vector79
vector79:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $79
  102083:	6a 4f                	push   $0x4f
  jmp __alltraps
  102085:	e9 1c fd ff ff       	jmp    101da6 <__alltraps>

0010208a <vector80>:
.globl vector80
vector80:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $80
  10208c:	6a 50                	push   $0x50
  jmp __alltraps
  10208e:	e9 13 fd ff ff       	jmp    101da6 <__alltraps>

00102093 <vector81>:
.globl vector81
vector81:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $81
  102095:	6a 51                	push   $0x51
  jmp __alltraps
  102097:	e9 0a fd ff ff       	jmp    101da6 <__alltraps>

0010209c <vector82>:
.globl vector82
vector82:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $82
  10209e:	6a 52                	push   $0x52
  jmp __alltraps
  1020a0:	e9 01 fd ff ff       	jmp    101da6 <__alltraps>

001020a5 <vector83>:
.globl vector83
vector83:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $83
  1020a7:	6a 53                	push   $0x53
  jmp __alltraps
  1020a9:	e9 f8 fc ff ff       	jmp    101da6 <__alltraps>

001020ae <vector84>:
.globl vector84
vector84:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $84
  1020b0:	6a 54                	push   $0x54
  jmp __alltraps
  1020b2:	e9 ef fc ff ff       	jmp    101da6 <__alltraps>

001020b7 <vector85>:
.globl vector85
vector85:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $85
  1020b9:	6a 55                	push   $0x55
  jmp __alltraps
  1020bb:	e9 e6 fc ff ff       	jmp    101da6 <__alltraps>

001020c0 <vector86>:
.globl vector86
vector86:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $86
  1020c2:	6a 56                	push   $0x56
  jmp __alltraps
  1020c4:	e9 dd fc ff ff       	jmp    101da6 <__alltraps>

001020c9 <vector87>:
.globl vector87
vector87:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $87
  1020cb:	6a 57                	push   $0x57
  jmp __alltraps
  1020cd:	e9 d4 fc ff ff       	jmp    101da6 <__alltraps>

001020d2 <vector88>:
.globl vector88
vector88:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $88
  1020d4:	6a 58                	push   $0x58
  jmp __alltraps
  1020d6:	e9 cb fc ff ff       	jmp    101da6 <__alltraps>

001020db <vector89>:
.globl vector89
vector89:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $89
  1020dd:	6a 59                	push   $0x59
  jmp __alltraps
  1020df:	e9 c2 fc ff ff       	jmp    101da6 <__alltraps>

001020e4 <vector90>:
.globl vector90
vector90:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $90
  1020e6:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020e8:	e9 b9 fc ff ff       	jmp    101da6 <__alltraps>

001020ed <vector91>:
.globl vector91
vector91:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $91
  1020ef:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020f1:	e9 b0 fc ff ff       	jmp    101da6 <__alltraps>

001020f6 <vector92>:
.globl vector92
vector92:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $92
  1020f8:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020fa:	e9 a7 fc ff ff       	jmp    101da6 <__alltraps>

001020ff <vector93>:
.globl vector93
vector93:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $93
  102101:	6a 5d                	push   $0x5d
  jmp __alltraps
  102103:	e9 9e fc ff ff       	jmp    101da6 <__alltraps>

00102108 <vector94>:
.globl vector94
vector94:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $94
  10210a:	6a 5e                	push   $0x5e
  jmp __alltraps
  10210c:	e9 95 fc ff ff       	jmp    101da6 <__alltraps>

00102111 <vector95>:
.globl vector95
vector95:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $95
  102113:	6a 5f                	push   $0x5f
  jmp __alltraps
  102115:	e9 8c fc ff ff       	jmp    101da6 <__alltraps>

0010211a <vector96>:
.globl vector96
vector96:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $96
  10211c:	6a 60                	push   $0x60
  jmp __alltraps
  10211e:	e9 83 fc ff ff       	jmp    101da6 <__alltraps>

00102123 <vector97>:
.globl vector97
vector97:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $97
  102125:	6a 61                	push   $0x61
  jmp __alltraps
  102127:	e9 7a fc ff ff       	jmp    101da6 <__alltraps>

0010212c <vector98>:
.globl vector98
vector98:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $98
  10212e:	6a 62                	push   $0x62
  jmp __alltraps
  102130:	e9 71 fc ff ff       	jmp    101da6 <__alltraps>

00102135 <vector99>:
.globl vector99
vector99:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $99
  102137:	6a 63                	push   $0x63
  jmp __alltraps
  102139:	e9 68 fc ff ff       	jmp    101da6 <__alltraps>

0010213e <vector100>:
.globl vector100
vector100:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $100
  102140:	6a 64                	push   $0x64
  jmp __alltraps
  102142:	e9 5f fc ff ff       	jmp    101da6 <__alltraps>

00102147 <vector101>:
.globl vector101
vector101:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $101
  102149:	6a 65                	push   $0x65
  jmp __alltraps
  10214b:	e9 56 fc ff ff       	jmp    101da6 <__alltraps>

00102150 <vector102>:
.globl vector102
vector102:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $102
  102152:	6a 66                	push   $0x66
  jmp __alltraps
  102154:	e9 4d fc ff ff       	jmp    101da6 <__alltraps>

00102159 <vector103>:
.globl vector103
vector103:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $103
  10215b:	6a 67                	push   $0x67
  jmp __alltraps
  10215d:	e9 44 fc ff ff       	jmp    101da6 <__alltraps>

00102162 <vector104>:
.globl vector104
vector104:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $104
  102164:	6a 68                	push   $0x68
  jmp __alltraps
  102166:	e9 3b fc ff ff       	jmp    101da6 <__alltraps>

0010216b <vector105>:
.globl vector105
vector105:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $105
  10216d:	6a 69                	push   $0x69
  jmp __alltraps
  10216f:	e9 32 fc ff ff       	jmp    101da6 <__alltraps>

00102174 <vector106>:
.globl vector106
vector106:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $106
  102176:	6a 6a                	push   $0x6a
  jmp __alltraps
  102178:	e9 29 fc ff ff       	jmp    101da6 <__alltraps>

0010217d <vector107>:
.globl vector107
vector107:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $107
  10217f:	6a 6b                	push   $0x6b
  jmp __alltraps
  102181:	e9 20 fc ff ff       	jmp    101da6 <__alltraps>

00102186 <vector108>:
.globl vector108
vector108:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $108
  102188:	6a 6c                	push   $0x6c
  jmp __alltraps
  10218a:	e9 17 fc ff ff       	jmp    101da6 <__alltraps>

0010218f <vector109>:
.globl vector109
vector109:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $109
  102191:	6a 6d                	push   $0x6d
  jmp __alltraps
  102193:	e9 0e fc ff ff       	jmp    101da6 <__alltraps>

00102198 <vector110>:
.globl vector110
vector110:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $110
  10219a:	6a 6e                	push   $0x6e
  jmp __alltraps
  10219c:	e9 05 fc ff ff       	jmp    101da6 <__alltraps>

001021a1 <vector111>:
.globl vector111
vector111:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $111
  1021a3:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021a5:	e9 fc fb ff ff       	jmp    101da6 <__alltraps>

001021aa <vector112>:
.globl vector112
vector112:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $112
  1021ac:	6a 70                	push   $0x70
  jmp __alltraps
  1021ae:	e9 f3 fb ff ff       	jmp    101da6 <__alltraps>

001021b3 <vector113>:
.globl vector113
vector113:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $113
  1021b5:	6a 71                	push   $0x71
  jmp __alltraps
  1021b7:	e9 ea fb ff ff       	jmp    101da6 <__alltraps>

001021bc <vector114>:
.globl vector114
vector114:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $114
  1021be:	6a 72                	push   $0x72
  jmp __alltraps
  1021c0:	e9 e1 fb ff ff       	jmp    101da6 <__alltraps>

001021c5 <vector115>:
.globl vector115
vector115:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $115
  1021c7:	6a 73                	push   $0x73
  jmp __alltraps
  1021c9:	e9 d8 fb ff ff       	jmp    101da6 <__alltraps>

001021ce <vector116>:
.globl vector116
vector116:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $116
  1021d0:	6a 74                	push   $0x74
  jmp __alltraps
  1021d2:	e9 cf fb ff ff       	jmp    101da6 <__alltraps>

001021d7 <vector117>:
.globl vector117
vector117:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $117
  1021d9:	6a 75                	push   $0x75
  jmp __alltraps
  1021db:	e9 c6 fb ff ff       	jmp    101da6 <__alltraps>

001021e0 <vector118>:
.globl vector118
vector118:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $118
  1021e2:	6a 76                	push   $0x76
  jmp __alltraps
  1021e4:	e9 bd fb ff ff       	jmp    101da6 <__alltraps>

001021e9 <vector119>:
.globl vector119
vector119:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $119
  1021eb:	6a 77                	push   $0x77
  jmp __alltraps
  1021ed:	e9 b4 fb ff ff       	jmp    101da6 <__alltraps>

001021f2 <vector120>:
.globl vector120
vector120:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $120
  1021f4:	6a 78                	push   $0x78
  jmp __alltraps
  1021f6:	e9 ab fb ff ff       	jmp    101da6 <__alltraps>

001021fb <vector121>:
.globl vector121
vector121:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $121
  1021fd:	6a 79                	push   $0x79
  jmp __alltraps
  1021ff:	e9 a2 fb ff ff       	jmp    101da6 <__alltraps>

00102204 <vector122>:
.globl vector122
vector122:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $122
  102206:	6a 7a                	push   $0x7a
  jmp __alltraps
  102208:	e9 99 fb ff ff       	jmp    101da6 <__alltraps>

0010220d <vector123>:
.globl vector123
vector123:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $123
  10220f:	6a 7b                	push   $0x7b
  jmp __alltraps
  102211:	e9 90 fb ff ff       	jmp    101da6 <__alltraps>

00102216 <vector124>:
.globl vector124
vector124:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $124
  102218:	6a 7c                	push   $0x7c
  jmp __alltraps
  10221a:	e9 87 fb ff ff       	jmp    101da6 <__alltraps>

0010221f <vector125>:
.globl vector125
vector125:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $125
  102221:	6a 7d                	push   $0x7d
  jmp __alltraps
  102223:	e9 7e fb ff ff       	jmp    101da6 <__alltraps>

00102228 <vector126>:
.globl vector126
vector126:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $126
  10222a:	6a 7e                	push   $0x7e
  jmp __alltraps
  10222c:	e9 75 fb ff ff       	jmp    101da6 <__alltraps>

00102231 <vector127>:
.globl vector127
vector127:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $127
  102233:	6a 7f                	push   $0x7f
  jmp __alltraps
  102235:	e9 6c fb ff ff       	jmp    101da6 <__alltraps>

0010223a <vector128>:
.globl vector128
vector128:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $128
  10223c:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102241:	e9 60 fb ff ff       	jmp    101da6 <__alltraps>

00102246 <vector129>:
.globl vector129
vector129:
  pushl $0
  102246:	6a 00                	push   $0x0
  pushl $129
  102248:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10224d:	e9 54 fb ff ff       	jmp    101da6 <__alltraps>

00102252 <vector130>:
.globl vector130
vector130:
  pushl $0
  102252:	6a 00                	push   $0x0
  pushl $130
  102254:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102259:	e9 48 fb ff ff       	jmp    101da6 <__alltraps>

0010225e <vector131>:
.globl vector131
vector131:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $131
  102260:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102265:	e9 3c fb ff ff       	jmp    101da6 <__alltraps>

0010226a <vector132>:
.globl vector132
vector132:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $132
  10226c:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102271:	e9 30 fb ff ff       	jmp    101da6 <__alltraps>

00102276 <vector133>:
.globl vector133
vector133:
  pushl $0
  102276:	6a 00                	push   $0x0
  pushl $133
  102278:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10227d:	e9 24 fb ff ff       	jmp    101da6 <__alltraps>

00102282 <vector134>:
.globl vector134
vector134:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $134
  102284:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102289:	e9 18 fb ff ff       	jmp    101da6 <__alltraps>

0010228e <vector135>:
.globl vector135
vector135:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $135
  102290:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102295:	e9 0c fb ff ff       	jmp    101da6 <__alltraps>

0010229a <vector136>:
.globl vector136
vector136:
  pushl $0
  10229a:	6a 00                	push   $0x0
  pushl $136
  10229c:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022a1:	e9 00 fb ff ff       	jmp    101da6 <__alltraps>

001022a6 <vector137>:
.globl vector137
vector137:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $137
  1022a8:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022ad:	e9 f4 fa ff ff       	jmp    101da6 <__alltraps>

001022b2 <vector138>:
.globl vector138
vector138:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $138
  1022b4:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1022b9:	e9 e8 fa ff ff       	jmp    101da6 <__alltraps>

001022be <vector139>:
.globl vector139
vector139:
  pushl $0
  1022be:	6a 00                	push   $0x0
  pushl $139
  1022c0:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1022c5:	e9 dc fa ff ff       	jmp    101da6 <__alltraps>

001022ca <vector140>:
.globl vector140
vector140:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $140
  1022cc:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022d1:	e9 d0 fa ff ff       	jmp    101da6 <__alltraps>

001022d6 <vector141>:
.globl vector141
vector141:
  pushl $0
  1022d6:	6a 00                	push   $0x0
  pushl $141
  1022d8:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022dd:	e9 c4 fa ff ff       	jmp    101da6 <__alltraps>

001022e2 <vector142>:
.globl vector142
vector142:
  pushl $0
  1022e2:	6a 00                	push   $0x0
  pushl $142
  1022e4:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022e9:	e9 b8 fa ff ff       	jmp    101da6 <__alltraps>

001022ee <vector143>:
.globl vector143
vector143:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $143
  1022f0:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022f5:	e9 ac fa ff ff       	jmp    101da6 <__alltraps>

001022fa <vector144>:
.globl vector144
vector144:
  pushl $0
  1022fa:	6a 00                	push   $0x0
  pushl $144
  1022fc:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102301:	e9 a0 fa ff ff       	jmp    101da6 <__alltraps>

00102306 <vector145>:
.globl vector145
vector145:
  pushl $0
  102306:	6a 00                	push   $0x0
  pushl $145
  102308:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10230d:	e9 94 fa ff ff       	jmp    101da6 <__alltraps>

00102312 <vector146>:
.globl vector146
vector146:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $146
  102314:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102319:	e9 88 fa ff ff       	jmp    101da6 <__alltraps>

0010231e <vector147>:
.globl vector147
vector147:
  pushl $0
  10231e:	6a 00                	push   $0x0
  pushl $147
  102320:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102325:	e9 7c fa ff ff       	jmp    101da6 <__alltraps>

0010232a <vector148>:
.globl vector148
vector148:
  pushl $0
  10232a:	6a 00                	push   $0x0
  pushl $148
  10232c:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102331:	e9 70 fa ff ff       	jmp    101da6 <__alltraps>

00102336 <vector149>:
.globl vector149
vector149:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $149
  102338:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10233d:	e9 64 fa ff ff       	jmp    101da6 <__alltraps>

00102342 <vector150>:
.globl vector150
vector150:
  pushl $0
  102342:	6a 00                	push   $0x0
  pushl $150
  102344:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102349:	e9 58 fa ff ff       	jmp    101da6 <__alltraps>

0010234e <vector151>:
.globl vector151
vector151:
  pushl $0
  10234e:	6a 00                	push   $0x0
  pushl $151
  102350:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102355:	e9 4c fa ff ff       	jmp    101da6 <__alltraps>

0010235a <vector152>:
.globl vector152
vector152:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $152
  10235c:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102361:	e9 40 fa ff ff       	jmp    101da6 <__alltraps>

00102366 <vector153>:
.globl vector153
vector153:
  pushl $0
  102366:	6a 00                	push   $0x0
  pushl $153
  102368:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10236d:	e9 34 fa ff ff       	jmp    101da6 <__alltraps>

00102372 <vector154>:
.globl vector154
vector154:
  pushl $0
  102372:	6a 00                	push   $0x0
  pushl $154
  102374:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102379:	e9 28 fa ff ff       	jmp    101da6 <__alltraps>

0010237e <vector155>:
.globl vector155
vector155:
  pushl $0
  10237e:	6a 00                	push   $0x0
  pushl $155
  102380:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102385:	e9 1c fa ff ff       	jmp    101da6 <__alltraps>

0010238a <vector156>:
.globl vector156
vector156:
  pushl $0
  10238a:	6a 00                	push   $0x0
  pushl $156
  10238c:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102391:	e9 10 fa ff ff       	jmp    101da6 <__alltraps>

00102396 <vector157>:
.globl vector157
vector157:
  pushl $0
  102396:	6a 00                	push   $0x0
  pushl $157
  102398:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10239d:	e9 04 fa ff ff       	jmp    101da6 <__alltraps>

001023a2 <vector158>:
.globl vector158
vector158:
  pushl $0
  1023a2:	6a 00                	push   $0x0
  pushl $158
  1023a4:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023a9:	e9 f8 f9 ff ff       	jmp    101da6 <__alltraps>

001023ae <vector159>:
.globl vector159
vector159:
  pushl $0
  1023ae:	6a 00                	push   $0x0
  pushl $159
  1023b0:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1023b5:	e9 ec f9 ff ff       	jmp    101da6 <__alltraps>

001023ba <vector160>:
.globl vector160
vector160:
  pushl $0
  1023ba:	6a 00                	push   $0x0
  pushl $160
  1023bc:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1023c1:	e9 e0 f9 ff ff       	jmp    101da6 <__alltraps>

001023c6 <vector161>:
.globl vector161
vector161:
  pushl $0
  1023c6:	6a 00                	push   $0x0
  pushl $161
  1023c8:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023cd:	e9 d4 f9 ff ff       	jmp    101da6 <__alltraps>

001023d2 <vector162>:
.globl vector162
vector162:
  pushl $0
  1023d2:	6a 00                	push   $0x0
  pushl $162
  1023d4:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023d9:	e9 c8 f9 ff ff       	jmp    101da6 <__alltraps>

001023de <vector163>:
.globl vector163
vector163:
  pushl $0
  1023de:	6a 00                	push   $0x0
  pushl $163
  1023e0:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023e5:	e9 bc f9 ff ff       	jmp    101da6 <__alltraps>

001023ea <vector164>:
.globl vector164
vector164:
  pushl $0
  1023ea:	6a 00                	push   $0x0
  pushl $164
  1023ec:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023f1:	e9 b0 f9 ff ff       	jmp    101da6 <__alltraps>

001023f6 <vector165>:
.globl vector165
vector165:
  pushl $0
  1023f6:	6a 00                	push   $0x0
  pushl $165
  1023f8:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023fd:	e9 a4 f9 ff ff       	jmp    101da6 <__alltraps>

00102402 <vector166>:
.globl vector166
vector166:
  pushl $0
  102402:	6a 00                	push   $0x0
  pushl $166
  102404:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102409:	e9 98 f9 ff ff       	jmp    101da6 <__alltraps>

0010240e <vector167>:
.globl vector167
vector167:
  pushl $0
  10240e:	6a 00                	push   $0x0
  pushl $167
  102410:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102415:	e9 8c f9 ff ff       	jmp    101da6 <__alltraps>

0010241a <vector168>:
.globl vector168
vector168:
  pushl $0
  10241a:	6a 00                	push   $0x0
  pushl $168
  10241c:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102421:	e9 80 f9 ff ff       	jmp    101da6 <__alltraps>

00102426 <vector169>:
.globl vector169
vector169:
  pushl $0
  102426:	6a 00                	push   $0x0
  pushl $169
  102428:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10242d:	e9 74 f9 ff ff       	jmp    101da6 <__alltraps>

00102432 <vector170>:
.globl vector170
vector170:
  pushl $0
  102432:	6a 00                	push   $0x0
  pushl $170
  102434:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102439:	e9 68 f9 ff ff       	jmp    101da6 <__alltraps>

0010243e <vector171>:
.globl vector171
vector171:
  pushl $0
  10243e:	6a 00                	push   $0x0
  pushl $171
  102440:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102445:	e9 5c f9 ff ff       	jmp    101da6 <__alltraps>

0010244a <vector172>:
.globl vector172
vector172:
  pushl $0
  10244a:	6a 00                	push   $0x0
  pushl $172
  10244c:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102451:	e9 50 f9 ff ff       	jmp    101da6 <__alltraps>

00102456 <vector173>:
.globl vector173
vector173:
  pushl $0
  102456:	6a 00                	push   $0x0
  pushl $173
  102458:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10245d:	e9 44 f9 ff ff       	jmp    101da6 <__alltraps>

00102462 <vector174>:
.globl vector174
vector174:
  pushl $0
  102462:	6a 00                	push   $0x0
  pushl $174
  102464:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102469:	e9 38 f9 ff ff       	jmp    101da6 <__alltraps>

0010246e <vector175>:
.globl vector175
vector175:
  pushl $0
  10246e:	6a 00                	push   $0x0
  pushl $175
  102470:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102475:	e9 2c f9 ff ff       	jmp    101da6 <__alltraps>

0010247a <vector176>:
.globl vector176
vector176:
  pushl $0
  10247a:	6a 00                	push   $0x0
  pushl $176
  10247c:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102481:	e9 20 f9 ff ff       	jmp    101da6 <__alltraps>

00102486 <vector177>:
.globl vector177
vector177:
  pushl $0
  102486:	6a 00                	push   $0x0
  pushl $177
  102488:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10248d:	e9 14 f9 ff ff       	jmp    101da6 <__alltraps>

00102492 <vector178>:
.globl vector178
vector178:
  pushl $0
  102492:	6a 00                	push   $0x0
  pushl $178
  102494:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102499:	e9 08 f9 ff ff       	jmp    101da6 <__alltraps>

0010249e <vector179>:
.globl vector179
vector179:
  pushl $0
  10249e:	6a 00                	push   $0x0
  pushl $179
  1024a0:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024a5:	e9 fc f8 ff ff       	jmp    101da6 <__alltraps>

001024aa <vector180>:
.globl vector180
vector180:
  pushl $0
  1024aa:	6a 00                	push   $0x0
  pushl $180
  1024ac:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024b1:	e9 f0 f8 ff ff       	jmp    101da6 <__alltraps>

001024b6 <vector181>:
.globl vector181
vector181:
  pushl $0
  1024b6:	6a 00                	push   $0x0
  pushl $181
  1024b8:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1024bd:	e9 e4 f8 ff ff       	jmp    101da6 <__alltraps>

001024c2 <vector182>:
.globl vector182
vector182:
  pushl $0
  1024c2:	6a 00                	push   $0x0
  pushl $182
  1024c4:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1024c9:	e9 d8 f8 ff ff       	jmp    101da6 <__alltraps>

001024ce <vector183>:
.globl vector183
vector183:
  pushl $0
  1024ce:	6a 00                	push   $0x0
  pushl $183
  1024d0:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024d5:	e9 cc f8 ff ff       	jmp    101da6 <__alltraps>

001024da <vector184>:
.globl vector184
vector184:
  pushl $0
  1024da:	6a 00                	push   $0x0
  pushl $184
  1024dc:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024e1:	e9 c0 f8 ff ff       	jmp    101da6 <__alltraps>

001024e6 <vector185>:
.globl vector185
vector185:
  pushl $0
  1024e6:	6a 00                	push   $0x0
  pushl $185
  1024e8:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024ed:	e9 b4 f8 ff ff       	jmp    101da6 <__alltraps>

001024f2 <vector186>:
.globl vector186
vector186:
  pushl $0
  1024f2:	6a 00                	push   $0x0
  pushl $186
  1024f4:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024f9:	e9 a8 f8 ff ff       	jmp    101da6 <__alltraps>

001024fe <vector187>:
.globl vector187
vector187:
  pushl $0
  1024fe:	6a 00                	push   $0x0
  pushl $187
  102500:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102505:	e9 9c f8 ff ff       	jmp    101da6 <__alltraps>

0010250a <vector188>:
.globl vector188
vector188:
  pushl $0
  10250a:	6a 00                	push   $0x0
  pushl $188
  10250c:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102511:	e9 90 f8 ff ff       	jmp    101da6 <__alltraps>

00102516 <vector189>:
.globl vector189
vector189:
  pushl $0
  102516:	6a 00                	push   $0x0
  pushl $189
  102518:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10251d:	e9 84 f8 ff ff       	jmp    101da6 <__alltraps>

00102522 <vector190>:
.globl vector190
vector190:
  pushl $0
  102522:	6a 00                	push   $0x0
  pushl $190
  102524:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102529:	e9 78 f8 ff ff       	jmp    101da6 <__alltraps>

0010252e <vector191>:
.globl vector191
vector191:
  pushl $0
  10252e:	6a 00                	push   $0x0
  pushl $191
  102530:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102535:	e9 6c f8 ff ff       	jmp    101da6 <__alltraps>

0010253a <vector192>:
.globl vector192
vector192:
  pushl $0
  10253a:	6a 00                	push   $0x0
  pushl $192
  10253c:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102541:	e9 60 f8 ff ff       	jmp    101da6 <__alltraps>

00102546 <vector193>:
.globl vector193
vector193:
  pushl $0
  102546:	6a 00                	push   $0x0
  pushl $193
  102548:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10254d:	e9 54 f8 ff ff       	jmp    101da6 <__alltraps>

00102552 <vector194>:
.globl vector194
vector194:
  pushl $0
  102552:	6a 00                	push   $0x0
  pushl $194
  102554:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102559:	e9 48 f8 ff ff       	jmp    101da6 <__alltraps>

0010255e <vector195>:
.globl vector195
vector195:
  pushl $0
  10255e:	6a 00                	push   $0x0
  pushl $195
  102560:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102565:	e9 3c f8 ff ff       	jmp    101da6 <__alltraps>

0010256a <vector196>:
.globl vector196
vector196:
  pushl $0
  10256a:	6a 00                	push   $0x0
  pushl $196
  10256c:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102571:	e9 30 f8 ff ff       	jmp    101da6 <__alltraps>

00102576 <vector197>:
.globl vector197
vector197:
  pushl $0
  102576:	6a 00                	push   $0x0
  pushl $197
  102578:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10257d:	e9 24 f8 ff ff       	jmp    101da6 <__alltraps>

00102582 <vector198>:
.globl vector198
vector198:
  pushl $0
  102582:	6a 00                	push   $0x0
  pushl $198
  102584:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102589:	e9 18 f8 ff ff       	jmp    101da6 <__alltraps>

0010258e <vector199>:
.globl vector199
vector199:
  pushl $0
  10258e:	6a 00                	push   $0x0
  pushl $199
  102590:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102595:	e9 0c f8 ff ff       	jmp    101da6 <__alltraps>

0010259a <vector200>:
.globl vector200
vector200:
  pushl $0
  10259a:	6a 00                	push   $0x0
  pushl $200
  10259c:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025a1:	e9 00 f8 ff ff       	jmp    101da6 <__alltraps>

001025a6 <vector201>:
.globl vector201
vector201:
  pushl $0
  1025a6:	6a 00                	push   $0x0
  pushl $201
  1025a8:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025ad:	e9 f4 f7 ff ff       	jmp    101da6 <__alltraps>

001025b2 <vector202>:
.globl vector202
vector202:
  pushl $0
  1025b2:	6a 00                	push   $0x0
  pushl $202
  1025b4:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1025b9:	e9 e8 f7 ff ff       	jmp    101da6 <__alltraps>

001025be <vector203>:
.globl vector203
vector203:
  pushl $0
  1025be:	6a 00                	push   $0x0
  pushl $203
  1025c0:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1025c5:	e9 dc f7 ff ff       	jmp    101da6 <__alltraps>

001025ca <vector204>:
.globl vector204
vector204:
  pushl $0
  1025ca:	6a 00                	push   $0x0
  pushl $204
  1025cc:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025d1:	e9 d0 f7 ff ff       	jmp    101da6 <__alltraps>

001025d6 <vector205>:
.globl vector205
vector205:
  pushl $0
  1025d6:	6a 00                	push   $0x0
  pushl $205
  1025d8:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025dd:	e9 c4 f7 ff ff       	jmp    101da6 <__alltraps>

001025e2 <vector206>:
.globl vector206
vector206:
  pushl $0
  1025e2:	6a 00                	push   $0x0
  pushl $206
  1025e4:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025e9:	e9 b8 f7 ff ff       	jmp    101da6 <__alltraps>

001025ee <vector207>:
.globl vector207
vector207:
  pushl $0
  1025ee:	6a 00                	push   $0x0
  pushl $207
  1025f0:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025f5:	e9 ac f7 ff ff       	jmp    101da6 <__alltraps>

001025fa <vector208>:
.globl vector208
vector208:
  pushl $0
  1025fa:	6a 00                	push   $0x0
  pushl $208
  1025fc:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102601:	e9 a0 f7 ff ff       	jmp    101da6 <__alltraps>

00102606 <vector209>:
.globl vector209
vector209:
  pushl $0
  102606:	6a 00                	push   $0x0
  pushl $209
  102608:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10260d:	e9 94 f7 ff ff       	jmp    101da6 <__alltraps>

00102612 <vector210>:
.globl vector210
vector210:
  pushl $0
  102612:	6a 00                	push   $0x0
  pushl $210
  102614:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102619:	e9 88 f7 ff ff       	jmp    101da6 <__alltraps>

0010261e <vector211>:
.globl vector211
vector211:
  pushl $0
  10261e:	6a 00                	push   $0x0
  pushl $211
  102620:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102625:	e9 7c f7 ff ff       	jmp    101da6 <__alltraps>

0010262a <vector212>:
.globl vector212
vector212:
  pushl $0
  10262a:	6a 00                	push   $0x0
  pushl $212
  10262c:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102631:	e9 70 f7 ff ff       	jmp    101da6 <__alltraps>

00102636 <vector213>:
.globl vector213
vector213:
  pushl $0
  102636:	6a 00                	push   $0x0
  pushl $213
  102638:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10263d:	e9 64 f7 ff ff       	jmp    101da6 <__alltraps>

00102642 <vector214>:
.globl vector214
vector214:
  pushl $0
  102642:	6a 00                	push   $0x0
  pushl $214
  102644:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102649:	e9 58 f7 ff ff       	jmp    101da6 <__alltraps>

0010264e <vector215>:
.globl vector215
vector215:
  pushl $0
  10264e:	6a 00                	push   $0x0
  pushl $215
  102650:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102655:	e9 4c f7 ff ff       	jmp    101da6 <__alltraps>

0010265a <vector216>:
.globl vector216
vector216:
  pushl $0
  10265a:	6a 00                	push   $0x0
  pushl $216
  10265c:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102661:	e9 40 f7 ff ff       	jmp    101da6 <__alltraps>

00102666 <vector217>:
.globl vector217
vector217:
  pushl $0
  102666:	6a 00                	push   $0x0
  pushl $217
  102668:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10266d:	e9 34 f7 ff ff       	jmp    101da6 <__alltraps>

00102672 <vector218>:
.globl vector218
vector218:
  pushl $0
  102672:	6a 00                	push   $0x0
  pushl $218
  102674:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102679:	e9 28 f7 ff ff       	jmp    101da6 <__alltraps>

0010267e <vector219>:
.globl vector219
vector219:
  pushl $0
  10267e:	6a 00                	push   $0x0
  pushl $219
  102680:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102685:	e9 1c f7 ff ff       	jmp    101da6 <__alltraps>

0010268a <vector220>:
.globl vector220
vector220:
  pushl $0
  10268a:	6a 00                	push   $0x0
  pushl $220
  10268c:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102691:	e9 10 f7 ff ff       	jmp    101da6 <__alltraps>

00102696 <vector221>:
.globl vector221
vector221:
  pushl $0
  102696:	6a 00                	push   $0x0
  pushl $221
  102698:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10269d:	e9 04 f7 ff ff       	jmp    101da6 <__alltraps>

001026a2 <vector222>:
.globl vector222
vector222:
  pushl $0
  1026a2:	6a 00                	push   $0x0
  pushl $222
  1026a4:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026a9:	e9 f8 f6 ff ff       	jmp    101da6 <__alltraps>

001026ae <vector223>:
.globl vector223
vector223:
  pushl $0
  1026ae:	6a 00                	push   $0x0
  pushl $223
  1026b0:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1026b5:	e9 ec f6 ff ff       	jmp    101da6 <__alltraps>

001026ba <vector224>:
.globl vector224
vector224:
  pushl $0
  1026ba:	6a 00                	push   $0x0
  pushl $224
  1026bc:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1026c1:	e9 e0 f6 ff ff       	jmp    101da6 <__alltraps>

001026c6 <vector225>:
.globl vector225
vector225:
  pushl $0
  1026c6:	6a 00                	push   $0x0
  pushl $225
  1026c8:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026cd:	e9 d4 f6 ff ff       	jmp    101da6 <__alltraps>

001026d2 <vector226>:
.globl vector226
vector226:
  pushl $0
  1026d2:	6a 00                	push   $0x0
  pushl $226
  1026d4:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026d9:	e9 c8 f6 ff ff       	jmp    101da6 <__alltraps>

001026de <vector227>:
.globl vector227
vector227:
  pushl $0
  1026de:	6a 00                	push   $0x0
  pushl $227
  1026e0:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026e5:	e9 bc f6 ff ff       	jmp    101da6 <__alltraps>

001026ea <vector228>:
.globl vector228
vector228:
  pushl $0
  1026ea:	6a 00                	push   $0x0
  pushl $228
  1026ec:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026f1:	e9 b0 f6 ff ff       	jmp    101da6 <__alltraps>

001026f6 <vector229>:
.globl vector229
vector229:
  pushl $0
  1026f6:	6a 00                	push   $0x0
  pushl $229
  1026f8:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026fd:	e9 a4 f6 ff ff       	jmp    101da6 <__alltraps>

00102702 <vector230>:
.globl vector230
vector230:
  pushl $0
  102702:	6a 00                	push   $0x0
  pushl $230
  102704:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102709:	e9 98 f6 ff ff       	jmp    101da6 <__alltraps>

0010270e <vector231>:
.globl vector231
vector231:
  pushl $0
  10270e:	6a 00                	push   $0x0
  pushl $231
  102710:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102715:	e9 8c f6 ff ff       	jmp    101da6 <__alltraps>

0010271a <vector232>:
.globl vector232
vector232:
  pushl $0
  10271a:	6a 00                	push   $0x0
  pushl $232
  10271c:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102721:	e9 80 f6 ff ff       	jmp    101da6 <__alltraps>

00102726 <vector233>:
.globl vector233
vector233:
  pushl $0
  102726:	6a 00                	push   $0x0
  pushl $233
  102728:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10272d:	e9 74 f6 ff ff       	jmp    101da6 <__alltraps>

00102732 <vector234>:
.globl vector234
vector234:
  pushl $0
  102732:	6a 00                	push   $0x0
  pushl $234
  102734:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102739:	e9 68 f6 ff ff       	jmp    101da6 <__alltraps>

0010273e <vector235>:
.globl vector235
vector235:
  pushl $0
  10273e:	6a 00                	push   $0x0
  pushl $235
  102740:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102745:	e9 5c f6 ff ff       	jmp    101da6 <__alltraps>

0010274a <vector236>:
.globl vector236
vector236:
  pushl $0
  10274a:	6a 00                	push   $0x0
  pushl $236
  10274c:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102751:	e9 50 f6 ff ff       	jmp    101da6 <__alltraps>

00102756 <vector237>:
.globl vector237
vector237:
  pushl $0
  102756:	6a 00                	push   $0x0
  pushl $237
  102758:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10275d:	e9 44 f6 ff ff       	jmp    101da6 <__alltraps>

00102762 <vector238>:
.globl vector238
vector238:
  pushl $0
  102762:	6a 00                	push   $0x0
  pushl $238
  102764:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102769:	e9 38 f6 ff ff       	jmp    101da6 <__alltraps>

0010276e <vector239>:
.globl vector239
vector239:
  pushl $0
  10276e:	6a 00                	push   $0x0
  pushl $239
  102770:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102775:	e9 2c f6 ff ff       	jmp    101da6 <__alltraps>

0010277a <vector240>:
.globl vector240
vector240:
  pushl $0
  10277a:	6a 00                	push   $0x0
  pushl $240
  10277c:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102781:	e9 20 f6 ff ff       	jmp    101da6 <__alltraps>

00102786 <vector241>:
.globl vector241
vector241:
  pushl $0
  102786:	6a 00                	push   $0x0
  pushl $241
  102788:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10278d:	e9 14 f6 ff ff       	jmp    101da6 <__alltraps>

00102792 <vector242>:
.globl vector242
vector242:
  pushl $0
  102792:	6a 00                	push   $0x0
  pushl $242
  102794:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102799:	e9 08 f6 ff ff       	jmp    101da6 <__alltraps>

0010279e <vector243>:
.globl vector243
vector243:
  pushl $0
  10279e:	6a 00                	push   $0x0
  pushl $243
  1027a0:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027a5:	e9 fc f5 ff ff       	jmp    101da6 <__alltraps>

001027aa <vector244>:
.globl vector244
vector244:
  pushl $0
  1027aa:	6a 00                	push   $0x0
  pushl $244
  1027ac:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027b1:	e9 f0 f5 ff ff       	jmp    101da6 <__alltraps>

001027b6 <vector245>:
.globl vector245
vector245:
  pushl $0
  1027b6:	6a 00                	push   $0x0
  pushl $245
  1027b8:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1027bd:	e9 e4 f5 ff ff       	jmp    101da6 <__alltraps>

001027c2 <vector246>:
.globl vector246
vector246:
  pushl $0
  1027c2:	6a 00                	push   $0x0
  pushl $246
  1027c4:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1027c9:	e9 d8 f5 ff ff       	jmp    101da6 <__alltraps>

001027ce <vector247>:
.globl vector247
vector247:
  pushl $0
  1027ce:	6a 00                	push   $0x0
  pushl $247
  1027d0:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027d5:	e9 cc f5 ff ff       	jmp    101da6 <__alltraps>

001027da <vector248>:
.globl vector248
vector248:
  pushl $0
  1027da:	6a 00                	push   $0x0
  pushl $248
  1027dc:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027e1:	e9 c0 f5 ff ff       	jmp    101da6 <__alltraps>

001027e6 <vector249>:
.globl vector249
vector249:
  pushl $0
  1027e6:	6a 00                	push   $0x0
  pushl $249
  1027e8:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027ed:	e9 b4 f5 ff ff       	jmp    101da6 <__alltraps>

001027f2 <vector250>:
.globl vector250
vector250:
  pushl $0
  1027f2:	6a 00                	push   $0x0
  pushl $250
  1027f4:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027f9:	e9 a8 f5 ff ff       	jmp    101da6 <__alltraps>

001027fe <vector251>:
.globl vector251
vector251:
  pushl $0
  1027fe:	6a 00                	push   $0x0
  pushl $251
  102800:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102805:	e9 9c f5 ff ff       	jmp    101da6 <__alltraps>

0010280a <vector252>:
.globl vector252
vector252:
  pushl $0
  10280a:	6a 00                	push   $0x0
  pushl $252
  10280c:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102811:	e9 90 f5 ff ff       	jmp    101da6 <__alltraps>

00102816 <vector253>:
.globl vector253
vector253:
  pushl $0
  102816:	6a 00                	push   $0x0
  pushl $253
  102818:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10281d:	e9 84 f5 ff ff       	jmp    101da6 <__alltraps>

00102822 <vector254>:
.globl vector254
vector254:
  pushl $0
  102822:	6a 00                	push   $0x0
  pushl $254
  102824:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102829:	e9 78 f5 ff ff       	jmp    101da6 <__alltraps>

0010282e <vector255>:
.globl vector255
vector255:
  pushl $0
  10282e:	6a 00                	push   $0x0
  pushl $255
  102830:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102835:	e9 6c f5 ff ff       	jmp    101da6 <__alltraps>

0010283a <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10283a:	55                   	push   %ebp
  10283b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  10283d:	8b 45 08             	mov    0x8(%ebp),%eax
  102840:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102843:	b8 23 00 00 00       	mov    $0x23,%eax
  102848:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10284a:	b8 23 00 00 00       	mov    $0x23,%eax
  10284f:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102851:	b8 10 00 00 00       	mov    $0x10,%eax
  102856:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102858:	b8 10 00 00 00       	mov    $0x10,%eax
  10285d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  10285f:	b8 10 00 00 00       	mov    $0x10,%eax
  102864:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102866:	ea 6d 28 10 00 08 00 	ljmp   $0x8,$0x10286d
}
  10286d:	5d                   	pop    %ebp
  10286e:	c3                   	ret    

0010286f <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  10286f:	55                   	push   %ebp
  102870:	89 e5                	mov    %esp,%ebp
  102872:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102875:	b8 40 f9 10 00       	mov    $0x10f940,%eax
  10287a:	05 00 04 00 00       	add    $0x400,%eax
  10287f:	a3 c4 f8 10 00       	mov    %eax,0x10f8c4
    ts.ts_ss0 = KERNEL_DS;
  102884:	66 c7 05 c8 f8 10 00 	movw   $0x10,0x10f8c8
  10288b:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10288d:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102894:	68 00 
  102896:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  10289b:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1028a1:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  1028a6:	c1 e8 10             	shr    $0x10,%eax
  1028a9:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1028ae:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028b5:	83 e0 f0             	and    $0xfffffff0,%eax
  1028b8:	83 c8 09             	or     $0x9,%eax
  1028bb:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028c0:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028c7:	83 c8 10             	or     $0x10,%eax
  1028ca:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028cf:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028d6:	83 e0 9f             	and    $0xffffff9f,%eax
  1028d9:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028de:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028e5:	83 c8 80             	or     $0xffffff80,%eax
  1028e8:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028ed:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028f4:	83 e0 f0             	and    $0xfffffff0,%eax
  1028f7:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028fc:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102903:	83 e0 ef             	and    $0xffffffef,%eax
  102906:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10290b:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102912:	83 e0 df             	and    $0xffffffdf,%eax
  102915:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10291a:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102921:	83 c8 40             	or     $0x40,%eax
  102924:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102929:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102930:	83 e0 7f             	and    $0x7f,%eax
  102933:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102938:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  10293d:	c1 e8 18             	shr    $0x18,%eax
  102940:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102945:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  10294c:	83 e0 ef             	and    $0xffffffef,%eax
  10294f:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102954:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  10295b:	e8 da fe ff ff       	call   10283a <lgdt>
  102960:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102966:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  10296a:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10296d:	c9                   	leave  
  10296e:	c3                   	ret    

0010296f <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  10296f:	55                   	push   %ebp
  102970:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102972:	e8 f8 fe ff ff       	call   10286f <gdt_init>
}
  102977:	5d                   	pop    %ebp
  102978:	c3                   	ret    

00102979 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102979:	55                   	push   %ebp
  10297a:	89 e5                	mov    %esp,%ebp
  10297c:	83 ec 58             	sub    $0x58,%esp
  10297f:	8b 45 10             	mov    0x10(%ebp),%eax
  102982:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102985:	8b 45 14             	mov    0x14(%ebp),%eax
  102988:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10298b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10298e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102991:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102994:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102997:	8b 45 18             	mov    0x18(%ebp),%eax
  10299a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10299d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1029a6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1029a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1029af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1029b3:	74 1c                	je     1029d1 <printnum+0x58>
  1029b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029b8:	ba 00 00 00 00       	mov    $0x0,%edx
  1029bd:	f7 75 e4             	divl   -0x1c(%ebp)
  1029c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1029c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029c6:	ba 00 00 00 00       	mov    $0x0,%edx
  1029cb:	f7 75 e4             	divl   -0x1c(%ebp)
  1029ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1029d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1029d7:	f7 75 e4             	divl   -0x1c(%ebp)
  1029da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1029dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1029e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1029e9:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1029ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029ef:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1029f2:	8b 45 18             	mov    0x18(%ebp),%eax
  1029f5:	ba 00 00 00 00       	mov    $0x0,%edx
  1029fa:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029fd:	77 56                	ja     102a55 <printnum+0xdc>
  1029ff:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102a02:	72 05                	jb     102a09 <printnum+0x90>
  102a04:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102a07:	77 4c                	ja     102a55 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102a09:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102a0c:	8d 50 ff             	lea    -0x1(%eax),%edx
  102a0f:	8b 45 20             	mov    0x20(%ebp),%eax
  102a12:	89 44 24 18          	mov    %eax,0x18(%esp)
  102a16:	89 54 24 14          	mov    %edx,0x14(%esp)
  102a1a:	8b 45 18             	mov    0x18(%ebp),%eax
  102a1d:	89 44 24 10          	mov    %eax,0x10(%esp)
  102a21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102a24:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102a27:	89 44 24 08          	mov    %eax,0x8(%esp)
  102a2b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102a2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a32:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a36:	8b 45 08             	mov    0x8(%ebp),%eax
  102a39:	89 04 24             	mov    %eax,(%esp)
  102a3c:	e8 38 ff ff ff       	call   102979 <printnum>
  102a41:	eb 1c                	jmp    102a5f <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a46:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a4a:	8b 45 20             	mov    0x20(%ebp),%eax
  102a4d:	89 04 24             	mov    %eax,(%esp)
  102a50:	8b 45 08             	mov    0x8(%ebp),%eax
  102a53:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102a55:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102a59:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102a5d:	7f e4                	jg     102a43 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102a5f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a62:	05 70 3c 10 00       	add    $0x103c70,%eax
  102a67:	0f b6 00             	movzbl (%eax),%eax
  102a6a:	0f be c0             	movsbl %al,%eax
  102a6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a70:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a74:	89 04 24             	mov    %eax,(%esp)
  102a77:	8b 45 08             	mov    0x8(%ebp),%eax
  102a7a:	ff d0                	call   *%eax
}
  102a7c:	c9                   	leave  
  102a7d:	c3                   	ret    

00102a7e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102a7e:	55                   	push   %ebp
  102a7f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a81:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a85:	7e 14                	jle    102a9b <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102a87:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8a:	8b 00                	mov    (%eax),%eax
  102a8c:	8d 48 08             	lea    0x8(%eax),%ecx
  102a8f:	8b 55 08             	mov    0x8(%ebp),%edx
  102a92:	89 0a                	mov    %ecx,(%edx)
  102a94:	8b 50 04             	mov    0x4(%eax),%edx
  102a97:	8b 00                	mov    (%eax),%eax
  102a99:	eb 30                	jmp    102acb <getuint+0x4d>
    }
    else if (lflag) {
  102a9b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a9f:	74 16                	je     102ab7 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa4:	8b 00                	mov    (%eax),%eax
  102aa6:	8d 48 04             	lea    0x4(%eax),%ecx
  102aa9:	8b 55 08             	mov    0x8(%ebp),%edx
  102aac:	89 0a                	mov    %ecx,(%edx)
  102aae:	8b 00                	mov    (%eax),%eax
  102ab0:	ba 00 00 00 00       	mov    $0x0,%edx
  102ab5:	eb 14                	jmp    102acb <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  102aba:	8b 00                	mov    (%eax),%eax
  102abc:	8d 48 04             	lea    0x4(%eax),%ecx
  102abf:	8b 55 08             	mov    0x8(%ebp),%edx
  102ac2:	89 0a                	mov    %ecx,(%edx)
  102ac4:	8b 00                	mov    (%eax),%eax
  102ac6:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102acb:	5d                   	pop    %ebp
  102acc:	c3                   	ret    

00102acd <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102acd:	55                   	push   %ebp
  102ace:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102ad0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102ad4:	7e 14                	jle    102aea <getint+0x1d>
        return va_arg(*ap, long long);
  102ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad9:	8b 00                	mov    (%eax),%eax
  102adb:	8d 48 08             	lea    0x8(%eax),%ecx
  102ade:	8b 55 08             	mov    0x8(%ebp),%edx
  102ae1:	89 0a                	mov    %ecx,(%edx)
  102ae3:	8b 50 04             	mov    0x4(%eax),%edx
  102ae6:	8b 00                	mov    (%eax),%eax
  102ae8:	eb 28                	jmp    102b12 <getint+0x45>
    }
    else if (lflag) {
  102aea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102aee:	74 12                	je     102b02 <getint+0x35>
        return va_arg(*ap, long);
  102af0:	8b 45 08             	mov    0x8(%ebp),%eax
  102af3:	8b 00                	mov    (%eax),%eax
  102af5:	8d 48 04             	lea    0x4(%eax),%ecx
  102af8:	8b 55 08             	mov    0x8(%ebp),%edx
  102afb:	89 0a                	mov    %ecx,(%edx)
  102afd:	8b 00                	mov    (%eax),%eax
  102aff:	99                   	cltd   
  102b00:	eb 10                	jmp    102b12 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102b02:	8b 45 08             	mov    0x8(%ebp),%eax
  102b05:	8b 00                	mov    (%eax),%eax
  102b07:	8d 48 04             	lea    0x4(%eax),%ecx
  102b0a:	8b 55 08             	mov    0x8(%ebp),%edx
  102b0d:	89 0a                	mov    %ecx,(%edx)
  102b0f:	8b 00                	mov    (%eax),%eax
  102b11:	99                   	cltd   
    }
}
  102b12:	5d                   	pop    %ebp
  102b13:	c3                   	ret    

00102b14 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102b14:	55                   	push   %ebp
  102b15:	89 e5                	mov    %esp,%ebp
  102b17:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102b1a:	8d 45 14             	lea    0x14(%ebp),%eax
  102b1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102b27:	8b 45 10             	mov    0x10(%ebp),%eax
  102b2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  102b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b31:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b35:	8b 45 08             	mov    0x8(%ebp),%eax
  102b38:	89 04 24             	mov    %eax,(%esp)
  102b3b:	e8 02 00 00 00       	call   102b42 <vprintfmt>
    va_end(ap);
}
  102b40:	c9                   	leave  
  102b41:	c3                   	ret    

00102b42 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102b42:	55                   	push   %ebp
  102b43:	89 e5                	mov    %esp,%ebp
  102b45:	56                   	push   %esi
  102b46:	53                   	push   %ebx
  102b47:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b4a:	eb 18                	jmp    102b64 <vprintfmt+0x22>
            if (ch == '\0') {
  102b4c:	85 db                	test   %ebx,%ebx
  102b4e:	75 05                	jne    102b55 <vprintfmt+0x13>
                return;
  102b50:	e9 d1 03 00 00       	jmp    102f26 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b58:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b5c:	89 1c 24             	mov    %ebx,(%esp)
  102b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  102b62:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b64:	8b 45 10             	mov    0x10(%ebp),%eax
  102b67:	8d 50 01             	lea    0x1(%eax),%edx
  102b6a:	89 55 10             	mov    %edx,0x10(%ebp)
  102b6d:	0f b6 00             	movzbl (%eax),%eax
  102b70:	0f b6 d8             	movzbl %al,%ebx
  102b73:	83 fb 25             	cmp    $0x25,%ebx
  102b76:	75 d4                	jne    102b4c <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102b78:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102b7c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102b83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b86:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102b89:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b93:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102b96:	8b 45 10             	mov    0x10(%ebp),%eax
  102b99:	8d 50 01             	lea    0x1(%eax),%edx
  102b9c:	89 55 10             	mov    %edx,0x10(%ebp)
  102b9f:	0f b6 00             	movzbl (%eax),%eax
  102ba2:	0f b6 d8             	movzbl %al,%ebx
  102ba5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102ba8:	83 f8 55             	cmp    $0x55,%eax
  102bab:	0f 87 44 03 00 00    	ja     102ef5 <vprintfmt+0x3b3>
  102bb1:	8b 04 85 94 3c 10 00 	mov    0x103c94(,%eax,4),%eax
  102bb8:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102bba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102bbe:	eb d6                	jmp    102b96 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102bc0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102bc4:	eb d0                	jmp    102b96 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102bc6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102bcd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102bd0:	89 d0                	mov    %edx,%eax
  102bd2:	c1 e0 02             	shl    $0x2,%eax
  102bd5:	01 d0                	add    %edx,%eax
  102bd7:	01 c0                	add    %eax,%eax
  102bd9:	01 d8                	add    %ebx,%eax
  102bdb:	83 e8 30             	sub    $0x30,%eax
  102bde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102be1:	8b 45 10             	mov    0x10(%ebp),%eax
  102be4:	0f b6 00             	movzbl (%eax),%eax
  102be7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102bea:	83 fb 2f             	cmp    $0x2f,%ebx
  102bed:	7e 0b                	jle    102bfa <vprintfmt+0xb8>
  102bef:	83 fb 39             	cmp    $0x39,%ebx
  102bf2:	7f 06                	jg     102bfa <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102bf4:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102bf8:	eb d3                	jmp    102bcd <vprintfmt+0x8b>
            goto process_precision;
  102bfa:	eb 33                	jmp    102c2f <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102bfc:	8b 45 14             	mov    0x14(%ebp),%eax
  102bff:	8d 50 04             	lea    0x4(%eax),%edx
  102c02:	89 55 14             	mov    %edx,0x14(%ebp)
  102c05:	8b 00                	mov    (%eax),%eax
  102c07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102c0a:	eb 23                	jmp    102c2f <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102c0c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c10:	79 0c                	jns    102c1e <vprintfmt+0xdc>
                width = 0;
  102c12:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102c19:	e9 78 ff ff ff       	jmp    102b96 <vprintfmt+0x54>
  102c1e:	e9 73 ff ff ff       	jmp    102b96 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102c23:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102c2a:	e9 67 ff ff ff       	jmp    102b96 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102c2f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c33:	79 12                	jns    102c47 <vprintfmt+0x105>
                width = precision, precision = -1;
  102c35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c38:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c3b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102c42:	e9 4f ff ff ff       	jmp    102b96 <vprintfmt+0x54>
  102c47:	e9 4a ff ff ff       	jmp    102b96 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102c4c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102c50:	e9 41 ff ff ff       	jmp    102b96 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102c55:	8b 45 14             	mov    0x14(%ebp),%eax
  102c58:	8d 50 04             	lea    0x4(%eax),%edx
  102c5b:	89 55 14             	mov    %edx,0x14(%ebp)
  102c5e:	8b 00                	mov    (%eax),%eax
  102c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c63:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c67:	89 04 24             	mov    %eax,(%esp)
  102c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6d:	ff d0                	call   *%eax
            break;
  102c6f:	e9 ac 02 00 00       	jmp    102f20 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102c74:	8b 45 14             	mov    0x14(%ebp),%eax
  102c77:	8d 50 04             	lea    0x4(%eax),%edx
  102c7a:	89 55 14             	mov    %edx,0x14(%ebp)
  102c7d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102c7f:	85 db                	test   %ebx,%ebx
  102c81:	79 02                	jns    102c85 <vprintfmt+0x143>
                err = -err;
  102c83:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102c85:	83 fb 06             	cmp    $0x6,%ebx
  102c88:	7f 0b                	jg     102c95 <vprintfmt+0x153>
  102c8a:	8b 34 9d 54 3c 10 00 	mov    0x103c54(,%ebx,4),%esi
  102c91:	85 f6                	test   %esi,%esi
  102c93:	75 23                	jne    102cb8 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102c95:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102c99:	c7 44 24 08 81 3c 10 	movl   $0x103c81,0x8(%esp)
  102ca0:	00 
  102ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ca4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  102cab:	89 04 24             	mov    %eax,(%esp)
  102cae:	e8 61 fe ff ff       	call   102b14 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102cb3:	e9 68 02 00 00       	jmp    102f20 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102cb8:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102cbc:	c7 44 24 08 8a 3c 10 	movl   $0x103c8a,0x8(%esp)
  102cc3:	00 
  102cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  102cce:	89 04 24             	mov    %eax,(%esp)
  102cd1:	e8 3e fe ff ff       	call   102b14 <printfmt>
            }
            break;
  102cd6:	e9 45 02 00 00       	jmp    102f20 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102cdb:	8b 45 14             	mov    0x14(%ebp),%eax
  102cde:	8d 50 04             	lea    0x4(%eax),%edx
  102ce1:	89 55 14             	mov    %edx,0x14(%ebp)
  102ce4:	8b 30                	mov    (%eax),%esi
  102ce6:	85 f6                	test   %esi,%esi
  102ce8:	75 05                	jne    102cef <vprintfmt+0x1ad>
                p = "(null)";
  102cea:	be 8d 3c 10 00       	mov    $0x103c8d,%esi
            }
            if (width > 0 && padc != '-') {
  102cef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cf3:	7e 3e                	jle    102d33 <vprintfmt+0x1f1>
  102cf5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102cf9:	74 38                	je     102d33 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cfb:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102cfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d01:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d05:	89 34 24             	mov    %esi,(%esp)
  102d08:	e8 15 03 00 00       	call   103022 <strnlen>
  102d0d:	29 c3                	sub    %eax,%ebx
  102d0f:	89 d8                	mov    %ebx,%eax
  102d11:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d14:	eb 17                	jmp    102d2d <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102d16:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102d1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d1d:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d21:	89 04 24             	mov    %eax,(%esp)
  102d24:	8b 45 08             	mov    0x8(%ebp),%eax
  102d27:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102d29:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d2d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d31:	7f e3                	jg     102d16 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d33:	eb 38                	jmp    102d6d <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102d35:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102d39:	74 1f                	je     102d5a <vprintfmt+0x218>
  102d3b:	83 fb 1f             	cmp    $0x1f,%ebx
  102d3e:	7e 05                	jle    102d45 <vprintfmt+0x203>
  102d40:	83 fb 7e             	cmp    $0x7e,%ebx
  102d43:	7e 15                	jle    102d5a <vprintfmt+0x218>
                    putch('?', putdat);
  102d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d48:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d4c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102d53:	8b 45 08             	mov    0x8(%ebp),%eax
  102d56:	ff d0                	call   *%eax
  102d58:	eb 0f                	jmp    102d69 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d61:	89 1c 24             	mov    %ebx,(%esp)
  102d64:	8b 45 08             	mov    0x8(%ebp),%eax
  102d67:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d69:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d6d:	89 f0                	mov    %esi,%eax
  102d6f:	8d 70 01             	lea    0x1(%eax),%esi
  102d72:	0f b6 00             	movzbl (%eax),%eax
  102d75:	0f be d8             	movsbl %al,%ebx
  102d78:	85 db                	test   %ebx,%ebx
  102d7a:	74 10                	je     102d8c <vprintfmt+0x24a>
  102d7c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d80:	78 b3                	js     102d35 <vprintfmt+0x1f3>
  102d82:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102d86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d8a:	79 a9                	jns    102d35 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d8c:	eb 17                	jmp    102da5 <vprintfmt+0x263>
                putch(' ', putdat);
  102d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d91:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d95:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d9f:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102da1:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102da5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102da9:	7f e3                	jg     102d8e <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102dab:	e9 70 01 00 00       	jmp    102f20 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102db0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102db3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102db7:	8d 45 14             	lea    0x14(%ebp),%eax
  102dba:	89 04 24             	mov    %eax,(%esp)
  102dbd:	e8 0b fd ff ff       	call   102acd <getint>
  102dc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dc5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102dce:	85 d2                	test   %edx,%edx
  102dd0:	79 26                	jns    102df8 <vprintfmt+0x2b6>
                putch('-', putdat);
  102dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dd9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102de0:	8b 45 08             	mov    0x8(%ebp),%eax
  102de3:	ff d0                	call   *%eax
                num = -(long long)num;
  102de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102de8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102deb:	f7 d8                	neg    %eax
  102ded:	83 d2 00             	adc    $0x0,%edx
  102df0:	f7 da                	neg    %edx
  102df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102df5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102df8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102dff:	e9 a8 00 00 00       	jmp    102eac <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102e04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e07:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e0b:	8d 45 14             	lea    0x14(%ebp),%eax
  102e0e:	89 04 24             	mov    %eax,(%esp)
  102e11:	e8 68 fc ff ff       	call   102a7e <getuint>
  102e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e19:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102e1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102e23:	e9 84 00 00 00       	jmp    102eac <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102e28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e2f:	8d 45 14             	lea    0x14(%ebp),%eax
  102e32:	89 04 24             	mov    %eax,(%esp)
  102e35:	e8 44 fc ff ff       	call   102a7e <getuint>
  102e3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102e40:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102e47:	eb 63                	jmp    102eac <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102e49:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e50:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102e57:	8b 45 08             	mov    0x8(%ebp),%eax
  102e5a:	ff d0                	call   *%eax
            putch('x', putdat);
  102e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e63:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6d:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102e6f:	8b 45 14             	mov    0x14(%ebp),%eax
  102e72:	8d 50 04             	lea    0x4(%eax),%edx
  102e75:	89 55 14             	mov    %edx,0x14(%ebp)
  102e78:	8b 00                	mov    (%eax),%eax
  102e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102e84:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102e8b:	eb 1f                	jmp    102eac <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102e8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e90:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e94:	8d 45 14             	lea    0x14(%ebp),%eax
  102e97:	89 04 24             	mov    %eax,(%esp)
  102e9a:	e8 df fb ff ff       	call   102a7e <getuint>
  102e9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ea2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102ea5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102eac:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102eb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102eb3:	89 54 24 18          	mov    %edx,0x18(%esp)
  102eb7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102eba:	89 54 24 14          	mov    %edx,0x14(%esp)
  102ebe:	89 44 24 10          	mov    %eax,0x10(%esp)
  102ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ec5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ec8:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ecc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ed3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  102eda:	89 04 24             	mov    %eax,(%esp)
  102edd:	e8 97 fa ff ff       	call   102979 <printnum>
            break;
  102ee2:	eb 3c                	jmp    102f20 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ee7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eeb:	89 1c 24             	mov    %ebx,(%esp)
  102eee:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef1:	ff d0                	call   *%eax
            break;
  102ef3:	eb 2b                	jmp    102f20 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102efc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102f03:	8b 45 08             	mov    0x8(%ebp),%eax
  102f06:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102f08:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102f0c:	eb 04                	jmp    102f12 <vprintfmt+0x3d0>
  102f0e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102f12:	8b 45 10             	mov    0x10(%ebp),%eax
  102f15:	83 e8 01             	sub    $0x1,%eax
  102f18:	0f b6 00             	movzbl (%eax),%eax
  102f1b:	3c 25                	cmp    $0x25,%al
  102f1d:	75 ef                	jne    102f0e <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102f1f:	90                   	nop
        }
    }
  102f20:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102f21:	e9 3e fc ff ff       	jmp    102b64 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102f26:	83 c4 40             	add    $0x40,%esp
  102f29:	5b                   	pop    %ebx
  102f2a:	5e                   	pop    %esi
  102f2b:	5d                   	pop    %ebp
  102f2c:	c3                   	ret    

00102f2d <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102f2d:	55                   	push   %ebp
  102f2e:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f33:	8b 40 08             	mov    0x8(%eax),%eax
  102f36:	8d 50 01             	lea    0x1(%eax),%edx
  102f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f3c:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f42:	8b 10                	mov    (%eax),%edx
  102f44:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f47:	8b 40 04             	mov    0x4(%eax),%eax
  102f4a:	39 c2                	cmp    %eax,%edx
  102f4c:	73 12                	jae    102f60 <sprintputch+0x33>
        *b->buf ++ = ch;
  102f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f51:	8b 00                	mov    (%eax),%eax
  102f53:	8d 48 01             	lea    0x1(%eax),%ecx
  102f56:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f59:	89 0a                	mov    %ecx,(%edx)
  102f5b:	8b 55 08             	mov    0x8(%ebp),%edx
  102f5e:	88 10                	mov    %dl,(%eax)
    }
}
  102f60:	5d                   	pop    %ebp
  102f61:	c3                   	ret    

00102f62 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102f62:	55                   	push   %ebp
  102f63:	89 e5                	mov    %esp,%ebp
  102f65:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102f68:	8d 45 14             	lea    0x14(%ebp),%eax
  102f6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f71:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f75:	8b 45 10             	mov    0x10(%ebp),%eax
  102f78:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f83:	8b 45 08             	mov    0x8(%ebp),%eax
  102f86:	89 04 24             	mov    %eax,(%esp)
  102f89:	e8 08 00 00 00       	call   102f96 <vsnprintf>
  102f8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f94:	c9                   	leave  
  102f95:	c3                   	ret    

00102f96 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102f96:	55                   	push   %ebp
  102f97:	89 e5                	mov    %esp,%ebp
  102f99:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  102f9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fa5:	8d 50 ff             	lea    -0x1(%eax),%edx
  102fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  102fab:	01 d0                	add    %edx,%eax
  102fad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102fb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102fbb:	74 0a                	je     102fc7 <vsnprintf+0x31>
  102fbd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fc3:	39 c2                	cmp    %eax,%edx
  102fc5:	76 07                	jbe    102fce <vsnprintf+0x38>
        return -E_INVAL;
  102fc7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102fcc:	eb 2a                	jmp    102ff8 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102fce:	8b 45 14             	mov    0x14(%ebp),%eax
  102fd1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  102fd8:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fdc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102fdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fe3:	c7 04 24 2d 2f 10 00 	movl   $0x102f2d,(%esp)
  102fea:	e8 53 fb ff ff       	call   102b42 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102fef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ff2:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102ff8:	c9                   	leave  
  102ff9:	c3                   	ret    

00102ffa <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102ffa:	55                   	push   %ebp
  102ffb:	89 e5                	mov    %esp,%ebp
  102ffd:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103000:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  103007:	eb 04                	jmp    10300d <strlen+0x13>
        cnt ++;
  103009:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  10300d:	8b 45 08             	mov    0x8(%ebp),%eax
  103010:	8d 50 01             	lea    0x1(%eax),%edx
  103013:	89 55 08             	mov    %edx,0x8(%ebp)
  103016:	0f b6 00             	movzbl (%eax),%eax
  103019:	84 c0                	test   %al,%al
  10301b:	75 ec                	jne    103009 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  10301d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103020:	c9                   	leave  
  103021:	c3                   	ret    

00103022 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  103022:	55                   	push   %ebp
  103023:	89 e5                	mov    %esp,%ebp
  103025:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103028:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10302f:	eb 04                	jmp    103035 <strnlen+0x13>
        cnt ++;
  103031:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  103035:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103038:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10303b:	73 10                	jae    10304d <strnlen+0x2b>
  10303d:	8b 45 08             	mov    0x8(%ebp),%eax
  103040:	8d 50 01             	lea    0x1(%eax),%edx
  103043:	89 55 08             	mov    %edx,0x8(%ebp)
  103046:	0f b6 00             	movzbl (%eax),%eax
  103049:	84 c0                	test   %al,%al
  10304b:	75 e4                	jne    103031 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  10304d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103050:	c9                   	leave  
  103051:	c3                   	ret    

00103052 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103052:	55                   	push   %ebp
  103053:	89 e5                	mov    %esp,%ebp
  103055:	57                   	push   %edi
  103056:	56                   	push   %esi
  103057:	83 ec 20             	sub    $0x20,%esp
  10305a:	8b 45 08             	mov    0x8(%ebp),%eax
  10305d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103060:	8b 45 0c             	mov    0xc(%ebp),%eax
  103063:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103066:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10306c:	89 d1                	mov    %edx,%ecx
  10306e:	89 c2                	mov    %eax,%edx
  103070:	89 ce                	mov    %ecx,%esi
  103072:	89 d7                	mov    %edx,%edi
  103074:	ac                   	lods   %ds:(%esi),%al
  103075:	aa                   	stos   %al,%es:(%edi)
  103076:	84 c0                	test   %al,%al
  103078:	75 fa                	jne    103074 <strcpy+0x22>
  10307a:	89 fa                	mov    %edi,%edx
  10307c:	89 f1                	mov    %esi,%ecx
  10307e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103081:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103084:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103087:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10308a:	83 c4 20             	add    $0x20,%esp
  10308d:	5e                   	pop    %esi
  10308e:	5f                   	pop    %edi
  10308f:	5d                   	pop    %ebp
  103090:	c3                   	ret    

00103091 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  103091:	55                   	push   %ebp
  103092:	89 e5                	mov    %esp,%ebp
  103094:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103097:	8b 45 08             	mov    0x8(%ebp),%eax
  10309a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10309d:	eb 21                	jmp    1030c0 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10309f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030a2:	0f b6 10             	movzbl (%eax),%edx
  1030a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030a8:	88 10                	mov    %dl,(%eax)
  1030aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030ad:	0f b6 00             	movzbl (%eax),%eax
  1030b0:	84 c0                	test   %al,%al
  1030b2:	74 04                	je     1030b8 <strncpy+0x27>
            src ++;
  1030b4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1030b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1030bc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1030c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030c4:	75 d9                	jne    10309f <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1030c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1030c9:	c9                   	leave  
  1030ca:	c3                   	ret    

001030cb <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1030cb:	55                   	push   %ebp
  1030cc:	89 e5                	mov    %esp,%ebp
  1030ce:	57                   	push   %edi
  1030cf:	56                   	push   %esi
  1030d0:	83 ec 20             	sub    $0x20,%esp
  1030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1030d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1030df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030e5:	89 d1                	mov    %edx,%ecx
  1030e7:	89 c2                	mov    %eax,%edx
  1030e9:	89 ce                	mov    %ecx,%esi
  1030eb:	89 d7                	mov    %edx,%edi
  1030ed:	ac                   	lods   %ds:(%esi),%al
  1030ee:	ae                   	scas   %es:(%edi),%al
  1030ef:	75 08                	jne    1030f9 <strcmp+0x2e>
  1030f1:	84 c0                	test   %al,%al
  1030f3:	75 f8                	jne    1030ed <strcmp+0x22>
  1030f5:	31 c0                	xor    %eax,%eax
  1030f7:	eb 04                	jmp    1030fd <strcmp+0x32>
  1030f9:	19 c0                	sbb    %eax,%eax
  1030fb:	0c 01                	or     $0x1,%al
  1030fd:	89 fa                	mov    %edi,%edx
  1030ff:	89 f1                	mov    %esi,%ecx
  103101:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103104:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103107:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  10310a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  10310d:	83 c4 20             	add    $0x20,%esp
  103110:	5e                   	pop    %esi
  103111:	5f                   	pop    %edi
  103112:	5d                   	pop    %ebp
  103113:	c3                   	ret    

00103114 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  103114:	55                   	push   %ebp
  103115:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103117:	eb 0c                	jmp    103125 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  103119:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10311d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103121:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103125:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103129:	74 1a                	je     103145 <strncmp+0x31>
  10312b:	8b 45 08             	mov    0x8(%ebp),%eax
  10312e:	0f b6 00             	movzbl (%eax),%eax
  103131:	84 c0                	test   %al,%al
  103133:	74 10                	je     103145 <strncmp+0x31>
  103135:	8b 45 08             	mov    0x8(%ebp),%eax
  103138:	0f b6 10             	movzbl (%eax),%edx
  10313b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10313e:	0f b6 00             	movzbl (%eax),%eax
  103141:	38 c2                	cmp    %al,%dl
  103143:	74 d4                	je     103119 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103145:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103149:	74 18                	je     103163 <strncmp+0x4f>
  10314b:	8b 45 08             	mov    0x8(%ebp),%eax
  10314e:	0f b6 00             	movzbl (%eax),%eax
  103151:	0f b6 d0             	movzbl %al,%edx
  103154:	8b 45 0c             	mov    0xc(%ebp),%eax
  103157:	0f b6 00             	movzbl (%eax),%eax
  10315a:	0f b6 c0             	movzbl %al,%eax
  10315d:	29 c2                	sub    %eax,%edx
  10315f:	89 d0                	mov    %edx,%eax
  103161:	eb 05                	jmp    103168 <strncmp+0x54>
  103163:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103168:	5d                   	pop    %ebp
  103169:	c3                   	ret    

0010316a <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10316a:	55                   	push   %ebp
  10316b:	89 e5                	mov    %esp,%ebp
  10316d:	83 ec 04             	sub    $0x4,%esp
  103170:	8b 45 0c             	mov    0xc(%ebp),%eax
  103173:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103176:	eb 14                	jmp    10318c <strchr+0x22>
        if (*s == c) {
  103178:	8b 45 08             	mov    0x8(%ebp),%eax
  10317b:	0f b6 00             	movzbl (%eax),%eax
  10317e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103181:	75 05                	jne    103188 <strchr+0x1e>
            return (char *)s;
  103183:	8b 45 08             	mov    0x8(%ebp),%eax
  103186:	eb 13                	jmp    10319b <strchr+0x31>
        }
        s ++;
  103188:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  10318c:	8b 45 08             	mov    0x8(%ebp),%eax
  10318f:	0f b6 00             	movzbl (%eax),%eax
  103192:	84 c0                	test   %al,%al
  103194:	75 e2                	jne    103178 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  103196:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10319b:	c9                   	leave  
  10319c:	c3                   	ret    

0010319d <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10319d:	55                   	push   %ebp
  10319e:	89 e5                	mov    %esp,%ebp
  1031a0:	83 ec 04             	sub    $0x4,%esp
  1031a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031a6:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1031a9:	eb 11                	jmp    1031bc <strfind+0x1f>
        if (*s == c) {
  1031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ae:	0f b6 00             	movzbl (%eax),%eax
  1031b1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1031b4:	75 02                	jne    1031b8 <strfind+0x1b>
            break;
  1031b6:	eb 0e                	jmp    1031c6 <strfind+0x29>
        }
        s ++;
  1031b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1031bf:	0f b6 00             	movzbl (%eax),%eax
  1031c2:	84 c0                	test   %al,%al
  1031c4:	75 e5                	jne    1031ab <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  1031c6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1031c9:	c9                   	leave  
  1031ca:	c3                   	ret    

001031cb <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1031cb:	55                   	push   %ebp
  1031cc:	89 e5                	mov    %esp,%ebp
  1031ce:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1031d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1031d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031df:	eb 04                	jmp    1031e5 <strtol+0x1a>
        s ++;
  1031e1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e8:	0f b6 00             	movzbl (%eax),%eax
  1031eb:	3c 20                	cmp    $0x20,%al
  1031ed:	74 f2                	je     1031e1 <strtol+0x16>
  1031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1031f2:	0f b6 00             	movzbl (%eax),%eax
  1031f5:	3c 09                	cmp    $0x9,%al
  1031f7:	74 e8                	je     1031e1 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1031f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fc:	0f b6 00             	movzbl (%eax),%eax
  1031ff:	3c 2b                	cmp    $0x2b,%al
  103201:	75 06                	jne    103209 <strtol+0x3e>
        s ++;
  103203:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103207:	eb 15                	jmp    10321e <strtol+0x53>
    }
    else if (*s == '-') {
  103209:	8b 45 08             	mov    0x8(%ebp),%eax
  10320c:	0f b6 00             	movzbl (%eax),%eax
  10320f:	3c 2d                	cmp    $0x2d,%al
  103211:	75 0b                	jne    10321e <strtol+0x53>
        s ++, neg = 1;
  103213:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103217:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  10321e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103222:	74 06                	je     10322a <strtol+0x5f>
  103224:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  103228:	75 24                	jne    10324e <strtol+0x83>
  10322a:	8b 45 08             	mov    0x8(%ebp),%eax
  10322d:	0f b6 00             	movzbl (%eax),%eax
  103230:	3c 30                	cmp    $0x30,%al
  103232:	75 1a                	jne    10324e <strtol+0x83>
  103234:	8b 45 08             	mov    0x8(%ebp),%eax
  103237:	83 c0 01             	add    $0x1,%eax
  10323a:	0f b6 00             	movzbl (%eax),%eax
  10323d:	3c 78                	cmp    $0x78,%al
  10323f:	75 0d                	jne    10324e <strtol+0x83>
        s += 2, base = 16;
  103241:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103245:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10324c:	eb 2a                	jmp    103278 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  10324e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103252:	75 17                	jne    10326b <strtol+0xa0>
  103254:	8b 45 08             	mov    0x8(%ebp),%eax
  103257:	0f b6 00             	movzbl (%eax),%eax
  10325a:	3c 30                	cmp    $0x30,%al
  10325c:	75 0d                	jne    10326b <strtol+0xa0>
        s ++, base = 8;
  10325e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103262:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103269:	eb 0d                	jmp    103278 <strtol+0xad>
    }
    else if (base == 0) {
  10326b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10326f:	75 07                	jne    103278 <strtol+0xad>
        base = 10;
  103271:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103278:	8b 45 08             	mov    0x8(%ebp),%eax
  10327b:	0f b6 00             	movzbl (%eax),%eax
  10327e:	3c 2f                	cmp    $0x2f,%al
  103280:	7e 1b                	jle    10329d <strtol+0xd2>
  103282:	8b 45 08             	mov    0x8(%ebp),%eax
  103285:	0f b6 00             	movzbl (%eax),%eax
  103288:	3c 39                	cmp    $0x39,%al
  10328a:	7f 11                	jg     10329d <strtol+0xd2>
            dig = *s - '0';
  10328c:	8b 45 08             	mov    0x8(%ebp),%eax
  10328f:	0f b6 00             	movzbl (%eax),%eax
  103292:	0f be c0             	movsbl %al,%eax
  103295:	83 e8 30             	sub    $0x30,%eax
  103298:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10329b:	eb 48                	jmp    1032e5 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10329d:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a0:	0f b6 00             	movzbl (%eax),%eax
  1032a3:	3c 60                	cmp    $0x60,%al
  1032a5:	7e 1b                	jle    1032c2 <strtol+0xf7>
  1032a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1032aa:	0f b6 00             	movzbl (%eax),%eax
  1032ad:	3c 7a                	cmp    $0x7a,%al
  1032af:	7f 11                	jg     1032c2 <strtol+0xf7>
            dig = *s - 'a' + 10;
  1032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b4:	0f b6 00             	movzbl (%eax),%eax
  1032b7:	0f be c0             	movsbl %al,%eax
  1032ba:	83 e8 57             	sub    $0x57,%eax
  1032bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032c0:	eb 23                	jmp    1032e5 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1032c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c5:	0f b6 00             	movzbl (%eax),%eax
  1032c8:	3c 40                	cmp    $0x40,%al
  1032ca:	7e 3d                	jle    103309 <strtol+0x13e>
  1032cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1032cf:	0f b6 00             	movzbl (%eax),%eax
  1032d2:	3c 5a                	cmp    $0x5a,%al
  1032d4:	7f 33                	jg     103309 <strtol+0x13e>
            dig = *s - 'A' + 10;
  1032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d9:	0f b6 00             	movzbl (%eax),%eax
  1032dc:	0f be c0             	movsbl %al,%eax
  1032df:	83 e8 37             	sub    $0x37,%eax
  1032e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1032e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032e8:	3b 45 10             	cmp    0x10(%ebp),%eax
  1032eb:	7c 02                	jl     1032ef <strtol+0x124>
            break;
  1032ed:	eb 1a                	jmp    103309 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1032ef:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032f6:	0f af 45 10          	imul   0x10(%ebp),%eax
  1032fa:	89 c2                	mov    %eax,%edx
  1032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032ff:	01 d0                	add    %edx,%eax
  103301:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  103304:	e9 6f ff ff ff       	jmp    103278 <strtol+0xad>

    if (endptr) {
  103309:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10330d:	74 08                	je     103317 <strtol+0x14c>
        *endptr = (char *) s;
  10330f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103312:	8b 55 08             	mov    0x8(%ebp),%edx
  103315:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  103317:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10331b:	74 07                	je     103324 <strtol+0x159>
  10331d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103320:	f7 d8                	neg    %eax
  103322:	eb 03                	jmp    103327 <strtol+0x15c>
  103324:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  103327:	c9                   	leave  
  103328:	c3                   	ret    

00103329 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  103329:	55                   	push   %ebp
  10332a:	89 e5                	mov    %esp,%ebp
  10332c:	57                   	push   %edi
  10332d:	83 ec 24             	sub    $0x24,%esp
  103330:	8b 45 0c             	mov    0xc(%ebp),%eax
  103333:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103336:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  10333a:	8b 55 08             	mov    0x8(%ebp),%edx
  10333d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103340:	88 45 f7             	mov    %al,-0x9(%ebp)
  103343:	8b 45 10             	mov    0x10(%ebp),%eax
  103346:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103349:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10334c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103350:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103353:	89 d7                	mov    %edx,%edi
  103355:	f3 aa                	rep stos %al,%es:(%edi)
  103357:	89 fa                	mov    %edi,%edx
  103359:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10335c:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  10335f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  103362:	83 c4 24             	add    $0x24,%esp
  103365:	5f                   	pop    %edi
  103366:	5d                   	pop    %ebp
  103367:	c3                   	ret    

00103368 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103368:	55                   	push   %ebp
  103369:	89 e5                	mov    %esp,%ebp
  10336b:	57                   	push   %edi
  10336c:	56                   	push   %esi
  10336d:	53                   	push   %ebx
  10336e:	83 ec 30             	sub    $0x30,%esp
  103371:	8b 45 08             	mov    0x8(%ebp),%eax
  103374:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103377:	8b 45 0c             	mov    0xc(%ebp),%eax
  10337a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10337d:	8b 45 10             	mov    0x10(%ebp),%eax
  103380:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103386:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103389:	73 42                	jae    1033cd <memmove+0x65>
  10338b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10338e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103391:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103394:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103397:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10339a:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10339d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1033a0:	c1 e8 02             	shr    $0x2,%eax
  1033a3:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1033a5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1033a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033ab:	89 d7                	mov    %edx,%edi
  1033ad:	89 c6                	mov    %eax,%esi
  1033af:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1033b1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1033b4:	83 e1 03             	and    $0x3,%ecx
  1033b7:	74 02                	je     1033bb <memmove+0x53>
  1033b9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033bb:	89 f0                	mov    %esi,%eax
  1033bd:	89 fa                	mov    %edi,%edx
  1033bf:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1033c2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1033c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1033c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033cb:	eb 36                	jmp    103403 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1033cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033d0:	8d 50 ff             	lea    -0x1(%eax),%edx
  1033d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033d6:	01 c2                	add    %eax,%edx
  1033d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033db:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1033de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033e1:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1033e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033e7:	89 c1                	mov    %eax,%ecx
  1033e9:	89 d8                	mov    %ebx,%eax
  1033eb:	89 d6                	mov    %edx,%esi
  1033ed:	89 c7                	mov    %eax,%edi
  1033ef:	fd                   	std    
  1033f0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033f2:	fc                   	cld    
  1033f3:	89 f8                	mov    %edi,%eax
  1033f5:	89 f2                	mov    %esi,%edx
  1033f7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1033fa:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1033fd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  103400:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103403:	83 c4 30             	add    $0x30,%esp
  103406:	5b                   	pop    %ebx
  103407:	5e                   	pop    %esi
  103408:	5f                   	pop    %edi
  103409:	5d                   	pop    %ebp
  10340a:	c3                   	ret    

0010340b <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10340b:	55                   	push   %ebp
  10340c:	89 e5                	mov    %esp,%ebp
  10340e:	57                   	push   %edi
  10340f:	56                   	push   %esi
  103410:	83 ec 20             	sub    $0x20,%esp
  103413:	8b 45 08             	mov    0x8(%ebp),%eax
  103416:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103419:	8b 45 0c             	mov    0xc(%ebp),%eax
  10341c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10341f:	8b 45 10             	mov    0x10(%ebp),%eax
  103422:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103425:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103428:	c1 e8 02             	shr    $0x2,%eax
  10342b:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10342d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103433:	89 d7                	mov    %edx,%edi
  103435:	89 c6                	mov    %eax,%esi
  103437:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103439:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10343c:	83 e1 03             	and    $0x3,%ecx
  10343f:	74 02                	je     103443 <memcpy+0x38>
  103441:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103443:	89 f0                	mov    %esi,%eax
  103445:	89 fa                	mov    %edi,%edx
  103447:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10344a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10344d:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103450:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103453:	83 c4 20             	add    $0x20,%esp
  103456:	5e                   	pop    %esi
  103457:	5f                   	pop    %edi
  103458:	5d                   	pop    %ebp
  103459:	c3                   	ret    

0010345a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10345a:	55                   	push   %ebp
  10345b:	89 e5                	mov    %esp,%ebp
  10345d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103460:	8b 45 08             	mov    0x8(%ebp),%eax
  103463:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103466:	8b 45 0c             	mov    0xc(%ebp),%eax
  103469:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10346c:	eb 30                	jmp    10349e <memcmp+0x44>
        if (*s1 != *s2) {
  10346e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103471:	0f b6 10             	movzbl (%eax),%edx
  103474:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103477:	0f b6 00             	movzbl (%eax),%eax
  10347a:	38 c2                	cmp    %al,%dl
  10347c:	74 18                	je     103496 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10347e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103481:	0f b6 00             	movzbl (%eax),%eax
  103484:	0f b6 d0             	movzbl %al,%edx
  103487:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10348a:	0f b6 00             	movzbl (%eax),%eax
  10348d:	0f b6 c0             	movzbl %al,%eax
  103490:	29 c2                	sub    %eax,%edx
  103492:	89 d0                	mov    %edx,%eax
  103494:	eb 1a                	jmp    1034b0 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103496:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10349a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  10349e:	8b 45 10             	mov    0x10(%ebp),%eax
  1034a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1034a4:	89 55 10             	mov    %edx,0x10(%ebp)
  1034a7:	85 c0                	test   %eax,%eax
  1034a9:	75 c3                	jne    10346e <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1034ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1034b0:	c9                   	leave  
  1034b1:	c3                   	ret    
